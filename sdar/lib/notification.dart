import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sdar/main.dart';
import 'package:sdar/helper/helper_notify.dart';
import 'package:provider/provider.dart';
import 'package:sdar/app_provider.dart'; 
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
   late PocketBase pb;
  

 @override
void initState() {
  super.initState();
  WidgetsBinding.instance.addPostFrameCallback((_) {
    
    final appProvider = Provider.of<AppProvider>(context, listen: false);
    pb = appProvider.pb;
    fetchUserNotifications();
  });
}


  Future<void> fetchUserNotifications() async {

    // notifications.clear();
    try {
     final appProvider = Provider.of<AppProvider>(context, listen: false);
     final userId = appProvider.userdata?.record.id; // Get current user ID
     final driverinfo = await pb
      .collection('Driver')
      .getFirstListItem('userID = "$userId"');
     final driverID = driverinfo.id;

      if(userId == null){
        print('User ID is null');
        return;
      }

      final result = await pb.collection('Notification').getFullList(
        ///sort: '-created',
        filter: 'driverID = "$driverID"',
      );

      final List<NotificationCard> loaded = result.map((record) {
        final title = record.getStringValue('Title');
        final message = record.getStringValue('Message');
        // ignore: deprecated_member_use
        final date = DateTime.parse(record.created);
        final type = record.getStringValue('NotificationType');
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

      // Ensure the widget is still mounted before calling setState()
      if (!mounted) return;

      setState(() {
        notifications = loaded;
      });
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
                  // Your onPressed logic here
                  Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (context) => MyHomePage(title: 'SDAR')),
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

// Group Notification by Date
Map<String, List<NotificationCard>> groupNotifications(List<NotificationCard> notifications) {
  final Map<String, List<NotificationCard>> grouped = {};

  for (var item in notifications) {
    final String key = '${DateFormat('MMMM yyyy').format(item.date)}';
    grouped.putIfAbsent(key, () => []).add(item);
  }

  return grouped;
}
