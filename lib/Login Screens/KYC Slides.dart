// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Dark mode.dart';
import '../config/common.dart';
import '../Home/bottom.dart';

class KYCSLides extends StatefulWidget {
  const KYCSLides({super.key});

  @override
  State<KYCSLides> createState() => _KYCSLidesState();
}

class _KYCSLidesState extends State<KYCSLides> {
  late final PageController _page;
  ColorNotifire notifier = ColorNotifire();
  int _index = 0;

  @override
  void initState() {
    super.initState();
    _page = PageController();
  }

  @override
  void dispose() {
    _page.dispose();
    super.dispose();
  }

  void _next() {
    if (_index < 1) {
      _page.nextPage(duration: const Duration(milliseconds: 250), curve: Curves.easeInOut);
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const BottomBarScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    notifier = Provider.of<ColorNotifire>(context, listen: true);
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: notifier.background,
      appBar: AppBar(
        backgroundColor: notifier.background,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: notifier.textColor),
          onPressed: () => Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const BottomBarScreen()),
          ),
        ),
      ),
      body: Column(
        children: [
          AppConstants.Height(10),
          LinearProgressIndicator(
            value: (_index + 1) / 2,
            color: const Color(0xFF8B0000),
            backgroundColor: notifier.linerIndicator,
          ),
          Expanded(
            child: PageView(
              controller: _page,
              onPageChanged: (i) => setState(() => _index = i),
              children: [
                _slide(
                  context,
                  height: height,
                  image: 'assets/new/kyc.jpg',
                  title: 'Compliance Made Simple',
                  subtitle: 'Your identity verification helps us maintain a secure and compliant platform.',
                ),
                _slide(
                  context,
                  height: height,
                  image: 'assets/new/Secure Your Account WITH DETAILS.jpg',
                  title: 'Quick, Safe & Hassle-Free',
                  subtitle: 'Just upload your ID and a selfie — verification takes only a few minutes.',
                ),
              ],
            ),
          ),
          SafeArea(
            minimum: const EdgeInsets.fromLTRB(16, 0, 16, 40),
            child: SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8B0000),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: _next,
                child: Text(_index == 1 ? 'Get Started' : 'Next',
                    style: const TextStyle(color: Colors.white, fontFamily: 'Manrope-Bold')),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _slide(BuildContext context,
      {required double height,
      required String image,
      required String title,
      required String subtitle}) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AppConstants.Height(40),
            Center(
              child: Image.asset(
                image,
                height: height / 3.6,
                fit: BoxFit.contain,
              ),
            ),
            AppConstants.Height(20),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontFamily: 'Manrope-Bold',
                color: notifier.textColor,
              ),
            ),
            AppConstants.Height(10),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xff64748B),
                fontFamily: 'Manrope-Regular',
              ),
            ),
          ],
        ),
      ),
    );
  }
}



