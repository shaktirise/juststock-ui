import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:crowwn/api/advice_api.dart';
import '../Dark mode.dart';

class AdviceViewPage extends StatelessWidget {
  final AdviceDetail advice;
  AdviceViewPage({super.key, required this.advice});

  final _fmt = DateFormat('dd MMM, hh:mm a');

  @override
  Widget build(BuildContext context) {
    final notifier = Provider.of<ColorNotifire>(context, listen: true);
    return Scaffold(
      backgroundColor: notifier.background,
      appBar: AppBar(
        backgroundColor: notifier.background,
        elevation: 0,
        title: Text(advice.category.toUpperCase(), style: TextStyle(color: notifier.textColor)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (advice.createdAt != null)
                  Text(_fmt.format(advice.createdAt!), style: const TextStyle(color: Color(0xFF64748B), fontSize: 12)),
                const Spacer(),
                if (advice.price != null)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(color: const Color(0x1A1DCE5C), borderRadius: BorderRadius.circular(12)),
                    child: const Text('PAID', style: TextStyle(color: Color(0xff1DCE5C), fontWeight: FontWeight.w700)),
                  )
              ],
            ),
            const SizedBox(height: 12),
            if (advice.text != null)
              Text(
                advice.text!,
                style: TextStyle(color: notifier.textColor, fontSize: 16, height: 1.4),
              ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                if (advice.buy != null) _kv('Buy', advice.buy!, notifier),
                if (advice.target != null) _kv('Target', advice.target!, notifier),
                if (advice.stoploss != null) _kv('Stoploss', advice.stoploss!, notifier),
                if (advice.price != null) _kv('Price', '₹${advice.price}', notifier),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _kv(String k, String v, ColorNotifire notifier) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: notifier.textField,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: notifier.getContainerBorder ?? const Color(0xFFE2E8F0)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('$k: ', style: const TextStyle(fontFamily: 'Manrope-Bold')),
          Text(v),
        ],
      ),
    );
  }
}

