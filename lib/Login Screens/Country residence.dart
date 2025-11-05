// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Dark mode.dart';
import '../config/common.dart';
import 'Select reason.dart';

class Residence extends StatefulWidget {
  const Residence({super.key});

  @override
  State<Residence> createState() => _ResidenceState();
}

class _ResidenceState extends State<Residence> {
  String? selectedOption;

  List mapvalue = [
    {
      "name": "United States",
      "image": "assets/images/united-states.png",
    },
    {
      "name": "United Kingdom",
      "image": "assets/images/united-kingdom.png",
    },
    {
      "name": "Ukraine",
      "image": "assets/images/ukraine.png",
    },
    {
      "name": "Uruguay",
      "image": "assets/images/uruguay.png",
    },
  ];
  ColorNotifire notifier = ColorNotifire();

  @override
  Widget build(BuildContext context) {
    notifier = Provider.of<ColorNotifire>(context, listen: true);
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: notifier.background,
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 40),
                  child: GestureDetector(
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
              ],
            ),
            AppConstants.Height(50),
            Text(
              "Select your country",
              style: TextStyle(
                fontSize: 26,
                color: notifier.textColor,
                fontFamily: "Manrope-Bold",
              ),
            ),
            AppConstants.Height(20),
            dropdownbuton(),
            AppConstants.Height(50),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.fromLTRB(15,0,15,30),
        child: InkWell(onTap: () {
          setState(() {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const Reason(),
              ),
            );
          });
        },
          child: Container(
            height: 55,
            width: double.maxFinite,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: const Color(0xFF8B0000),
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

  Widget dropdownbuton({TextStyle? stle}) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 10,
          ),
          Container(
            decoration: BoxDecoration(
              color: notifier.textField,
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
            child: DropdownButtonFormField<String>(
              dropdownColor: notifier.textField,
              value: selectedOption,
              padding: const EdgeInsets.only(left: 10),
              items: mapvalue.map((e) {
                return DropdownMenuItem<String>(
                    value: e["name"],
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 20,
                          child: Image.asset(
                            e["image"],
                            scale: 4,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(e["name"],
                            style: TextStyle(
                                color: notifier.textColor, fontSize: 18)),
                      ],
                    ));
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedOption = newValue;
                });
              },
              decoration: InputDecoration(
                hintText: 'Select Country',
                hintStyle: TextStyle(color: notifier.textColor),
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
