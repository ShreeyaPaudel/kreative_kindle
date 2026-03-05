import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings();
    await _plugin.initialize(
      const InitializationSettings(android: android, iOS: ios),
    );
    await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(const AndroidNotificationChannel(
          'kreative_kindle_daily',
          'Daily Reminder',
          description: 'Daily activity reminder for Kreative Kindle',
          importance: Importance.max,
        ));
  }

  static Future<void> scheduleDailyReminder() async {
    await _plugin.periodicallyShow(
      0,
      'Time to Learn! 🌟',
      "Don't forget today's activity for your little one 📚",
      RepeatInterval.daily,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'kreative_kindle_daily',
          'Daily Reminder',
          channelDescription: 'Daily activity reminder for Kreative Kindle',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.inexact,
    );
  }

  static Future<void> cancelAll() async => _plugin.cancelAll();
}
