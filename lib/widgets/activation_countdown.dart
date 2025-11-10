import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Dark mode.dart';
import '../api/profile_api.dart';

class ActivationCountdownCard extends StatefulWidget {
  const ActivationCountdownCard({super.key});

  @override
  State<ActivationCountdownCard> createState() => _ActivationCountdownCardState();
}

class _ActivationCountdownCardState extends State<ActivationCountdownCard> {
  Timer? _ticker;
  Timer? _refetchTimer;
  DateTime? _activationAt;
  DateTime? _target;
  Duration _remaining = Duration.zero;
  bool _loading = true;

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
    final at = await ProfileApi.activationAt();
    if (!mounted) return;
    if (at != null) {
      final t = at.add(const Duration(days: 60));
      setState(() {
        _activationAt = at;
        _target = t;
        _remaining = t.difference(DateTime.now());
        _loading = false;
      });
      _startTicker();
    } else {
      setState(() {
        _activationAt = null;
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
      setState(() => _remaining = diff.isNegative ? Duration.zero : diff);
    });
  }

  void _startRefetch() {
    _refetchTimer?.cancel();
    // Re-check activation every 15s until detected, then stop
    _refetchTimer = Timer.periodic(const Duration(seconds: 15), (_) async {
      final at = await ProfileApi.activationAt();
      if (at != null) {
        if (!mounted) return;
        final t = at.add(const Duration(days: 60));
        setState(() {
          _activationAt = at;
          _target = t;
          _remaining = t.difference(DateTime.now());
        });
        _startTicker();
        _refetchTimer?.cancel();
      }
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
          : (_activationAt == null
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
                    const Text(
                      'COMING SOON ....',
                      style: TextStyle(
                        fontSize: 18,
                        letterSpacing: 1.2,
                        fontFamily: 'Manrope-Bold',
                      ),
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
