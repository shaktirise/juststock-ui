// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:crowwn/api/auth_api.dart';
import 'package:crowwn/api/token_storage.dart';
import '../Dark mode.dart';
import '../config/common.dart';
import 'Login.dart';
import 'Sign phone.dart';
import 'package:crowwn/services/api_locator.dart';


class Sign extends StatefulWidget {
  const Sign({super.key});

  @override
  State<Sign> createState() => _SignState();
}

class _SignState extends State<Sign> {
  bool value = false;
  bool _obsecuretext1 = true;
  ColorNotifire notifier = ColorNotifire();
  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _passwordCtrl = TextEditingController();
  final TextEditingController _confirmCtrl = TextEditingController();
  final TextEditingController _referralCtrl = TextEditingController();
  bool _submitting = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
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
                "Let’s get started with a free Financy account.",
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
                    activeColor: const Color(0xff6B39F4),
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
                    child: Text(
                      "I certify that I’m 18 years of age or older, and I \n agree to the User Agreement and Privacy Policy.",
                      style: TextStyle(
                          fontSize: 12,
                          fontFamily: "Manrope-Medium",
                          color: notifier.textColor),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ),
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
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: 155,
                      height: 56,
                      child: OutlinedButton(
                          style: ButtonStyle(
                              shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(13),
                                ),
                              ),
                              side: MaterialStatePropertyAll(BorderSide(
                                  color: notifier.getContainerBorder))),
                          onPressed: () {},
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                "assets/images/apple-logo.png",
                                height: 19,
                                width: 16,
                                color: notifier.isDark ? Colors.white : null,
                              ),
                              Text(
                                " Apple",
                                style: TextStyle(
                                    color: notifier.isDark
                                        ? Colors.white
                                        : Colors.black,
                                    fontFamily: "Manrope-SemiBold",
                                    fontSize: 16),
                              )
                            ],
                          )),
                    ),
                  ),
                  Expanded(child: AppConstants.Width(50)),
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: SizedBox(
                      width: 155,
                      height: 56,
                      child: OutlinedButton(
                          style: ButtonStyle(
                              shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(13),
                                ),
                              ),
                              side: MaterialStatePropertyAll(BorderSide(
                                  color: notifier.getContainerBorder))),
                          onPressed: () {},
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Image(
                                image: AssetImage("assets/images/google.png"),
                                height: 19,
                                width: 16,
                              ),
                              Text(
                                " Google",
                                style: TextStyle(
                                    color: notifier.isDark
                                        ? Colors.white
                                        : Colors.black,
                                    fontFamily: "Manrop-SemiBold",
                                    fontSize: 16),
                              )
                            ],
                          )),
                    ),
                  ),
                ],
              ),
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
                            color: Color(0xff6B39F4),
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
    final password = _passwordCtrl.text;
    final confirm = _confirmCtrl.text;

    if (name.length < 2 || name.length > 100) {
      return 'Name must be 2–100 characters';
    }
    final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!emailRegex.hasMatch(email)) {
      return 'Enter a valid email address';
    }
    if (password.length < 8 || password.length > 128) {
      return 'Password must be 8–128 characters';
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
        referralCode: _referralCtrl.text.trim().isEmpty ? null : _referralCtrl.text.trim(),
      );
      await TokenStorage.saveAuth(auth);
      // Also persist to secure storage for Dio client
      await ApiLocator.tokenStore.save(auth.token, auth.refreshToken);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Signup successful')), 
      );

      // Continue existing flow
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const phone()),
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
