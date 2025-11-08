import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

import 'local_push_notifications.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  try {
    // Safe to call multiple times; will no-op if already initialized.
    await Firebase.initializeApp();
  } catch (_) {
    // If options are missing, initialization will throw; ignore to avoid crashes.
  }
  await LocalPushNotifications.initialize();
  final notification = message.notification;
  final title = notification?.title ?? message.data['title'] ?? 'New message';
  final body = notification?.body ?? message.data['body'] ?? 'You have a new notification';
  await LocalPushNotifications.showNotification(title: title, body: body);
}

Future<void> initPushMessaging() async {
  // Initialize Firebase if configured; ignore if not available.
  try {
    await Firebase.initializeApp();
  } catch (e) {
    if (kDebugMode) {
      // In debug builds we can log that FCM setup is skipped (likely missing config files).
      // print('Firebase init skipped: $e');
    }
    return; // Without Firebase config, remote push won't be available.
  }

  // Background handler
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  // iOS permission prompt (Android 13 permission handled via local notifications request)
  await FirebaseMessaging.instance.requestPermission(alert: true, badge: true, sound: true);

  // Foreground message -> show local notification
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    final notification = message.notification;
    final title = notification?.title ?? message.data['title'] ?? 'New message';
    final body = notification?.body ?? message.data['body'] ?? '';
    LocalPushNotifications.showNotification(title: title, body: body);
  });
}