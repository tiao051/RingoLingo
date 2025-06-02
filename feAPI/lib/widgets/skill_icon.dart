import 'package:flutter/material.dart';
import 'package:ringolingo_app/utils/color.dart';
import '../utils/text_styles.dart';

class SkillIcon extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: width,
        child: Column(
          children: [
            Container(
              width: width,
              height: width,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFF2E9DE),
              ),
              child: Center(
                child: imagePath != null
                    ? Image.asset(
                        imagePath!,
                        width: iconSize,
                        height: iconSize,
                        fit: BoxFit.contain,
                      )
                    : Icon(
                        icon ?? Icons.help_outline,
                        size: iconSize,
                        color: iconColor ?? AppColors.brownNormal,
                      ),
              ),
            ),

            const Spacer(),

            Text(
              title,
              style: textStyle ?? AppTextStyles.head3Black,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              softWrap: false,
            ),
          ],
        ),
      ),
    );
  }
}
