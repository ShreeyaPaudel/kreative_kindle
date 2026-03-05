import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static final _androidPlugin = _plugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();

  static Future<void> init() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings();
    await _plugin.initialize(
      const InitializationSettings(android: android, iOS: ios),
    );
    await _androidPlugin?.createNotificationChannel(
      const AndroidNotificationChannel(
        'kreative_kindle_daily',
        'Daily Reminder',
        description: 'Daily activity reminder for Kreative Kindle',
        importance: Importance.max,
      ),
    );
  }

  /// Request POST_NOTIFICATIONS permission (Android 13+ / API 33+).
  /// Returns true if granted.
  static Future<bool> requestPermission() async {
    final granted = await _androidPlugin?.requestNotificationsPermission();
    return granted ?? true; // iOS/older Android assumed granted
  }

  /// Shows an immediate confirmation notification + schedules daily repeat.
  static Future<void> scheduleDailyReminder() async {
    const details = NotificationDetails(
      android: AndroidNotificationDetails(
        'kreative_kindle_daily',
        'Daily Reminder',
        channelDescription: 'Daily activity reminder for Kreative Kindle',
        importance: Importance.max,
        priority: Priority.high,
      ),
    );

    // Fire immediately so the user sees it straight away
    await _plugin.show(
      1,
      'Reminder set! 🔔',
      "You'll get a daily nudge to keep learning going 📚",
      details,
    );

    // Cancel any existing periodic notification then re-schedule
    await _plugin.cancel(0);
    await _plugin.periodicallyShow(
      0,
      'Time to Learn! 🌟',
      "Don't forget today's activity for your little one 📚",
      RepeatInterval.daily,
      details,
      androidScheduleMode: AndroidScheduleMode.inexact,
    );
  }

  static Future<void> cancelAll() async => _plugin.cancelAll();
}
