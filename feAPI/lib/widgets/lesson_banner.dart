// lesson_banner.dart
import 'package:flutter/material.dart';

class LessonBanner extends StatelessWidget {
  final String title;
  final String description;
  final String imagePath;
  final VoidCallback? onTap;

  const LessonBanner({
    Key? key,
    required this.title,
    required this.description,
    required this.imagePath,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.orangeAccent.shade100,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.orange.shade200.withOpacity(0.6),
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Image.asset(imagePath, width: 80, height: 80, fit: BoxFit.cover),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  Text(description, style: TextStyle(fontSize: 16, color: Colors.black87)),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 20, color: Colors.orange.shade700),
          ],
        ),
      ),
    );
  }
}
