import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sdar/main.dart';
import 'package:sdar/helper/helper_notify.dart';
import 'package:pocketbase/pocketbase.dart';

class Messages extends StatefulWidget {
  const Messages({super.key});

  @override
  State<StatefulWidget> createState() {
    return _StateMessages();
  }
}

class _StateMessages extends State<Messages> {
  List<NotificationCard> notifications = [];
  final pb = PocketBase('http://localhost:8090');

  @override
  void initState() {
    super.initState();
    fetchUserNotifications();
  }

  Future<void> fetchUserNotifications() async {
    try {
      // Check if the user is authenticated
      if (pb.authStore.isValid) {
        final userId = pb.authStore.model?.id; // Get current user ID

        if (userId == null) {
          throw Exception('User ID is null');
        }

        // Fetch the current user's driver data (assuming a relation exists in the user model)
        final user = await pb.collection('users').getOne(userId);
        final driverId = user.getStringValue('driverId'); // Adjust this if the field name is different

        if (driverId == null) {
          throw Exception('Driver ID is null');
        }

        // Fetch notifications for the driver
        final result = await pb.collection('notifications').getFullList(
          sort: '-created',
          filter: 'driver = "$driverId"',  // Filter by the driverId
        );

        final List<NotificationCard> loaded = result.map((record) {
          final title = record.getStringValue('title');
          final message = record.getStringValue('message');
          final date = DateTime.parse(record.created);
          final type = record.getStringValue('type');
          final style = getStyleForType(type);

          return NotificationCard(
            icon: style.icon,
            iconBackgroundColor: style.iconBackgroundColor,
            cardBackgroundColor: style.cardBackgroundColor,
            title: title,
            message: message,
            date: date,
          );
        }).toList();

        if (!mounted) return;

        setState(() {
          notifications = loaded;
        });
      } else {
        // Handle the case when the user is not authenticated
        print('User is not authenticated');
        // You could navigate to a login page here, for example:
        // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
      }
    } catch (e) {
      print('Failed to load notifications: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final grouped = groupNotifications(notifications);
    return FScaffold(
      header: FHeader(
        title: Stack(
          alignment: Alignment.center,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => MyHomePage(title: 'SDAR')),
                  );
                },
                icon: const Icon(Icons.arrow_back, color: Colors.black),
              ),
            ),
            Center(
              child: Text(
                "Notifications",
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  textStyle: TextStyle(fontSize: 30, fontWeight: FontWeight.w700, color: Colors.black),
                ),
              ),
            ),
          ],
        ),
      ),
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
    required this.date,
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

// Group Notification by Date
Map<String, List<NotificationCard>> groupNotifications(List<NotificationCard> notifications) {
  final Map<String, List<NotificationCard>> grouped = {};

  for (var item in notifications) {
    final String key = '${DateFormat('MMMM yyyy').format(item.date)}';
    grouped.putIfAbsent(key, () => []).add(item);
  }

  return grouped;
}
