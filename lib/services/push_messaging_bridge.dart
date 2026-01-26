import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../api/token_storage.dart' as legacy;
import '../main.dart' show rootNavigatorKey;
import 'api_locator.dart';
import 'in_app_notification_center.dart';
import 'local_push_notifications.dart';

const List<String> _defaultSegments = [
  'stocks',
  'future',
  'options',
  'commodity',
];
const String _defaultPlatform = 'android';

bool _isAdvisorySegment(String? value) {
  final segment = value?.toLowerCase();
  if (segment == null || segment.isEmpty) return false;
  return segment == 'stocks' ||
      segment == 'stock' ||
      segment == 'future' ||
      segment == 'futures' ||
      segment == 'options' ||
      segment == 'option' ||
      segment == 'commodity' ||
      segment == 'commodities';
}

String? _normalizeAdvisoryCategory(String? value) {
  final segment = value?.toLowerCase();
  if (segment == null || segment.isEmpty) return null;
  if (segment == 'stock' || segment == 'stocks') return 'STOCKS';
  if (segment == 'option' || segment == 'options') return 'OPTIONS';
  if (segment == 'future' || segment == 'futures') return 'FUTURE';
  if (segment == 'commodity' || segment == 'commodities') return 'COMMODITY';
  return value?.toUpperCase();
}

void _recordInAppNotification(RemoteMessage message) {
  final center = NotificationCenter.instance;
  if (center == null) return;

  final notification = message.notification;
  final title = notification?.title ?? message.data['title'] ?? 'New message';
  final body = notification?.body ?? message.data['body'] ?? '';
  if (title.trim().isEmpty && body.trim().isEmpty) return;

  final data = message.data;
  final segment = data['segment']?.toString();
  final type = data['type']?.toString();
  final category = data['category']?.toString();
  final isAdvisory = _isAdvisorySegment(segment) ||
      _isAdvisorySegment(category) ||
      (type != null &&
          (type.toLowerCase() == 'advice' ||
              type.toLowerCase() == 'advisory'));
  final normalizedCategory = _normalizeAdvisoryCategory(segment) ??
      _normalizeAdvisoryCategory(category);
  final id = message.messageId ??
      data['id']?.toString() ??
      data['adviceId']?.toString() ??
      data['notificationId']?.toString();

  center.recordRemoteNotification(
    id: id,
    title: title,
    body: body,
    channel: isAdvisory ? NotificationChannel.advisory : NotificationChannel.information,
    category: isAdvisory ? normalizedCategory : null,
    tag: type?.toLowerCase(),
  );
}

Future<void> registerFcmTokenOnLaunch() async {
  try {
    final token = await FirebaseMessaging.instance.getToken();
    if (token == null || token.isEmpty) {
      log('FCM token missing; skipping registration.');
      return;
    }
    log('FCM token: $token');
    await _registerTokenWithBackend(token);
  } catch (e) {
    log('Failed to get FCM token: $e');
  }
}

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  try {
    await Firebase.initializeApp();
  } catch (_) {
    // Ignore Firebase init errors (config might be missing in test builds)
  }

  await LocalPushNotifications.initialize();

  final notification = message.notification;
  final title = notification?.title ?? message.data['title'] ?? 'New message';
  final body = notification?.body ??
      message.data['body'] ??
      'You have a new notification';
  final payload = message.data.isEmpty
      ? null
      : Uri(queryParameters: message.data).toString();

  log('🔔 [Background] Showing notification: $title - $body');
  await LocalPushNotifications.showNotification(
      title: title, body: body, payload: payload);
}

Future<void> initPushMessaging() async {
  // Initialize Firebase
  try {
    await Firebase.initializeApp();
    log('✅ Firebase initialized');
  } catch (e) {
    log('❌ Firebase init failed: $e');
    return;
  }

  // Register background handler BEFORE any other FCM setup
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  log('✅ Background handler registered');

  // Request permissions (iOS + Android 13+)
  final settings = await FirebaseMessaging.instance.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );
  log('🔔 Permission status: ${settings.authorizationStatus}');

  // Always register token on every app launch.
  await registerFcmTokenOnLaunch();

  // Handle token refresh - register new token with backend
  FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
    log('FCM token refreshed: $newToken');
    _registerTokenWithBackend(newToken);
  });

  // Handle foreground messages
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    final notification = message.notification;
    final title = notification?.title ?? message.data['title'] ?? 'New message';
    final body = notification?.body ?? message.data['body'] ?? '';
    final payload = message.data.isEmpty
        ? null
        : Uri(queryParameters: message.data).toString();

    log('📬 [Foreground] Showing notification: $title - $body');
    LocalPushNotifications.showNotification(
        title: title, body: body, payload: payload);
    _recordInAppNotification(message);
  });

  // Handle notification tap (when user taps the notification)
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    log('📖 [Tap] Notification tapped: ${message.messageId}');
    final data = message.data;
    _recordInAppNotification(message);
    if (data.isNotEmpty) {
      log('📖 Payload: $data');
      _handleNotificationTap(data);
    }
  });

  // Handle initial message (app opened from notification when killed)
  final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
  if (initialMessage != null) {
    log('📖 [Killed] App opened from notification: ${initialMessage.messageId}');
    final data = initialMessage.data;
    _recordInAppNotification(initialMessage);
    if (data.isNotEmpty) {
      log('📖 Payload: $data');
      _handleNotificationTap(data);
    }
  }

  log('✅ All FCM handlers registered successfully');
}

/// Register FCM token with backend API
Future<void> _registerTokenWithBackend(String token) async {
  if (!await _hasAuthToken()) {
    log('Skipping FCM registration: no user auth token.');
    return;
  }
  try {
    await ApiLocator.dio.post(
      '/api/notifications/register',
      data: {
        'token': token,
        'platform': _defaultPlatform,
        'segments': _defaultSegments,
      },
    );
    log('FCM token registered with backend');
  } catch (e) {
    log('Failed to register FCM token with backend: $e');
    // Don't fail - token is still valid, just not registered yet
  }
}

Future<void> registerFcmTokenAfterLogin() async {
  try {
    await Firebase.initializeApp();
  } catch (e) {
    log('Firebase init failed for FCM registration: $e');
    return;
  }

  try {
    await registerFcmTokenOnLaunch();
  } catch (e) {
    log('Failed to register FCM token after login: $e');
  }
}

Future<bool> _hasAuthToken() async {
  final secureToken = await ApiLocator.tokenStore.access;
  if (secureToken != null && secureToken.isNotEmpty) return true;
  final legacyToken = await legacy.TokenStorage.getToken();
  return legacyToken != null && legacyToken.isNotEmpty;
}

/// Handle notification tap - navigate to relevant screen based on notification type
void _handleNotificationTap(Map<String, dynamic> data) {
  try {
    final segment = data['segment']?.toString().toLowerCase();
    final type = data['type']?.toString().toLowerCase();

    log('🎯 Handling notification tap - segment: $segment, type: $type');

    // Navigate based on notification type/segment
    // These routes should match your app's navigation
    if (segment != null) {
      switch (segment) {
        case 'stocks':
          log('📊 Navigating to Stocks');
          rootNavigatorKey.currentState?.pushNamedAndRemoveUntil(
            '/stocks',
            (route) => route.isFirst,
          );
          break;
        case 'futures':
          log('📈 Navigating to Futures');
          rootNavigatorKey.currentState?.pushNamedAndRemoveUntil(
            '/futures',
            (route) => route.isFirst,
          );
          break;
        case 'options':
          log('📉 Navigating to Options');
          rootNavigatorKey.currentState?.pushNamedAndRemoveUntil(
            '/options',
            (route) => route.isFirst,
          );
          break;
        case 'commodity':
        case 'commodities':
          log('🌾 Navigating to Commodities');
          rootNavigatorKey.currentState?.pushNamedAndRemoveUntil(
            '/commodities',
            (route) => route.isFirst,
          );
          break;
        case 'nft':
          log('🎨 Navigating to NFT');
          rootNavigatorKey.currentState?.pushNamedAndRemoveUntil(
            '/nft',
            (route) => route.isFirst,
          );
          break;
        case 'crypto':
          log('₿ Navigating to Crypto');
          rootNavigatorKey.currentState?.pushNamedAndRemoveUntil(
            '/crypto',
            (route) => route.isFirst,
          );
          break;
        case 'gold':
          log('🏆 Navigating to Gold');
          rootNavigatorKey.currentState?.pushNamedAndRemoveUntil(
            '/gold',
            (route) => route.isFirst,
          );
          break;
        case 'advice':
          log('💡 Navigating to Advice');
          rootNavigatorKey.currentState?.pushNamedAndRemoveUntil(
            '/advice',
            (route) => route.isFirst,
          );
          break;
        default:
          log('❓ Unknown segment: $segment');
      }
    }

    // Log extra info for debugging
    if (type == 'advice') {
      log('💡 Advice notification - segment: $segment, details: ${data['body']}');
    }
  } catch (e) {
    log('❌ Error handling notification tap: $e');
  }
}
