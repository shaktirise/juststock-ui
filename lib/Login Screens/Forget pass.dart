// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:juststock/api/auth_api.dart';

import '../Dark mode.dart';
import 'Password update.dart';
import '../config/common.dart';

class Forget extends StatefulWidget {
  const Forget({super.key});

  @override
  State<Forget> createState() => _ForgetState();
}

class _ForgetState extends State<Forget> {
  ColorNotifire notifier = ColorNotifire();
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _tokenCtrl = TextEditingController();
  final TextEditingController _passCtrl = TextEditingController();
  final TextEditingController _confirmCtrl = TextEditingController();
  final FocusNode _tokenFocus = FocusNode();
  bool _obsecuretext2 = true;
  bool _busyCode = false;   // for Get Code only (no spinner shown)
  bool _busyReset = false;  // for Reset button spinner/disable
  // Removed testing hint UI; code will still auto-fill the input.
  @override
  Widget build(BuildContext context) {
    notifier = Provider.of<ColorNotifire>(context, listen: true);
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: notifier.background,
      appBar: AppBar(
        backgroundColor: notifier.background,
        elevation: 0,
        leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.close,color:notifier.textColor,size: 25,)),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 10,right: 10),
        child: Column(
          children: [
            AppConstants.Height(50),
            Row(
              children: [
                Text(
                  "Reset Password",
                  style: TextStyle(fontSize: 27, fontFamily: "Manrope -SemiBold",color: notifier.textColor),
                ),
              ],
            ),
            AppConstants.Height(20),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Enter your account email to request a reset code. Paste the reset code below with your new password.",
                style: TextStyle(fontSize: 14, color: Color(0xff64748B),fontFamily: "Manrope-Medium"),
              ),
            ),
            AppConstants.Height(20),
            // Email
            Container(
              height: height/13,
              decoration: BoxDecoration(color: notifier.textField,borderRadius: BorderRadius.circular(15)),
              child: TextField(
                controller: _emailCtrl,
                keyboardType: TextInputType.emailAddress,
                style: TextStyle(color: notifier.textColor),
                decoration: InputDecoration(hintText: "Email",border: const OutlineInputBorder(borderSide: BorderSide.none),hintStyle: TextStyle(color: notifier.textFieldHintText)),
              ),
            ),
            AppConstants.Height(10),
            // Request reset email / code
            SizedBox(
              width: double.infinity,
              height: 44,
              child: OutlinedButton(
                onPressed: _busyCode ? null : _requestReset,
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFF8B0000)),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Get Code', style: TextStyle(color: Color(0xFF8B0000), fontFamily: 'Manrope-Bold')),
              ),
            ),
            // Removed visible testing note. Auto-filled code appears directly in the input above.
            AppConstants.Height(16),
            // Reset token
            Container(
              height: height/13,
              decoration: BoxDecoration(color: notifier.textField,borderRadius: BorderRadius.circular(15)),
              child: TextField(
                controller: _tokenCtrl,
                focusNode: _tokenFocus,
                style: TextStyle(color: notifier.textColor),
                decoration: InputDecoration(hintText: "Enter Code",border: const OutlineInputBorder(borderSide: BorderSide.none),hintStyle: TextStyle(color: notifier.textFieldHintText)),
              ),
            ),
            AppConstants.Height(10),
            // New password
            Container(
              height: height/13,
              decoration: BoxDecoration(color: notifier.textField,borderRadius: BorderRadius.circular(15)),
              child: TextField(
                controller: _passCtrl,
                style: TextStyle(color: notifier.textColor),
                obscureText: true,
                decoration: InputDecoration(hintText: "New Password",border: const OutlineInputBorder(borderSide: BorderSide.none),hintStyle: TextStyle(color: notifier.textFieldHintText)),
              ),
            ),
            AppConstants.Height(10),
            // Confirm password
            Container(
              height: height/13,
              decoration: BoxDecoration(color: notifier.textField,borderRadius: BorderRadius.circular(15)),
              child: TextField(
                controller: _confirmCtrl,
                style: TextStyle(color: notifier.textColor),
                obscureText: _obsecuretext2,
                decoration: InputDecoration(hintText: "Confirm Password",border: const OutlineInputBorder(borderSide: BorderSide.none),hintStyle: TextStyle(color: notifier.textFieldHintText),suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _obsecuretext2 =! _obsecuretext2;
                      });
                    },
                    icon: _obsecuretext2?const Icon(Icons.visibility_off) : const Icon(Icons.visibility)
                ),),
              ),
            ),
            AppConstants.Height(20),
            GestureDetector(
              onTap: _busyReset ? null : _submitReset,
              child: Container(
                height: height/12,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(15),color: const Color(0xFF8B0000),),
                child: Center(child: _busyReset ? const SizedBox(width: 22,height: 22,child: CircularProgressIndicator(strokeWidth: 2.5,valueColor: AlwaysStoppedAnimation<Color>(Colors.white))) : const Text("Reset Password",style: TextStyle(color: Color(0xffFFFFFF),fontSize: 15,fontFamily: "Manrope-Bold"),)),
              ),
            ),

          ],

        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _tokenCtrl.dispose();
    _passCtrl.dispose();
    _confirmCtrl.dispose();
    _tokenFocus.dispose();
    super.dispose();
  }

  void _showMsg(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  Future<void> _requestReset() async {
    final email = _emailCtrl.text.trim();
    if (email.isEmpty) {
      _showMsg('Enter your email first');
      return;
    }
    setState(() => _busyCode = true);
    try {
      final r = await AuthApi.forgotPassword(email: email);
      final code = r.resetToken ?? r.code;
      if (code != null && code.isNotEmpty) {
        _tokenCtrl.text = code;
        _tokenFocus.requestFocus();
        _showMsg('Code received');
      } else {
        _showMsg('If an account exists, a reset email with a code has been sent.');
      }
    } catch (e) {
      _showMsg(e.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) setState(() => _busyCode = false);
    }
  }

  Future<void> _submitReset() async {
    final email = _emailCtrl.text.trim();
    final token = _tokenCtrl.text.trim();
    final p1 = _passCtrl.text;
    final p2 = _confirmCtrl.text;
    if (email.isEmpty || token.isEmpty || p1.isEmpty || p2.isEmpty) {
      _showMsg('Fill all fields');
      return;
    }
    if (p1 != p2) {
      _showMsg('Passwords do not match');
      return;
    }
    setState(() => _busyReset = true);
    try {
      await AuthApi.resetPassword(email: email, token: token, password: p1, confirmPassword: p2);
      if (!mounted) return;
      Navigator.push(context, MaterialPageRoute(builder: (_) => const Password()));
    } catch (e) {
      _showMsg(e.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) setState(() => _busyReset = false);
    }
  }
}
