import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Dark mode.dart';
import '../config/common.dart';
import 'Country residence.dart';

class Country extends StatefulWidget {
  const Country({super.key});

  @override
  State<Country> createState() => _CountryState();
}

class _CountryState extends State<Country> {
  ColorNotifire notifier = ColorNotifire();

  @override
  Widget build(BuildContext context) {
    notifier = Provider.of<ColorNotifire>(context, listen: true);
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
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
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppConstants.Height(10),
            indicator(value: 0.4),
            AppConstants.Height(30),
            Text(
              "What’s your citizenship?",
              style: TextStyle(
                fontSize: 26,
                color: notifier.textColor,
                fontFamily: "Manrope-Bold",
              ),
            ),
            AppConstants.Height(10),
            const Text(
              "If you’re a citizen of more than one country, please pick one.",
              style: TextStyle(
                fontSize: 17,
                color: Colors.grey,
                fontFamily: "Manrope-Regular",
              ),
            ),
            AppConstants.Height(30),
            Text(
              "Citizenship",
              style: TextStyle(
                fontSize: 19,
                fontFamily: "Manrope-Bold",
                color: notifier.textColor,
              ),
            ),
            AppConstants.Height(10),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: notifier.textField,
              ),
              child: ListTile(
                leading: const Image(
                  image: AssetImage("assets/images/united-states.png"),
                  width: 25,
                ),
                title: Text(
                  'United States',
                  style: TextStyle(
                    fontSize: 18,
                    color: notifier.textColor,
                    fontFamily: "Manrope-Bold",
                  ),
                ),
                trailing: const Icon(
                  Icons.chevron_right,
                  color: Colors.grey,
                ),
                selected: true,
              ),
            ),
            const Spacer(),
            const ListTile(
              leading: Icon(
                Icons.lock_outline,
                color: Colors.grey,
              ),
              title: Text(
                "This info is used only for identity verification and is transmitted securely using 128-bit encryption.",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 13,
                  fontFamily: "Manrope-Regular",
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 60, left: 15, right: 15),
        child: InkWell(
          onTap: () {
            setState(() {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const Residence(),
                ),
              );
            });
          },
          child: Container(
            width: double.maxFinite,
            height: 55,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Color(0xFF8B0000),
            ),
            child: const Center(
              child: Text(
                "Continue",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget indicator({required double value}) {
    return LinearProgressIndicator(
      value: value,
      color: const Color(0xFF8B0000),
      backgroundColor: notifier.linerIndicator,
    );
  }
}

/* Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Center(
                child: Container(
                  height: height / 12,
                  // width: 327,
                  decoration: BoxDecoration(
                    color: const Color(0xFF8B0000),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Residence(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF8B0000),
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(width: 300),
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: const Center(
                      child: Text(
                        "Continue",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            )*/
