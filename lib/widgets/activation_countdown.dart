import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Dark mode.dart';
import '../services/api_locator.dart';
import '../api/profile_api.dart';

class ActivationCountdownCard extends StatefulWidget {
  const ActivationCountdownCard({super.key});

  @override
  State<ActivationCountdownCard> createState() => _ActivationCountdownCardState();
}

class _ActivationCountdownCardState extends State<ActivationCountdownCard> {
  Timer? _ticker;
  Timer? _refetchTimer;
  DateTime? _target;
  Duration _remaining = Duration.zero;
  bool _loading = true;
  bool _active = false;
  String _cycle = 'none';
  int _cycleDays = 0;
  int _nextRequiredTopupRupees = 2100;
  bool _backfillAttempted = false;

  @override
  void initState() {
    super.initState();
    _loadActivation();
  }

  @override
  void dispose() {
    _ticker?.cancel();
    _refetchTimer?.cancel();
    super.dispose();
  }

  Future<void> _loadActivation() async {
    setState(() => _loading = true);
    try {
      Map<String, dynamic>? data = await ProfileApi.membershipSnapshot();
      // Fallback to dio and legacy endpoint if needed
      data ??= await ApiLocator.user.membershipSnapshot().catchError((_) => null);
      data ??= await ApiLocator.walletActivation.countdown().catchError((_) => null);
      if (data == null) throw Exception('No membership data');
      if (!mounted) return;

      final status = (data['status']?.toString().toUpperCase());
      bool active = false;
      if (data['isActive'] is bool) {
        active = data['isActive'] as bool;
      } else if (status == 'ACTIVE') {
        active = true;
      } else if (data['active'] is bool) {
        active = data['active'] as bool; // legacy field
      }
      _active = active;

      // Compute cycle details
      final activatedMs = (data['activatedAtMs'] as num?)?.toInt();
      final activeUntilMs = (data['activeUntilMs'] as num?)?.toInt();
      if (activatedMs != null && activeUntilMs != null) {
        final start = DateTime.fromMillisecondsSinceEpoch(activatedMs).toLocal();
        final end = DateTime.fromMillisecondsSinceEpoch(activeUntilMs).toLocal();
        _cycleDays = end.difference(start).inDays.abs();
        _cycle = _cycleDays >= 45 ? 'registration' : 'renewal';
      } else {
        _cycleDays = (data['remainingDays'] as num?)?.toInt() ?? (data['currentCycleDays'] as num?)?.toInt() ?? 0;
        final legacyCycle = (data['currentCycle']?.toString());
        _cycle = legacyCycle ?? ((_cycleDays >= 45) ? 'registration' : 'renewal');
      }
      _nextRequiredTopupRupees = 2100;

      DateTime? activeUntil;
      final msRaw = (data['activeUntilMs'] as num?)?.toInt();
      if (msRaw != null && msRaw > 0) {
        final ms = msRaw < 100000000000 ? (msRaw * 1000) : msRaw;
        activeUntil = DateTime.fromMillisecondsSinceEpoch(ms).toLocal();
      } else {
        final s = data['activeUntil']?.toString();
        if (s != null && s.isNotEmpty) {
          activeUntil = DateTime.tryParse(s)?.toLocal();
        }
      }

      final sr = (data['remainingSeconds'] as num?)?.toInt() ?? (data['secondsRemaining'] as num?)?.toInt();
      final rm = (data['remainingMs'] as num?)?.toInt();
      if (activeUntil == null && sr != null && sr > 0) {
        activeUntil = DateTime.now().add(Duration(seconds: sr));
      } else if (activeUntil == null && rm != null && rm > 0) {
        activeUntil = DateTime.now().add(Duration(milliseconds: rm));
      }

      if ((active || (sr != null && sr > 0)) && activeUntil != null) {
        setState(() {
          _target = activeUntil;
          _remaining = activeUntil!.difference(DateTime.now());
          _loading = false;
          _active = true;
        });
        _startTicker();
        _refetchTimer?.cancel();
      } else {
        // One-time backfill for older active users
        if (!_backfillAttempted) {
          _backfillAttempted = true;
          try {
            await ProfileApi.backfillMembership();
            await _loadActivation();
            return;
          } catch (_) {}
        }
        setState(() {
          _target = null;
          _remaining = Duration.zero;
          _loading = false;
        });
        _startRefetch();
      }
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _target = null;
        _remaining = Duration.zero;
        _loading = false;
      });
      _startRefetch();
    }
  }

  void _startTicker() {
    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted || _target == null) return;
      final diff = _target!.difference(DateTime.now());
      if (diff.isNegative || diff.inSeconds <= 0) {
        setState(() => _remaining = Duration.zero);
        // when expired, try to refresh the window status
        _loadActivation();
      } else {
        setState(() => _remaining = diff);
      }
    });
  }

  void _startRefetch() {
    _refetchTimer?.cancel();
    // Poll the countdown endpoint periodically when inactive
    _refetchTimer = Timer.periodic(const Duration(seconds: 20), (_) async {
      await _loadActivation();
    });
  }

  String _two(int n) => n.toString().padLeft(2, '0');

  @override
  Widget build(BuildContext context) {
    final notifier = Provider.of<ColorNotifire>(context, listen: true);
    final cardColor = notifier.onboardBackgroundColor;
    final boxColor = notifier.background;

    final days = _two(_remaining.inDays);
    final hours = _two(_remaining.inHours % 24);
    final minutes = _two(_remaining.inMinutes % 60);
    final seconds = _two(_remaining.inSeconds % 60);

    Widget numberBox(String n, String label) {
      return Expanded(
        child: Container(
          height: 90,
          margin: const EdgeInsets.symmetric(horizontal: 6),
          decoration: BoxDecoration(
            color: boxColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: notifier.getContainerBorder),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 8,
                offset: const Offset(0, 4),
              )
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                n,
                style: TextStyle(
                  fontSize: 32,
                  fontFamily: 'Manrope-Bold',
                  color: notifier.textColor,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 11,
                  letterSpacing: .6,
                  color: Color(0xff64748B),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: notifier.getContainerBorder, width: 1),
      ),
      child: _loading
          ? const Center(
              child: SizedBox(
                height: 32,
                width: 32,
                child: CircularProgressIndicator(
                  color: Color(0xFFD32F2F),
                  strokeWidth: 2.5,
                ),
              ),
            )
          : (!_active
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Activation Countdown',
                      style: TextStyle(fontSize: 17, fontFamily: 'Manrope-Bold'),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Activate your account with ₹2100 to start your 60‑day access.',
                      style: TextStyle(fontSize: 13, color: Color(0xff64748B)),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        numberBox('--', 'DAYS'),
                        numberBox('--', 'HOURS'),
                        numberBox('--', 'MINUTES'),
                        numberBox('--', 'SECONDS'),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Row(
                      children: [
                        Icon(Icons.lock_outline, size: 16, color: Color(0xff94A3B8)),
                        SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            'Countdown starts after successful ₹2100 activation top‑up.',
                            style: TextStyle(fontSize: 12, color: Color(0xff64748B)),
                          ),
                        )
                      ],
                    )
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      _cycle == 'registration' ? 'Registration window (' + _cycleDays.toString() + ' days)' : 'Renewal window (' + _cycleDays.toString() + ' days)',
                      style: const TextStyle(fontSize: 14, color: Color(0xff64748B)),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        numberBox(days, 'DAYS'),
                        numberBox(hours, 'HOURS'),
                        numberBox(minutes, 'MINUTES'),
                        numberBox(seconds, 'SECONDS'),
                      ],
                    ),
                    const SizedBox(height: 8),
                    if (_target != null)
                      Text(
                        'Expires on ${_formatDate(_target!)}',
                        style: const TextStyle(fontSize: 12, color: Color(0xff64748B)),
                      ),
                    const SizedBox(height: 6),
                    const Text(
                      'First cycle is 60 days after ₹2100. Renewals are 30 days per ₹1000.',
                      style: TextStyle(fontSize: 12, color: Color(0xff64748B)),
                      textAlign: TextAlign.center,
                    ),
                  ],
                )),
    );
  }

  String _formatDate(DateTime dt) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    final d = dt.day.toString().padLeft(2, '0');
    final m = months[dt.month - 1];
    final y = dt.year.toString();
    return '$d $m $y';
  }
}
