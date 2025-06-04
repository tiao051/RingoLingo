import 'dart:math' as math;
import 'package:flutter/material.dart';

class FlippableBanner extends StatefulWidget {
  final String imagePath;
  final VoidCallback onTap;
  final String backText;
  final double? width;
  final double? height;

  const FlippableBanner({
    super.key,
    required this.imagePath,
    required this.onTap,
    required this.backText,
    this.width,
    this.height,
  });

  @override
  State<FlippableBanner> createState() => _FlippableBannerState();
}

class _FlippableBannerState extends State<FlippableBanner>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onHover(bool hovering) {
    setState(() {
      _isHovered = hovering;
      if (hovering) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = widget.width ??
        (MediaQuery.of(context).size.width < 600 ? 300 : 400);
    final height = widget.height ??
        (MediaQuery.of(context).size.width < 600 ? 160 : 220);

    return MouseRegion(
      onEnter: (_) => _onHover(true),
      onExit: (_) => _onHover(false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            final angle = _animation.value * math.pi;
            final isFront = angle <= math.pi / 2;

            return Transform(
              alignment: Alignment.center,
              transform: Matrix4.rotationY(angle),
              child: isFront
                  ? Container(
                      width: width,
                      height: height,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.asset(
                          widget.imagePath,
                          fit: BoxFit.cover,
                        ),
                      ),
                    )
                  : Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.rotationY(math.pi),
                      child: Stack(
                        children: [
                          Container(
                            width: width,
                            height: height,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFFff6a00), Color(0xFFee0979)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 10,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            alignment: Alignment.center,
                            child: AnimatedScale(
                              scale: _isHovered ? 1.05 : 1.0,
                              duration: const Duration(milliseconds: 300),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.auto_awesome,
                                    color: Colors.white,
                                    size: 36,
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    widget.backText,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 26,
                                      fontWeight: FontWeight.bold,
                                      shadows: [
                                        Shadow(
                                          blurRadius: 10,
                                          color: Colors.black45,
                                          offset: Offset(2, 2),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  const Text(
                                    "Khám phá ngay!",
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // Moving light effect
                          Positioned.fill(
                            child: AnimatedOpacity(
                              opacity: _isHovered ? 0.3 : 0,
                              duration: const Duration(milliseconds: 600),
                              child: TweenAnimationBuilder<double>(
                                tween: Tween(begin: -1, end: 2),
                                duration: const Duration(seconds: 2),
                                curve: Curves.easeInOut,
                                builder: (context, value, _) {
                                  return Transform.translate(
                                    offset: Offset(value * width, 0),
                                    child: Container(
                                      width: 60,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            Colors.white.withOpacity(0),
                                            Colors.white.withOpacity(0.2),
                                            Colors.white.withOpacity(0),
                                          ],
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                onEnd: () {
                                  if (_isHovered) {
                                    setState(() {}); // restart animation
                                  }
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
            );
          },
        ),
      ),
    );
  }
}
