import 'package:flutter/material.dart';

class ScenePreset {
  const ScenePreset({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.prompt,
    required this.icon,
    required this.gradient,
  });

  final String id;
  final String title;
  final String subtitle;
  final String prompt;
  final IconData icon;
  final List<Color> gradient;
}


