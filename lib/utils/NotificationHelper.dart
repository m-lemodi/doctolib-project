import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:uuid/uuid.dart';

class NotificationHelper {
  static final _notifications = FlutterLocalNotificationsPlugin();
  static const uuid = Uuid();
  static final onNotifications = BehaviorSubject<String?>();
  static const channel = AndroidNotificationChannel(
      'Umbrella channel id',
      'Umbrella channel name',
      description: "This channel is used for Umbrella's notifications",
      groupId: 'Umbrella');

  static NotificationDetails _notificationDetails() {
    return NotificationDetails(
        android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            channelDescription: channel.description,
            importance: Importance.high,
            priority: Priority.max,
            groupKey: channel.groupId
        ),
        iOS: DarwinNotificationDetails(threadIdentifier: channel.groupId)
    );
  }

  static Future init({bool initScheduled = true}) async {
    const android = AndroidInitializationSettings("@mipmap/ic_launcher");
    const iOS = DarwinInitializationSettings();
    const settings = InitializationSettings(android: android, iOS: iOS);

    await _notifications.initialize(
        settings,
        onDidReceiveNotificationResponse: (notificationResponse) async {
          onNotifications.add(notificationResponse.payload);
        }
    );
    if (initScheduled) {
      tz.initializeTimeZones();
      final locationName = await FlutterNativeTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(locationName));
    }
  }

  static void cancelNotification(int id) {
    _notifications.cancel(id);
  }

  static Future showScheduledNotification({
    required String? title,
    required String? body,
    String? payload,
    required int uuid,
    required tz.TZDateTime scheduledDate
  }) async {
    await _notifications.zonedSchedule(
        uuid,
        title,
        body,
        scheduledDate,
        _notificationDetails(),
        payload: payload,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime
    );
  }
}
