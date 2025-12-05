// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Dark mode.dart';
import '../config/common.dart';
import '../Home/bottom.dart';
import 'Login.dart';

class KYCSLides extends StatefulWidget {
  const KYCSLides({super.key});

  @override
  State<KYCSLides> createState() => _KYCSLidesState();
}

class _KYCSLidesState extends State<KYCSLides> {
  ColorNotifire notifier = ColorNotifire();

  void _accept() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const BottomBarScreen()),
    );
  }

  void _exit() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const Login()),
      (route) => false,
    );
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AppConstants.Height(10),
              Container(
                margin: const EdgeInsets.only(top: 8),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: notifier.textField,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: notifier.getContainerBorder ?? const Color(0xFFE2E8F0)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Disclaimer',
                        style: TextStyle(
                            fontSize: 22,
                            fontFamily: 'Manrope-Bold',
                            color: notifier.textColor)),
                    const SizedBox(height: 12),
                    const _Bullet(
                        'We are not SEBI registered, investment advisor, financial advisor, or any license required financial institution.'),
                    const SizedBox(height: 10),
                    const _Bullet(
                        'Any available service, including but not limited to the compliance status and screening of stocks, is purely for information and educational purposes only.'),
                    const SizedBox(height: 10),
                    const _Bullet(
                        'We do not undertake any liability for damage, cost, harm, or loss caused in connection with the information available in the app, website, or blogs.'),
                    const SizedBox(height: 10),
                    const _Bullet(
                        'Be aware of the risks involved in trading in financial markets. Consult a qualified financial advisor before making any investment or financial decision.'),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF8B0000),
                              minimumSize: const Size.fromHeight(48),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                            ),
                            onPressed: _accept,
                            child: const Text('Accept', style: TextStyle(color: Colors.white)),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        minimumSize: const Size.fromHeight(48),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      onPressed: _exit,
                      child: const Text('Exit', style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

}

class _Bullet extends StatelessWidget {
  final String text;
  const _Bullet(this.text);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 6),
          child: Icon(Icons.circle, size: 10, color: Color(0xFFFFB100)),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(color: Color(0xFF334155), fontSize: 14),
          ),
        ),
      ],
    );
  }
}



