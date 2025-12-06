import 'package:flutter/material.dart';
import 'liquid_background.dart';

class SearchOverlay extends StatelessWidget {
  final double opacity;
  final bool isVisible;
  final VoidCallback onClose;
  final Widget child;

  const SearchOverlay({
    super.key,
    required this.opacity,
    required this.isVisible,
    required this.onClose,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: !isVisible,
      child: Opacity(
        opacity: opacity,
        child: LiquidBackground(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 100.0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 10.0,
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: onClose,
                          icon: const Icon(
                            Icons.arrow_back_ios,
                            color: Colors.white,
                          ),
                        ),
                        const Expanded(
                          child: Text(
                            'البحث عن مدينة',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            textDirection: TextDirection.rtl,
                          ),
                        ),
                        const SizedBox(width: 48),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Expanded(child: child),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

