import 'package:flutter/material.dart';
class Section extends StatelessWidget {
  final String title;
  final bool isCard;
  final Widget child;
  const Section({super.key, required this.title, required this.child, this.isCard = true});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    if (isCard) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                title,
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(color: cs.primary),
              ),
              const SizedBox(height: 10),
              child,
            ],
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(color: cs.primary),
        ),
        const SizedBox(height: 10),
        child,
      ],
    );
  }
}
