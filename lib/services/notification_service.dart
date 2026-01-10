import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  NotificationService._internal();
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;

  final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  static const AndroidNotificationChannel _channel = AndroidNotificationChannel(
    'daily_reminder_channel_id',
    'Daily Reminders',
    description: 'Reminder to complete daily habits',
    importance: Importance.max,
  );

  Future<void> init() async {
    if (_initialized) return;

    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Europe/Athens'));

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const settings = InitializationSettings(android: androidSettings);

    await _plugin.initialize(settings);
    final androidPlugin = _plugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    if (androidPlugin != null) {
      await androidPlugin.requestNotificationsPermission();
      await androidPlugin.createNotificationChannel(_channel);
    }

    _initialized = true;
  }

  Future<void> showNow({
    required String title,
    required String body,
  }) async {
    if (!_initialized) await init();

    const androidDetails = AndroidNotificationDetails(
      _channelId,
      _channelName,
      channelDescription: _channelDescription,
      importance: Importance.max,
      priority: Priority.high,
    );
    await _plugin.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      const NotificationDetails(android: androidDetails),
    );
  }

  NotificationDebugNow debugNow() {
    return NotificationDebugNow(
      now: DateTime.now(),
      tzNow: tz.TZDateTime.now(tz.local),
      tzName: tz.local.name,
    );
  }

  Future<void> scheduleDaily({
    required String id,
    required String title,
    required String body,
    required TimeOfDay time,
  }) async {
    if (!_initialized) await init();

    final debugNow = DateTime.now();
    final debugTzNow = tz.TZDateTime.now(tz.local);
    debugPrint(
      'Now: $debugNow | TZ now: $debugTzNow | TZ local: ${tz.local.name}',
    );

    final now = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );

    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }
    debugPrint(
      'Scheduling notification id=$id at $scheduled (local=${tz.local.name})',
    );

    const androidDetails = AndroidNotificationDetails(
      _channelId,
      _channelName,
      channelDescription: _channelDescription,
      importance: Importance.max,
      priority: Priority.high,
    );
    await _plugin.zonedSchedule(
      id.hashCode,
      title,
      body,
      scheduled,
      const NotificationDetails(android: androidDetails),
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle: true,
      matchDateTimeComponents: DateTimeComponents.time, // daily best-effort
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
    );
  }

  Future<void> scheduleInSeconds({
    required String id,
    required String title,
    required String body,
    required int seconds,
  }) async {
    if (!_initialized) await init();

    final now = tz.TZDateTime.now(tz.local);
    final scheduled = now.add(Duration(seconds: seconds));
    debugPrint(
      'Scheduling debug id=$id at $scheduled (local=${tz.local.name})',
    );

    const androidDetails = AndroidNotificationDetails(
      _channelId,
      _channelName,
      channelDescription: _channelDescription,
      importance: Importance.max,
      priority: Priority.high,
    );
    await _plugin.zonedSchedule(
      id.hashCode,
      title,
      body,
      scheduled,
      const NotificationDetails(android: androidDetails),
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle: true,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
    );
  }

  Future<void> cancelDaily({required String id}) async {
    if (!_initialized) await init();
    await _plugin.cancel(id.hashCode);
  }
}

const String _channelId = 'daily_reminder_channel_id';
const String _channelName = 'Daily Reminders';
const String _channelDescription = 'Reminder to complete daily habits';

class NotificationDebugNow {
  final DateTime now;
  final DateTime tzNow;
  final String tzName;

  NotificationDebugNow({
    required this.now,
    required this.tzNow,
    required this.tzName,
  });
}



