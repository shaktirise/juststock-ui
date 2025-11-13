import 'package:flutter/material.dart';
import 'package:crowwn/api/wallet_api.dart';

class WalletBalanceAmount extends StatelessWidget {
  final bool visible;
  final TextStyle style;
  const WalletBalanceAmount({super.key, required this.visible, required this.style});

  String _formatRupees(int paise) {
    final rupees = (paise / 100).toStringAsFixed(2);
    return '\u20B9 $rupees';
  }

  @override
  Widget build(BuildContext context) {
    if (!visible) {
      return Text(' **********', style: style);
    }
    return FutureBuilder<int>(
      future: WalletApi.getBalancePaise(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text('\u20B9 0.00', style: style);
        }
        final paise = snapshot.data ?? 0;
        return Text(_formatRupees(paise), style: style);
      },
    );
  }
}

