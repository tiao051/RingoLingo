import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:ringolingo_app/utils/color.dart';
import 'package:ringolingo_app/utils/text_styles.dart';
import 'dart:async';
import 'dart:math';
import 'package:record/record.dart';
import 'dart:html' as html;
import 'package:speech_to_text/speech_to_text.dart' as stt;

class SpeakingPracticeScreen extends StatefulWidget {
  final String lessonTitle;
  final int lessonId;
  final List<SpeakingExercise> exercises;

  const SpeakingPracticeScreen({
    Key? key,
    required this.lessonTitle,
    required this.lessonId,
    required this.exercises,
  }) : super(key: key);

  @override
  _SpeakingPracticeScreenState createState() => _SpeakingPracticeScreenState();
}

class _SpeakingPracticeScreenState extends State<SpeakingPracticeScreen>
    with TickerProviderStateMixin {
  // Animation Controllers
  late AnimationController _pulseController;
  late AnimationController _progressController;
  late AnimationController _slideController;
  late AnimationController _bounceController;

  // Animations
  late Animation<double> _pulseAnimation;
  late Animation<double> _progressAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _bounceAnimation;

  // State variables
  int currentExerciseIndex = 0;
  bool isRecording = false;
  bool isPlaying = false;
  bool hasRecorded = false;
  double recordingTime = 0.0;
  double playbackTime = 0.0;
  Timer? _recordingTimer;
  Timer? _playbackTimer;

  // Audio visualization
  List<double> audioLevels = List.generate(30, (index) => 0.0);
  Timer? _audioLevelTimer;
  final Record _recorder = Record();
  String? _audioUrl; // Đường dẫn file ghi âm (web: blob url)

  // Speech to text
  late stt.SpeechToText _speech;
  String _recognizedText = '';
  String _backendResult = '';

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _slideController.forward();
    _speech = stt.SpeechToText();
  }

  void _initializeAnimations() {
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _progressController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _bounceController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _progressAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _progressController, curve: Curves.easeOutCubic),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    _bounceAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _bounceController, curve: Curves.elasticOut),
    );

    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _progressController.dispose();
    _slideController.dispose();
    _bounceController.dispose();
    _recordingTimer?.cancel();
    _playbackTimer?.cancel();
    _audioLevelTimer?.cancel();
    _recorder.dispose();
    super.dispose();
  }

  Future<void> _startRecording() async {
    print('[DEBUG] _startRecording called');
    if (await _recorder.hasPermission()) {
      print('[DEBUG] Microphone permission granted');
      setState(() {
        isRecording = true;
        recordingTime = 0.0;
        hasRecorded = false;
        _audioUrl = null;
        _recognizedText = '';
      });
      _pulseController.repeat(reverse: true);
      _startAudioVisualization();
      // Start speech recognition
      bool available = await _speech.initialize(
        onStatus: (status) => print('[DEBUG] Speech status: ' + status),
        onError: (error) => print('[DEBUG] Speech error: ' + error.errorMsg),
      );
      if (available) {
        _speech.listen(
          onResult: (result) {
            setState(() {
              _recognizedText = result.recognizedWords;
            });
          },
          listenMode: stt.ListenMode.dictation,
          partialResults: true,
          localeId: 'en_US', // hoặc 'vi_VN' nếu muốn nhận diện tiếng Việt
        );
      }
      // Ghi âm thật
      await _recorder.start(
        encoder: AudioEncoder.opus, // dùng opus cho web/mobile
        bitRate: 128000,
        samplingRate: 44100,
      );
      print('[DEBUG] Recording started');
      _recordingTimer =
          Timer.periodic(const Duration(milliseconds: 100), (timer) async {
        setState(() {
          recordingTime += 0.1;
        });
        if (recordingTime >= 30.0) {
          await _stopRecording();
        }
      });
    } else {
      print('[DEBUG] Microphone permission denied');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Không có quyền truy cập microphone!')),
      );
    }
  }

  Future<void> _stopRecording() async {
    print('[DEBUG] _stopRecording called');
    setState(() {
      isRecording = false;
      hasRecorded = true;
    });
    _pulseController.stop();
    _pulseController.reset();
    _recordingTimer?.cancel();
    _audioLevelTimer?.cancel();
    _bounceController.forward();
    // Stop speech recognition
    await _speech.stop();
    // Lấy file ghi âm
    final path = await _recorder.stop();
    print('[DEBUG] Recording stopped, path: ' + (path ?? 'null'));
    if (path != null) {
      print(' vao day roi');
      _audioUrl = path;
      // Lấy dữ liệu blob audio ngay sau khi ghi xong
      final audioData = await _getAudioBlobData();
      print('[DEBUG] Audio blob data retrieved: $audioData');
      if (audioData != null) {
        print('[DEBUG] Audio blob size: \\${audioData.length} bytes');
        await _uploadAudioToBackend(audioData);
      } else {
        print('[DEBUG] Không lấy được dữ liệu blob audio');
      }
    }
    setState(() {
      audioLevels = List.generate(30, (index) => 0.0);
    });
  }

  Future<void> _startPlayback() async {
    print('[DEBUG] _startPlayback called');
    if (!hasRecorded || _audioUrl == null) {
      print('[DEBUG] No recording to play');
      return;
    }
    setState(() {
      isPlaying = true;
      playbackTime = 0.0;
    });
    _startAudioVisualization();
    // Phát lại trên web dùng AudioElement
    if (_audioUrl != null) {
      print('[DEBUG] Playing audio from url: ' + _audioUrl!);
      final audio = html.AudioElement(_audioUrl!);
      audio.onEnded.listen((event) {
        print('[DEBUG] Audio playback ended');
        _stopPlayback();
      });
      audio.play();
      _playbackTimer =
          Timer.periodic(const Duration(milliseconds: 100), (timer) {
        setState(() {
          playbackTime += 0.1;
        });
        if (playbackTime >= recordingTime) {
          print('[DEBUG] Playback timer reached recordingTime');
          _stopPlayback();
        }
      });
    }
  }

  void _stopPlayback() {
    setState(() {
      isPlaying = false;
    });
    _playbackTimer?.cancel();
    _audioLevelTimer?.cancel();
    setState(() {
      audioLevels = List.generate(30, (index) => 0.0);
    });
  }

  void _startAudioVisualization() {
    _audioLevelTimer =
        Timer.periodic(const Duration(milliseconds: 50), (timer) {
      setState(() {
        for (int i = 0; i < audioLevels.length; i++) {
          audioLevels[i] =
              Random().nextDouble() * (isRecording || isPlaying ? 1.0 : 0.0);
        }
      });
    });
  }

  void _nextExercise() {
    if (currentExerciseIndex < widget.exercises.length - 1) {
      setState(() {
        currentExerciseIndex++;
        hasRecorded = false;
        recordingTime = 0.0;
        playbackTime = 0.0;
        _audioUrl = null;
        _recognizedText = ''; // Clear recognized text
        _backendResult = ''; // Clear backend result khi sang câu mới
      });

      _progressController.forward();
      _slideController.reset();
      _slideController.forward();
    } else {
      _showCompletionDialog();
    }
  }

  void _previousExercise() {
    if (currentExerciseIndex > 0) {
      setState(() {
        currentExerciseIndex--;
        hasRecorded = false;
        recordingTime = 0.0;
        playbackTime = 0.0;
        _audioUrl = null;
        _recognizedText = ''; // Clear recognized text
        _backendResult = ''; // Clear backend result
      });

      _slideController.reset();
      _slideController.forward();
    }
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.green.shade50, Colors.green.shade100],
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.green.shade400, Colors.green.shade600],
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_rounded,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Chúc mừng!',
                  style: AppTextStyles.head2Bold.copyWith(
                    color: Colors.green.shade700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Bạn đã hoàn thành bài luyện nói',
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Colors.green.shade600,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                        },
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(color: Colors.green.shade300),
                          ),
                        ),
                        child: Text(
                          'Về trang chủ',
                          style: TextStyle(color: Colors.green.shade600),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          setState(() {
                            currentExerciseIndex = 0;
                            hasRecorded = false;
                            recordingTime = 0.0;
                            playbackTime = 0.0;
                            _recognizedText = '';
                            _backendResult = '';
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green.shade500,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Luyện lại',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Hàm này dùng để lấy blob từ blob url (web) để gửi lên backend
  Future<Uint8List?> _getAudioBlobData() async {
    print('[DEBUG] Bắt đầu lấy blob audio...');
    if (_audioUrl != null && _audioUrl!.startsWith('blob:')) {
      print('[DEBUG] _audioUrl hợp lệ: $_audioUrl');

      try {
        final xhr = html.HttpRequest();

        print('[DEBUG] Tạo XMLHttpRequest xong, mở kết nối...');
        xhr.open('GET', _audioUrl!);
        xhr.responseType = 'arraybuffer';

        print('[DEBUG] Gửi request...');
        xhr.send();

        print('[DEBUG] Đợi phản hồi load...');
        await xhr.onLoadEnd.first;

        print('[DEBUG] Đã load xong, kiểm tra status: ${xhr.status}');
        if (xhr.status == 200 || xhr.status == 0) {
          final buffer = xhr.response as ByteBuffer;
          final result = buffer.asUint8List();
          print(
              '[✅] Lấy dữ liệu blob audio thành công, size: ${result.length}');
          return result;
        } else {
          print('[❌] Lỗi status khi lấy blob: ${xhr.status}');
        }
      } catch (e) {
        print('[❌] Exception khi lấy blob audio: $e');
      }
    } else {
      print('[❌] _audioUrl null hoặc không phải blob URL: $_audioUrl');
    }

    return null;
  }

  Future<void> _uploadAudioToBackend(Uint8List audioData) async {
    final formData = html.FormData();
    final blob = html.Blob([audioData], 'audio/webm'); // đúng mime type
    formData.appendBlob('file', blob, 'recording.webm'); // khớp key 'file'

    try {
      final request = await html.HttpRequest.request(
        'http://127.0.0.1:5000/transcribe', // ✅ sửa endpoint đúng
        method: 'POST',
        sendData: formData,
      );

      print(
          '[DEBUG] Backend response: [38;5;2m[1m[4m[3m[9m${request.responseText}[0m');
      // Parse JSON và setState để hiển thị kết quả
      try {
        final json = request.responseText;
        if (json != null && json.isNotEmpty) {
          final decoded = jsonDecode(json); // dùng jsonDecode từ dart:convert
          setState(() {
            _backendResult = decoded['text']?.toString() ?? '';
          });
        }
      } catch (e) {
        print('[DEBUG] Lỗi parse JSON backend: $e');
      }
    } catch (e) {
      print('[DEBUG] Upload error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentExercise = widget.exercises[currentExerciseIndex];
    final progress = (currentExerciseIndex + 1) / widget.exercises.length;

    return Scaffold(
      backgroundColor: const Color(0xFFD5B893),
      body: SafeArea(
        child: Column(
          children: [
            // Header with back button and title - Fixed height
            Container(
              padding: const EdgeInsets.all(20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.brownNormal.withOpacity(0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back_rounded),
                      color: AppColors.brownDark,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    'Pronunciation Practice: Animals',
                    style: AppTextStyles.head2Bold.copyWith(
                      color: AppColors.brownDark,
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Bài số
                  Text(
                    'Bài ${currentExerciseIndex + 1}/${widget.exercises.length}',
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: AppColors.brownNormal,
                        ),
                  ),
                ],
              ),
            ),

            // Scrollable content
            Expanded(
              child: SlideTransition(
                position: _slideAnimation,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.brownNormal.withOpacity(0.15),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Exercise instruction
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Colors.blue.shade50,
                                Colors.blue.shade100,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Colors.blue.shade200,
                              width: 1,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Colors.blue.shade500,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Icon(
                                      Icons.lightbulb_outline,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    'Hướng dẫn',
                                    style: AppTextStyles.head3Bold.copyWith(
                                      color: Colors.blue.shade700,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Text(
                                currentExercise.instruction,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                      color: Colors.blue.shade600,
                                      height: 1.5,
                                    ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Text to practice
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                AppColors.brownLight.withOpacity(0.1),
                                AppColors.brownLight.withOpacity(0.2),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: AppColors.brownNormal.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: Column(
                            children: [
                              Icon(
                                Icons.format_quote,
                                color: AppColors.brownNormal,
                                size: 32,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                currentExercise.textToPractice,
                                style: AppTextStyles.head3Bold.copyWith(
                                  color: AppColors.brownDark,
                                  height: 1.6,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 32),

                        // Audio visualization
                        if (isRecording || isPlaying) ...[
                          Container(
                            height: 80,
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: audioLevels.map((level) {
                                return AnimatedContainer(
                                  duration: const Duration(milliseconds: 100),
                                  width: 4,
                                  height: 20 + (level * 40),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.bottomCenter,
                                      end: Alignment.topCenter,
                                      colors: isRecording
                                          ? [
                                              Colors.red.shade400,
                                              Colors.red.shade600
                                            ]
                                          : [
                                              Colors.blue.shade400,
                                              Colors.blue.shade600
                                            ],
                                    ),
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],
                        if (_recognizedText.isNotEmpty) ...[
                          Container(
                            width: double.infinity,
                            margin: const EdgeInsets.only(bottom: 16),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.yellow.shade50,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.yellow.shade200),
                            ),
                            child: Text(
                              _recognizedText,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(
                                    color: Colors.brown.shade800,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                          ),
                        ],
                        if (_backendResult.isNotEmpty) ...[
                          Container(
                            width: double.infinity,
                            margin: const EdgeInsets.only(bottom: 16),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.green.shade50,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.green.shade200),
                            ),
                            child: Text(
                              _backendResult,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(
                                    color: Colors.green.shade800,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                          ),
                        ],

                        // Recording controls
                        Container(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            children: [
                              // Timer
                              Text(
                                isRecording
                                    ? '${recordingTime.toStringAsFixed(1)}s'
                                    : isPlaying
                                        ? '${playbackTime.toStringAsFixed(1)}s / ${recordingTime.toStringAsFixed(1)}s'
                                        : hasRecorded
                                            ? 'Đã ghi ${recordingTime.toStringAsFixed(1)}s'
                                            : 'Sẵn sàng ghi âm',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(
                                      color: AppColors.brownNormal,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                              const SizedBox(height: 20),

                              // Control buttons
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  // Play button
                                  AnimatedOpacity(
                                    duration: const Duration(milliseconds: 300),
                                    opacity: hasRecorded ? 1.0 : 0.5,
                                    child: Container(
                                      width: 60,
                                      height: 60,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: hasRecorded
                                              ? [
                                                  Colors.blue.shade400,
                                                  Colors.blue.shade600
                                                ]
                                              : [
                                                  Colors.grey.shade300,
                                                  Colors.grey.shade400
                                                ],
                                        ),
                                        shape: BoxShape.circle,
                                        boxShadow: hasRecorded && !isPlaying
                                            ? [
                                                BoxShadow(
                                                  color: Colors.blue
                                                      .withOpacity(0.3),
                                                  blurRadius: 10,
                                                  offset: const Offset(0, 4),
                                                ),
                                              ]
                                            : [],
                                      ),
                                      child: Material(
                                        color: Colors.transparent,
                                        child: InkWell(
                                          onTap: hasRecorded && !isRecording
                                              ? (isPlaying
                                                  ? _stopPlayback
                                                  : _startPlayback)
                                              : null,
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          child: Icon(
                                            isPlaying
                                                ? Icons.stop
                                                : Icons.play_arrow,
                                            color: Colors.white,
                                            size: 30,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),

                                  // Record button
                                  AnimatedBuilder(
                                    animation: _pulseAnimation,
                                    builder: (context, child) {
                                      return Transform.scale(
                                        scale: isRecording
                                            ? _pulseAnimation.value
                                            : 1.0,
                                        child: Container(
                                          width: 80,
                                          height: 80,
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: isRecording
                                                  ? [
                                                      Colors.red.shade400,
                                                      Colors.red.shade600
                                                    ]
                                                  : [
                                                      Colors.green.shade400,
                                                      Colors.green.shade600
                                                    ],
                                            ),
                                            shape: BoxShape.circle,
                                            boxShadow: [
                                              BoxShadow(
                                                color: (isRecording
                                                        ? Colors.red
                                                        : Colors.green)
                                                    .withOpacity(0.4),
                                                blurRadius:
                                                    isRecording ? 20 : 15,
                                                offset: const Offset(0, 6),
                                              ),
                                            ],
                                          ),
                                          child: Material(
                                            color: Colors.transparent,
                                            child: InkWell(
                                              onTap: isPlaying
                                                  ? null
                                                  : (isRecording
                                                      ? _stopRecording
                                                      : _startRecording),
                                              borderRadius:
                                                  BorderRadius.circular(40),
                                              child: Icon(
                                                isRecording
                                                    ? Icons.stop
                                                    : Icons.mic,
                                                color: Colors.white,
                                                size: 36,
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),

                                  // Reset button
                                  AnimatedOpacity(
                                    duration: const Duration(milliseconds: 300),
                                    opacity: hasRecorded ? 1.0 : 0.5,
                                    child: Container(
                                      width: 60,
                                      height: 60,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: hasRecorded
                                              ? [
                                                  Colors.orange.shade400,
                                                  Colors.orange.shade600
                                                ]
                                              : [
                                                  Colors.grey.shade300,
                                                  Colors.grey.shade400
                                                ],
                                        ),
                                        shape: BoxShape.circle,
                                        boxShadow: hasRecorded &&
                                                !isRecording &&
                                                !isPlaying
                                            ? [
                                                BoxShadow(
                                                  color: Colors.orange
                                                      .withOpacity(0.3),
                                                  blurRadius: 10,
                                                  offset: const Offset(0, 4),
                                                ),
                                              ]
                                            : [],
                                      ),
                                      child: Material(
                                        color: Colors.transparent,
                                        child: InkWell(
                                          onTap: hasRecorded &&
                                                  !isRecording &&
                                                  !isPlaying
                                              ? () {
                                                  setState(() {
                                                    hasRecorded = false;
                                                    recordingTime = 0.0;
                                                    playbackTime = 0.0;
                                                    _audioUrl = null;
                                                    audioLevels = List.generate(
                                                        30, (index) => 0.0);
                                                  });
                                                }
                                              : null,
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          child: const Icon(
                                            Icons.refresh,
                                            color: Colors.white,
                                            size: 30,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Navigation buttons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            if (currentExerciseIndex > 0)
                              SizedBox(
                                width: 140,
                                child: ElevatedButton.icon(
                                  onPressed: _previousExercise,
                                  icon: const Icon(Icons.arrow_back),
                                  label: const Text('Trước'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.grey.shade200,
                                    foregroundColor: Colors.grey.shade700,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 14),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                              ),
                            if (currentExerciseIndex > 0)
                              const SizedBox(width: 12),
                            SizedBox(
                              width: 160,
                              child: AnimatedBuilder(
                                animation: _bounceAnimation,
                                builder: (context, child) {
                                  return Transform.scale(
                                    scale: hasRecorded
                                        ? 1.0 + (_bounceAnimation.value * 0.05)
                                        : 1.0,
                                    child: ElevatedButton.icon(
                                      onPressed:
                                          hasRecorded ? _nextExercise : null,
                                      icon: Icon(
                                        currentExerciseIndex ==
                                                widget.exercises.length - 1
                                            ? Icons.check_rounded
                                            : Icons.arrow_forward,
                                      ),
                                      label: Text(
                                        currentExerciseIndex ==
                                                widget.exercises.length - 1
                                            ? 'Hoàn thành'
                                            : 'Tiếp theo',
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: hasRecorded
                                            ? (currentExerciseIndex ==
                                                    widget.exercises.length - 1
                                                ? Colors.green.shade500
                                                : Colors.blue.shade500)
                                            : Colors.grey.shade300,
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 14),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
// Add some bottom padding for better scrolling experience
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Model classes
class SpeakingExercise {
  final int id;
  final String instruction;
  final String textToPractice;
  final String? audioUrl;
  final String? pronunciation;

  SpeakingExercise({
    required this.id,
    required this.instruction,
    required this.textToPractice,
    this.audioUrl,
    this.pronunciation,
  });
}

// Sample data generator
List<SpeakingExercise> getSampleSpeakingExercises() {
  return [
    SpeakingExercise(
      id: 1,
      instruction:
          'Hãy đọc to và rõ ràng từ vựng về động vật sau đây. Chú ý phát âm đúng từng từ.',
      textToPractice: 'Cat, Dog, Bird, Fish, Elephant, Tiger, Lion, Monkey',
    ),
    SpeakingExercise(
      id: 2,
      instruction:
          'Thực hành nói câu hoàn chỉnh về động vật. Hãy nói chậm và rõ ràng.',
      textToPractice:
          'I have a cute cat. The big elephant is gray. Birds can fly in the sky.',
    ),
    SpeakingExercise(
      id: 3,
      instruction:
          'Mô tả động vật yêu thích của bạn. Sử dụng các tính từ để miêu tả.',
      textToPractice:
          'My favorite animal is a dog. It is friendly, loyal, and very playful.',
    ),
    SpeakingExercise(
      id: 4,
      instruction:
          'Thực hành hội thoại về động vật. Hãy tưởng tượng bạn đang trò chuyện với bạn bè.',
      textToPractice:
          'What animals do you like? I like cats because they are cute and independent.',
    ),
  ];
}
