import 'package:flutter/material.dart';
import 'package:ringolingo_app/utils/color.dart';
import '../utils/text_styles.dart';

class SkillIcon extends StatefulWidget {
  final IconData? icon;
  final String? imagePath;
  final String title;
  final VoidCallback? onTap;

  final double width;
  final double iconSize;
  final Color? iconColor;
  final TextStyle? textStyle;

  const SkillIcon({
    Key? key,
    this.icon,
    this.imagePath,
    required this.title,
    this.onTap,
    this.width = 121,
    this.iconSize = 80,
    this.iconColor,
    this.textStyle,
  }) : super(key: key);

  @override
  State<SkillIcon> createState() => _SkillIconState();
}

class _SkillIconState extends State<SkillIcon> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: AnimatedScale(
        scale: _isHovering ? 1.2 : 1.0,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        child: InkWell(
          onTap: widget.onTap,
          borderRadius: BorderRadius.circular(widget.width / 2),
          child: SizedBox(
            width: widget.width,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: widget.width,
                  height: widget.width,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFFF2E9DE),
                  ),
                  child: Center(
                    child: widget.imagePath != null
                        ? Image.asset(
                            widget.imagePath!,
                            width: widget.iconSize,
                            height: widget.iconSize,
                            fit: BoxFit.contain,
                          )
                        : Icon(
                            widget.icon ?? Icons.help_outline,
                            size: widget.iconSize,
                            color: widget.iconColor ?? AppColors.brownNormal,
                          ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.title,
                  style: widget.textStyle ?? AppTextStyles.head3Black,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  softWrap: false,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
