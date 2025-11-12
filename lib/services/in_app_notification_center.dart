import 'dart:async';
import 'dart:collection';

import 'package:crowwn/api/advice_api.dart';
import 'package:crowwn/services/advice_seen_store.dart';
import 'package:flutter/material.dart';
import 'package:crowwn/services/local_push_notifications.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

enum NotificationChannel { advisory, information }

class InAppNotification {
  InAppNotification({
    required this.id,
    required this.channel,
    required this.title,
    required this.body,
    required this.createdAt,
    this.createdAtLocalText,
    this.category,
    this.tag,
    this.amount,
    this.currency,
    bool isRead = false,
  }) : _isRead = isRead;

  final String id;
  final NotificationChannel channel;
  final String title;
  final String body;
  final DateTime createdAt;
  // If server provided a preformatted IST time string, prefer using this for exact display.
  final String? createdAtLocalText;
  final String? category;
  final String? tag;
  final double? amount;
  final String? currency;

  bool _isRead;

  bool get isRead => _isRead;

  void markRead() => _isRead = true;

  void markUnread() => _isRead = false;
}

class NotificationCenter extends ChangeNotifier {
  NotificationCenter(this.navigatorKey) {
    NotificationCenter.instance = this;
    _seedInformationDefaults();
    _startAdvisoryPolling();
  }

  static NotificationCenter? instance;

  final GlobalKey<NavigatorState> navigatorKey;

  final List<InAppNotification> _advisory = [];
  final List<InAppNotification> _information = [];
  final Set<String> _advisoryAlerted = <String>{};
  final List<String> _advisoryCategories = const ['stocks', 'options', 'future', 'commodity'];
  final NumberFormat _currencyFormat = NumberFormat.currency(locale: 'en_IN', symbol: '₹');

  Timer? _pollTimer;
  bool _pollInFlight = false;
  bool _popupVisible = false;
  int _infoCounter = 0;

  UnmodifiableListView<InAppNotification> get advisoryNotifications => UnmodifiableListView(_advisory);
  UnmodifiableListView<InAppNotification> get informationNotifications => UnmodifiableListView(_information);

  @override
  void dispose() {
    _pollTimer?.cancel();
    super.dispose();
  }

  Future<void> refreshAdvisories({bool silent = true}) => _pollAdvisories(showPopup: !silent);

  void markAsRead(String id) {
    final all = [..._advisory, ..._information];
    for (final item in all) {
      if (item.id == id) {
        if (!item.isRead) {
          item.markRead();
          notifyListeners();
        }
        return;
      }
    }
  }

  void markAsUnread(String id) {
    final all = [..._advisory, ..._information];
    for (final item in all) {
      if (item.id == id) {
        if (item.isRead) {
          item.markUnread();
          notifyListeners();
        }
        return;
      }
    }
  }

  void logDeposit({double? amount, String currency = 'USD'}) {
    _recordInformation(
      title: 'Deposit completed',
      body: amount == null ? 'Your deposit request has been processed.' : 'You deposited ${_formatAmount(amount, currency)}.',
      tag: 'deposit',
      amount: amount,
      currency: currency,
    );
  }

  void logWithdraw({double? amount, String currency = 'USD'}) {
    _recordInformation(
      title: 'Withdrawal submitted',
      body: amount == null ? 'Your withdrawal request is on the way.' : 'You withdrew ${_formatAmount(amount, currency)}.',
      tag: 'withdraw',
      amount: amount,
      currency: currency,
    );
  }

  void _recordInformation({
    required String title,
    required String body,
    required String tag,
    double? amount,
    String? currency,
  }) {
    final item = InAppNotification(
      id: 'info-${DateTime.now().microsecondsSinceEpoch}-${_infoCounter++}',
      channel: NotificationChannel.information,
      title: title,
      body: body,
      createdAt: DateTime.now(),
      tag: tag,
      amount: amount,
      currency: currency,
    );
    _information.insert(0, item);
    notifyListeners();
  }

  void _seedInformationDefaults() {
    if (_information.isNotEmpty) return;
    logDeposit(amount: 150.00, currency: 'USD');
    logWithdraw(amount: 80.00, currency: 'USD');
  }

  void _startAdvisoryPolling() {
    _pollTimer?.cancel();
    _pollTimer = Timer.periodic(const Duration(seconds: 45), (_) => _pollAdvisories());
    // Kick off immediately.
    unawaited(_pollAdvisories());
  }

  Future<void> _pollAdvisories({bool showPopup = true}) async {
    if (_pollInFlight) return;
    _pollInFlight = true;
    try {
      for (final cat in _advisoryCategories) {
        await _checkLatestForCategory(cat, showPopup: showPopup);
      }
    } finally {
      _pollInFlight = false;
    }
  }

  Future<void> _checkLatestForCategory(String category, {required bool showPopup}) async {
    try {
      final latest = await AdviceApi.latest(category: category);
      if (latest == null) return;
      final id = latest.id;
      if (id.isEmpty) return;
      if (_advisoryAlerted.contains(id)) return;
      final seenId = await AdviceSeenStore.getSeenId(category);
      if (seenId == id) {
        // User already opened this call; do not alert.
        return;
      }
      _advisoryAlerted.add(id);
      final created = latest.createdAt;
      final item = InAppNotification(
        id: id,
        channel: NotificationChannel.advisory,
        title: 'New ${category.toUpperCase()} call',
        body: latest.price == null ? 'A fresh advisory is available.' : 'Entry at ${_formatAmount(latest.price!.toDouble(), 'INR')}',
        createdAt: created,
        createdAtLocalText: latest.createdAtLocal,
        category: category.toUpperCase(),
      );
      _advisory.insert(0, item);
      notifyListeners();
      // Also surface a system notification with sound (status bar)
      unawaited(LocalPushNotifications.showNotification(
        title: 'Admin sent message in ${category.toUpperCase()}',
        body: item.body,
      ));
      if (showPopup) {
        unawaited(_presentPopup(item));
      }
    } catch (e) {
      debugPrint('Advisory polling failed for $category => $e');
    }
  }

  Future<void> _presentPopup(InAppNotification item) async {
    if (_popupVisible) return;
    final context = navigatorKey.currentState?.overlay?.context ?? navigatorKey.currentContext;
    if (context == null) return;
    _popupVisible = true;
    try {
      await SystemSound.play(SystemSoundType.alert);
      await showDialog<void>(
        context: context,
        builder: (ctx) {
          final theme = Theme.of(ctx);
          return AlertDialog(
            title: Text(item.title),
            content: Text(item.body),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
                child: const Text('Dismiss'),
              ),
              FilledButton(
                onPressed: () {
                  markAsRead(item.id);
                  Navigator.of(ctx).pop();
                },
                style: FilledButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                ),
                child: const Text('View later'),
              ),
            ],
          );
        },
      );
    } finally {
      _popupVisible = false;
    }
  }

  String _formatAmount(double value, String? currency) {
    if (currency == null || currency.toUpperCase() == 'INR') {
      return _currencyFormat.format(value);
    }
    return '${value.toStringAsFixed(2)} $currency';
  }
}
