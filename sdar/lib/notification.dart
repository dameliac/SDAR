import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:intl/intl.dart';


class Messages extends StatefulWidget {
  const Messages({super.key});

  @override
  State<StatefulWidget> createState() {
    return _StateMessages();
  }
}

class _StateMessages extends State<Messages> {
  final List<NotificationCard> notifications = [
    NotificationCard(
      icon: Icons.info,
      iconBackgroundColor: Color(0xFF4CAF50),
      cardBackgroundColor: Color(0xFFDFF5E3),
      date: DateTime(2025, 5, 8),
      title: 'Eco-friendly tips',
      message: 'Combine trips to save fuel and cut emissions.',
    ),
    NotificationCard(
      icon: Icons.warning,
      iconBackgroundColor: Color(0xFFFFC107),
      cardBackgroundColor: Color(0xFFFFF9DC),
      date: DateTime(2025, 5, 8),
      title: 'Departure Reminder',
      message: 'Leave out now to avoid peak traffic time.',
    ),
    NotificationCard(
      icon: Icons.error,
      iconBackgroundColor: Color(0xFFF44336),
      cardBackgroundColor: Color(0xFFFCE4E4),
      date: DateTime(2025, 4, 10),
      title: 'Error',
      message: 'Trip to Fontana was not saved.',
    ),
    NotificationCard(
      icon: Icons.info,
      iconBackgroundColor: Color(0xFF2196F3),
      cardBackgroundColor: Color(0xFFE0F0FF),
      date: DateTime(2025, 5, 20),
      title: 'Account needs action',
      message: 'Please complete your account.',
    ),
  ];

    @override
  Widget build(BuildContext context) {
    final grouped = groupNotifications(notifications);
    return FScaffold(
      header: FHeader(title: const Text("Notifications")),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: grouped.entries.map((entry) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 16),
                  Text(
                    entry.key,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  ...entry.value,
                ],
              );
            }).toList(),
          ),
        ),
      );
  }
}

//generated from ChatGPT
class NotificationCard extends StatelessWidget {
  final IconData icon;
  final Color iconBackgroundColor;
  final Color cardBackgroundColor;
  final String title;
  final String message;
  final DateTime date;

  const NotificationCard({
    Key? key,
    required this.icon,
    required this.iconBackgroundColor,
    required this.cardBackgroundColor,
    required this.title,
    required this.message,
    required this.date
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cardBackgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Circular icon
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: iconBackgroundColor,
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 20,
            ),
          ),
          SizedBox(width: 12),
          // Text content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  message,
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

//Group Notification by Date
Map<String, List<NotificationCard>> groupNotifications(List<NotificationCard> notifications) {
  final Map<String, List<NotificationCard>> grouped = {};

  for (var item in notifications) {
    final String key = '${DateFormat('MMMM yyyy').format(item.date)}';
    grouped.putIfAbsent(key, () => []).add(item);
  }

  return grouped;
}
