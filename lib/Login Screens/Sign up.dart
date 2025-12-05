// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:juststock/api/auth_api.dart';
import 'package:juststock/api/token_storage.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/gestures.dart';
import '../Dark mode.dart';
import '../config/common.dart';
import 'Login.dart';
// Removed phone/OTP flow after signup
import 'package:juststock/services/api_locator.dart';


class Sign extends StatefulWidget {
  const Sign({super.key});

  @override
  State<Sign> createState() => _SignState();
}

class _SignState extends State<Sign> {
  bool value = false;
  bool _obsecuretext1 = true;
  ColorNotifire notifier = ColorNotifire();
  late final TapGestureRecognizer _termsRecognizer;
  late final TapGestureRecognizer _privacyRecognizer;
  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _phoneCtrl = TextEditingController();
  final TextEditingController _passwordCtrl = TextEditingController();
  final TextEditingController _confirmCtrl = TextEditingController();
  final TextEditingController _referralCtrl = TextEditingController();
  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    _termsRecognizer = TapGestureRecognizer()
      ..onTap = () {
        launchUrl(
          Uri.parse('https://juststock.in/terms'),
          mode: LaunchMode.externalApplication,
        );
      };
    _privacyRecognizer = TapGestureRecognizer()
      ..onTap = () {
        launchUrl(
          Uri.parse('https://juststock.in/privacy'),
          mode: LaunchMode.externalApplication,
        );
      };
  }

  @override
  void dispose() {
    _termsRecognizer.dispose();
    _privacyRecognizer.dispose();
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmCtrl.dispose();
    _referralCtrl.dispose();
    super.dispose();
  }

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
          child: Icon(
            Icons.close,
            color: notifier.textColor,
            size: 25,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppConstants.Height(50),
              Text(
                "Create your account",
                style: TextStyle(
                    fontSize: 24,
                    fontFamily: "Manrope-SemiBold",
                    color: notifier.isDark ? Colors.white : null),
              ),
              AppConstants.Height(10),
              const Text(
                "Letâ€™s get started with a free JustStock account.",
                style: TextStyle(
                    fontSize: 14,
                    color: Color(0xff64748B),
                    fontFamily: "Manrope-Medium"),
              ),
              AppConstants.Height(10),
              Container(
                height: height / 13,
                decoration: BoxDecoration(
                    color: notifier.textField,
                    borderRadius: BorderRadius.circular(15)),
                child: TextField(
                  controller: _nameCtrl,
                  style: TextStyle(color: notifier.textColor),
                  decoration: InputDecoration(
                      hintText: "Full Name",
                      border: const OutlineInputBorder(borderSide: BorderSide.none),
                      hintStyle: TextStyle(color: notifier.textFieldHintText)),
                ),
              ),
              // CommonTextfield(text: "Full name", textcolor: Color(0xff94A3B8)),
              AppConstants.Height(15),
              Container(
                height: height / 13,
                decoration: BoxDecoration(
                    color: notifier.textField,
                    borderRadius: BorderRadius.circular(15)),
                child: TextField(
                  controller: _emailCtrl,
                  style: TextStyle(color: notifier.textColor),
                  decoration: InputDecoration(
                      hintText: "Email",
                      border: const OutlineInputBorder(borderSide: BorderSide.none),
                      hintStyle: TextStyle(color: notifier.textFieldHintText)),
                ),
              ),
              AppConstants.Height(15),
              Container(
                height: height / 13,
                decoration: BoxDecoration(
                    color: notifier.textField,
                    borderRadius: BorderRadius.circular(15)),
                child: TextField(
                  controller: _phoneCtrl,
                  style: TextStyle(color: notifier.textColor),
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      hintText: "Mobile number",
                      border: const OutlineInputBorder(borderSide: BorderSide.none),
                      hintStyle: TextStyle(color: notifier.textFieldHintText)),
                ),
              ),
              AppConstants.Height(15),
              Container(
                height: height / 13,
                decoration: BoxDecoration(
                    color: notifier.textField,
                    borderRadius: BorderRadius.circular(15)),
                child: TextField(
                  controller: _passwordCtrl,
                  style: TextStyle(color: notifier.textColor),
                  obscureText: _obsecuretext1,
                  decoration: InputDecoration(
                    hintText: "Password",
                    border: const OutlineInputBorder(borderSide: BorderSide.none),
                    hintStyle: TextStyle(color: notifier.textFieldHintText),
                    suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _obsecuretext1 = !_obsecuretext1;
                          });
                        },
                        icon: _obsecuretext1
                            ? const Icon(Icons.remove_red_eye_outlined)
                            : Icon(
                                Icons.visibility_off_outlined,
                                color: notifier.passwordIcon,
                              )),
                  ),
                ),
              ),
              AppConstants.Height(15),
              Container(
                height: height / 13,
                decoration: BoxDecoration(
                    color: notifier.textField,
                    borderRadius: BorderRadius.circular(15)),
                child: TextField(
                  controller: _confirmCtrl,
                  style: TextStyle(color: notifier.textColor),
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: "Confirm Password",
                    border: const OutlineInputBorder(borderSide: BorderSide.none),
                    hintStyle: TextStyle(color: notifier.textFieldHintText),
                  ),
                ),
              ),
              AppConstants.Height(15),
              Container(
                height: height / 13,
                decoration: BoxDecoration(
                    color: notifier.textField,
                    borderRadius: BorderRadius.circular(15)),
                child: TextField(
                  controller: _referralCtrl,
                  style: TextStyle(color: notifier.textColor),
                  decoration: InputDecoration(
                    hintText: "Referral Code (optional)",
                    border: const OutlineInputBorder(borderSide: BorderSide.none),
                    hintStyle: TextStyle(color: notifier.textFieldHintText),
                  ),
                ),
              ),
              AppConstants.Height(20),
              GestureDetector(
                onTap: _submitting ? null : _submitSignup,
                child: Container(
                  height: height / 12,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: const Color(0xFF8B0000),
                  ),
                  child: Center(
                      child: _submitting
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : const Text(
                              "Sign Up",
                              style: TextStyle(
                                  color: Color(0xffFFFFFF),
                                  fontSize: 15,
                                  fontFamily: "Manrope-Bold"),
                            )),
                ),
              ),
              AppConstants.Height(10),
              Row(
                children: [
                  Checkbox(
                    side: const BorderSide(color: Color(0xff334155)),
                    activeColor: const Color(0xFF8B0000),
                    checkColor: const Color(0xffFFFFFF),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                    value: value,
                    onChanged: (value) {
                      setState(() {
                        this.value = value!;
                      });
                    },
                  ),
                  Flexible(
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: 12,
                          fontFamily: "Manrope-Medium",
                          color: notifier.textColor,
                        ),
                        children: [
                          const TextSpan(
                            text:
                                "I confirm that I am 18 years or older and agree to the ",
                          ),
                          TextSpan(
                            text: "Terms of Use",
                            style: const TextStyle(
                              color: Color(0xFF8B0000),
                              decoration: TextDecoration.underline,
                            ),
                            recognizer: _termsRecognizer,
                          ),
                          const TextSpan(text: " and "),
                          TextSpan(
                            text: "Privacy Policy",
                            style: const TextStyle(
                              color: Color(0xFF8B0000),
                              decoration: TextDecoration.underline,
                            ),
                            recognizer: _privacyRecognizer,
                          ),
                          const TextSpan(text: "."),
                        ],
                      ),
                    ),
                  ),
                  // Duplicate 18+ consent removed
                ],
              ),
              AppConstants.Height(15),
              const Center(
                child: Text(
                  "--------------- Or sign in with ---------------",
                  style: TextStyle(
                      fontSize: 15,
                      color: Color(0xff64748B),
                      fontFamily: "Manrope-Medium"),
                ),
              ),
              AppConstants.Height(10),
              // Social signup buttons (Apple/Google) removed
              AppConstants.Height(20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Already have an account?",
                    style: TextStyle(
                        fontFamily: "Manrope-Medium", color: Color(0xff64748B)),
                  ),
                  GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Login(),
                            ));
                      },
                      child: const Text(
                        "Sign In",
                        style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF8B0000),
                            fontFamily: "Manrope-Medium"),
                      ))
                ],
              ),
              const SizedBox(
                height: 20,
              )
            ],
          ),
        ),
      ),
    );
  }
}

extension on _SignState {
  String? _validate() {
    final name = _nameCtrl.text.trim();
    final email = _emailCtrl.text.trim();
    final phone = _phoneCtrl.text.trim();
    final password = _passwordCtrl.text;
    final confirm = _confirmCtrl.text;

    if (name.length < 2 || name.length > 100) {
      return 'Name must be 2â€“100 characters';
    }
    final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!emailRegex.hasMatch(email)) {
      return 'Enter a valid email address';
    }
    if (phone.isNotEmpty) {
      final onlyDigits = RegExp(r'^\d{10}$');
      final withCode = RegExp(r'^\+91\d{10}$');
      if (!onlyDigits.hasMatch(phone) && !withCode.hasMatch(phone)) {
        return 'Enter a valid 10-digit Indian mobile (or +91XXXXXXXXXX)';
      }
    }
    if (password.length < 8 || password.length > 128) {
      return 'Password must be 8â€“128 characters';
    }
    if (password != confirm) {
      return 'Passwords do not match';
    }
    if (!value) {
      return 'Please agree to the terms to continue';
    }
    return null;
  }

  Future<void> _submitSignup() async {
    final error = _validate();
    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error)),
      );
      return;
    }

    setState(() => _submitting = true);
    try {
      final auth = await AuthApi.signup(
        name: _nameCtrl.text.trim(),
        email: _emailCtrl.text.trim(),
        password: _passwordCtrl.text,
        confirmPassword: _confirmCtrl.text,
        phone: _phoneCtrl.text.trim().isEmpty ? null : _phoneCtrl.text.trim(),
        referralCode: _referralCtrl.text.trim().isEmpty ? null : _referralCtrl.text.trim(),
      );
      await TokenStorage.saveAuth(auth);
      // Also persist to secure storage for Dio client
      await ApiLocator.tokenStore.save(auth.token, auth.refreshToken);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Signup successful')), 
      );

      // After signup, go to Sign In (OTP/PIN screens removed)
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const Login()),
        (route) => false,
      );
    } catch (e) {
      final msg = e.toString().replaceFirst('Exception: ', '');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(msg)),
      );
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }
}

