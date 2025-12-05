import 'package:juststock/config/common.dart';
import 'package:juststock/services/api_locator.dart';
import 'package:juststock/Home/bottom.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Dark mode.dart';
import 'onboarding_1.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    init();
    super.initState();
  }

  init() {
    Future.microtask(() async {
      // Give the app a brief moment to settle
      await Future.delayed(const Duration(milliseconds: 400));
      try {
        // If user/me works, go to app; else fall back to onboarding
        await ApiLocator.user.me();
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const BottomBarScreen()),
        );
      } catch (_) {
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Onboard1()),
        );
      }
    });
  }

  ColorNotifire notifier = ColorNotifire();

  @override
  Widget build(BuildContext context) {
    notifier = Provider.of<ColorNotifire>(context, listen: true);
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: notifier.background,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'lib/assets/inside-logo.png',
                width: width * 0.55,
                fit: BoxFit.contain,
              ),
              AppConstants.Height(12),
              Text(
                "JustStock Education",
                style: TextStyle(
                  color: notifier.textColor,
                  fontSize: 22,
                  fontFamily: "Manrope-Bold",
                ),
              ),
              AppConstants.Height(6),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  "Learn stocks, options and more with concise lessons and actionable insights.",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Color(0xFF64748B)),
                ),
              )
            ],
          )
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: notifier.background,
        elevation: 0,
        height: 75,
        child: Center(
          child: Column(
            children: [
              Text(
                "Your companion for learning markets",
                style: TextStyle(
                  fontSize: 15,
                  fontFamily: "Manrope-Bold",
                  color: notifier.textColor,
                  wordSpacing: 5,
                ),
              ),
              AppConstants.Height(5),
              const Text(
                "Version 0.0.1",
                style: TextStyle(
                  color: Color(0xffD1D1D1),
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  fontFamily: "Manrope_semibold",
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
