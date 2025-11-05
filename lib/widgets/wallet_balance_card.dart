// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:crowwn/api/wallet_api.dart';
import 'package:crowwn/api/profile_api.dart';
import 'package:provider/provider.dart';
import '../Dark mode.dart';

class WalletBalanceCard extends StatefulWidget {
  const WalletBalanceCard({super.key});

  @override
  State<WalletBalanceCard> createState() => _WalletBalanceCardState();
}

class _WalletBalanceCardState extends State<WalletBalanceCard> {
  late Future<int> _balanceFuture;
  late Future<bool> _activationFuture;
  Razorpay? _razorpay;
  bool _isProcessing = false;
  bool? _activated;

  @override
  void initState() {
    super.initState();
    _balanceFuture = WalletApi.getBalancePaise();
    _activationFuture = ProfileApi.isActivated();
    _activationFuture.then((v) {
      if (mounted) setState(() => _activated = v);
    });
  }

  @override
  void dispose() {
    _razorpay?.clear();
    super.dispose();
  }

  void _refresh() {
    setState(() {
      _balanceFuture = WalletApi.getBalancePaise();
      _activationFuture = ProfileApi.isActivated();
      _activated = null;
      _activationFuture.then((v) {
        if (mounted) setState(() => _activated = v);
      });
    });
  }

  String _formatRupees(int paise) {
    final rupees = (paise / 100).toStringAsFixed(2);
    return '₹$rupees';
  }

  Future<void> _startTopup(BuildContext context) async {
    final isMobile = defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS;
    if (kIsWeb || !isMobile) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Top-up is supported only on Android/iOS')),
      );
      return;
    }

    final activated = await _activationFuture.catchError((_) => false) ?? false;
    final int amount = activated ? 1000 : 2100;

    Map<String, dynamic> create;
    try {
      setState(() => _isProcessing = true);
      create = await WalletApi.createOrder(amountInRupees: amount);
    } catch (e) {
      if (!mounted) return;
      setState(() => _isProcessing = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to create order: $e')),
      );
      return;
    }
    final key = (create['key'] as String?) ?? '';
    final orderId = ((create['orderId'] ?? create['order_id']) as String?) ?? '';
    final amountPaise = (create['amount'] as num?)?.toInt() ?? (amount * 100);
    final currency = (create['currency'] as String?) ?? 'INR';
    if (key.isEmpty || orderId.isEmpty) {
      if (mounted) {
        setState(() => _isProcessing = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid order response from server')),
        );
      }
      return;
    }

    _razorpay?.clear();
    _razorpay = Razorpay();

    _razorpay!.on(Razorpay.EVENT_PAYMENT_SUCCESS, (PaymentSuccessResponse res) async {
      try {
        await WalletApi.verify(
          razorpayOrderId: res.orderId ?? orderId,
          razorpayPaymentId: res.paymentId ?? '',
          razorpaySignature: res.signature ?? '',
          amountInRupees: amount,
          currency: currency,
        );
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Payment verified and wallet credited')));
        _refresh();
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Verification failed: $e')));
        }
      } finally {
        _razorpay?.clear();
        _razorpay = null;
      }
    });

    _razorpay!.on(Razorpay.EVENT_PAYMENT_ERROR, (PaymentFailureResponse res) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Payment failed: ${res.message ?? res.code}')));
      _razorpay?.clear();
      _razorpay = null;
    });

    _razorpay!.on(Razorpay.EVENT_EXTERNAL_WALLET, (_) {});

    final options = {
      'key': key,
      'amount': amountPaise,
      'currency': currency,
      'name': 'Wallet Top-up',
      'description': 'JustStock education',
      'order_id': orderId,
      'timeout': 120,
      'prefill': {
        'email': '',
        'contact': '',
      }
    };

    _razorpay!.open(options);
    if (mounted) setState(() => _isProcessing = false);
  }

  String _formatRupeesFixed(int paise) {
    final rupees = (paise / 100).toStringAsFixed(2);
    return '₹$rupees';
  }

  @override
  Widget build(BuildContext context) {
    final notifier = Provider.of<ColorNotifire>(context, listen: true);
    return FutureBuilder<int>(
      future: _balanceFuture,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: notifier.textField,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: notifier.getContainerBorder ?? Colors.transparent),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Wallet Balance', style: TextStyle(color: notifier.textColor, fontSize: 16, fontFamily: 'Manrope-Bold')),
                const SizedBox(height: 8),
                const Text('Sign in to view your wallet balance and add money.', style: TextStyle(color: Color(0xff64748B))),
              ],
            ),
          );
        }
        final paise = snapshot.data ?? 0;
        final isFirst = !(_activated ?? false);
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: notifier.textField,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: notifier.getContainerBorder ?? Colors.transparent),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text('Wallet Balance', style: TextStyle(color: notifier.textColor, fontSize: 16, fontFamily: 'Manrope-Bold')),
                  const Spacer(),
                  IconButton(
                    onPressed: _refresh,
                    icon: const Icon(Icons.refresh, size: 18),
                    color: notifier.textColor,
                    tooltip: 'Refresh',
                  )
                ],
              ),
              const SizedBox(height: 8),
              if (snapshot.connectionState == ConnectionState.waiting)
                const SizedBox(height: 28, width: 28, child: CircularProgressIndicator(strokeWidth: 2.5))
              else
                Text(_formatRupeesFixed(paise), style: TextStyle(fontSize: 24, color: notifier.textColor, fontFamily: 'Manrope-Bold')),
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                height: 44,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8B0000),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: snapshot.connectionState == ConnectionState.waiting || _isProcessing
                      ? null
                      : () => _startTopup(context),
                  child: Text(isFirst ? 'Add ₹2100 to Activate' : 'Add ₹1000',
                      style: const TextStyle(color: Colors.white, fontFamily: 'Manrope-Bold')),
                ),
              ),
              if (isFirst)
                const Padding(
                  padding: EdgeInsets.only(top: 8.0),
                  child: Text(
                    'Your first successful top-up of ₹2100 activates your account. Later top-ups are ₹1000.',
                    style: TextStyle(color: Color(0xff64748B), fontSize: 12),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
