// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../Dark mode.dart';
import '../api/wallet_api.dart';

class Transaction extends StatefulWidget {
  const Transaction({super.key});

  @override
  State<Transaction> createState() => _TransactionState();
}

class _TransactionState extends State<Transaction> {
  ColorNotifire notifier = ColorNotifire();
  late Future<_TxnBundle> _future;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<_TxnBundle> _load() async {
    final balancePaise = await WalletApi.getBalancePaise();
    final txns = await WalletApi.ledgerOrHistory(page: 1, limit: 50);
    txns.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return _TxnBundle(balancePaise: balancePaise, txns: txns);
  }

  @override
  Widget build(BuildContext context) {
    notifier = Provider.of<ColorNotifire>(context, listen: true);
    return Scaffold(
      backgroundColor: notifier.background,
      appBar: AppBar(
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Image.asset(
            'assets/images/arrow-narrow-left (1).png',
            scale: 2.9,
            color: notifier.textColor,
          ),
        ),
        title: Center(
          child: Text(
            'Transaction History',
            style: TextStyle(fontSize: 16, color: notifier.textColor),
          ),
        ),
        backgroundColor: notifier.background,
      ),
      body: FutureBuilder<_TxnBundle>(
        future: _future,
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(strokeWidth: 2.5));
          }
          if (snap.hasError || !snap.hasData) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Failed to load transactions'),
                  const SizedBox(height: 8),
                  TextButton(onPressed: () => setState(() => _future = _load()), child: const Text('Retry')),
                ],
              ),
            );
          }
          final data = snap.data!;
          final rupees = (data.balancePaise / 100).toStringAsFixed(2);
          final items = data.txns;
          if (items.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('No transactions yet'),
                  const SizedBox(height: 6),
                  Text('Current balance: ₹ $rupees', style: const TextStyle(fontWeight: FontWeight.w600)),
                ],
              ),
            );
          }

          final timeFmt = DateFormat('d MMM yyyy • hh:mm a');
          return ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
            itemCount: items.length + 1,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              if (index == 0) {
                return Row(
                  children: [
                    Text('Current Balance', style: TextStyle(color: notifier.textColor, fontSize: 15)),
                    const Spacer(),
                    Text('₹ $rupees', style: TextStyle(color: notifier.textColor, fontSize: 16, fontFamily: 'Manrope-Bold')),
                  ],
                );
              }
              final t = items[index - 1];
              final isCredit = t.amountPaise >= 0;
              final amount = (t.amountPaise.abs() / 100).toStringAsFixed(2);
              final title = t.title?.isNotEmpty == true
                  ? t.title!
                  : (t.note?.isNotEmpty == true ? t.note! : (isCredit ? 'Wallet credit' : 'Wallet debit'));
              final subtitle = timeFmt.format(t.createdAt);
              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: notifier.getContainerBorder, width: 1),
                ),
                child: ListTile(
                  leading: Image.asset('assets/images/receipt.png', height: 40, width: 40),
                  title: Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 15, color: notifier.textColor, fontFamily: 'Manrope-Bold'),
                        ),
                      ),
                      Text(
                        (isCredit ? '+ ' : '- ') + '₹ $amount',
                        style: TextStyle(
                          fontSize: 15,
                          color: isCredit ? const Color(0xFF0F172A) : const Color(0xFFE82C81),
                          fontFamily: 'Manrope-Bold',
                        ),
                      ),
                    ],
                  ),
                  subtitle: Text(subtitle, style: const TextStyle(fontSize: 13, color: Color(0xff64748B))),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _TxnBundle {
  final int balancePaise;
  final List<WalletHistoryItem> txns;
  const _TxnBundle({required this.balancePaise, required this.txns});
}

