import 'dart:math' as math;
import 'package:flutter/material.dart';

class FlippableBanner extends StatefulWidget {
  final String imagePath;
  final VoidCallback onTap;
  final double? width;
  final double? height;

  const FlippableBanner({
    super.key,
    required this.imagePath,
    required this.onTap,
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
                      child: Container(
                        width: width,
                        height: height,
                        decoration: BoxDecoration(
                          color: Colors.redAccent,
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
                        child: const Text(
                          'BẮT ĐẦU',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ),
                    ),
            );
          },
        ),
      ),
    );
  }
}
