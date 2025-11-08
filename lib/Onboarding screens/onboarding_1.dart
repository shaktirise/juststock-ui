import 'package:crowwn/Onboarding%20screens/splash_screen.dart';
import 'package:crowwn/config/common.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Dark mode.dart';
import 'Get started.dart';

class Onboard1 extends StatefulWidget {
  const Onboard1({super.key});

  @override
  State<Onboard1> createState() => _Onboard1State();
}

class _Onboard1State extends State<Onboard1> {
  ColorNotifire notifier = ColorNotifire();
  late final PageController _page;

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

  @override
  Widget build(BuildContext context) {
    notifier = Provider.of<ColorNotifire>(context, listen: true);

    return Scaffold(
      backgroundColor: notifier.background,
      appBar: AppBar(
        actions: [
          Center(
            child: OutlinedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Get1(),
                  ),
                );
              },
              style: ButtonStyle(
                side: MaterialStatePropertyAll(
                  BorderSide(color: notifier.outlinedButtonColor),
                ),
              ),
              child: Text(
                "Skip",
                style: TextStyle(
                  fontSize: 17,
                  color: notifier.outlinedButtonColor,
                ),
              ),
            ),
          ),
          const SizedBox(
            width: 15,
          ),
        ],
        backgroundColor: notifier.onboardBackgroundColor,
        elevation: 0,
      ),
      body: PageView(
        controller: _page,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Container(
                  alignment: Alignment.center,
                  height: MediaQuery.of(context).size.height / 2,
                  width: double.infinity,
                  color: notifier.onboardBackgroundColor,
                  child: Image.asset(
                    "assets/images/card_1.png",
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              // Switch(
              //   value: notifier.isDark,
              //   onChanged: (bool value) {
              //     notifier.isavalable(value);
              //   },
              // ),
              AppConstants.Height(10),
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Learn Stock Market the Right Way",
                      style: TextStyle(
                          fontSize: 24,
                          // wordSpacing: 5,
                          fontFamily: "Manrope-Bold",
                          color: notifier.textColor),
                      textAlign: TextAlign.center,
                    ),
                    AppConstants.Height(10),
                    const Text(
                      "Short, simple lessons designed for beginners and intermediates.",
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xff64748B),
                        fontFamily: "Manrope-Medium",
                      ),
                      textAlign: TextAlign.center,
                    ),
                    AppConstants.Height(15),
                    GestureDetector(
                      onTap: () {
                        _page.nextPage(
                            duration: const Duration(milliseconds: 250),
                            curve: Curves.easeInOut);
                      },
                      child: Container(
                        height: 60,
                        // width: 350,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: const Color(0xFF8B0000)),
                        child: const Center(
                          child: Text(
                            "Next",
                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: "Manrope-SemiBold",
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    AppConstants.Height(20),
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Splash(),
                            ),
                          );
                        },
                        child: const SizedBox(
                          height: 60,
                          width: double.infinity,
                          child: Center(
                            child: Text(
                              "",
                              style: TextStyle(
                                color: Color(0xFF8B0000),
                                fontSize: 16,
                                fontFamily: "Manrope-Bold",
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    // AppConstants.Height(30),
                  ],
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Container(
                  alignment: Alignment.center,
                  height: MediaQuery.of(context).size.height / 2.8,
                  width: double.infinity,
                  color: notifier.onboardBackgroundColor,
                  child: Image.asset(
                    "assets/images/card_2.png",
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              AppConstants.Height(20),
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Real Market Concepts Made Easy",
                      style: TextStyle(
                        fontSize: 24,
                        fontFamily: "Manrope-Bold",
                        color: notifier.textColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    AppConstants.Height(10),
                    const Text(
                      "Candlesticks, trends, indicators, charts explained in plain language.",
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xff64748B),
                        fontFamily: "Manrope-Medium",
                      ),
                      textAlign: TextAlign.center,
                    ),
                    AppConstants.Height(10),
                    GestureDetector(
                      onTap: () {
                        _page.nextPage(
                            duration: const Duration(milliseconds: 250),
                            curve: Curves.easeInOut);
                      },
                      child: Center(
                        child: Container(
                          height: 60,
                          // width: 350,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: const Color(0xFF8B0000),
                          ),
                          child: const Center(
                            child: Text(
                              "Next",
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: "Manrope-SemiBold",
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    AppConstants.Height(20),
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Splash(),
                            ),
                          );
                        },
                        child: const SizedBox(
                          height: 60,
                          width: double.infinity,
                          child: Center(
                            child: Text(
                              "",
                              style: TextStyle(
                                color: Color(0xFF8B0000),
                                fontSize: 16,
                                fontFamily: "Manrope-Bold",
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              // AppConstants.Height(30),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Container(
                  height: MediaQuery.of(context).size.height / 2.8,
                  alignment: Alignment.center,
                  width: double.infinity,
                  color: notifier.onboardBackgroundColor,
                  child: Image.asset(
                    "assets/images/card_3.png",
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              AppConstants.Height(20),
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Daily Market Insights",
                      style: TextStyle(
                        fontSize: 24,
                        // wordSpacing: 5,
                        fontFamily: "Manrope-Bold",
                        color: notifier.textColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    AppConstants.Height(10),
                    const Text(
                      "Get simplified updates, analysis, and educational content every day.",
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xff64748B),
                        fontFamily: "Manrope-Medium",
                      ),
                      textAlign: TextAlign.center,
                    ),
                    AppConstants.Height(10),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Get1(),
                          ),
                        );
                      },
                      child: Container(
                        height: 60,
                        // width: 350,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          color: const Color(0xFF8B0000),
                        ),
                        child: const Center(
                          child: Text(
                            "Get Started",
                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: "Manrope-SemiBold",
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    AppConstants.Height(20),
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Splash(),
                            ),
                          );
                        },
                        child: const SizedBox(
                          height: 60,
                          width: double.infinity,
                          child: Center(
                            child: Text(
                              "",
                              style: TextStyle(
                                color: Color(0xFF8B0000),
                                fontSize: 16,
                                fontFamily: "Manrope-Bold",
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    // AppConstants.Height(30),
                  ],
                ),
              ),
            ],
          ),
          Column(
            children: [
              Expanded(
                child: Container(
                  alignment: Alignment.center,
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height / 2.8,
                  color: notifier.onboardBackgroundColor,
                  child: Image.asset(
                    "assets/images/card_4.png",
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              AppConstants.Height(20),
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Enter for a Chance to Win You Share 1M Assets",
                      style: TextStyle(
                        fontSize: 24,
                        color: notifier.textColor,
                        // wordSpacing: 5,
                        fontFamily: "Manrope-SemiBold",
                      ),
                    ),
                    AppConstants.Height(10),
                    const Text(
                      "Each time the friends you invite buy or sells, you get a 0.020%. Commission is calculated from the value of buy or sell purchase.",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                        fontFamily: "Manrope-Medium",
                      ),
                    ),
                    AppConstants.Height(10),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Get1(),
                          ),
                        );
                      },
                      child: Container(
                        height: 60,
                        // width: 350,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          color: const Color(0xFF8B0000),
                        ),
                        child: const Center(
                          child: Text(
                            "Get Started",
                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: "Manrope-SemiBold",
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    AppConstants.Height(20),
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Splash(),
                            ),
                          );
                        },
                        child: const SizedBox(
                          height: 60,
                          width: double.infinity,
                          child: Center(
                            child: Text(
                              "",
                              style: TextStyle(
                                color: Color(0xFF8B0000),
                                fontSize: 16,
                                fontFamily: "Manrope-Bold",
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    // AppConstants.Height(30),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
