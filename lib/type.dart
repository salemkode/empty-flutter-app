import 'package:flutter/material.dart';

class Project {
  final String name;
  final String description;
  final Uri url;
  final List<String> tags;
  const Project({
    required this.name,
    required this.description,
    required this.url,
    required this.tags,
  });
}

class SocialLink {
  final IconData icon;
  final String label;
  final Uri url;
  const SocialLink({
    required this.icon,
    required this.label,
    required this.url,
  });
}

