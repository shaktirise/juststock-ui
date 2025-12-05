import 'dart:developer';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalPushNotifications {
  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static const AndroidNotificationChannel _channel = AndroidNotificationChannel(
    'juststock_alerts',
    'JustStock Alerts',
    description: 'Trade calls and admin messages',
    importance: Importance.max,
    playSound: true,
  );

  static bool _initialized = false;

  static Future<void> initialize() async {
    if (_initialized) return;

    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosInit = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    const initSettings =
        InitializationSettings(android: androidInit, iOS: iosInit);

    await _plugin.initialize(initSettings);

    // Android: create channel and request POST_NOTIFICATIONS runtime permission (API 33+)
    final androidImpl = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    if (androidImpl != null) {
      await androidImpl.createNotificationChannel(_channel);
      // On Android 13+, explicit runtime permission is required.
      try {
        await androidImpl.requestNotificationsPermission();
      } catch (_) {}
    }

    _initialized = true;
  }

  static Future<void> showNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    if (!_initialized) {
      await initialize();
    }

    final androidDetails = AndroidNotificationDetails(
      _channel.id,
      _channel.name,
      channelDescription: _channel.description,
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
      ticker: 'alert',
      icon: null, // use default app icon
      styleInformation: const BigTextStyleInformation(''),
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      interruptionLevel: InterruptionLevel.timeSensitive,
    );

    final details =
        NotificationDetails(android: androidDetails, iOS: iosDetails);

    // Use a unique id based on timestamp
    final id = DateTime.now().millisecondsSinceEpoch.remainder(0x7FFFFFFF);

    log('📢 Showing notification: ID=$id, Title=$title, Payload=$payload');
    await _plugin.show(id, title, body, details, payload: payload);
  }
}
