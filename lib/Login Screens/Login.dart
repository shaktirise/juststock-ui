// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:juststock/api/auth_api.dart';
import 'package:juststock/api/token_storage.dart';
import '../Dark mode.dart';
import '../config/common.dart';
import 'Face id.dart';
import 'KYC Slides.dart';
import 'package:juststock/services/api_locator.dart';
import 'Forget pass.dart';
import 'Sign up.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool value = false;
  bool _obsecuretext = true;
  ColorNotifire notifier = ColorNotifire();
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _passwordCtrl = TextEditingController();
  bool _submitting = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    notifier = Provider.of<ColorNotifire>(context, listen: true);
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: notifier.background,
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Container(
                height: 279,
                width: 450,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('lib/assets/background.png'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 20,left: 10),

                          child:
                          GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Icon(Icons.close,color:notifier.textColor,size: 25,)),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Image.asset('lib/assets/inside-logo.png', height: height/6, fit: BoxFit.contain),
                    const Spacer(),
                    const Text('Welcome Back!',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontFamily: "Manrope-Bold")),
                    const Text('Sign in to your account',
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 18,
                            fontFamily: "Manrope-Medium")),
                    const SizedBox(
                      height: 20,
                    )
                  ],
                )),
            AppConstants.Height(10),
            Padding(
              padding: const EdgeInsets.only(left: 10,right: 10),
              child: Column(
                children: [
                  Container(
                    height: height/13,
                    decoration: BoxDecoration(color: notifier.textField,borderRadius: BorderRadius.circular(15)),
                    child: TextField(
                      controller: _emailCtrl,
                      style: TextStyle(color: notifier.textColor),
                      decoration: InputDecoration(hintText: "Email",border: const OutlineInputBorder(borderSide: BorderSide.none),hintStyle: TextStyle(color: notifier.textFieldHintText)),
                    ),
                  ),
                  AppConstants.Height(20),
                  Container(
                    height: height/13,
                    decoration: BoxDecoration(color: notifier.textField,borderRadius: BorderRadius.circular(15)),
                    child: TextField(
                      controller: _passwordCtrl,
                      style: TextStyle(color: notifier.textColor),
                      obscureText: _obsecuretext,
                      decoration: InputDecoration(hintText: "Password",border: const OutlineInputBorder(borderSide: BorderSide.none),hintStyle: TextStyle(color: notifier.textFieldHintText),suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _obsecuretext =! _obsecuretext;
                            });
                          },
                          icon: _obsecuretext?const Icon(Icons.remove_red_eye_outlined) : const Icon(Icons.visibility_off_outlined)
                      ),),
                    ),
                  ),
                  // AppConstants.Height(10),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Checkbox(
                          // checkColor: Colors.blue,
                           side: const BorderSide(color: Color(0xff334155)),
                          activeColor: const Color(0xFF8B0000),
                          checkColor: const Color(0xffFFFFFF),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),

                          value: value,
                          onChanged: (value) {
                            setState(() {
                              this.value = value!;
                            });
                          },
                        ),
                         Text("Remember me",
                            style: TextStyle(
                                fontSize: 14,
                                fontFamily: "Manrope-Medium",
                                color: notifier.textColor)),
                        Expanded(child: AppConstants.Width(60)),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const Forget(),));
                          },
                          child: const Text(
                            "Forgot Password?",
                            style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFF8B0000),
                                fontFamily: "Manrope-Bold"),
                          ),
                        )
                      ],
                    ),
                  ),
                  // AppConstants.Height(5),
                  GestureDetector(
                    onTap: _submitting ? null : _submitLogin,
                    child: Container(
                      height: height/12,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(15),color: const Color(0xFF8B0000),),
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
                            : const Text("Sign In",style: TextStyle(color: Color(0xffFFFFFF),fontSize: 15,fontFamily: "Manrope-Bold"),),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            AppConstants.Height(20),

          ],
        ),
      ),
    );
  }
}

extension on _LoginState {
  String? _validate() {
    final email = _emailCtrl.text.trim();
    final password = _passwordCtrl.text;
    final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!emailRegex.hasMatch(email)) {
      return 'Enter a valid email address';
    }
    if (password.isEmpty) {
      return 'Enter your password';
    }
    return null;
  }

  Future<void> _submitLogin() async {
    final error = _validate();
    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error)),
      );
      return;
    }

    setState(() => _submitting = true);
    try {
      final auth = await AuthApi.login(
        email: _emailCtrl.text.trim(),
        password: _passwordCtrl.text,
      );
      await TokenStorage.saveAuth(auth);
      // Also persist to secure storage for Dio client
      await ApiLocator.tokenStore.save(auth.token, auth.refreshToken);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login successful')),
      );

      // Show post-login KYC slides (2 screens) before actual home flow
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const KYCSLides()),
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
