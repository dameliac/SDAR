import 'package:flutter/material.dart';

class NotificationStyle {
  final IconData icon;
  final Color iconBackgroundColor;
  final Color cardBackgroundColor;

  NotificationStyle({
    required this.icon,
    required this.iconBackgroundColor,
    required this.cardBackgroundColor,
  });
}

NotificationStyle getStyleForType(String type) {
  switch (type) {
    case 'error':
      return NotificationStyle(
        icon: Icons.error,
        iconBackgroundColor: Color(0xFFF44336),
        cardBackgroundColor: Color(0xFFFCE4E4),
      );
    case 'reminder':
      return NotificationStyle(
        icon: Icons.warning,
        iconBackgroundColor: Color(0xFFFFC107),
        cardBackgroundColor: Color(0xFFFFF9DC),
      );
    case 'general':
      return NotificationStyle(
        icon: Icons.alarm,
        iconBackgroundColor: Color(0xFF2196F3),
        cardBackgroundColor: Color(0xFFE0F0FF),
      );
    case 'eco_tips':
    default:
      return NotificationStyle(
        icon: Icons.info,
        iconBackgroundColor: Color(0xFF4CAF50),
        cardBackgroundColor: Color(0xFFDFF5E3),
      );
  }
}
