import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

final FlutterLocalNotificationsPlugin local = FlutterLocalNotificationsPlugin();

void initialization() async {
  AndroidInitializationSettings android =
      const AndroidInitializationSettings("@mipmap/ic_launcher");
  DarwinInitializationSettings ios = const DarwinInitializationSettings(
    requestSoundPermission: false,
    requestBadgePermission: false,
    requestAlertPermission: false,
  );
  InitializationSettings settings =
      InitializationSettings(android: android, iOS: ios);
  await local.initialize(settings);
  tz.initializeTimeZones();
  tz.setLocalLocation(tz.getLocation('Asia/Seoul'));
}

Future<void> scheduleRoutineNotification(
  int id,
  String title,
  String body,
  int startTime,
  int notificationTime,
) async {
  NotificationDetails details = NotificationDetails(
    iOS: const DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    ),
    android: AndroidNotificationDetails(
      id.toString(),
      title,
      importance: Importance.max,
      priority: Priority.high,
    ),
  );

  final now = DateTime.now();
  DateTime scheduledTime = DateTime(now.year, now.month, now.day).add(
    Duration(seconds: startTime - notificationTime),
  );

  if (scheduledTime.isAfter(now)) {
    final tz.TZDateTime tzScheduledTime =
        tz.TZDateTime.from(scheduledTime, tz.local);

    await local.zonedSchedule(
      id,
      title,
      body,
      tzScheduledTime,
      details,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: null,
    );
  }
}
