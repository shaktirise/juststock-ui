import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Dark mode.dart';
import '../api/mutual_fund_api.dart';

class MutualFundPage extends StatefulWidget {
  const MutualFundPage({super.key});

  @override
  State<MutualFundPage> createState() => _MutualFundPageState();
}

class _MutualFundPageState extends State<MutualFundPage> {
  final _formKey = GlobalKey<FormState>();

  final _fullNameCtrl = TextEditingController();
  final _dobCtrl = TextEditingController();
  final _mobileCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _panCtrl = TextEditingController();
  final _cityCtrl = TextEditingController();
  final _stateCtrl = TextEditingController();
  final _pinCtrl = TextEditingController();
  final _signatureCtrl = TextEditingController();
  final _declarationDateCtrl = TextEditingController();

  String? _enrollmentId;
  String? _isNewToMutualFunds; // yes/no
  String? _investmentAmount;
  String? _investmentType;
  String? _preferredContactTime;
  bool _consentToBeContacted = false;

  bool _savingDraft = false;
  bool _finalSubmitting = false;

  @override
  void dispose() {
    _fullNameCtrl.dispose();
    _dobCtrl.dispose();
    _mobileCtrl.dispose();
    _emailCtrl.dispose();
    _panCtrl.dispose();
    _cityCtrl.dispose();
    _stateCtrl.dispose();
    _pinCtrl.dispose();
    _signatureCtrl.dispose();
    _declarationDateCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate(TextEditingController ctrl) async {
    final now = DateTime.now();
    final initial = DateTime.tryParse(ctrl.text) ?? DateTime(now.year - 21);
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(1900),
      lastDate: DateTime(now.year + 10),
    );
    if (picked == null) return;
    ctrl.text = _dateOnly(picked);
  }

  String _dateOnly(DateTime d) => d.toIso8601String().split('T').first;

  Map<String, dynamic> _buildPayload({required bool finalSubmit}) {
    return {
      'fullName': _fullNameCtrl.text.trim(),
      'dateOfBirth': _dobCtrl.text.trim(),
      'mobileNumber': _mobileCtrl.text.trim(),
      'emailId': _emailCtrl.text.trim(),
      'panNumber': _panCtrl.text.trim().toUpperCase(),
      'city': _cityCtrl.text.trim(),
      'state': _stateCtrl.text.trim(),
      'pinCode': _pinCtrl.text.trim(),
      if (_isNewToMutualFunds != null)
        'isNewToMutualFunds': _isNewToMutualFunds,
      if (_investmentAmount != null)
        'approximateInvestmentAmount': _investmentAmount,
      if (_investmentType != null) 'investmentTypeInterested': _investmentType,
      if (_preferredContactTime != null)
        'preferredContactTime': _preferredContactTime,
      'consentToBeContacted': _consentToBeContacted,
      'declarationDate': _declarationDateCtrl.text.trim(),
      'signatureOrDigitalConsent': _signatureCtrl.text.trim(),
      'finalSubmit': finalSubmit,
      if ((_enrollmentId ?? '').isNotEmpty) 'enrollmentId': _enrollmentId,
    };
  }

  String? _validateRequired(String? v) {
    if ((v ?? '').trim().isEmpty) return 'Required';
    return null;
  }

  bool _validateFinalForm() {
    final base = _formKey.currentState?.validate() ?? false;
    if (!base) return false;
    if (_isNewToMutualFunds == null ||
        _investmentAmount == null ||
        _investmentType == null ||
        _preferredContactTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select all dropdown options')),
      );
      return false;
    }
    if (!_consentToBeContacted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please provide consent to be contacted')),
      );
      return false;
    }
    return true;
  }

  Future<void> _save({required bool finalSubmit}) async {
    if (finalSubmit && !_validateFinalForm()) return;
    setState(() {
      if (finalSubmit) {
        _finalSubmitting = true;
      } else {
        _savingDraft = true;
      }
    });
    try {
      final res = await MutualFundApi.saveEnrollment(
        payload: _buildPayload(finalSubmit: finalSubmit),
      );
      final enrollment = (res['enrollment'] is Map<String, dynamic>)
          ? res['enrollment'] as Map<String, dynamic>
          : res;
      final id = enrollment['enrollmentId']?.toString() ??
          enrollment['id']?.toString() ??
          enrollment['_id']?.toString();
      if (id != null && id.isNotEmpty) {
        _enrollmentId = id;
      }
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(finalSubmit
              ? 'Form submitted successfully'
              : 'Draft saved successfully'),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      if (mounted) {
        setState(() {
          _savingDraft = false;
          _finalSubmitting = false;
        });
      }
    }
  }

  Widget _dropdown({
    required String label,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      items: items
          .map((e) => DropdownMenuItem<String>(value: e, child: Text(e)))
          .toList(),
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final notifier = Provider.of<ColorNotifire>(context, listen: true);
    return Scaffold(
      backgroundColor: notifier.background,
      appBar: AppBar(
        backgroundColor: notifier.background,
        elevation: 0,
        title: Text('Mutual Fund', style: TextStyle(color: notifier.textColor)),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(12),
          children: [
            TextFormField(
              controller: _fullNameCtrl,
              validator: _validateRequired,
              decoration: const InputDecoration(
                labelText: 'Full Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _dobCtrl,
              validator: _validateRequired,
              readOnly: true,
              onTap: () => _pickDate(_dobCtrl),
              decoration: const InputDecoration(
                labelText: 'Date of Birth',
                hintText: 'YYYY-MM-DD',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.calendar_today_outlined),
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _mobileCtrl,
              keyboardType: TextInputType.phone,
              validator: _validateRequired,
              decoration: const InputDecoration(
                labelText: 'Mobile Number',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _emailCtrl,
              keyboardType: TextInputType.emailAddress,
              validator: _validateRequired,
              decoration: const InputDecoration(
                labelText: 'Email ID',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _panCtrl,
              validator: _validateRequired,
              textCapitalization: TextCapitalization.characters,
              decoration: const InputDecoration(
                labelText: 'PAN Number',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _cityCtrl,
              validator: _validateRequired,
              decoration: const InputDecoration(
                labelText: 'City',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _stateCtrl,
              validator: _validateRequired,
              decoration: const InputDecoration(
                labelText: 'State',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _pinCtrl,
              keyboardType: TextInputType.number,
              validator: _validateRequired,
              decoration: const InputDecoration(
                labelText: 'Pin Code',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            _dropdown(
              label: 'Is New To Mutual Funds',
              value: _isNewToMutualFunds,
              items: const ['yes', 'no'],
              onChanged: (v) => setState(() => _isNewToMutualFunds = v),
            ),
            const SizedBox(height: 10),
            _dropdown(
              label: 'Approximate Investment Amount',
              value: _investmentAmount,
              items: const ['5000-25000', '25000-100000', '100000_PLUS'],
              onChanged: (v) => setState(() => _investmentAmount = v),
            ),
            const SizedBox(height: 10),
            _dropdown(
              label: 'Investment Type Interested',
              value: _investmentType,
              items: const ['SIP', 'LUMPSUM', 'GUIDANCE'],
              onChanged: (v) => setState(() => _investmentType = v),
            ),
            const SizedBox(height: 10),
            _dropdown(
              label: 'Preferred Contact Time',
              value: _preferredContactTime,
              items: const ['MORNING', 'AFTERNOON', 'EVENING'],
              onChanged: (v) => setState(() => _preferredContactTime = v),
            ),
            const SizedBox(height: 10),
            CheckboxListTile(
              value: _consentToBeContacted,
              onChanged: (v) =>
                  setState(() => _consentToBeContacted = v ?? false),
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.zero,
              title: const Text('I consent to be contacted'),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _declarationDateCtrl,
              validator: _validateRequired,
              readOnly: true,
              onTap: () => _pickDate(_declarationDateCtrl),
              decoration: const InputDecoration(
                labelText: 'Declaration Date',
                hintText: 'YYYY-MM-DD',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.calendar_today_outlined),
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _signatureCtrl,
              validator: _validateRequired,
              decoration: const InputDecoration(
                labelText: 'Signature / Digital Consent',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: (_savingDraft || _finalSubmitting)
                        ? null
                        : () => _save(finalSubmit: false),
                    child: Text(_savingDraft ? 'Saving...' : 'Save Draft'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: (_savingDraft || _finalSubmitting)
                        ? null
                        : () => _save(finalSubmit: true),
                    child: Text(
                        _finalSubmitting ? 'Submitting...' : 'Final Submit'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
