import 'dart:convert';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:timezone/timezone.dart' as tz;

class CommuteService {
  final String pocketbaseUrl = "http://localhost:8090/api/collections/Commute/records";
  final FlutterLocalNotificationsPlugin notificationsPlugin = FlutterLocalNotificationsPlugin();

  CommuteService() {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    notificationsPlugin.initialize(initializationSettings);
  }

  /// Save commute to PocketBase
  Future<void> saveCommute({
    required String start,
    required String end,
    required List<String> days,
    required String arriveByTime,
    required bool remindMe,
  }) async {
    final response = await http.post(
      Uri.parse(pocketbaseUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "start": start,
        "end": end,
        "days": days,
        "arriveByTime": arriveByTime,
        "remindMe": remindMe,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      print("Commute saved successfully!");
      if (remindMe) {
        await scheduleNotifications(days, arriveByTime, start, end);
      }
    } else {
      throw Exception("Failed to save commute: ${response.body}");
    }
  }

  /// Simulate traffic adjustment and schedule notifications
  Future<void> scheduleNotifications(
      List<String> days, String arriveByTime, String start, String end) async {
    // Simulate fetching traffic delay (replace with live API later)
    int trafficDelayInMinutes = await _simulateTrafficDelay(start, end);

    final timeParts = arriveByTime.split(":");
    int hour = int.parse(timeParts[0]);
    int minute = int.parse(timeParts[1]);

    final baseTime = DateTime.now();
    for (String day in days) {
      final dayOffset = _dayToWeekdayOffset(day);
      final adjustedDateTime = DateTime(
        baseTime.year,
        baseTime.month,
        baseTime.day + (dayOffset - baseTime.weekday) % 7,
        hour,
        minute,
      ).subtract(Duration(minutes: trafficDelayInMinutes));

      await notificationsPlugin.zonedSchedule(
        day.hashCode, // unique id
        'Time to leave for your commute',
        'Leave now to reach by $arriveByTime (Traffic adjusted)',
        tz.TZDateTime.from(adjustedDateTime, tz.local),
        const NotificationDetails(
          android: AndroidNotificationDetails(
              'commute_channel', 'Commute Notifications',
              channelDescription: 'Notifications for your commutes',
              importance: Importance.max,
              priority: Priority.high),
        ),
        // ignore: deprecated_member_use
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
      );
    }
  }

  /// Simulate traffic delay (in real usage, query a service like TomTom)
  Future<int> _simulateTrafficDelay(String start, String end) async {
    // Simulated delay of 10 minutes
    await Future.delayed(Duration(milliseconds: 500));
    return 10;
  }

  /// Helper to convert weekday string to DateTime weekday index
  int _dayToWeekdayOffset(String day) {
    switch (day.toUpperCase()) {
      case "M":
        return DateTime.monday;
      case "Tu":
        return DateTime.tuesday;
      case "W":
        return DateTime.wednesday;
      case "Th":
        return DateTime.thursday;
      case "F":
        return DateTime.friday;
      case "Sa":
        return DateTime.saturday;
      default:
        return DateTime.sunday;
    }
  }
}
