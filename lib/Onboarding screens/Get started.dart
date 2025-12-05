// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:juststock/Login%20Screens/Login.dart';
import 'package:juststock/Login%20Screens/Sign%20up.dart';

import '../Dark mode.dart';
import '../config/common.dart';

class Get1 extends StatefulWidget {
  const Get1({super.key});

  @override
  State<Get1> createState() => _Get1State();
}

class _Get1State extends State<Get1> {
  ColorNotifire notifier = ColorNotifire();
  @override
  Widget build(BuildContext context) {
    notifier = Provider.of<ColorNotifire>(context, listen: true);
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: notifier.background,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                    image: DecorationImage(
                  image: AssetImage('assets/images/Get1.png'),
                )),
              ),
            ),
            // Switch(
            //   value: notifier.isDark,
            //   onChanged: (bool value) {
            //     notifier.isavalable(value);
            //   },
            // ),

             Text(
              "Start Your Growth Journey",
              style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Manrope-SemiBold",
                  color: notifier.textColor),
            ),
            const Text(
                    "Understand. Learn. Apply. Become a smarter investor.",
              style: TextStyle(
                  fontSize: 16,
                  color: Color(0xff64748B),
                  fontFamily: "Manrope-SemiBold"),
                  
            ),
            AppConstants.Height(15),
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Login(),
                    ));
              },
              child: Container(
                height: height/12,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: const Color(0xFF8B0000)),
                // width: 327,
                child: const Center(
                    child: Text(
                  "Continue with Email",
                  style: TextStyle(fontSize: 17, color: Colors.white),
                )),
              ),
            ),
            // Container(
            //     height: 60,
            //     width: 400,
            //     decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: Color(0xFF8B0000),),
            //     child: Center(
            //       child: ElevatedButton(
            //         onPressed: () {
            //           Navigator.push(context, MaterialPageRoute(builder: (context) => Login(),));
            //         },style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(Color(0xFF8B0000))),
            //         child: Text(
            //           "Continue with email",
            //           style: TextStyle(fontSize: 20,fontFamily: "Manrope-Bold",color: Color(0xffFFFFFF)),
            //         ),
            //       ),
            //     )),
            // OutlinedButton(
            //     onPressed: () {},
            //     style: ButtonStyle(
            //         minimumSize: MaterialStatePropertyAll(Size(200, 50))),
            //     child: const Row(
            //       mainAxisAlignment: MainAxisAlignment.center,
            //       children: [
            //         Image(
            //           image: AssetImage("assets/images/apple-logo.png"),
            //           height: 25,
            //           width: 25,
            //         ),
            //         Text(
            //           " Continue with Apple",
            //           style: TextStyle(
            //               color: Colors.black, fontFamily: "Manrope-SemiBold"),
            //         )
            //       ],
            //     )),
            // Apple/Google sign-in removed; email only
            AppConstants.Height(20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Don't have an account?",
                  style: TextStyle(
                      fontFamily: "Manrope-Medium", color: Color(0xff64748B)),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const Sign(),));
                  },
                    child: const Text(
                  "Sign Up",
                  style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF8B0000),
                      fontFamily: "Manrope-Bold"),
                ))
              ],
            ),
            AppConstants.Height(20),
          ],
        ),
      ),
    );
  }
}
