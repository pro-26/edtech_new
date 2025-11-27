// lib/app/global_widgets/subjectscard.dart
import 'package:ed_tech/app/data/models/course.model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SubjectsCard extends StatelessWidget {
  final Course course;
  final VoidCallback? onTap;

  const SubjectsCard({super.key, required this.course, this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Get.theme;
    final colorScheme = theme.colorScheme;
    final screenWidth = Get.width;

    // Adaptive sizes
    final imageSize = screenWidth * 0.18; // 18% of screen width
    final buttonWidth = screenWidth * 0.25; // 25% of screen width

    return Card(
      color: colorScheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 1,
      child: Padding(
        padding: EdgeInsets.all(screenWidth * 0.04),
        child: Row(
          children: [
            // Responsive image with a fixed size
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                course.thumbnail ??
                    'https://images.unsplash.com/photo-1551434678-e076c223a692?w=800',
                width: imageSize,
                height: imageSize,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: imageSize,
                  height: imageSize,
                  color: Colors.grey[300],
                  child: Icon(Icons.image_not_supported),
                ),
              ),
            ),
            SizedBox(width: screenWidth * 0.04),

            // Text section
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    course.title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: screenWidth * 0.01),
                  Text(
                    'Instructor', // Placeholder as instructor name is not in Course model yet
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.grey,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            // Responsive button
            SizedBox(
              width: buttonWidth,
              child: ElevatedButton(
                onPressed: onTap,
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  foregroundColor: colorScheme.onPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.symmetric(vertical: screenWidth * 0.025),
                ),
                child: const Text('View'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
