import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotificationService {
  static final _plugin = FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    tz.initializeTimeZones();

    // ✅ Set India timezone directly (no extra package needed)
    tz.setLocalLocation(tz.getLocation('Asia/Kolkata'));
    await Permission.notification.request();

    const android = AndroidInitializationSettings('@mipmap/ic_launcher');

    await _plugin.initialize(
      const InitializationSettings(android: android),
    );
  }
  // static Future<void> scheduleDailyReminder() async {
  //   await _plugin.zonedSchedule(
  //     0,
  //     '💰 Daily Reminder',
  //     'Don’t forget to track your expenses today!',
  //     _nextInstanceOfTime(20, 0),
  //
  //
  //     const NotificationDetails(
  //       android: AndroidNotificationDetails(
  //         'daily_channel',
  //         'Daily Reminder',
  //         importance: Importance.high,
  //         priority: Priority.high,
  //       ),
  //     ),
  //     androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
  //     matchDateTimeComponents: DateTimeComponents.time,
  //     uiLocalNotificationDateInterpretation:
  //     UILocalNotificationDateInterpretation.absoluteTime,
  //   );
  // }
  static Future<void> testNotification() async {
    final now = tz.TZDateTime.now(tz.local);

    await _plugin.zonedSchedule(
      99,
      '🧪 Test Notification',
      'This should appear in 1 minute',
      now.add(const Duration(minutes: 1)),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'test_channel',
          'Test',
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  static Future<void> cancelReminder() async {
    await _plugin.cancel(0);
  }

  static tz.TZDateTime _nextInstanceOfTime(int hour, int minute) {
    final now = tz.TZDateTime.now(tz.local);


    var scheduledDate =
    tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    // return scheduledDate;
    return now.add(const Duration(minutes: 1));
  }
}