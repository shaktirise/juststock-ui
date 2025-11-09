// ignore_for_file: file_names, camel_case_types

import 'package:flutter/material.dart';
import '../config/common.dart';
import 'package:crowwn/api/wallet_api.dart';

class Transaction_all extends StatefulWidget {
  const Transaction_all({super.key});

  @override
  State<Transaction_all> createState() => _Transaction_allState();
}

class _Transaction_allState extends State<Transaction_all> {
  Future<List<WalletHistoryItem>>? _future;

  @override
  void initState() {
    super.initState();
    _future = WalletApi.ledgerOrHistory(limit: 50);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child:
          Image.asset("assets/images/arrow-narrow-left (1).png", scale: 3),
        ),
        title: const Text("See All Transactions",style: TextStyle(color: Color(0xFF8B0000),fontSize: 17,fontFamily: "Manrope-Bold")),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: FutureBuilder<List<WalletHistoryItem>>(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: SizedBox(
                  height: 26,
                  width: 26,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              );
            }
            final items = snapshot.data ?? const <WalletHistoryItem>[];
            if (items.isEmpty) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.only(top: 24),
                  child: Text('No transactions yet', style: TextStyle(color: Color(0xff64748B))),
                ),
              );
            }
            return ListView.separated(
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              itemCount: items.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final it = items[index];
                final isCredit = it.amountPaise > 0;
                final amount = (it.amountPaise / 100).toStringAsFixed(2);
                final title = it.title ?? it.category ?? (isCredit ? 'Credit' : 'Debit');
                final subtitle = it.note ?? '';
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: const Color(0xffE2E8F0)),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: const Color(0xFF8B0000).withOpacity(0.08),
                      child: Icon(isCredit ? Icons.call_received : Icons.call_made, color: const Color(0xFF8B0000)),
                    ),
                    title: Row(
                      children: [
                        Expanded(
                          child: Text(title,
                              style: const TextStyle(
                                  fontSize: 15,
                                  color: Color(0xff0F172A),
                                  fontFamily: "Manrope-Bold")),
                        ),
                        Text('${isCredit ? '+' : ''}$amount',
                            style: const TextStyle(
                                fontSize: 16,
                                color: Color(0xff0F172A),
                                fontFamily: "Manrope-Bold")),
                      ],
                    ),
                    subtitle: Row(
                      children: [
                        Expanded(
                          child: Text(
                            subtitle,
                            style: const TextStyle(
                                fontSize: 13,
                                color: Color(0xff64748B),
                                fontFamily: "Manrope-Regular"),
                          ),
                        ),
                      ],
                    ),
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
