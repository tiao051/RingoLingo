import 'package:flutter/material.dart';
import 'package:ringolingo_app/utils/color.dart';
import 'package:ringolingo_app/utils/text_styles.dart';
import 'package:ringolingo_app/services/recorder.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:async';

// // Model cho bài luyện nói
class SpeakingLesson {
  final int id;
  final String title;
  final String description;
  final List<SpeakingTask> tasks;
  final int categoryId;

  SpeakingLesson({
    required this.id,
    required this.title,
    required this.description,
    required this.tasks,
    required this.categoryId,
  });
}

class SpeakingTask {
  final String id;
  final String type; // 'repeat', 'describe', 'conversation'
  final String instruction;
  final String? targetText;
  final String? imageUrl;
  final String? audioUrl;
  final List<String>? keywords;
  String? userResponse;
  bool isCompleted;

  SpeakingTask({
    required this.id,
    required this.type,
    required this.instruction,
    this.targetText,
    this.imageUrl,
    this.audioUrl,
    this.keywords,
    this.userResponse,
    this.isCompleted = false,
  });
}

class SpeakingPracticeScreen extends StatefulWidget {
  final SpeakingLesson lesson;

  const SpeakingPracticeScreen({Key? key, required this.lesson}) : super(key: key);

  @override
  _SpeakingPracticeScreenState createState() => _SpeakingPracticeScreenState();
}

class _SpeakingPracticeScreenState extends State<SpeakingPracticeScreen>
    with TickerProviderStateMixin {
  final AudioPlayer _audioPlayer = AudioPlayer();
  int currentTaskIndex = 0;
  bool isRecording = false;
  bool isPlayingAudio = false;
  Timer? _recordingTimer;
  int recordingDuration = 0;
  String recordingStatus = '';
  
  late AnimationController _pulseController;
  late AnimationController _waveController;
  late AnimationController _progressController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _waveAnimation;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _setupAudioPlayer();
  }

  void _initializeAnimations() {
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _waveController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    _progressController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    _waveAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _waveController, curve: Curves.easeInOut),
    );
    _progressAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _progressController, curve: Curves.easeInOut),
    );
  }

  void _setupAudioPlayer() {
    _audioPlayer.onPlayerStateChanged.listen((state) {
      if (mounted) {
        setState(() {
          isPlayingAudio = state == PlayerState.playing;
        });
      }
    });
  }

  Future<bool> _onWillPop() async {
    return await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Thoát bài luyện nói?',
          style: AppTextStyles.head3Bold.copyWith(color: AppColors.brownDark),
        ),
        content: Text(
          'Bạn có chắc chắn muốn thoát? Mọi kết quả sẽ không được lưu.',
          style: AppTextStyles.body.copyWith(color: AppColors.brownNormal),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(
              'Hủy',
              style: AppTextStyles.bodyBold.copyWith(color: AppColors.brownNormal),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.redNormal,
              foregroundColor: AppColors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: Text(
              'Thoát',
              style: AppTextStyles.bodyBold.copyWith(color: AppColors.white),
            ),
          ),
        ],
      ),
    ) ?? false;
  }

  Future<void> _playTargetAudio() async {
    final currentTask = widget.lesson.tasks[currentTaskIndex];
    if (currentTask.audioUrl != null) {
      try {
        String path = currentTask.audioUrl!;
        if (path.startsWith('assets/')) {
          path = path.substring('assets/'.length);
        }
        if (path.startsWith('/')) {
          path = path.substring(1);
        }
        await _audioPlayer.play(AssetSource(path));
      } catch (e) {
        print("Error playing audio: $e");
      }
    }
  }

  Future<void> _startRecording() async {
    if (isRecording) return;
    
    setState(() {
      isRecording = true;
      recordingDuration = 0;
      recordingStatus = 'Đang ghi âm...';
    });

    _pulseController.repeat(reverse: true);
    _waveController.repeat();

    try {
      await startRecording();
      _recordingTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          recordingDuration++;
        });
      });
    } catch (e) {
      print("Error starting recording: $e");
      _stopRecording();
    }
  }

  Future<void> _stopRecording() async {
    if (!isRecording) return;

    setState(() {
      isRecording = false;
      recordingStatus = 'Đã hoàn thành ghi âm';
    });

    _pulseController.stop();
    _waveController.stop();
    _recordingTimer?.cancel();

    try {
      await stopRecordingAndSend();
      // Mark current task as completed
      widget.lesson.tasks[currentTaskIndex].isCompleted = true;
      _progressController.forward();
    } catch (e) {
      print("Error stopping recording: $e");
    }
  }

  void _nextTask() {
    if (currentTaskIndex < widget.lesson.tasks.length - 1) {
      setState(() {
        currentTaskIndex++;
        recordingStatus = '';
      });
      _progressController.reset();
    } else {
      _showCompletionDialog();
    }
  }

  void _previousTask() {
    if (currentTaskIndex > 0) {
      setState(() {
        currentTaskIndex--;
        recordingStatus = '';
      });
      _progressController.reset();
    }
  }

  void _showCompletionDialog() {
    final completedTasks = widget.lesson.tasks.where((task) => task.isCompleted).length;
    final totalTasks = widget.lesson.tasks.length;
    final percentage = (completedTasks / totalTasks) * 100;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        contentPadding: const EdgeInsets.all(24),
        content: Container(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Success Icon
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.green.shade100,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check_circle,
                  size: 50,
                  color: Colors.green.shade600,
                ),
              ),
              const SizedBox(height: 16),
              
              // Title
              Text(
                'Chúc mừng!',
                style: AppTextStyles.head2Bold.copyWith(color: AppColors.brownDark),
              ),
              const SizedBox(height: 8),
              
              // Stats
              Text(
                'Bạn đã hoàn thành ${percentage.toStringAsFixed(0)}% bài luyện nói',
                style: AppTextStyles.body.copyWith(color: AppColors.brownNormal),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              
              // Progress indicator
              Container(
                height: 6,
                decoration: BoxDecoration(
                  color: AppColors.brownLight.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(3),
                ),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: percentage / 100,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.green.shade600,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              
              // Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                      },
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: AppColors.brownNormal),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: Text(
                        'Hoàn thành',
                        style: AppTextStyles.bodyBold.copyWith(color: AppColors.brownNormal),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        setState(() {
                          currentTaskIndex = 0;
                          for (var task in widget.lesson.tasks) {
                            task.isCompleted = false;
                          }
                          recordingStatus = '';
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.brownDark,
                        foregroundColor: AppColors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: Text(
                        'Luyện lại',
                        style: AppTextStyles.bodyBold.copyWith(color: AppColors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _pulseController.dispose();
    _waveController.dispose();
    _progressController.dispose();
    _recordingTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: const Color(0xFFD5B893),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Main Content
              Expanded(
                flex: 6,
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Header
                      _buildHeader(),
                      const SizedBox(height: 20),
                      
                      // Progress Bar
                      _buildProgressBar(),
                      const SizedBox(height: 24),
                      
                      // Main Content Area
                      Expanded(
                        child: SingleChildScrollView(
                          child: _buildTaskContent(),
                        ),
                      ),
                      
                      // Bottom Controls
                      _buildBottomControls(),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(width: 20),
              
              // Right Sidebar
              Expanded(
                flex: 2,
                child: _buildRightSidebar(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.brownDark),
          onPressed: () async {
            final shouldPop = await _onWillPop();
            if (shouldPop) {
              Navigator.pop(context);
            }
          },
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.lesson.title,
                style: AppTextStyles.head2Bold.copyWith(color: AppColors.brownDark),
              ),
              const SizedBox(height: 4),
              Text(
                widget.lesson.description,
                style: AppTextStyles.body.copyWith(
                  color: AppColors.brownNormal.withOpacity(0.8),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProgressBar() {
    final progress = (currentTaskIndex + 1) / widget.lesson.tasks.length;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Tiến độ',
              style: AppTextStyles.bodyBold.copyWith(color: AppColors.brownDark),
            ),
            Text(
              '${currentTaskIndex + 1}/${widget.lesson.tasks.length}',
              style: AppTextStyles.body.copyWith(color: AppColors.brownNormal),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          height: 8,
          decoration: BoxDecoration(
            color: AppColors.brownLight.withOpacity(0.3),
            borderRadius: BorderRadius.circular(4),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: progress,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.brownNormal, AppColors.brownDark],
                ),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTaskContent() {
    final currentTask = widget.lesson.tasks[currentTaskIndex];
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Task Type Badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: _getTaskTypeColor(currentTask.type).withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: _getTaskTypeColor(currentTask.type).withOpacity(0.3),
            ),
          ),
          child: Text(
            _getTaskTypeName(currentTask.type),
            style: AppTextStyles.bodyBold.copyWith(
              color: _getTaskTypeColor(currentTask.type),
            ),
          ),
        ),
        const SizedBox(height: 24),
        
        // Instruction
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.brownLight.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColors.brownLight.withOpacity(0.3),
            ),
          ),
          child: Text(
            currentTask.instruction,
            style: AppTextStyles.head3Bold.copyWith(color: AppColors.brownDark),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 24),
        
        // Task-specific content
        if (currentTask.type == 'repeat' && currentTask.targetText != null) ...[
          _buildRepeatTask(currentTask),
        ] else if (currentTask.type == 'describe' && currentTask.imageUrl != null) ...[
          _buildDescribeTask(currentTask),
        ] else if (currentTask.type == 'conversation') ...[
          _buildConversationTask(currentTask),
        ],
        
        const SizedBox(height: 32),
        
        // Recording Section
        _buildRecordingSection(),
      ],
    );
  }

  Widget _buildRepeatTask(SpeakingTask task) {
    return Column(
      children: [
        // Play target audio button
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.brownNormal.withOpacity(0.3)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              IconButton(
                onPressed: _playTargetAudio,
                icon: Icon(
                  isPlayingAudio ? Icons.pause_circle_filled : Icons.play_circle_filled,
                  size: 64,
                  color: AppColors.brownDark,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Nghe và lặp lại',
                style: AppTextStyles.bodyBold.copyWith(color: AppColors.brownDark),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        
        // Target text
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.brownLight.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            task.targetText!,
            style: AppTextStyles.head3.copyWith(color: AppColors.brownDark),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget _buildDescribeTask(SpeakingTask task) {
    return Column(
      children: [
        // Image to describe
        Container(
          width: 300,
          height: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              task.imageUrl!,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  decoration: BoxDecoration(
                    color: AppColors.brownLight.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.image_outlined,
                          size: 48,
                          color: AppColors.brownDark.withOpacity(0.5),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Hình ảnh không khả dụng',
                          style: AppTextStyles.body.copyWith(
                            color: AppColors.brownDark.withOpacity(0.5),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        
        if (task.keywords != null && task.keywords!.isNotEmpty) ...[
          const SizedBox(height: 16),
          Text(
            'Gợi ý từ khóa:',
            style: AppTextStyles.bodyBold.copyWith(color: AppColors.brownDark),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: task.keywords!.map((keyword) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.brownLight.withOpacity(0.2),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                keyword,
                style: AppTextStyles.body.copyWith(color: AppColors.brownDark),
              ),
            )).toList(),
          ),
        ],
      ],
    );
  }

  Widget _buildConversationTask(SpeakingTask task) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.brownNormal.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(
            Icons.chat_bubble_outline,
            size: 64,
            color: AppColors.brownDark,
          ),
          const SizedBox(height: 16),
          Text(
            'Hãy trả lời câu hỏi bằng tiếng Anh',
            style: AppTextStyles.body.copyWith(color: AppColors.brownNormal),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildRecordingSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isRecording 
            ? Colors.red.withOpacity(0.3)
            : AppColors.brownNormal.withOpacity(0.3),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Recording Button
          GestureDetector(
            onTap: isRecording ? _stopRecording : _startRecording,
            child: AnimatedBuilder(
              animation: _pulseAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: isRecording ? _pulseAnimation.value : 1.0,
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isRecording ? Colors.red : AppColors.brownDark,
                      boxShadow: [
                        BoxShadow(
                          color: (isRecording ? Colors.red : AppColors.brownDark)
                              .withOpacity(0.3),
                          blurRadius: isRecording ? 20 : 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Icon(
                      isRecording ? Icons.stop : Icons.mic,
                      size: 40,
                      color: AppColors.white,
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          
          // Recording Status
          Text(
            isRecording 
              ? 'Đang ghi âm... ${_formatDuration(recordingDuration)}'
              : recordingStatus.isEmpty 
                ? 'Nhấn để bắt đầu ghi âm'
                : recordingStatus,
            style: AppTextStyles.bodyBold.copyWith(
              color: isRecording ? Colors.red : AppColors.brownDark,
            ),
            textAlign: TextAlign.center,
          ),
          
          if (isRecording) ...[
            const SizedBox(height: 16),
            // Wave animation
            AnimatedBuilder(
              animation: _waveAnimation,
              builder: (context, child) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) {
                    final delay = index * 0.2;
                    final animationValue = (_waveAnimation.value + delay) % 1.0;
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      height: 20 + (20 * animationValue),
                      width: 4,
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    );
                  }),
                );
              },
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildBottomControls() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.brownLight.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // Previous Button
          if (currentTaskIndex > 0)
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _previousTask,
                icon: Icon(Icons.arrow_back, color: AppColors.brownNormal),
                label: Text(
                  'Trước',
                  style: AppTextStyles.bodyBold.copyWith(color: AppColors.brownNormal),
                ),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: AppColors.brownNormal),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          
          if (currentTaskIndex > 0) const SizedBox(width: 16),
          
          // Next/Complete Button
          Expanded(
            flex: 2,
            child: ElevatedButton.icon(
              onPressed: widget.lesson.tasks[currentTaskIndex].isCompleted ? _nextTask : null,
              icon: Icon(
                currentTaskIndex == widget.lesson.tasks.length - 1 
                  ? Icons.check_circle 
                  : Icons.arrow_forward,
                color: AppColors.white,
              ),
              label: Text(
                currentTaskIndex == widget.lesson.tasks.length - 1 
                  ? 'Hoàn thành' 
                  : 'Tiếp theo',
                style: AppTextStyles.bodyBold.copyWith(color: AppColors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: widget.lesson.tasks[currentTaskIndex].isCompleted 
                  ? AppColors.brownDark 
                  : AppColors.brownNormal.withOpacity(0.5),
                foregroundColor: AppColors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRightSidebar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Danh sách bài tập',
            style: AppTextStyles.head3Bold.copyWith(color: AppColors.brownDark),
          ),
          const SizedBox(height: 16),
          
          Expanded(
            child: ListView.builder(
              itemCount: widget.lesson.tasks.length,
              itemBuilder: (context, index) {
                final task = widget.lesson.tasks[index];
                final isCurrentTask = index == currentTaskIndex;
                
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isCurrentTask 
                      ? AppColors.brownDark.withOpacity(0.1)
                      : task.isCompleted 
                        ? Colors.green.withOpacity(0.1)
                        : AppColors.brownLight.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isCurrentTask 
                        ? AppColors.brownDark
                        : task.isCompleted 
                          ? Colors.green
                          : AppColors.brownLight,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: task.isCompleted 
                            ? Colors.green 
                            : isCurrentTask 
                              ? AppColors.brownDark
                              : AppColors.brownLight,
                        ),
                        child: Center(
                          child: task.isCompleted 
                            ? Icon(Icons.check, size: 16, color: AppColors.white)
                            : Text(
                                '${index + 1}',
                                style: AppTextStyles.body.copyWith(
                                  color: AppColors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _getTaskTypeName(task.type),
                          style: AppTextStyles.body.copyWith(
                            color: AppColors.brownDark,
                            fontWeight: isCurrentTask ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Color _getTaskTypeColor(String type) {
    switch (type) {
      case 'repeat':
        return Colors.blue;
      case 'describe':
        return Colors.orange;
      case 'conversation':
        return Colors.green;
      default:
        return AppColors.brownNormal;
    }
  }

  String _getTaskTypeName(String type) {
    switch (type) {
      case 'repeat':
        return 'Lặp lại';
      case 'describe':
        return 'Mô tả';
      case 'conversation':
        return 'Hội thoại';
      default:
        return 'Bài tập';
    }
  }
}
