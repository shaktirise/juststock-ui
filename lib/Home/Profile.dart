// ignore_for_file: file_names
// import 'package:Crowwn/Home/bottom.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Account&setting/About App.dart';
import '../Account&setting/Bank Account.dart';
import '../Account&setting/Help Center.dart';
import '../Account&setting/Personal data.dart';
import '../Account&setting/Privacy&Policy.dart';
import '../Account&setting/Refferal Code.dart';
import '../Account&setting/Select Language.dart';
import '../Account&setting/Social Media Link.dart';
import '../Account&setting/Terms&conditions.dart';
import '../Activity&History/Transaction History.dart';
import '../Dark mode.dart';
import '../Message & Notification/Notifications.dart';
import '../config/common.dart';
import 'bottom.dart';
import 'package:crowwn/services/api_locator.dart';
import 'package:crowwn/Login Screens/Login.dart';
import 'package:crowwn/Account&setting/Referrals.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  ColorNotifire notifier = ColorNotifire();
  Map<String, dynamic>? _me;
  bool _loadingMe = false;

  @override
  void initState() {
    super.initState();
    _fetchMe();
  }

  Future<void> _onLogout() async {
    try {
      await ApiLocator.auth.logout();
      if (!mounted) return;
      // Navigate to Sign In and clear history so back can't reach protected routes
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const Login()),
        (route) => false,
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Logout failed: $e')),
      );
    }
  }

  Future<void> _fetchMe() async {
    setState(() => _loadingMe = true);
    try {
      final me = await ApiLocator.user.me();
      setState(() => _me = me);
    } catch (_) {}
    setState(() => _loadingMe = false);
  }

  @override
  Widget build(BuildContext context) {
    notifier = Provider.of<ColorNotifire>(context, listen: true);
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: notifier.background,
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const BottomBarScreen(),
              ),
            );
          },
          child: Image.asset(
            "assets/images/arrow-narrow-left (1).png",
            scale: 3,
            color: const Color(0xFF0F172A),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Color(0xFF0F172A)),
            onPressed: _onLogout,
          ),
          const SizedBox(width: 10),
        ],
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: height / 2.7,
              width: double.infinity,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/Background (2).png"),
                  fit: BoxFit.cover,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 20, top: 40, right: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppConstants.Height(30),
                    Center(
                      child: Container(
                        height: height / 7,
                        width: width / 3,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: AssetImage("assets/images/Krishna.jpg"),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    AppConstants.Height(20),
                    Center(
                      child: _loadingMe
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : Text(
                              (_me?['name'] ?? 'Your Name').toString(),
                              style: const TextStyle(
                                fontFamily: "Manrope-Bold",
                                color: Color(0xffFFFFFF),
                                fontSize: 20,
                              ),
                            ),
                    ),
                    AppConstants.Height(5),
                    Center(
                      child: Text(
                        (_me?['email'] ?? '').toString(),
                        style: const TextStyle(
                          fontFamily: "Manrope-Regular",
                          color: Color(0xffFFFFFF),
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            AppConstants.Height(20),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Quick entry to Referrals
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ReferralsPage(),
                        ),
                      );
                    },
                    child: accountDetails(
                      image: "assets/images/card.png",
                      name: "Referrals",
                      desc: "Tree, earnings and MLM details",
                      onPress: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ReferralsPage(),
                          ),
                        );
                      },
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Reffle_code(),
                        ),
                      );
                    },
                    child: Container(
                      height: 88,
                      decoration: BoxDecoration(
                        color: notifier.background,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: const Color(0xffFFFFFF),
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Text(
                                "Invite friends and earn referral rewards on activations and renewals.",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: "Manrope-Regular",
                                  color: notifier.textColor,
                                  wordSpacing: 2,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: width / 5,
                            height: height / 9,
                            child: FittedBox(
                              fit: BoxFit.contain,
                              child: Image.asset("assets/images/Gift_1.png"),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  AppConstants.Height(20),
                  const Text(
                    "Profile",
                    style: TextStyle(
                      fontSize: 13,
                      color: Color(0xff64748B),
                      fontFamily: "Manrope-Bold",
                    ),
                  ),
                  AppConstants.Height(10),
                  Text(
                    "Account Details",
                    style: TextStyle(
                      fontFamily: "Manrope-Bold",
                      color: notifier.textColor,
                      fontSize: 16,
                    ),
                  ),
                  AppConstants.Height(20),
                  // Temporarily disabled: Personal Details
                  GestureDetector(
                    onTap: () {},
                    child: accountDetails(
                      image: "assets/images/Person.png",
                      name: "Personal Details",
                      desc: "Your account information",
                      onPress: null,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: accountDetails(
                      image: "assets/images/Identycard_.png",
                      name: "Identify Verification",
                      desc: "Your verification status",
                      onPress: () {},
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Transaction(),
                        ),
                      );
                    },
                    child: accountDetails(
                      image: "assets/images/receipt.png",
                      name: "Transaction History",
                      desc: "Your transaction details",
                      onPress: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Transaction(),
                          ),
                        );
                      },
                    ),
                  ),
                  // Temporarily disabled: Bank Account
                  GestureDetector(
                    onTap: () {},
                    child: accountDetails(
                      image: "assets/images/card.png",
                      name: "Bank Account",
                      desc: "Manage your bank account",
                      onPress: null,
                    ),
                  ),
                  Text(
                    "Features",
                    style: TextStyle(
                      color: notifier.textColor,
                      fontSize: 16,
                      fontFamily: "Manrope-Bold",
                    ),
                  ),
                  AppConstants.Height(20),
                  GestureDetector(
                    onTap: () {},
                    child: accountDetails_(
                      image: "assets/images/gift.png",
                      name: "Mission",
                      desc: "Get more rewards",
                      onPress: () {},
                    ),
                  ),
                  // Removed: Auto Invest
                  // Temporarily disabled: Social Media
                  // Removed: Social Media
                  AppConstants.Height(20),
                  Text(
                    "Settings",
                    style: TextStyle(
                        fontFamily: "Manrope-Bold",
                        color: notifier.textColor,
                        fontSize: 16),
                  ),
                  AppConstants.Height(20),
                  GestureDetector(
                    onTap: () {},
                    child: accountDetails(
                      image: "assets/images/Privacy.png",
                      name: "Privacy & Security",
                      desc: "PIN & Biometric protection",
                      onPress: () {},
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      // Route to the same Notifications page as the Home bell icon
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Notifications(),
                        ),
                      );
                    },
                    child: accountDetails(
                      image: "assets/images/notification.png",
                      name: "Push Notifications",
                      desc: "Notification preferences",
                      onPress: () {
                        // Keep behavior consistent if inner onPress is used
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Notifications(),
                          ),
                        );
                      },
                    ),
                  ),
                  // Removed: Language
                  Container(
                    height: 75,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: notifier.getContainerBorder),),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: Row(
                        children: [
                          Container(
                              alignment: Alignment.center,
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(25),
                                  color: notifier.tabBar1,),
                              child: Image.asset(
                                "assets/images/light dark mode.png",
                                scale: 20,
                                color: notifier.passwordIcon,
                              )),
                          const SizedBox(width: 20),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AppConstants.Height(20),
                              Text(
                                "Light/Dark Mode",
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontFamily: "Manrope_bold",
                                  fontSize: 14,
                                  color: notifier.textColor,
                                ),
                              ),
                              const SizedBox(height: 7),
                              const Text(
                                "Mode",
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontFamily: "Manrope_bold",
                                  fontSize: 12,
                                  letterSpacing: 0.2,
                                  color: Color(0xff64748B),
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          Switch(
                            value: notifier.isDark,
                            onChanged: (bool value) {
                              notifier.isavalable(value);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  AppConstants.Height(20),
                  Text(
                    "Others",
                    style: TextStyle(
                        fontFamily: "Manrope-Bold",
                        color: notifier.textColor,
                        fontSize: 16),
                  ),
                  AppConstants.Height(20),
                  // Removed: Help Center
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Terms(),
                          ));
                    },
                    child: accountDetails(
                      image: "assets/images/Terms&condition.png",
                      name: "Terms & Conditions",
                      desc: "Our terms & conditions",
                      onPress: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Terms(),
                            ));
                      },
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Policy(),
                          ));
                    },
                    child: accountDetails(
                      image: "assets/images/Lock.png",
                      name: "Privacy Policy",
                      desc: "Our privacy policy",
                      onPress: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Policy(),
                            ));
                      },
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Reffle_code(),
                          ));
                    },
                    child: accountDetails(
                      image: "assets/images/card.png",
                      name: "Refferal Code",
                      desc: "Refferal Program",
                      onPress: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Reffle_code(),
                            ));
                      },
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const About_App(),
                          ));
                    },
                    child: accountDetails2(
                      image: 'lib/assets/inside-logo.png',
                      name: "About JustStock",
                      desc: "About Us",
                      onPress: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const About_App(),
                            ));
                      },
                    ),
                  ),
                  GestureDetector(
                    onTap: _onLogout,
                    child: accountDetails3(
                      image: "assets/images/logout.png",
                      name: "Logout",
                      desc: "Sign out of your account",
                      onPress: _onLogout,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget accountDetails(
      {required String image,
      required String name,
      required String desc,
      required void Function()? onPress}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Container(
        height: 75,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: notifier.getContainerBorder)),
        child: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: Row(
            children: [
              Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: notifier.tabBar1),
                  child: Image.asset(
                    image,
                    scale: 3,
                    color: notifier.passwordIcon,
                  )),
              const SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppConstants.Height(20),
                  Text(
                    name,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontFamily: "Manrope_bold",
                      fontSize: 14,
                      color: notifier.textColor,
                    ),
                  ),
                  const SizedBox(height: 7),
                  Text(
                    desc,
                    style: const TextStyle(
                      fontWeight: FontWeight.w400,
                      fontFamily: "Manrope_bold",
                      fontSize: 12,
                      letterSpacing: 0.2,
                      color: Color(0xff64748B),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              IconButton(
                onPressed: onPress,
                icon: Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: notifier.tabBarText2,
                  size: 18,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget accountDetails_(
      {required String image,
      required String name,
      required String desc,
      required void Function()? onPress}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Container(
        height: 75,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: notifier.getContainerBorder)),
        child: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: Row(
            children: [
              Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: notifier.tabBar1),
                  child: Image.asset(
                    image,
                    scale: 3,
                    color: notifier.passwordIcon,
                  )),
              const SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppConstants.Height(20),
                  Text(
                    name,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontFamily: "Manrope_bold",
                      fontSize: 14,
                      color: notifier.textColor,
                    ),
                  ),
                  const SizedBox(height: 7),
                  Text(
                    desc,
                    style: const TextStyle(
                      fontWeight: FontWeight.w400,
                      fontFamily: "Manrope_bold",
                      fontSize: 12,
                      letterSpacing: 0.2,
                      color: Color(0xff64748B),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              IconButton(
                onPressed: onPress,
                icon: Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: notifier.tabBarText2,
                  size: 18,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget accountDetails1(
      {required String image,
      required String name,
      required String desc,
      required void Function()? onPress}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Container(
        height: 75,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: notifier.getContainerBorder)),
        child: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: Row(
            children: [
              Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: notifier.tabBar1),
                  child: Image.asset(
                    image,
                    scale: 3,
                    color: notifier.passwordIcon,
                  )),
              const SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppConstants.Height(20),
                  Text(
                    name,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontFamily: "Manrope_bold",
                      fontSize: 14,
                      color: notifier.textColor,
                    ),
                  ),
                  const SizedBox(height: 7),
                  Text(
                    desc,
                    style: const TextStyle(
                      fontWeight: FontWeight.w400,
                      fontFamily: "Manrope_bold",
                      fontSize: 12,
                      letterSpacing: 0.2,
                      color: Color(0xff64748B),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              SizedBox(
                height: 20,
                width: 20,
                child: Image.asset("assets/images/united-states.png"),
              ),
              IconButton(
                onPressed: onPress,
                icon: Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: notifier.tabBarText2,
                  size: 18,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget accountDetails2(
      {required String image,
      required String name,
      required String desc,
      required void Function()? onPress}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Container(
        height: 75,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: notifier.getContainerBorder)),
        child: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: Row(
            children: [
              Container(
                  alignment: Alignment.center,
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: notifier.tabBar1),
                  child: Image.asset(
                    image,
                    scale: 70,
                  )),
              const SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppConstants.Height(20),
                  Text(
                    name,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontFamily: "Manrope_bold",
                      fontSize: 14,
                      color: notifier.textColor,
                    ),
                  ),
                  const SizedBox(height: 7),
                  Text(
                    desc,
                    style: const TextStyle(
                      fontWeight: FontWeight.w400,
                      fontFamily: "Manrope_bold",
                      fontSize: 12,
                      letterSpacing: 0.2,
                      color: Color(0xff64748B),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              IconButton(
                onPressed: onPress,
                icon: Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: notifier.tabBarText2,
                  size: 18,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget accountDetails3(
      {required String image,
      required String name,
      required String desc,
      required void Function()? onPress}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Container(
        height: 75,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: notifier.getContainerBorder)),
        child: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: Row(
            children: [
              Container(
                  alignment: Alignment.center,
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: notifier.tabBar1),
                  child: Image.asset(
                    image,
                    scale: 20,
                    color: notifier.passwordIcon,
                  )),
              const SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppConstants.Height(20),
                  Text(
                    name,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontFamily: "Manrope_bold",
                      fontSize: 14,
                      color: notifier.textColor,
                    ),
                  ),
                  const SizedBox(height: 7),
                  Text(
                    desc,
                    style: const TextStyle(
                      fontWeight: FontWeight.w400,
                      fontFamily: "Manrope_bold",
                      fontSize: 12,
                      letterSpacing: 0.2,
                      color: Color(0xff64748B),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              IconButton(
                onPressed: onPress,
                icon: Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: notifier.tabBarText2,
                  size: 18,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
