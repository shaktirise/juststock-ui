// import 'package:juststock/Home/Market.dart';
import 'package:juststock/Home/classes.dart';
import 'package:juststock/Home/Portfolio.dart';
import 'package:juststock/Home/Profile.dart';
import 'package:juststock/Home/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Dark mode.dart';
import '../Wallet/My wallet.dart';

class BottomBarScreen extends StatefulWidget {
  const BottomBarScreen({super.key});

  @override
  State<BottomBarScreen> createState() => _BottomBarScreenState();
}

class _BottomBarScreenState extends State<BottomBarScreen> {
  // Fixed index mapping
  static const int INDEX_CLASSES = 0;
  static const int INDEX_HOME = 1;
  static const int INDEX_WALLET = 2;
  static const int INDEX_PORTFOLIO = 3;
  static const int INDEX_PROFILE = 4;

  int currentIndex = 0;

  final List<Widget> screens = const [
    ClassesPage(), // 0 → Home button
    home(), // 1 → Purchase
    Wallet(), // 2 → Floating Button
    Portfolio(), // 3 → Demat
    Profile(), // 4 → Profile
  ];

  ColorNotifire notifier = ColorNotifire();

  @override
  Widget build(BuildContext context) {
    notifier = Provider.of<ColorNotifire>(context, listen: true);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            currentIndex = INDEX_WALLET;
          });
        },
        backgroundColor: const Color(0xFF8B0000),
        child: const Image(
          image: AssetImage("assets/images/Floating action.png"),
          height: 20,
          width: 20,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: notifier.background,
        type: BottomNavigationBarType.fixed,
        currentIndex: _getBottomIndex(),
        elevation: 0,
        onTap: (index) {
          setState(() {
            currentIndex = _mapBottomIndexToScreen(index);
          });
        },
        unselectedItemColor: notifier.textColor,
        selectedItemColor: notifier.textColor,
        unselectedLabelStyle: const TextStyle(
          fontFamily: "Manrope_bold",
          fontSize: 10,
          letterSpacing: 0.2,
        ),
        selectedLabelStyle: TextStyle(
          fontFamily: "Manrope_bold",
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: notifier.textColor,
          letterSpacing: 0.2,
        ),
        items: [
          BottomNavigationBarItem(
            icon: Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Image.asset("assets/images/home.png",
                  scale: 3.5, color: notifier.bottom),
            ),
            activeIcon: Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Image.asset("assets/images/home_fill.png",
                  scale: 3.5, color: notifier.bottom),
            ),
            label: "Home",
          ),
          const BottomNavigationBarItem(
            icon: Padding(
                padding: EdgeInsets.only(bottom: 8),
                child: Icon(Icons.shopping_cart_checkout)),
            activeIcon: Padding(
                padding: EdgeInsets.only(bottom: 8.0),
                child: Icon(Icons.shopping_cart_sharp)),
            label: "Purchase",
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Image.asset("assets/images/Portfolio.png",
                  scale: 3.5, color: notifier.bottom),
            ),
            activeIcon: Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Image.asset("assets/images/Portfolio_fill.png",
                  scale: 3.5, color: notifier.bottom),
            ),
            label: "Demat",
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: const EdgeInsets.only(bottom: 8.0, right: 5),
              child: Image.asset("assets/images/Person.png",
                  scale: 3.5, color: notifier.bottom),
            ),
            activeIcon: Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Image.asset("assets/images/Person_fill.png",
                  scale: 3.5, color: notifier.bottom),
            ),
            label: "Profile",
          ),
        ],
      ),
      body: screens[currentIndex],
    );
  }

  // Map bottom bar tap to actual screen index
  int _mapBottomIndexToScreen(int bottomIndex) {
    switch (bottomIndex) {
      case 0:
        return INDEX_CLASSES; // Home → Classes
      case 1:
        return INDEX_HOME; // Purchase → Home
      case 2:
        return currentIndex; // Demat → Portfolio
      case 3:
        return INDEX_PROFILE; // Profile → Profile
      default:
        return INDEX_HOME;
    }
  }

  // Highlight correct bottom icon
  int _getBottomIndex() {
    switch (currentIndex) {
      case INDEX_CLASSES:
        return 0;
      case INDEX_HOME:
        return 1;
      case INDEX_PORTFOLIO:
        return 2;
      case INDEX_PROFILE:
        return 3;
      default:
        return 1;
    }
  }
}
