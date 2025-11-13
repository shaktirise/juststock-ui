import 'Withdraw options.dart';
import 'Top up balance.dart';
import 'package:crowwn/widgets/topup_helper.dart';
// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Dark mode.dart';
import 'package:crowwn/services/api_locator.dart';
import '../config/common.dart';
import 'Transaction all.dart';
import 'Withdraw Balance.dart';
import '../Account&setting/Referral Withdraw.dart';
import 'package:crowwn/api/wallet_api.dart';

class Wallet extends StatefulWidget {
  const Wallet({super.key});

  @override
  State<Wallet> createState() => _WalletState();
}

class _WalletState extends State<Wallet> {
  bool _password = true;
  ColorNotifire notifier = ColorNotifire();
  Future<List<WalletHistoryItem>>? _historyFuture;

  @override
  void initState() {
    super.initState();
    _historyFuture = WalletApi.ledgerOrHistory(limit: 10);
  }

  @override
  Widget build(BuildContext context) {
    notifier = Provider.of<ColorNotifire>(context, listen: true);
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: notifier.background,
      appBar: AppBar(
        elevation: 0,
        // title: const Text(
        //   "Wallet",
        //   style: TextStyle(
        //     color: Color(0xffFFFFFF),
        //     fontSize: 16,
        //   ),
        // ),
        centerTitle: true,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Image.asset(
            "assets/images/arrow-narrow-left (1).png",
            scale: 2.9,
            color: Colors.white,
          ),
        ),
        backgroundColor: Color(0xFF8B0000),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                Container(
                  clipBehavior: Clip.none,
                  alignment: Alignment.center,
                  // Increased header height for breathing room
                  height: 220,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                    image: AssetImage("assets/images/Background (2).png"),
                    fit: BoxFit.cover,
                  )),
                  child: Padding(
                    padding:
                        const EdgeInsets.only(top: 40, left: 15, right: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppConstants.Height(10),
                        const Column(
                          children: [
                            Text(
                              "Referral Income",
                              style: TextStyle(
                                color: Color(0xff94A3B8),
                                fontSize: 15,
                                fontFamily: "Manrope-Regular",
                              ),
                            ),
                          ],
                        ),
                    AppConstants.Height(10),
                    // Add right padding so the eye icon doesn't collide
                    // with the centered Withdraw action.
                    Padding(
                      padding: const EdgeInsets.only(right: 72),
                      child: Row(
                      children: [
                            FutureBuilder<Map<String, dynamic>>(
                              future: ApiLocator.referral.earnings(),
                              builder: (context, snap) {
                                // If hidden, show stars regardless of data
                                if (!_password) {
                                  return const Text(
                                    '  ********',
                                    style: TextStyle(
                                      fontSize: 32,
                                      color: Color(0xffFFFFFF),
                                    ),
                                  );
                                }
                                if (snap.connectionState == ConnectionState.waiting) {
                                  return const SizedBox(
                                      height: 24,
                                      width: 24,
                                      child: CircularProgressIndicator(
                                          strokeWidth: 2, color: Colors.white));
                                }
                                final data = snap.data ?? const {};
                                final totalEarnedPaise =
                                    (data['totalEarnedPaise'] as num?)?.toInt() ?? 0;
                                final rupees = (totalEarnedPaise / 100).toStringAsFixed(2);
                                return Text(
                                  '\u20B9 $rupees',
                                  style: const TextStyle(
                                    fontSize: 32,
                                    color: Color(0xffFFFFFF),
                                  ),
                                );
                              },
                            ),
                            AppConstants.Width(10),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _password = !_password;
                                });
                              },
                              child: _password
                                  ? const Icon(
                                      Icons.visibility,
                                      size: 24,
                                      color: Color(0xffFFFFFF),
                                    )
                                  : const Icon(
                                      Icons.visibility_off,
                                      size: 24,
                                      color: Color(0xffFFFFFF),
                                    ),
                            ),
                          ],
                        ),
                      ),
                        // Removed secondary label/value; big value shows referral earnings
                      ],
                    ),
                  ),
                ),
                // Place Withdraw just below the earnings row, centered.
                Positioned(
                  bottom: 14,
                  left: 0,
                  right: 0,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            PageRouteBuilder(
                              pageBuilder: (_, __, ___) => const ReferralWithdrawPage(),
                              transitionDuration: Duration.zero,
                              reverseTransitionDuration: Duration.zero,
                            ),
                          );
                        },
                        child: Container(
                          height: 72,
                          width: 72,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(36),
                            color: const Color(0xFF8B0000).withOpacity(0.3),
                          ),
                          child: Center(
                            child: Image.asset(
                              "assets/images/Recieve.png",
                              scale: 2.0,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 0),
                      Transform.translate(
                        offset: const Offset(0, -12),
                        child: const Text(
                          "Withdraw",
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xffFFFFFF),
                            fontFamily: "Manrope-SemiBold",
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
            AppConstants.Height(8),
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        "Transactions",
                        style: TextStyle(
                            color: notifier.textColor,
                            fontSize: 16,
                            fontFamily: "Manrope-Bold"),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            PageRouteBuilder(
                              pageBuilder: (_, __, ___) => const Transaction_all(),
                              transitionDuration: Duration.zero,
                              reverseTransitionDuration: Duration.zero,
                            ),
                          );
                        },
                        child: const Text(
                          "See all",
                          style: TextStyle(
                              fontSize: 15,
                              color: Color(0xFF8B0000),
                              fontFamily: "Manrope - Regular"),
                        ),
                      )
                    ],
                  ),
                  AppConstants.Height(12),
                  FutureBuilder<List<WalletHistoryItem>>(
                    future: _historyFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 24),
                          child: Center(
                            child: SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          ),
                        );
                      }
                      final items = snapshot.data ?? const <WalletHistoryItem>[];
                      if (items.isEmpty) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: Text(
                            'No transactions yet',
                            style: TextStyle(color: Color(0xff64748B)),
                          ),
                        );
                      }
                      return ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: items.length > 5 ? 5 : items.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final it = items[index];
                          final isCredit = it.amountPaise > 0;
                          final amount = (it.amountPaise / 100).toStringAsFixed(2);
                          final title = it.title ?? it.category ?? (isCredit ? 'Credit' : 'Debit');
                          return Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: notifier.getContainerBorder, width: 1),
                            ),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: const Color(0xFF8B0000).withOpacity(0.08),
                                child: Icon(isCredit ? Icons.call_received : Icons.call_made, color: const Color(0xFF8B0000)),
                              ),
                              title: Text(
                                title,
                                style: TextStyle(color: notifier.textColor, fontFamily: 'Manrope-Bold'),
                              ),
                              subtitle: Text(
                                it.note ?? '',
                                style: const TextStyle(color: Color(0xff64748B), fontSize: 12),
                              ),
                              trailing: Text(
                                '${isCredit ? '+' : ''}$amount',
                                style: TextStyle(color: notifier.textColor, fontFamily: 'Manrope-Bold'),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                  AppConstants.Height(12),
                  
                  
                  
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
