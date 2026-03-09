import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static final _androidPlugin = _plugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();

  static const _details = NotificationDetails(
    android: AndroidNotificationDetails(
      'kreative_kindle_daily',
      'Daily Reminder',
      channelDescription: 'Daily activity reminder for Kreative Kindle',
      importance: Importance.max,
      priority: Priority.high,
    ),
  );

  static Future<void> init() async {
    tz.initializeTimeZones();
    final tzInfo = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(tzInfo.identifier));

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

  static Future<bool> requestPermission() async {
    final granted = await _androidPlugin?.requestNotificationsPermission();
    return granted ?? true;
  }

  static Future<void> scheduleDailyReminder({
    int hour = 9,
    int minute = 0,
  }) async {
    final h = hour.toString().padLeft(2, '0');
    final m = minute.toString().padLeft(2, '0');

    await _plugin.show(
      1,
      'Reminder set! 🔔',
      "You'll get a daily reminder at $h:$m every day 📚",
      _details,
    );

    await _plugin.cancel(0);
    await _plugin.zonedSchedule(
      0,
      'Time to Learn! 🌟',
      "Don't forget today's activity for your little one 📚",
      _nextInstanceOfTime(hour, minute),
      _details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  static tz.TZDateTime _nextInstanceOfTime(int hour, int minute) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduled =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }
    return scheduled;
  }

  static Future<void> cancelAll() async => _plugin.cancelAll();
}
