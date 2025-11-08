

// ignore_for_file: file_names, camel_case_types

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:crowwn/config/common.dart';
import 'package:flutter/services.dart';
import 'package:crowwn/api/deeplink_api.dart';

import '../Dark mode.dart';
import 'package:share_plus/share_plus.dart';

class Reffle_code extends StatefulWidget {
  const Reffle_code({super.key});

  @override
  State<Reffle_code> createState() => _Reffle_codeState();
}

class _Reffle_codeState extends State<Reffle_code> {
  ColorNotifire notifier = ColorNotifire();
  static const String _refCode = '63LZNWKX';
  bool _loading = false;

  Future<void> _invite() async {
    if (_loading) return;
    setState(() => _loading = true);
    try {
      final res = await DeepLinkApi.createReferral(_refCode);
      final share = (res['shareUrl'] ?? res['appUrl'] ?? '').toString();
      final message =
          "I'm earning commissions through the Just Stock referral system. Join using my code and earn rewards on every activation and renewal.";
      if (share.isNotEmpty) {
        Share.share('$message $share');
      } else {
        Share.share(message);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to create invite: $e')));
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }
  @override
  Widget build(BuildContext context) {
    notifier = Provider.of<ColorNotifire>(context, listen: true);
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: const Color(0xff0F172A),
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: const Color(0xff0F172A),
        leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(Icons.close, color: Color(0xffFFFFFF))),
        title: const Text("Refferal Program",
            style: TextStyle(fontSize: 16, fontFamily: "Manrope-Bold")),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              AppConstants.Height(30),
              Container(
                height: 576,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: notifier.onboardBackgroundColor),
                child: Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Column(
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      AppConstants.Height(40),
                      Center(
                          child: Image.asset(
                        "assets/images/Gift_1.png",
                        scale: 1.6,
                      )),
                      AppConstants.Height(30),
                      Text(
                        "Invite Friends & Earn referral Commissions!",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: "Manrope-Bold",
                            fontSize: 22,
                            color: notifier.textColor),
                      ),
                      AppConstants.Height(10),
                      const Padding(
                        padding: EdgeInsets.only(left: 15, right: 15),
                        child: Text(
                          "Earn commissions up to 10 levels whenever your referred users activate (₹2100) or renew (₹1000). Commissions are added instantly to your referral wallet.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Color(0xff64748B),
                              fontSize: 14,
                              fontFamily: "Manrope-Regular"),
                        ),
                      ),
                      AppConstants.Height(30),
                      Container(
                        height: height/9,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                color: notifier.getContainerBorder, width: 1)),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 15, left: 10, right: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text("Your referral code",
                                          style: TextStyle(
                                              color: Color(0xff64748B),
                                              fontSize: 13,
                                              fontFamily: "Manrope-Regular")),
                                       Text(
                                        _refCode,
                                        style: TextStyle(
                                            fontSize: 19,
                                            color: notifier.textColor,
                                            fontFamily: "Manrope-Bold"),
                                      ),
                                    ],
                                  ),
                                  const Spacer(),
                                  const Padding(
                                    padding: EdgeInsets.only(top: 20),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.copy,
                                              color: Color(0xFF8B0000),
                                              size: 14,
                                            ),
                                            Text(
                                              'Copy',
                                              style: TextStyle(
                                                  color: Color(0xFF8B0000),
                                                  fontSize: 12,
                                                  fontFamily: "Manrope-Bold"),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      AppConstants.Height(90),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(20, 10, 20, 20),
        child: SizedBox(
          height: 48,
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF8B0000),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: _loading ? null : _invite,
            child: Text(_loading ? 'Generating…' : 'Invite',
                style: const TextStyle(color: Colors.white)),
          ),
        ),
      ),
    );
  }
}


