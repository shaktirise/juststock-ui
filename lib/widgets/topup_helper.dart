// ignore_for_file: use_build_context_synchronously

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import '../api/wallet_api.dart';

class TopupHelper {
  static Future<void> ensureFunds(BuildContext context) async {
    final isMobile = defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS;
    if (!isMobile || kIsWeb) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Top-up is supported only on Android/iOS')),
      );
      return;
    }

    final balancePaise = await WalletApi.getBalancePaise();
    final firstTopup = balancePaise <= 0;
    final amountInRupees = firstTopup ? 2100 : 1000;

    final order = await WalletApi.createOrder(amountInRupees: amountInRupees);
    final key = order['key'] as String;
    final orderId = order['order_id'] as String;
    final amountPaise = (order['amount'] as num?)?.toInt() ?? (amountInRupees * 100);
    final currency = (order['currency'] as String?) ?? 'INR';

    final rp = Razorpay();
    rp.on(Razorpay.EVENT_PAYMENT_SUCCESS, (PaymentSuccessResponse res) async {
      try {
        await WalletApi.verify(
          razorpayOrderId: res.orderId ?? orderId,
          razorpayPaymentId: res.paymentId ?? '',
          razorpaySignature: res.signature ?? '',
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Payment verified. Wallet credited.')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Verification failed: $e')),
        );
      } finally {
        rp.clear();
      }
    });
    rp.on(Razorpay.EVENT_PAYMENT_ERROR, (PaymentFailureResponse res) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Payment failed: ${res.message ?? res.code}')),
      );
      rp.clear();
    });
    rp.on(Razorpay.EVENT_EXTERNAL_WALLET, (_) {});

    final options = {
      'key': key,
      'amount': amountPaise,
      'currency': currency,
      'name': 'Wallet Top-up',
      'description': 'Crowwn trading advisory',
      'order_id': orderId,
      'timeout': 120,
    };
    rp.open(options);
  }
}

