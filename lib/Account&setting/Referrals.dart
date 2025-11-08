// ignore_for_file: file_names
import 'package:crowwn/services/api_locator.dart';
import 'package:crowwn/services/referral_api.dart';
import '../widgets/topup_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Dark mode.dart';
import '../config/common.dart';

class ReferralsPage extends StatefulWidget {
  const ReferralsPage({super.key});

  @override
  State<ReferralsPage> createState() => _ReferralsPageState();
}

class _ReferralsPageState extends State<ReferralsPage> with SingleTickerProviderStateMixin {
  late final TabController _tab;
  ColorNotifire notifier = ColorNotifire();

  Map<String, dynamic>? _earn;
  List<dynamic>? _levels;
  Map<String, dynamic>? _config;
  List<dynamic>? _withdrawals;
  bool _loading = true;
  String? _error;

  int _amountPaiseFrom(Map<String, dynamic> m) {
    final ap = m['amountPaise'];
    if (ap is num) return ap.toInt();
    final a = m['amount'];
    if (a is num) return (a * 100).round();
    return 0;
  }

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 3, vsync: this);
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final ref = ApiLocator.referral;
      final results = await Future.wait([
        ref.earnings(),
        ref.tree(depth: 10),
        ref.config(),
        ref.withdrawals(),
      ]);
      setState(() {
        _earn = results[0] as Map<String, dynamic>;
        _levels = results[1] as List<dynamic>;
        _config = results[2] as Map<String, dynamic>;
        _withdrawals = results[3] as List<dynamic>;
      });
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    notifier = Provider.of<ColorNotifire>(context, listen: true);
    return Scaffold(
      backgroundColor: notifier.background,
      appBar: AppBar(
        backgroundColor: notifier.background,
        title: const Text('Referrals', style: TextStyle(fontFamily: 'Manrope-Bold', fontSize: 16)),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
        bottom: TabBar(
          controller: _tab,
          labelColor: notifier.textColor,
          tabs: const [
            Tab(text: 'Tree'),
            Tab(text: 'Earnings'),
            Tab(text: 'Plan Details'),
          ],
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text(_error!, style: TextStyle(color: notifier.textColor)))
              : TabBarView(
                  controller: _tab,
                  children: [
                    _buildTree(),
                    _buildEarnings(),
                    _buildConfig(),
                  ],
                ),
    );
  }

  Widget _buildTree() {
    final levels = _levels ?? [];
    return RefreshIndicator(
      onRefresh: _load,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: levels.length,
        itemBuilder: (context, i) {
          final level = levels[i] as Map<String, dynamic>;
          final n = level['level'];
          final users = (level['users'] as List).cast<Map<String, dynamic>>();
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: notifier.getContainerBorder),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Level $n - ${users.length} users', style: TextStyle(fontFamily: 'Manrope-Bold', color: notifier.textColor)),
                const SizedBox(height: 8),
                for (final u in users.take(5))
                  Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Text(
                      '${u['name'] ?? 'Unknown'} • ${u['email'] ?? '-'}',
                      style: TextStyle(color: notifier.textColor),
                    ),
                  ),
                if (users.length > 5)
                  Text('+${users.length - 5} more', style: const TextStyle(color: Colors.grey)),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildEarnings() {
    final e = _earn ?? {};
    final total = (e['totalEarnedPaise'] ?? 0) as int;
    final paid = (e['totalPaidPaise'] ?? 0) as int;
    final pending = (e['totalPendingPaise'] ?? 0) as int;
    final entries = (e['entries'] as List?)?.cast<Map<String, dynamic>>() ?? const [];
    final withdrawals = (_withdrawals ?? const []).cast<Map<String, dynamic>>();

    return RefreshIndicator(
      onRefresh: _load,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _statTile('Total Earned', rupees(total)),
          _statTile('Paid', rupees(paid)),
          _statTile('Pending', rupees(pending)),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () => TopupHelper.ensureFunds(context),
                  child: const Text('Deposit'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: entries.isEmpty ? null : _withdraw,
                  child: const Text('Withdraw'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text('Entries', style: TextStyle(fontFamily: 'Manrope-Bold', color: notifier.textColor)),
          const SizedBox(height: 8),
          for (final it in entries)
            Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: notifier.getContainerBorder),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Level ${it['level'] ?? '-'}', style: TextStyle(color: notifier.textColor)),
                        const SizedBox(height: 4),
                        Text('${it['status']}', style: const TextStyle(color: Colors.grey)),
                      ],
                    ),
                  ),
                  Text('₹ ${rupees(_amountPaiseFrom(it)).toStringAsFixed(2)}', style: TextStyle(color: notifier.textColor)),
                ],
              ),
            ),
          const SizedBox(height: 16),
          Text('Withdrawals', style: TextStyle(fontFamily: 'Manrope-Bold', color: notifier.textColor)),
          const SizedBox(height: 8),
          for (final w in withdrawals)
            Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: notifier.getContainerBorder),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${w['status']}', style: TextStyle(color: notifier.textColor)),
                        const SizedBox(height: 4),
                        Text('${w['createdAt']}', style: const TextStyle(color: Colors.grey, fontSize: 12)),
                      ],
                    ),
                  ),
                  Text('₹ ${rupees(_amountPaiseFrom(w)).toStringAsFixed(2)}', style: TextStyle(color: notifier.textColor)),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildConfig() {
    final c = _config ?? {};
    final levelPercentages = (c['levelPercentages'] as List?)?.cast<num>() ?? const [];
    final maxDepth = c['maxDepth']?.toString() ?? '-';
    final regFee = (c['registrationFeePaise'] ?? 0) as int;
    final renFee = (c['renewalFeePaise'] ?? 0) as int;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _row('Max Depth', maxDepth),
        _row('Registration Fee', '₹ ${rupees(regFee).toStringAsFixed(2)}'),
        _row('Renewal Fee', '₹ ${rupees(renFee).toStringAsFixed(2)}'),
        const SizedBox(height: 8),
        Text('Level Percentages', style: TextStyle(fontFamily: 'Manrope-Bold', color: notifier.textColor)),
        const SizedBox(height: 6),
        Wrap(
          spacing: 6,
          children: [
            for (int i = 0; i < levelPercentages.length; i++)
              Chip(label: Text('L${i + 1}: ${levelPercentages[i]}%')),
          ],
        ),
      ],
    );
  }

  Widget _statTile(String title, num value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: notifier.getContainerBorder),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: TextStyle(color: notifier.textColor)),
          Text('₹ ${value.toStringAsFixed(2)}', style: TextStyle(color: notifier.textColor)),
        ],
      ),
    );
  }

  Widget _row(String k, String v) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: notifier.getContainerBorder),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(k, style: TextStyle(color: notifier.textColor)),
          Text(v, style: TextStyle(color: notifier.textColor)),
        ],
      ),
    );
  }

  Future<void> _withdraw() async {
    try {
      await ApiLocator.referral.requestWithdraw();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Withdrawal requested')),
      );
      await _load();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Withdraw failed: $e')),
      );
    }
  }
}
