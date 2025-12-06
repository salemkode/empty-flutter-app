import 'package:flutter/material.dart';
import 'glass_container.dart';
import '../app_colors.dart';

class CustomSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onClose;
  final double scale;
  final double opacity;
  final bool isVisible;

  const CustomSearchBar({
    super.key,
    required this.controller,
    required this.onClose,
    required this.scale,
    required this.opacity,
    required this.isVisible,
  });

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: scale,
      alignment: Alignment.bottomCenter,
      child: Opacity(
        opacity: opacity,
        child: IgnorePointer(
          ignoring: !isVisible,
          child: GlassContainer(
            height: 60,
            borderRadius: BorderRadius.circular(30),
            margin: const EdgeInsets.fromLTRB(20, 0, 20, 30),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                children: [
                  const Icon(
                    Icons.search_rounded,
                    color: Colors.white,
                    size: 24,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: controller,
                      decoration: const InputDecoration(
                        hintText: 'ابحث عن مدينة...',
                        hintStyle: TextStyle(
                          color: AppColors.textSecondary,
                        ),
                        border: InputBorder.none,
                      ),
                      style: const TextStyle(color: Colors.white),
                      onTapOutside: (event) =>
                          FocusManager.instance.primaryFocus?.unfocus(),
                    ),
                  ),
                  IconButton(
                    onPressed: onClose,
                    icon: const Icon(
                      Icons.close_rounded,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
