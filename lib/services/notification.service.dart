import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// ignore_for_file: depend_on_referenced_packages
import 'package:timezone/timezone.dart' as tz;
import 'package:welldone/main.dart';

class NotificationShow {
  Future showNotification(int id, String title, String body, DateTime? date) async {
    AndroidNotificationDetails androidNotificationDetails =
        const AndroidNotificationDetails(
      'Well.Done',
      'Tasks',
      priority: Priority.max,
      importance: Importance.max,
    );
    NotificationDetails notificationDetails = NotificationDetails(android: androidNotificationDetails);
    var scheduledTime = tz.TZDateTime.from(date!, tz.local);
    flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      scheduledTime,
      notificationDetails,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle: true,
      payload: 'notlification-payload',
    );
  }
}
