// ignore_for_file: file_names

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Dark mode.dart';
import '../services/api_locator.dart';

class WalletWithdrawUpiPage extends StatefulWidget {
  const WalletWithdrawUpiPage({super.key, required this.amountInRupees});

  final int amountInRupees;

  @override
  State<WalletWithdrawUpiPage> createState() => _WalletWithdrawUpiPageState();
}

class _WalletWithdrawUpiPageState extends State<WalletWithdrawUpiPage> {
  ColorNotifire notifier = ColorNotifire();
  final _upiId = TextEditingController();
  final _name = TextEditingController();
  final _mobile = TextEditingController();
  final _note = TextEditingController();
  bool _submitting = false;

  @override
  void dispose() {
    _upiId.dispose();
    _name.dispose();
    _mobile.dispose();
    _note.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_upiId.text.trim().isEmpty || _name.text.trim().isEmpty || _mobile.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Enter UPI ID, name and mobile')));
      return;
    }
    setState(() => _submitting = true);
    try {
      await ApiLocator.wallet.createWithdrawalUpi(
        amountInRupees: widget.amountInRupees,
        upiId: _upiId.text.trim(),
        name: _name.text.trim(),
        mobile: _mobile.text.trim(),
        note: _note.text.trim().isEmpty ? null : _note.text.trim(),
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Withdrawal requested')));
      Navigator.pop(context, {'status': 'success'});
    } on DioException catch (e) {
      final sc = e.response?.statusCode;
      String msg;
      if (sc == 400) {
        msg = 'Amount/method invalid';
      } else if (sc == 401) {
        msg = 'Unauthorized. Please login again';
      } else {
        msg = 'Request failed (${sc ?? '-'})';
      }
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed: $e')));
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    notifier = Provider.of<ColorNotifire>(context, listen: true);
    return Scaffold(
      backgroundColor: notifier.background,
      appBar: AppBar(
        backgroundColor: notifier.background,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: notifier.textColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Withdraw to UPI', style: TextStyle(color: notifier.textColor, fontFamily: 'Manrope-Bold', fontSize: 16)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Amount: ₹${widget.amountInRupees}', style: TextStyle(color: notifier.textColor, fontFamily: 'Manrope-Bold')),
            const SizedBox(height: 12),
            _tf(_upiId, 'UPI ID (e.g., name@upi)'),
            _tf(_name, 'Account holder name'),
            _tf(_mobile, 'Mobile number', type: TextInputType.phone),
            _tf(_note, 'Note (optional)'),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8B0000),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: _submitting ? null : _submit,
                child: _submitting
                    ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2.5, valueColor: AlwaysStoppedAnimation<Color>(Colors.white)))
                    : const Text('Request Withdrawal', style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tf(TextEditingController c, String hint, {TextInputType? type}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: notifier.textField,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: notifier.getContainerBorder),
      ),
      child: TextField(
        controller: c,
        keyboardType: type,
        style: TextStyle(color: notifier.textColor),
        decoration: InputDecoration(
          hintText: hint,
          border: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(12)),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        ),
      ),
    );
  }
}

