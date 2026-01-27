import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:juststock/services/api_locator.dart';
import 'package:juststock/services/in_app_notification_center.dart';
import 'package:juststock/services/local_push_notifications.dart';

class DailyTipNotifier extends ChangeNotifier {
  DailyTipNotifier({Duration? pollInterval})
      : _pollInterval = pollInterval ?? const Duration(minutes: 8) {
    _initialize();
  }

  final Duration _pollInterval;
  Timer? _pollTimer;
  String? _latestTipId;
  Map<String, dynamic>? _latestTip;
  bool _hasNewTip = false;

  bool get hasNewTip => _hasNewTip;
  Map<String, dynamic>? get latestTip => _latestTip;

  Future<void> refresh({bool showNotification = true}) =>
      _checkLatest(showNotification: showNotification);

  void markTipSeen() {
    if (!_hasNewTip) return;
    _hasNewTip = false;
    notifyListeners();
  }

  Future<void> _initialize() async {
    await _checkLatest(showNotification: false);
    _pollTimer = Timer.periodic(_pollInterval, (_) => _checkLatest());
  }

  Future<void> _checkLatest({bool showNotification = true}) async {
    try {
      final tip = await ApiLocator.dailyTip.latest();
      if (tip == null) return;
      final id = _extractId(tip);
      if (id == null) return;

      final firstRun = _latestTipId == null;
      final isNew = !firstRun && id != _latestTipId;
      _latestTipId = id;
      _latestTip = tip;

      if (isNew) {
        _hasNewTip = true;
        notifyListeners();
        if (showNotification) {
          unawaited(_announceTip(tip, id));
        }
      }
    } catch (e, st) {
      log('DailyTipNotifier failed to refresh tips: $e\n$st');
    }
  }

  Future<void> _announceTip(Map<String, dynamic> tip, String id) async {
    final message =
        (tip['message'] ?? tip['tip'] ?? tip['body'] ?? '').toString().trim();
    final body = message.isNotEmpty
        ? message
        : 'A new daily tip is available. Open the Daily Tip screen to read it.';
    NotificationCenter.instance?.recordRemoteNotification(
      id: 'daily-tip-$id',
      title: 'New Daily Tip',
      body: body,
      channel: NotificationChannel.information,
      tag: 'daily_tip',
    );

    await LocalPushNotifications.showNotification(
      title: 'Daily Tip arrived',
      body: body,
    );
  }

  String? _extractId(Map<String, dynamic> tip) {
    final raw = tip['id'] ?? tip['_id'];
    if (raw == null) return null;
    final parsed = raw.toString().trim();
    return parsed.isEmpty ? null : parsed;
  }

  @override
  void dispose() {
    _pollTimer?.cancel();
    super.dispose();
  }
}
