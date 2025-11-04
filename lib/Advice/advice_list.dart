// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:crowwn/api/advice_api.dart';
import 'package:crowwn/widgets/topup_helper.dart';
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

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() {
    _future = AdviceApi.list(category: widget.category);
    AdviceApi.latest(category: widget.category).then((v) {
      if (mounted) setState(() => _latest = v);
    });
  }

  Future<void> _unlockLatest() async {
    try {
      final res = await AdviceApi.unlockLatest(widget.category);
      _unlocked.add(res.advice.id);
      _showAdvice(res.advice);
      setState(() {});
    } on PaymentRequiredException {
      await TopupHelper.ensureFunds(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  Future<void> _unlockById(String id) async {
    try {
      final res = await AdviceApi.unlockById(id);
      _unlocked.add(res.advice.id);
      _showAdvice(res.advice);
      setState(() {});
    } on PaymentRequiredException {
      await TopupHelper.ensureFunds(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  void _showAdvice(AdviceDetail a) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        final notifier = Provider.of<ColorNotifire>(context, listen: true);
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: notifier.background,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${a.category.toUpperCase()} ADVICE', style: TextStyle(color: notifier.textColor, fontFamily: 'Manrope-Bold', fontSize: 16)),
                const SizedBox(height: 8),
                if (a.text != null) Text(a.text!, style: TextStyle(color: notifier.textColor)),
                const SizedBox(height: 8),
                if (a.buy != null) Text('Buy: ${a.buy}', style: TextStyle(color: notifier.textColor)),
                if (a.target != null) Text('Target: ${a.target}', style: TextStyle(color: notifier.textColor)),
                if (a.stoploss != null) Text('Stoploss: ${a.stoploss}', style: TextStyle(color: notifier.textColor)),
                const SizedBox(height: 12),
              ],
            ),
          ),
        );
      },
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
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD32F2F),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
                onPressed: _unlockLatest,
                child: const Text('Pay latest', style: TextStyle(color: Colors.white)),
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
              return Center(child: Text(snapshot.error.toString(), style: TextStyle(color: notifier.textColor)));
            }
            final items = snapshot.data ?? const <AdviceMeta>[];
            if (items.isEmpty) {
              return Center(child: Text('No advice yet', style: TextStyle(color: notifier.textColor)));
            }
            return ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: items.length,
              separatorBuilder: (_, __) => Divider(color: notifier.divider),
              itemBuilder: (context, index) {
                final m = items[index];
                final paid = _unlocked.contains(m.id);
                return ListTile(
                  title: Text('Advice #${m.id}', style: TextStyle(color: notifier.textColor, fontFamily: 'Manrope-Bold')),
                  subtitle: Text(
                    paid ? 'Unlocked' : 'Message hidden',
                    style: const TextStyle(color: Color(0xff64748B)),
                  ),
                  trailing: paid
                      ? Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(color: const Color(0x1A1DCE5C), borderRadius: BorderRadius.circular(12)),
                          child: const Text('PAID', style: TextStyle(color: Color(0xff1DCE5C), fontWeight: FontWeight.w700)),
                        )
                      : TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: const Color(0xffF8F9FD),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: const BorderSide(color: Color(0xffE2E8F0))),
                          ),
                          onPressed: () => _unlockById(m.id),
                          child: Text('Pay ₹${m.price}', style: const TextStyle(color: Color(0xFFD32F2F))),
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

