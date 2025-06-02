import 'package:flutter/material.dart';
import 'package:ringolingo_app/utils/color.dart';
import '../utils/text_styles.dart';

class SkillIcon extends StatelessWidget {
  final IconData? icon;
  final String? imagePath;
  final String title;
  final VoidCallback? onTap;

  final double width;
  final double height;
  final double iconSize;
  final double spacing;
  final Color? iconColor;
  final TextStyle? textStyle;

  const SkillIcon({
    Key? key,
    this.icon,
    this.imagePath,
    required this.title,
    this.onTap,
    this.width = 101,
    this.height = 260,
    this.iconSize = 60,
    this.spacing = 24,
    this.iconColor,
    this.textStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        child: Column(
          children: [
            SizedBox(
              width: width - 1,
              height: width - 1,
              child: imagePath != null
                  ? Image.asset(
                      imagePath!,
                      fit: BoxFit.contain,
                    )
                  : Icon(
                      icon ?? Icons.help_outline,
                      size: iconSize,
                      color: iconColor ?? AppColors.brownNormal,
                    ),
            ),
            SizedBox(height: spacing),
            Text(
              title,
              style: textStyle ?? AppTextStyles.head3Black,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

