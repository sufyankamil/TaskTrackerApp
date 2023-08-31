import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:management/common/models/task_model.dart';
import 'package:rxdart/subjects.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

import '../../features/todo/pages/view_notif.dart';

class NotificationsHelper {
  final WidgetRef ref;

  NotificationsHelper({required this.ref});

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  String? selectedNotificationPayload;

  final BehaviorSubject<String?> selectNotificationSubject =
      BehaviorSubject<String?>();

  Future<void> initNotifications() async {
    _configureSelectNotificationSubject();
    await _configureLocalTimeZone();

    DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: false,
      requestSoundPermission: false,
      defaultPresentAlert: true,
      defaultPresentBadge: true,
      defaultPresentSound: true,
      onDidReceiveLocalNotification: onDidReceiveLocalNotification,
    );

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_notif');

    InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: (data) async {
      debugPrint('onDidReceiveNotificationResponse: $data');

      selectNotificationSubject.add(data.payload);
    });
  }

  void requestIOSPermissions() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  Future<void> _configureLocalTimeZone() async {
    tz.initializeTimeZones();
    const String timeZoneName = 'Asia/Kolkata';
    tz.setLocalLocation(tz.getLocation(timeZoneName));
  }

  Future onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) async {
    showDialog(
      context: ref.context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text(title ?? ''),
        content: Text(body ?? ''),
        actions: [
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NotificationPage(payload: payload),
                ),
              );
            },
            child: const Text('View'),
          )
        ],
      ),
    );
    selectNotificationSubject.add(payload);
  }

  scheduleNotification(
      int days, int hours, int minutes, int seconds, Task task) async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
      task.id ?? 0,
      task.title,
      task.description,
      tz.TZDateTime.now(tz.local).add(
        Duration(
          days: days,
          hours: hours,
          minutes: minutes,
          seconds: seconds,
        ),
      ),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'your channel id',
          'your channel name',
          importance: Importance.max,
          priority: Priority.high,
          showWhen: false,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
      payload:
          '${task.title}|${task.description}|${task.startTime}|${task.endTime}',
    );
  }

  void _configureSelectNotificationSubject() {
    selectNotificationSubject.stream.listen((String? payload) async {
      debugPrint('selectNotificationSubject: $payload');

      var title = payload != null ? payload.split('|')[0] : '';
      var body = payload != null ? payload.split('|')[1] : '';
      showDialog(
        context: ref.context,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: Text(title),
          content: Text(body, textAlign: TextAlign.justify, maxLines: 4),
          actions: [
            CupertinoDialogAction(
              isDestructiveAction: true,
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            CupertinoDialogAction(
              isDefaultAction: true,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NotificationPage(
                      payload: payload,
                    ),
                  ),
                );
              },
              child: const Text('View'),
            )
          ],
        ),
      );
    });
  }
}
