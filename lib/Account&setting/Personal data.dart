// ignore_for_file: file_names, camel_case_types

import 'package:juststock/config/common.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Dark mode.dart';

class Personal_data extends StatefulWidget {
  const Personal_data({super.key});

  @override
  State<Personal_data> createState() => _Personal_dataState();
}

class _Personal_dataState extends State<Personal_data> {
  ColorNotifire notifier = ColorNotifire();

  @override
  Widget build(BuildContext context) {
    notifier = Provider.of<ColorNotifire>(context, listen: true);
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: notifier.background,
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Image.asset(
            "assets/images/arrow-narrow-left (1).png",
            scale: 3,
            color: notifier.textColor,
          ),
        ),
        title: Center(
          child: Text(
            "Personal Data",
            style: TextStyle(
              fontFamily: "Manrope-Bold",
              color: notifier.textColor,
              fontSize: 16,
            ),
          ),
        ),
        actions: [
          Image.asset(
            "assets/images/edit.png",
            scale: 3,
            color: const Color(0xFF8B0000),
          ),
          SizedBox(width: 10),
        ],
        backgroundColor: notifier.background,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppConstants.Height(40),
            Center(
              child: Stack(
                alignment: AlignmentDirectional.bottomEnd,
                children: [
                  Container(
                    height: 100,
                    width: 100,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: AssetImage("assets/images/Krishna.jpg"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Container(
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFF8B0000),
                        border: Border.all(
                            color: notifier.isDark
                                ? const Color(0xff0F172A)
                                : Colors.white,
                            width: 1)),
                    child: Image.asset(
                      "assets/images/edit.png",
                      color: Colors.white,
                      scale: 5,
                    ),
                  ),
                ],
              ),
            ),
            AppConstants.Height(40),
            const Text(
              "Full name",
              style: TextStyle(
                fontFamily: "Manrope-Bold",
                fontSize: 16,
                color: Color(0xff64748B),
              ),
            ),
            AppConstants.Height(15),
            Container(
              height: height / 15,
              // width: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.grey.withOpacity(
                  0.1,
                ), /*border: Border.all(color: Color(0xFF8B0000))*/
              ),
              child: Center(
                child: TextField(
                  style: TextStyle(color: notifier.textColor),
                  // keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
            ),
            AppConstants.Height(15),
            const Text(
              "Phone number",
              style: TextStyle(
                fontFamily: "Manrope-Bold",
                fontSize: 16,
                color: Color(0xff64748B),
              ),
            ),
            AppConstants.Height(15),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 50,
                  width: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.grey.withOpacity(0.1),
                  ),
                  child: Center(
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(0),
                      leading: const Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Image(
                          image: AssetImage("assets/images/united-states.png"),
                          height: 30,
                          width: 30,
                        ),
                      ),
                      title: Text("+1",
                          style: TextStyle(
                              fontSize: 17, color: notifier.textColor)),
                    ),
                  ),
                ),
                AppConstants.Width(5),
                Container(
                  height: 56,
                  width: MediaQuery.of(context).size.width / 1.6,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.grey.withOpacity(
                      0.1,
                    ), /*border: Border.all(color: Color(0xFF8B0000))*/
                  ),
                  child: TextField(
                    style: TextStyle(color: notifier.textColor),
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            AppConstants.Height(15),
            const Text(
              "Email",
              style: TextStyle(
                fontFamily: "Manrope-Bold",
                fontSize: 16,
                color: Color(0xff64748B),
              ),
            ),
            AppConstants.Height(15),
            Container(
              height: 56,
              // width: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.grey.withOpacity(
                    0.1), /*border: Border.all(color: Color(0xFF8B0000))*/
              ),
              child: TextField(
                // keyboardType: TextInputType.number,
                style: TextStyle(color: notifier.textColor),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(left: 20, bottom: 15, right: 20),
        child: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            height: 56,
            // width: 370,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: const Color(0xFF8B0000),
            ),
            child: const Center(
                child: Text("Save Change",
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontFamily: "̌Manrope-Bold"))),
          ),
        ),
      ),
    );
  }
}
