
// ignore_for_file: file_names, camel_case_types

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:juststock/config/common.dart';

import '../Dark mode.dart';


class About_App extends StatefulWidget {
  const About_App({super.key});

  @override   
  State<About_App> createState() => _About_AppState();
}

class _About_AppState extends State<About_App> {
  ColorNotifire notifier = ColorNotifire();
  @override
  Widget build(BuildContext context) {
    notifier = Provider.of<ColorNotifire>(context, listen: true);
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: notifier.background,
      appBar: AppBar(
        backgroundColor: notifier.background,
        elevation: 0,
        leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Image.asset("assets/images/arrow-narrow-left (1).png",scale: 3,color: notifier.textColor,)),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Image.asset('lib/assets/inside-logo.png', width: width * 0.55, fit: BoxFit.contain),
                  ),
                  AppConstants.Height(16),
                  Text(
                    "JustStock Education",
                    style: TextStyle(
                        fontSize: 24,
                        color: notifier.textColor,
                        fontFamily: "Manrope-Bold"),
                  ),
                  AppConstants.Height(8),
                  const Text(
                    "JustStock Education helps you learn markets the simple way — covering stocks, options, futures and more with practical tips and community-backed insights.",
                    style: TextStyle(
                        color: Color(0xff64748B),
                        fontSize: 16,
                        fontFamily: "Manrope-Regular"),
                  ),
                ],
              ),
            ),
            AppConstants.Height(30),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "About JustStock",
                    style: TextStyle(
                        fontSize: 18,
                        color: notifier.textColor,
                        fontFamily: "Manrope-Bold"),
                  ),
                  AppConstants.Height(10),
                  const Text(
                    "We provide educational content and tools designed to guide you on your trading and investing journey. Our mission is to make market education accessible, practical and community-driven.",
                    style: TextStyle(
                        color: Color(0xff64748B),
                        fontSize: 16,
                        fontFamily: "Manrope-Regular"),
                  ),
                  AppConstants.Height(5),
                  const Text(
                    "Disclaimer: JustStock offers educational material and does not provide financial advice. Always do your own research before making investment decisions.",
                    style: TextStyle(
                        color: Color(0xff64748B),
                        fontSize: 16,
                        fontFamily: "Manrope-Regular"),
                  ),
                  AppConstants.Height(30),
                  Text(
                    "Contact Us",
                    style: TextStyle(
                        fontSize: 18,
                        color: notifier.textColor,
                        fontFamily: "Manrope-Bold"),
                  ),
                  AppConstants.Height(10),
                  const Text(
                    "Email: [your email]",
                    style: TextStyle(
                        color: Color(0xff64748B),
                        fontSize: 16,
                        fontFamily: "Manrope-Regular"),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    "Website: https://juststock.in",
                    style: TextStyle(
                        color: Color(0xff64748B),
                        fontSize: 16,
                        fontFamily: "Manrope-Regular"),
                  ),
                  AppConstants.Height(20),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
