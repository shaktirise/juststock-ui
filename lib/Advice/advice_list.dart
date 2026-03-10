// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:juststock/api/advice_api.dart';
import 'package:juststock/widgets/topup_helper.dart';
import 'package:juststock/services/advice_unlocked_store.dart';
import 'package:juststock/services/advice_seen_store.dart';
import 'advice_view.dart';
import '../Dark mode.dart';

class AdviceListPage extends StatefulWidget {
  final String category; // stocks, options, future, commodity
  const AdviceListPage({super.key, required this.category});

  @override
  State<AdviceListPage> createState() => _AdviceListPageState();
}

class _AdviceListPageState extends State<AdviceListPage> {
  late Future<List<AdviceMeta>> _future;
  AdviceMeta? _latest;
  final Set<String> _unlocked = {};
  final _dateFmt = DateFormat('dd MMM, hh:mm a');

  @override
  void initState() {
    super.initState();
    _load();
    _initUnlocked();
  }

  Future<void> _initUnlocked() async {
    final ids = await AdviceUnlockedStore.getUnlockedIds();
    if (!mounted) return;
    setState(() {
      _unlocked
        ..clear()
        ..addAll(ids);
    });
  }

  void _load() {
    _future = AdviceApi.list(category: widget.category);
    AdviceApi.latest(category: widget.category).then((v) {
      if (!mounted) return;
      setState(() => _latest = v);
      if (v != null && v.id.isNotEmpty) {
        AdviceSeenStore.markSeen(widget.category, v.id);
      }
    });
  }

  Future<void> _unlockLatest() async {
    try {
      final res = await AdviceApi.unlockLatest(widget.category);
      _unlocked.add(res.advice.id);
      await AdviceUnlockedStore.put(res.advice);
      _openAdvice(res.advice);
      setState(() {});
    } on PaymentRequiredException {
      await TopupHelper.ensureFunds(context);
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  Future<void> _unlockById(String id) async {
    try {
      final res = await AdviceApi.unlockById(id);
      _unlocked.add(res.advice.id);
      await AdviceUnlockedStore.put(res.advice);
      _openAdvice(res.advice);
      setState(() {});
    } on PaymentRequiredException {
      await TopupHelper.ensureFunds(context);
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  void _openAdvice(AdviceDetail a) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => AdviceViewPage(advice: a)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final notifier = Provider.of<ColorNotifire>(context, listen: true);
    final cat = AdviceApi.normalizeCategory(widget.category).toUpperCase();
    return Scaffold(
      backgroundColor: notifier.background,
      appBar: AppBar(
        backgroundColor: notifier.background,
        elevation: 0,
        title: Text(cat, style: TextStyle(color: notifier.textColor)),
        actions: [
          if (_latest != null)
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Center(
                child: SizedBox(
                  height: 32,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      backgroundColor: const Color(0xFF8B0000),
                      foregroundColor: Colors.white,
                      shape: const StadiumBorder(),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    onPressed: _unlockLatest,
                    child: const Text(
                      'Pay',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async => setState(_load),
        child: FutureBuilder<List<AdviceMeta>>(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(
                  child: Text(snapshot.error.toString(),
                      style: TextStyle(color: notifier.textColor)));
            }
            final items = snapshot.data ?? const <AdviceMeta>[];
            if (items.isEmpty) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.inbox_outlined,
                        size: 48, color: notifier.divider),
                    const SizedBox(height: 8),
                    Text('No calls yet',
                        style: TextStyle(
                            color: notifier.textColor,
                            fontFamily: 'Manrope-Bold')),
                    const SizedBox(height: 4),
                    const Text('Check back later for new updates',
                        style: TextStyle(color: Color(0xFF94A3B8))),
                  ],
                ),
              );
            }
            return ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(12),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final m = items[index];
                final paid = _unlocked.contains(m.id) || (m.price <= 0);
                if (!paid) {
                  return _LockedAdviceCard(
                    title: 'Call ${index + 1}',
                    createdAt: m.createdAtLocal ?? _dateFmt.format(m.createdAt),
                    amount: m.price.toInt(),
                    onTap: () => _unlockById(m.id),
                  );
                }
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: notifier.textField,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: notifier.getContainerBorder ??
                          const Color(0xFFE2E8F0),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: 36,
                        width: 36,
                        decoration: BoxDecoration(
                          color: notifier.tabBar1,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.lock_open,
                          color: notifier.radioButton,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Call ${index + 1}',
                              style: TextStyle(
                                color: notifier.textColor,
                                fontFamily: 'Manrope-Bold',
                                fontSize: 16,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              m.createdAtLocal ?? _dateFmt.format(m.createdAt),
                              style: const TextStyle(
                                  color: Color(0xFF94A3B8), fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF16A34A),
                          minimumSize: const Size(0, 36),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        onPressed: () async {
                          final cached = await AdviceUnlockedStore.get(m.id);
                          if (cached != null) {
                            _openAdvice(cached);
                            return;
                          }
                          try {
                            final res = await AdviceApi.unlockById(m.id);
                            await AdviceUnlockedStore.put(res.advice);
                            _openAdvice(res.advice);
                          } catch (e) {
                            if (!mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(e.toString())));
                          }
                        },
                        child: const Text('Open',
                            style:
                                TextStyle(color: Colors.white, fontSize: 14)),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class _LockedAdviceCard extends StatefulWidget {
  const _LockedAdviceCard({
    required this.title,
    required this.createdAt,
    required this.amount,
    required this.onTap,
  });

  final String title;
  final String createdAt;
  final int amount;
  final VoidCallback onTap;

  @override
  State<_LockedAdviceCard> createState() => _LockedAdviceCardState();
}

class _LockedAdviceCardState extends State<_LockedAdviceCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final t = _controller.value;
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          child: GestureDetector(
            onTap: widget.onTap,
            child: Container(
              height: 150,
              decoration: BoxDecoration(
                color: Color.lerp(
                    const Color(0xFFF4F6FA), const Color(0xFFFDECEE), t),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Color.lerp(
                      const Color(0xFFCBD5E1), const Color(0xFFFCA5A5), t)!,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFEF4444)
                        .withValues(alpha: 0.12 + (0.12 * t)),
                    blurRadius: 8 + (8 * t),
                    spreadRadius: 0.5,
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 10),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 36,
                          width: 36,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.8),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            Icons.lock_outline_rounded,
                            color: const Color(0xFFDC2626),
                            size: 20 + t,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.title,
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontFamily: 'Manrope-Bold',
                                  color: Color(0xFF1E293B),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                widget.createdAt,
                                style: const TextStyle(
                                  color: Color(0xFF64748B),
                                  fontSize: 12,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Transform.scale(
                        scale: 0.97 + (0.06 * t),
                        child: Container(
                          height: 46,
                          width: 90,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Color(0xFFDC2626),
                                Color(0xFF991B1B),
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFFDC2626)
                                    .withValues(alpha: 0.35 + (0.15 * t)),
                                blurRadius: 8 + (6 * t),
                              ),
                            ],
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            '${widget.amount}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
