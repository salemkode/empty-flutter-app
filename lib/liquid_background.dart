import 'package:flutter/material.dart';
import 'app_colors.dart';

class LiquidBackground extends StatelessWidget {
  final Widget child;

  const LiquidBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Base Gradient
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: AppColors.backgroundGradient,
            ),
          ),
        ),
        // Blob 1 (Top Left)
        Positioned(
          top: -100,
          left: -100,
          child: Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.blobColor1.withOpacity(0.6),
              boxShadow: [
                BoxShadow(
                  color: AppColors.blobColor1.withOpacity(0.4),
                  blurRadius: 100,
                  spreadRadius: 50,
                ),
              ],
            ),
          ),
        ),
        // Blob 2 (Center Right)
        Positioned(
          top: 200,
          right: -100,
          child: Container(
            width: 250,
            height: 250,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.blobColor2.withOpacity(0.5),
              boxShadow: [
                BoxShadow(
                  color: AppColors.blobColor2.withOpacity(0.4),
                  blurRadius: 100,
                  spreadRadius: 40,
                ),
              ],
            ),
          ),
        ),
        // Blob 3 (Bottom Left)
        Positioned(
          bottom: -50,
          left: -50,
          child: Container(
            width: 350,
            height: 350,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.blobColor3.withOpacity(0.4),
              boxShadow: [
                BoxShadow(
                  color: AppColors.blobColor3.withOpacity(0.3),
                  blurRadius: 120,
                  spreadRadius: 60,
                ),
              ],
            ),
          ),
        ),
        // Content
        child,
      ],
    );
  }
}
