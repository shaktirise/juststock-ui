// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Dark mode.dart';

class WithdrawOptions extends StatelessWidget {
  const WithdrawOptions({super.key});

  @override
  Widget build(BuildContext context) {
    final notifier = Provider.of<ColorNotifire>(context, listen: true);
    return Scaffold(
      backgroundColor: notifier.background,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: notifier.background,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Icon(Icons.arrow_back, color: notifier.textColor),
        ),
        title: Text('Withdraw', style: TextStyle(color: notifier.textColor, fontFamily: 'Manrope-Bold', fontSize: 16)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Choose withdrawal method', style: TextStyle(color: notifier.textColor, fontFamily: 'Manrope-Bold', fontSize: 16)),
            const SizedBox(height: 16),
            _OptionTile(
              title: 'UPI',
              subtitle: 'Withdraw to UPI ID',
              icon: Icons.qr_code_2,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('UPI option (coming soon)')));
              },
            ),
            const SizedBox(height: 12),
            _OptionTile(
              title: 'Bank Account',
              subtitle: 'Withdraw to bank account',
              icon: Icons.account_balance,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Bank Account option (coming soon)')));
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _OptionTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;
  const _OptionTile({required this.title, required this.subtitle, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final notifier = Provider.of<ColorNotifire>(context, listen: true);
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: notifier.getContainerBorder, width: 1),
          color: notifier.textField,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: notifier.onboardBackgroundColor,
              ),
              child: Icon(icon, color: notifier.textColor),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(color: notifier.textColor, fontFamily: 'Manrope-Bold', fontSize: 15)),
                  const SizedBox(height: 4),
                  Text(subtitle, style: const TextStyle(color: Color(0xff64748B), fontSize: 13)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Color(0xff64748B))
          ],
        ),
      ),
    );
  }
}