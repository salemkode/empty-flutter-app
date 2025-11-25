import 'package:flutter/material.dart';
import "type.dart";

class ProjectCard extends StatelessWidget {
  final Project project;
  const ProjectCard({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    return Card(
      borderOnForeground: false,
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              project.name,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(project.description),
            const SizedBox(height: 8),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: project.tags
                  .map(
                    (t) => Chip(
                      label: Text(t),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
