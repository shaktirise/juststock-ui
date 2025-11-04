// ignore_for_file: file_names, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Dark mode.dart';
import '../config/common.dart';
import 'Create pin.dart';

class Reason extends StatefulWidget {
  const Reason({super.key});

  @override
  State<Reason> createState() => _ReasonState();
}

class _ReasonState extends State<Reason> {
  int selectIndex = 0;

  bool Select1 = false;
  bool Select2 = false;
  bool Select3 = false;
  bool Select4 = false;
  bool Select5 = false;
  bool Select6 = false;
  bool Select7 = false;
  bool Select8 = false;
  bool Select9 = false;
  bool Select10 = false;
  bool Select11 = false;
  bool Select12 = false;
  bool Select13 = false;

  List select = [];
  List name = [
    "Transfers",
    "Scheduling Payments",
    "Get salary early",
    "Budgeting",
    "Cashback",
    "View account in one\n place",
  ];

  List select1 = [];
  List name1 = [
    "Invest in gold",
    "  Invest in cryptocurrency",
    "Invest in stocks",
    "Trading",
    "NFTs",
  ];

  List select2 = [];
  List name2 = [
    "Hotel booking",
    "Foreign exchanges",
  ];
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
          child: Icon(
            Icons.close,
            color: notifier.textColor,
            size: 25,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 15, right: 10),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppConstants.Height(10),
              indicator(value: 0.6),
              AppConstants.Height(20),
              Text(
                "What do you want to use Financial for?",
                style: TextStyle(
                    fontSize: 24,
                    fontFamily: "Manrope-Bold",
                    color: notifier.textColor),
              ),
              AppConstants.Height(10),
              const Text(
                "We need to know this for regulatory reasons.And also, we need curious!",
                style: TextStyle(
                    fontSize: 16,
                    color: Color(0xff64748B),
                    fontFamily: "Manrope-Regular"),
              ),
              AppConstants.Height(30),
              Text(
                "Banking",
                style: TextStyle(
                    fontSize: 18,
                    fontFamily: "Manrope-Bold",
                    color: notifier.textColor),
              ),
              AppConstants.Height(15),
              Column(
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            Select1 = !Select1;
                          });
                        },
                        child: Container(
                          height: height / 18,
                          width: width / 5,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Select1
                                ? notifier.textField
                                : notifier.textField,
                            border: Border.all(
                                color: Select1
                                    ? const Color(0xff6B39F4)
                                    : Colors.transparent),
                          ),
                          child: Center(
                              child: Text(
                            "Transfers",
                            style: TextStyle(
                                fontFamily: "Manrope-SemiBold",
                                fontSize: 12,
                                color: Select1
                                    ? const Color(0xff6B39F4)
                                    : Colors.grey),
                          )),
                        ),
                      ),
                      AppConstants.Width(30),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            Select2 = !Select2;
                          });
                        },
                        child: Container(
                          height: height / 16,
                          width: width / 3,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Select2
                                  ? notifier.textField
                                  : notifier.textField,
                              border: Border.all(
                                  color: Select2
                                      ? const Color(0xff6B39F4)
                                      : Colors.transparent)),
                          child: Center(
                              child: Text(
                            "Scheduling Payments",
                            style: TextStyle(
                                fontFamily: "Manrope-SemiBold",
                                fontSize: 12,
                                color: Select2
                                    ? const Color(0xff6B39F4)
                                    : Colors.grey),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          )),
                        ),
                      ),
                    ],
                  ),
                  AppConstants.Height(10),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            Select3 = !Select3;
                          });
                        },
                        child: Container(
                          height: height / 16,
                          width: width / 3,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Select3
                                  ? notifier.textField
                                  : notifier.textField,
                              border: Border.all(
                                  color: Select3
                                      ? const Color(0xff6B39F4)
                                      : Colors.transparent)),
                          child: Center(
                              child: Text(
                            "Get salary early",
                            style: TextStyle(
                                fontFamily: "Manrope-SemiBold",
                                fontSize: 12,
                                color: Select3
                                    ? const Color(0xff6B39F4)
                                    : Colors.grey),
                          )),
                        ),
                      ),
                      AppConstants.Width(30),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            Select4 = !Select4;
                          });
                        },
                        child: Container(
                          height: height / 16,
                          width: width / 4,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Select4
                                  ? notifier.textField
                                  : notifier.textField,
                              border: Border.all(
                                  color: Select4
                                      ? const Color(0xff6B39F4)
                                      : Colors.transparent)),
                          child: Center(
                              child: Text(
                            "Budgeting",
                            style: TextStyle(
                                fontFamily: "Manrope-SemiBold",
                                fontSize: 12,
                                color: Select4
                                    ? const Color(0xff6B39F4)
                                    : Colors.grey),
                          )),
                        ),
                      ),
                    ],
                  ),
                  AppConstants.Height(10),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            Select5 = !Select5;
                          });
                        },
                        child: Container(
                          height: height / 16,
                          width: width / 4,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Select5
                                  ? notifier.textField
                                  : notifier.textField,
                              border: Border.all(
                                  color: Select5
                                      ? const Color(0xff6B39F4)
                                      : Colors.transparent)),
                          child: Center(
                              child: Text(
                            "Cashback",
                            style: TextStyle(
                                fontFamily: "Manrope-SemiBold",
                                fontSize: 12,
                                color: Select5
                                    ? const Color(0xff6B39F4)
                                    : Colors.grey),
                          )),
                        ),
                      ),
                      AppConstants.Width(30),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            Select6 = !Select6;
                          });
                        },
                        child: Container(
                          height: height / 16,
                          width: width / 2,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Select6
                                  ? notifier.textField
                                  : notifier.textField,
                              border: Border.all(
                                  color: Select6
                                      ? const Color(0xff6B39F4)
                                      : Colors.transparent)),
                          child: Center(
                              child: Text(
                            "View account in one place",
                            style: TextStyle(
                                fontFamily: "Manrope-SemiBold",
                                fontSize: 12,
                                color: Select6
                                    ? const Color(0xff6B39F4)
                                    : Colors.grey),
                          )),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              AppConstants.Height(15),
              Text(
                "Investments",
                style: TextStyle(
                    fontSize: 18,
                    fontFamily: "Manrope-SemiBold",
                    color: notifier.textColor),
              ),
              AppConstants.Height(15),
              Column(
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            Select7 = !Select7;
                          });
                        },
                        child: Container(
                          height: height / 16,
                          width: width / 3,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Select7
                                  ? notifier.textField
                                  : notifier.textField,
                              border: Border.all(
                                  color: Select7
                                      ? const Color(0xff6B39F4)
                                      : Colors.transparent)),
                          child: Center(
                              child: Text(
                            "Invest in gold",
                            style: TextStyle(
                                fontFamily: "Manrope-SemiBold",
                                fontSize: 12,
                                color: Select7
                                    ? const Color(0xff6B39F4)
                                    : Colors.grey),
                          )),
                        ),
                      ),
                      AppConstants.Width(30),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            Select8 = !Select8;
                          });
                        },
                        child: Container(
                          height: height / 16,
                          width: width / 2,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Select8
                                  ? notifier.textField
                                  : notifier.textField,
                              border: Border.all(
                                  color: Select8
                                      ? const Color(0xff6B39F4)
                                      : Colors.transparent)),
                          child: Center(
                              child: Text(
                            "Invest in cryptocurrency",
                            style: TextStyle(
                                fontFamily: "Manrope-SemiBold",
                                fontSize: 12,
                                color: Select8
                                    ? const Color(0xff6B39F4)
                                    : Colors.grey),
                          )),
                        ),
                      ),
                    ],
                  ),
                  AppConstants.Height(10),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            Select9 = !Select9;
                          });
                        },
                        child: Container(
                          height: height / 16,
                          width: width / 3,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Select9
                                  ? notifier.textField
                                  : notifier.textField,
                              border: Border.all(
                                  color: Select9
                                      ? const Color(0xff6B39F4)
                                      : Colors.transparent)),
                          child: Center(
                              child: Text(
                            "Invest in stocks",
                            style: TextStyle(
                                fontFamily: "Manrope-SemiBold",
                                fontSize: 12,
                                color: Select9
                                    ? const Color(0xff6B39F4)
                                    : Colors.grey),
                          )),
                        ),
                      ),
                      AppConstants.Width(20),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            Select10 = !Select10;
                          });
                        },
                        child: Container(
                          height: height / 16,
                          width: width / 5,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Select10
                                  ? notifier.textField
                                  : notifier.textField,
                              border: Border.all(
                                  color: Select10
                                      ? const Color(0xff6B39F4)
                                      : Colors.transparent)),
                          child: Center(
                              child: Text(
                            "Trading",
                            style: TextStyle(
                                fontFamily: "Manrope-SemiBold",
                                fontSize: 12,
                                color: Select10
                                    ? const Color(0xff6B39F4)
                                    : Colors.grey),
                          )),
                        ),
                      ),
                      AppConstants.Width(20),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            Select11 = !Select11;
                          });
                        },
                        child: Container(
                          height: height / 16,
                          width: width / 5,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Select11
                                  ? notifier.textField
                                  : notifier.textField,
                              border: Border.all(
                                  color: Select11
                                      ? const Color(0xff6B39F4)
                                      : Colors.transparent)),
                          child: Center(
                              child: Text(
                            "NFTs",
                            style: TextStyle(
                                fontFamily: "Manrope-SemiBold",
                                fontSize: 12,
                                color: Select11
                                    ? const Color(0xff6B39F4)
                                    : Colors.grey),
                          )),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              AppConstants.Height(15),
              Text(
                "Global Spending",
                style: TextStyle(
                    fontSize: 18,
                    fontFamily: "Manrope-SemiBold",
                    color: notifier.textColor),
              ),
              AppConstants.Height(15),
              Column(
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            Select12 = !Select12;
                          });
                        },
                        child: Container(
                          height: height / 16,
                          width: width / 4,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Select12
                                  ? notifier.textField
                                  : notifier.textField,
                              border: Border.all(
                                  color: Select12
                                      ? const Color(0xff6B39F4)
                                      : Colors.transparent)),
                          child: Center(
                              child: Text(
                            "Invest",
                            style: TextStyle(
                                fontFamily: "Manrope-SemiBold",
                                fontSize: 12,
                                color: Select12
                                    ? const Color(0xff6B39F4)
                                    : Colors.grey),
                          )),
                        ),
                      ),
                      AppConstants.Width(30),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            Select13 = !Select13;
                          });
                        },
                        child: Container(
                          height: height / 16,
                          width: width / 5,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Select13
                                  ? notifier.textField
                                  : notifier.textField,
                              border: Border.all(
                                  color: Select13
                                      ? const Color(0xff6B39F4)
                                      : Colors.transparent)),
                          child: Center(
                              child: Text(
                            "Trad",
                            style: TextStyle(
                                fontFamily: "Manrope-SemiBold",
                                fontSize: 12,
                                color: Select13
                                    ? const Color(0xff6B39F4)
                                    : Colors.grey),
                          )),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(15,0,15,20),
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
                  builder: (context) => const Pin(),
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

  Widget indicator({required double value}) {
    return LinearProgressIndicator(
      value: value,
      color: const Color(0xff6B39F4),
      backgroundColor: notifier.linerIndicator,
    );
  }
}


// GridView.builder(
//   itemCount: 6,
//   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//       crossAxisCount: 2, mainAxisExtent: 100),
//   shrinkWrap: true,
//   itemBuilder: (context, index) {
//     return Padding(
//       padding: const EdgeInsets.all(10.0),
//       child: GestureDetector(
//         onTap: () {
//           if (select.contains(index)) {
//             setState(() {
//               select.remove(index);
//             });
//           } else {
//             setState(() {
//               select.add(index);
//             });
//           }
//           select.contains(index);
//         },
//         child: Container(
//           height: 30,
//           width: 70,
//           decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(20),
//               color: select.contains(index)
//                   ? Color(0xffF8F5FF)
//                   : Color(0xffF8F9FD)),
//           child: Center(
//               child: Text(
//             name[index],
//             style: TextStyle(
//                 color: select.contains(index)
//                     ? Color(0xff6B39F4)
//                     : Color(0xff94A3B8),
//                 fontSize: 14,
//                 fontFamily: "Manrope-SemiBold"),
//           )),
//         ),
//       ),
//     );
//   },
// ),
// Text(
//   "Investments",
//   style: TextStyle(
//       fontSize: 18,
//       fontFamily: "Manrope-SemiBold",
//       color: Color(0xff0F172A)),
// ),
// GridView.builder(
//   itemCount: 5,
//   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//       crossAxisCount: 2, mainAxisExtent: 100),
//   shrinkWrap: true,
//   itemBuilder: (context, index) {
//     return Padding(
//       padding: const EdgeInsets.all(10.0),
//       child: GestureDetector(
//         onTap: () {
//           if (select1.contains(index)) {
//             setState(() {
//               select1.remove(index);
//             });
//           } else {
//             setState(() {
//               select1.add(index);
//             });
//           }
//           select1.contains(index);
//         },
//         child: Container(
//           height: 30,
//           width: 70,
//           decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(20),
//               color: select1.contains(index)
//                   ? Color(0xffF8F5FF)
//                   : Color(0xffF8F9FD)),
//           child: Center(
//               child: Text(
//             name1[index],
//             style: TextStyle(
//                 color: select1.contains(index)
//                     ? Color(0xff6B39F4)
//                     : Color(0xff94A3B8),
//                 fontSize: 14,
//                 fontFamily: "Manrope-SemiBold"),
//           )),
//         ),
//       ),
//     );
//   },
// ),
// Text(
//   "Global Spending",
//   style: TextStyle(
//       fontSize: 18,
//       fontFamily: "Manrope-SemiBold",
//       color: Color(0xff0F172A)),
// ),
// GridView.builder(
//   itemCount: 2,
//   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//       crossAxisCount: 2, mainAxisExtent: 100),
//   shrinkWrap: true,
//   itemBuilder: (context, index) {
//     return Padding(
//       padding: const EdgeInsets.all(10.0),
//       child: GestureDetector(
//         onTap: () {
//           if (select2.contains(index)) {
//             setState(() {
//               select2.remove(index);
//             });
//           } else {
//             setState(() {
//               select2.add(index);
//             });
//           }
//           select2.contains(index);
//         },
//         child: Container(
//           height: 30,
//           width: 70,
//           decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(20),
//               color: select2.contains(index)
//                   ? Color(0xffF8F5FF)
//                   : Color(0xffF8F9FD)),
//           child: Center(
//               child: Text(
//             name2[index],
//             style: TextStyle(
//                 color: select2.contains(index)
//                     ? Color(0xff6B39F4)
//                     : Color(0xff94A3B8),
//                 fontSize: 14,
//                 fontFamily: "Manrope-SemiBold"),
//           )),
//         ),
//       ),
//     );
//   },
// ),