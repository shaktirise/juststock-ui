import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../Dark mode.dart';
import '../services/api_locator.dart';

class DailyTipPage extends StatefulWidget {
  const DailyTipPage({super.key});

  @override
  State<DailyTipPage> createState() => _DailyTipPageState();
}

class _DailyTipPageState extends State<DailyTipPage> {
  bool _loading = true;
  String? _error;
  Map<String, dynamic>? _latest;
  List<Map<String, dynamic>> _items = const [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final api = ApiLocator.dailyTip;
      final latest = await api.latest();
      final list = await api.list(limit: 20);
      // De-duplicate latest in list if present
      if (latest != null && list.isNotEmpty) {
        final lid = (latest['id'] ?? latest['_id'])?.toString();
        _items = list.where((e) => (e['id'] ?? e['_id'])?.toString() != lid).toList();
      } else {
        _items = list;
      }
      _latest = latest;
    } catch (e) {
      _error = e.toString();
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  String _formatTs(Map<String, dynamic> m) {
    final fmt = DateFormat('dd MMM, hh:mm a');
    final s = m['publishedAt']?.toString() ?? m['createdAt']?.toString();
    if (s != null) {
      final dt = DateTime.tryParse(s);
      if (dt != null) return fmt.format(dt.toLocal());
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    final notifier = Provider.of<ColorNotifire>(context, listen: true);
    return Scaffold(
      backgroundColor: notifier.background,
      appBar: AppBar(
        backgroundColor: notifier.background,
        title: const Text('Daily Tip'),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text(_error!, style: TextStyle(color: notifier.textColor)))
              : RefreshIndicator(
                  onRefresh: _load,
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      if (_latest != null) ...[
                        Text('Latest', style: TextStyle(fontFamily: 'Manrope-Bold', color: notifier.textColor)),
                        const SizedBox(height: 8),
                        _TipCard(tip: _latest!, subtitle: _formatTs(_latest!)),
                        const SizedBox(height: 16),
                      ],
                      Text('Recent', style: TextStyle(fontFamily: 'Manrope-Bold', color: notifier.textColor)),
                      const SizedBox(height: 8),
                      if (_items.isEmpty)
                        const Text('No recent tips')
                      else
                        ..._items.map((t) => Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: _TipCard(tip: t, subtitle: _formatTs(t)),
                            )),
                    ],
                  ),
                ),
    );
  }
}

class _TipCard extends StatelessWidget {
  const _TipCard({required this.tip, this.subtitle});
  final Map<String, dynamic> tip;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    final notifier = Provider.of<ColorNotifire>(context, listen: true);
    final msg = (tip['message'] ?? '').toString();
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: notifier.getContainerBorder),
        color: notifier.onboardBackgroundColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            msg,
            style: TextStyle(fontSize: 15, height: 1.5, color: notifier.textColor, fontFamily: 'Manrope-Medium'),
          ),
          if (subtitle != null && subtitle!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(subtitle!, style: const TextStyle(color: Color(0xff94A3B8), fontSize: 12)),
          ],
        ],
      ),
    );
  }
}

