// ignore_for_file: file_names, camel_case_types

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:crowwn/services/api_locator.dart';

import '../Dark mode.dart';

class ReferralWithdrawPage extends StatefulWidget {
  const ReferralWithdrawPage({super.key});

  @override
  State<ReferralWithdrawPage> createState() => _ReferralWithdrawPageState();
}

class _ReferralWithdrawPageState extends State<ReferralWithdrawPage> {
  ColorNotifire notifier = ColorNotifire();
  String _method = 'UPI';
  bool _submitting = false;
  int _pendingPaise = 0;
  String? _error;

  // UPI
  final _upiId = TextEditingController();
  final _upiName = TextEditingController();
  final _upiMobile = TextEditingController();
  final _note = TextEditingController();

  // BANK
  final _accName = TextEditingController();
  final _accNo = TextEditingController();
  final _ifsc = TextEditingController();
  final _bankName = TextEditingController();
  final _contactName = TextEditingController();
  final _contactMobile = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadEarnings();
  }

  Future<void> _loadEarnings() async {
    try {
      final e = await ApiLocator.referral.earnings();
      setState(() => _pendingPaise = (e['totalPendingPaise'] as num? ?? 0).toInt());
    } catch (e) {
      setState(() => _error = e.toString());
    }
  }

  @override
  void dispose() {
    _upiId.dispose();
    _upiName.dispose();
    _upiMobile.dispose();
    _note.dispose();
    _accName.dispose();
    _accNo.dispose();
    _ifsc.dispose();
    _bankName.dispose();
    _contactName.dispose();
    _contactMobile.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_pendingPaise < 10000) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Minimum ₹100 required to withdraw')));
      return;
    }
    setState(() => _submitting = true);
    try {
      Map<String, dynamic> res;
      if (_method == 'UPI') {
        if (_upiId.text.trim().isEmpty || _upiName.text.trim().isEmpty || _upiMobile.text.trim().isEmpty) {
          throw Exception('Enter UPI ID, name and mobile');
        }
        res = await ApiLocator.referral.requestWithdrawUpi(
          upiId: _upiId.text.trim(),
          name: _upiName.text.trim(),
          mobile: _upiMobile.text.trim(),
          note: _note.text.trim().isEmpty ? null : _note.text.trim(),
        );
      } else {
        if (_accName.text.trim().isEmpty || _accNo.text.trim().isEmpty || _ifsc.text.trim().isEmpty || _bankName.text.trim().isEmpty || _contactName.text.trim().isEmpty || _contactMobile.text.trim().isEmpty) {
          throw Exception('Fill all bank details');
        }
        res = await ApiLocator.referral.requestWithdrawBank(
          bankAccountName: _accName.text.trim(),
          bankAccountNumber: _accNo.text.trim(),
          bankIfsc: _ifsc.text.trim(),
          bankName: _bankName.text.trim(),
          contactName: _contactName.text.trim(),
          contactMobile: _contactMobile.text.trim(),
          note: _note.text.trim().isEmpty ? null : _note.text.trim(),
        );
      }
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Withdrawal requested')));
      Navigator.pop(context, res);
    } catch (e) {
      if (!mounted) return;
      final msg = e.toString().replaceFirst('Exception: ', '');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
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
        title: Text('Withdraw', style: TextStyle(color: notifier.textColor)),
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_error != null) Text(_error!, style: const TextStyle(color: Colors.red)),
            Text('Available: ₹ ${(_pendingPaise / 100).toStringAsFixed(2)}', style: TextStyle(color: notifier.textColor, fontFamily: 'Manrope-Bold')),
            const SizedBox(height: 16),
            Text('Choose withdrawal method', style: TextStyle(color: notifier.textColor, fontFamily: 'Manrope-Bold')),
            const SizedBox(height: 8),
            _methodTile('UPI', 'Withdraw to UPI ID', Icons.qr_code),
            const SizedBox(height: 10),
            _methodTile('BANK', 'Withdraw to bank account', Icons.account_balance),
            const SizedBox(height: 16),
            if (_method == 'UPI') _upiForm() else _bankForm(),
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

  Widget _methodTile(String value, String subtitle, IconData icon) {
    final selected = _method == value;
    return InkWell(
      onTap: () => setState(() => _method = value),
      child: Container(
        decoration: BoxDecoration(
          color: notifier.textField,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: selected ? const Color(0xFF8B0000) : (notifier.getContainerBorder)),
        ),
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Icon(icon, color: selected ? const Color(0xFF8B0000) : Colors.grey[700]),
            const SizedBox(width: 12),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(value, style: TextStyle(color: notifier.textColor, fontFamily: 'Manrope-Bold')),
                const SizedBox(height: 2),
                Text(subtitle, style: const TextStyle(color: Color(0xFF64748B), fontSize: 12)),
              ]),
            ),
            Icon(Icons.chevron_right, color: selected ? const Color(0xFF8B0000) : Colors.grey),
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

  Widget _upiForm() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      _tf(_upiId, 'UPI ID (e.g., name@upi)'),
      _tf(_upiName, 'Account holder name'),
      _tf(_upiMobile, 'Mobile number', type: TextInputType.phone),
      _tf(_note, 'Note (optional)'),
    ]);
  }

  Widget _bankForm() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      _tf(_accName, 'Account holder name'),
      _tf(_accNo, 'Account number', type: TextInputType.number),
      _tf(_ifsc, 'IFSC'),
      _tf(_bankName, 'Bank name'),
      _tf(_contactName, 'Contact name'),
      _tf(_contactMobile, 'Contact mobile', type: TextInputType.phone),
      _tf(_note, 'Note (optional)'),
    ]);
  }
}

