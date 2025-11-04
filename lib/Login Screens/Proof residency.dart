// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Dark mode.dart';
import '../config/Liner_indicator.dart';
import '../config/common.dart';
import 'Verify identi.dart';

class Proof extends StatefulWidget {
  const Proof({super.key});

  @override
  State<Proof> createState() => _ProofState();
}

class _ProofState extends State<Proof> {
  int selectedFilter = 0;
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
            indicator(value: 1),
            AppConstants.Height(10),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Text(
                "Select and upload",
                style: TextStyle(
                  fontSize: 25,
                  fontFamily: "Manrope-Bold",
                  color: notifier.textColor,
                ),
              ),
            ),
            AppConstants.Height(10),
            const Padding(
              padding: EdgeInsets.only(left: 10, right: 10),
              child: Text(
                "We need this to confirm you reside in United  States and verify who you are. Data is  processed securely.",
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xff64748B),
                  fontFamily: "Manrope-Regular",
                ),
              ),
            ),
            AppConstants.Height(30),
            Container(
              height: height / 10.5,
              // width: 320,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: notifier.textField,
                  border: Border.all(
                      color: selectedFilter == 0
                          ? const Color(0xff6B39F4)
                          : notifier.background)),
              child: Center(
                child: ListTile(
                  onTap: () {
                    setState(
                      () {
                        selectedFilter = 0;
                      },
                    );
                  },
                  leading: const Image(
                      image: AssetImage("assets/images/identycard.png"),
                      height: 40,
                      width: 40),
                  title: Text("Identity Card",
                      style: TextStyle(
                          fontSize: 18,
                          fontFamily: "Manrope-Bold",
                          color: notifier.textColor)),
                  trailing: Radio(
                    fillColor: MaterialStateColor.resolveWith(
                        (states) => const Color(0xff6B39F4)),
                    // activeColor: Color(0xff6B39F4),
                    value: 0,
                    groupValue: selectedFilter,
                    onChanged: (index) {
                      setState(
                        () {
                          selectedFilter = 0;
                        },
                      );
                    },
                  ),
                ),
              ),
            ),
            // Column(
            //   children: [
            //     ...List.generate(
            //       buttonText.length,
            //           (index) => button(
            //         index: index,
            //         text: buttonText[index],
            //       ),
            //     )
            //   ],
            // ),
            AppConstants.Height(20),
            Container(
              height: height / 10.5,
              // width: 320,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: notifier.textField,
                border: Border.all(
                  color: selectedFilter == 1
                      ? const Color(0xff6B39F4)
                      : notifier.background,
                ),
              ),
              child: Center(
                child: ListTile(
                  onTap: () {
                    setState(
                      () {
                        selectedFilter = 1;
                      },
                    );
                  },
                  leading: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.white,
                    ),
                    child: Image.asset(
                      "assets/images/digital_document.png",
                      scale: 2.9,
                    ),
                  ),
                  title: Text(
                    "My Digital Document",
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: "Manrope-Bold",
                      color: notifier.textColor,
                    ),
                  ),
                  trailing: Radio(
                    fillColor: MaterialStateColor.resolveWith(
                      (states) => const Color(0xff6B39F4),
                    ),
                    // activeColor: Color(0xff6B39F4),
                    value: 1,
                    groupValue: selectedFilter,
                    onChanged: (value) {
                      setState(
                        () {
                          selectedFilter = 1;
                        },
                      );
                    },
                  ),
                ),
              ),
            ),
            AppConstants.Height(20),
            Container(
              height: height / 10.5,
              // width: 320,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: notifier.textField,
                border: Border.all(
                  color: selectedFilter == 2
                      ? const Color(0xff6B39F4)
                      : notifier.background,
                ),
              ),
              child: Center(
                child: ListTile(
                  onTap: () {
                    setState(
                      () {
                        selectedFilter = 2;
                      },
                    );
                  },
                  leading: Container(
                    alignment: Alignment.center,
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.white,
                    ),
                    child: Image.asset(
                      "assets/images/passport.png",
                      scale: 2.9,
                    ),
                  ),
                  title: Text("My Passport",
                      style: TextStyle(
                          fontSize: 18,
                          fontFamily: "Manrope-Bold",
                          color: notifier.textColor)),
                  trailing: Radio(
                    fillColor: MaterialStateColor.resolveWith(
                      (states) => const Color(0xff6B39F4),
                    ),
                    // activeColor: Color(0xff6B39F4),
                    value: 2,
                    groupValue: selectedFilter,
                    onChanged: (value) {
                      setState(
                        () {
                          selectedFilter = 2;
                        },
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(15, 0, 15, 20),
        child: SizedBox(
          height: 56,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(20),
                ),
              ),
              backgroundColor: const Color(0xff6B39F4),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const Verify(),
                ),
              );
            },
            child: const Text(
              "Continue",
              style: TextStyle(
                fontSize: 16,
                fontFamily: "Manrope-SemiBold",
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
/* const Spacer(),
            Center(
              child: Container(
                height: 50,
                // width: 330,
                decoration: BoxDecoration(
                    color: const Color(0xff6B39F4),
                    borderRadius: BorderRadius.circular(15)),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Verify(),
                        ));
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff6B39F4),
                      shape: RoundedRectangleBorder(
                          side: const BorderSide(width: 300),
                          borderRadius: BorderRadius.circular(15))),
                  child: const Center(
                      child: Text("Continue",
                          style: TextStyle(color: Colors.white, fontSize: 19))),
                ),
              ),
            ),
            AppConstants.Height(10),*/
