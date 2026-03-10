// ignore_for_file: camel_case_types
import 'package:juststock/Home/home_video.dart';
import 'package:juststock/Home/stocks_.dart';
import 'package:juststock/Home/videos_detaiils.dart';
import 'package:juststock/api/profile_api.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../Crypto/Detail_crypto.dart';
import '../Crypto/crypto.dart';
import '../Dark mode.dart';
import '../Gold/Detail_gold.dart';
import '../Gold/Gold.dart';
import '../Message & Notification/Message.dart';
import '../Message & Notification/Notifications.dart';
import '../NFT/Collections.dart';
import '../NFT/NFTs.dart';
import '../Stocks/Detail_stock.dart';
import '../Stocks/Us stocks.dart';
import '../config/common.dart';
import '../widgets/wallet_balance_card.dart';
import '../widgets/wallet_balance_amount.dart';
import '../widgets/activation_countdown.dart';
// sliders removed from home page
import '../widgets/cloud_image_slider.dart';
import '../Account&setting/Refferal Code.dart';
import '../Advice/advice_list.dart';
import 'package:juststock/api/advice_api.dart';
import '../services/advice_seen_store.dart';
import '../services/daily_tip_notifier.dart';
import '../services/in_app_notification_center.dart';
import '../widgets/pulse_badge.dart';
import 'Search.dart';
import 'crypto_.dart';
import 'gold_.dart';
import '../DailyTip/daily_tip_page.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class home extends StatefulWidget {
  const home({super.key});

  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> with SingleTickerProviderStateMixin {
  static const String _whatsappPhone = '919898767665';
  Future<void> _openWhatsApp() async {
    final profile = await ProfileApi.fetchProfile();
    final rawEmail = profile?['email'] ?? profile?['userEmail'];
    final email = rawEmail?.toString().trim();
    final message = (email != null && email.isNotEmpty)
        ? 'Hi, I need help with Just Stock. My email is $email.'
        : 'Hi, I need help with Just Stock.';
    final encoded = Uri.encodeComponent(message);
    final uri = Uri.parse('https://wa.me/$_whatsappPhone?text=$encoded');
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  int currentindex = 0;
  int selectIndex = 0;
  bool _password = true;
  final List<String> _cats = const ['stocks', 'options', 'future', 'commodity'];
  final Map<String, AdviceMeta?> _latestByCat = {};
  final Map<String, bool> _unread = {};

  List page = [
    const Crypto_(),
    const Stock(),
    const gold(),
    const nfts(),
  ];

  List text = [
    "Crypto Assets",
    "US Stock",
    "Gold",
    "NFTs",
  ];

  String? selectedVideo;
  int selectedIndex = 0;

  late final TabController _tabController;

  String getVideoId(String url) {
    return YoutubePlayer.convertUrlToId(url) ?? "";
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _refreshUnread();
    super.initState();
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _refreshUnread() async {
    for (final cat in _cats) {
      try {
        final latest = await AdviceApi.latest(category: cat);
        _latestByCat[cat] = latest;
        final seen = await AdviceSeenStore.getSeenId(cat);
        final latestId = latest?.id;
        final isUnread =
            latestId != null && latestId.isNotEmpty && latestId != seen;
        if (mounted) setState(() => _unread[cat] = isUnread);
      } catch (_) {
        // ignore errors silently on home badges
      }
    }
  }

  Future<void> _openCategory(String cat) async {
    final latest = _latestByCat[cat];
    if (latest != null && latest.id.isNotEmpty) {
      await AdviceSeenStore.markSeen(cat, latest.id);
      if (mounted) setState(() => _unread[cat] = false);
    }
    if (!mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AdviceListPage(category: cat)),
    ).then((_) => _refreshUnread());
  }

  ColorNotifire notifier = ColorNotifire();

  @override
  Widget build(BuildContext context) {
    notifier = Provider.of<ColorNotifire>(context, listen: true);
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    final notificationCenter = Provider.of<NotificationCenter>(context);
    final hasUnreadAdmin =
        notificationCenter.advisoryNotifications.any((item) => !item.isRead);
    final dailyTipNotifier = Provider.of<DailyTipNotifier>(context);
    final hasNewDailyTip = dailyTipNotifier.hasNewTip;
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: notifier.background,
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          title: Row(
            children: [
              Image.asset(
                'lib/assets/inside-logo.png',
                width: 140,
                fit: BoxFit.contain,
              ),
            ],
          ),
          actionsIconTheme: const IconThemeData(size: 22),
          actions: [
            IconButton(
              tooltip: 'WhatsApp',
              onPressed: _openWhatsApp,
              icon: const FaIcon(FontAwesomeIcons.whatsapp,
                  color: Color(0xFF25D366)),
            ),
            Stack(
              clipBehavior: Clip.none,
              children: [
                IconButton(
                  tooltip: 'Daily Tip',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const DailyTipPage()),
                    );
                  },
                  icon: const FaIcon(FontAwesomeIcons.lightbulb,
                      color: Color(0xFFF59E0B)),
                ),
                if (hasNewDailyTip)
                  const Positioned(
                    top: 6,
                    right: 6,
                    child: PulseBadge(
                      size: 16,
                      color: Color(0xFFF59E0B),
                    ),
                  ),
              ],
            ),
            Stack(
              clipBehavior: Clip.none,
              children: [
                IconButton(
                  tooltip: 'Notifications',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Notifications(),
                      ),
                    );
                  },
                  icon: Image.asset(
                    "assets/images/notification.png",
                    height: 22,
                    width: 22,
                  ),
                ),
                if (hasUnreadAdmin)
                  const Positioned(
                    top: 6,
                    right: 6,
                    child: PulseBadge(
                      size: 16,
                      color: Color(0xFF8B0000),
                    ),
                  ),
              ],
            ),
          ],
          backgroundColor: notifier.background,
        ),
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
                      alignment: Alignment.center,
                      children: [
                        Container(
                          clipBehavior: Clip.none,
                          alignment: Alignment.center,
                          height: 190,
                          width: double.infinity,
                          decoration: const BoxDecoration(
                              image: DecorationImage(
                            image:
                                AssetImage("assets/images/Background (1).png"),
                            fit: BoxFit.cover,
                          )),
                          child: Padding(
                            padding: const EdgeInsets.only(top: 40, left: 15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Total wallet balance",
                                  style: TextStyle(
                                      color: Color(0xffFFFFFF),
                                      fontSize: 15,
                                      fontFamily: "Manrope-Regular"),
                                ),
                                AppConstants.Height(10),
                                Row(
                                  children: [
                                    WalletBalanceAmount(
                                      visible: _password,
                                      style: const TextStyle(
                                        fontSize: 32,
                                        color: Color(0xffFFFFFF),
                                      ),
                                    ),
                                    AppConstants.Width(10),
                                    GestureDetector(
                                        onTap: () {
                                          setState(
                                            () {
                                              _password = !_password;
                                            },
                                          );
                                        },
                                        child: _password
                                            ? const Icon(
                                                Icons.remove_red_eye_outlined,
                                                size: 24,
                                                color: Colors.white)
                                            : const Icon(
                                                Icons.visibility_off_outlined,
                                                size: 24,
                                                color: Colors.white)),
                                    // Expand
                                    const Spacer(),
                                    // Removed green growth badge on wallet header
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: -60,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              height: 90,
                              width: 330,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: notifier.onboardBackgroundColor,
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  InkWell(
                                    onTap: () => _openCategory('stocks'),
                                    child: Container(
                                      height: height / 12,
                                      width: width / 7,
                                      color: notifier.onboardBackgroundColor,
                                      child: Stack(
                                        children: [
                                          Center(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(Icons.stacked_line_chart,
                                                    size: 26,
                                                    color: notifier.bottom),
                                                AppConstants.Height(4),
                                                const SizedBox(
                                                  width: 68,
                                                  child: Text(
                                                    "Stocks",
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        color:
                                                            Color(0xff64748B),
                                                        fontFamily:
                                                            "Manrope-Bold"),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          if (_unread['stocks'] == true)
                                            const Positioned(
                                              right: 4,
                                              top: 6,
                                              child: _BlinkingBellBadge(),
                                            ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () => _openCategory('options'),
                                    child: Container(
                                      height: height / 12,
                                      width: width / 7,
                                      color: notifier.onboardBackgroundColor,
                                      child: Stack(
                                        children: [
                                          Center(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Icon(Icons.swap_calls,
                                                    size: 26,
                                                    color: notifier.bottom),
                                                AppConstants.Height(4),
                                                const SizedBox(
                                                  width: 68,
                                                  child: Text(
                                                    "Options",
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        color:
                                                            Color(0xff64748B),
                                                        fontFamily:
                                                            "Manrope-Bold"),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          if (_unread['options'] == true)
                                            const Positioned(
                                              right: 4,
                                              top: 6,
                                              child: _BlinkingBellBadge(),
                                            ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () => _openCategory('future'),
                                    child: Container(
                                      height: height / 12,
                                      width: width / 7,
                                      color: notifier.onboardBackgroundColor,
                                      child: Stack(
                                        children: [
                                          Center(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Icon(Icons.timeline,
                                                    size: 26,
                                                    color: notifier.bottom),
                                                AppConstants.Height(4),
                                                const SizedBox(
                                                  width: 68,
                                                  child: Text(
                                                    "Future",
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        color:
                                                            Color(0xff64748B),
                                                        fontFamily:
                                                            "Manrope-Bold"),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          if (_unread['future'] == true)
                                            const Positioned(
                                              right: 4,
                                              top: 6,
                                              child: _BlinkingBellBadge(),
                                            ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () => _openCategory('commodity'),
                                    child: Container(
                                      height: height / 12,
                                      width: width / 7,
                                      color: notifier.onboardBackgroundColor,
                                      child: Stack(
                                        children: [
                                          Center(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Icon(
                                                    Icons.shopping_bag_outlined,
                                                    size: 26,
                                                    color: notifier.bottom),
                                                AppConstants.Height(4),
                                                const SizedBox(
                                                  width: 68,
                                                  child: Text(
                                                    "Commodity",
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        color:
                                                            Color(0xff64748B),
                                                        fontFamily:
                                                            "Manrope-Bold"),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          if (_unread['commodity'] == true)
                                            const Positioned(
                                              right: 4,
                                              top: 6,
                                              child: _BlinkingBellBadge(),
                                            ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    AppConstants.Height(80),
                  ],
                ),
              ),
            ];
          },
          body: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Row(
                  children: [
                    Text(
                      "Activation Countdown",
                      style: TextStyle(
                        fontSize: 17,
                        fontFamily: "Manrope-Bold",
                        color: notifier.textColor,
                      ),
                    ),
                  ],
                ),
              ),
              AppConstants.Height(15),
              const Padding(
                padding: EdgeInsets.only(left: 10, right: 10),
                child: ActivationCountdownCard(),
              ),
              Column(
                children: [
                  // Wallet balance + Add money card
                  const WalletBalanceCard(),
                  AppConstants.Height(20),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: SizedBox(
                      height: 408,
                      child: Card(
                        margin: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                          child: HomeVedioPage(),
                        ),
                      ),
                    ),
                  ),
                  AppConstants.Height(20),

                  // Earn up to 5% APR promo card (restored)
                  Stack(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Reffle_code()),
                          );
                        },
                        child: Container(
                          height: height / 5.5,
                          decoration: BoxDecoration(
                            color: notifier.earn,
                            borderRadius: BorderRadius.circular(15),
                            border:
                                Border.all(color: notifier.getContainerBorder),
                          ),
                          child: const Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 20),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Your Referral Code Awaits!',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontFamily: 'Manrope-Bold',
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      'Share it. Earn cashbacks. Repeat.',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontFamily: 'Manrope-Regular',
                                        color: Color(0xff64748B),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Spacer(),
                              const Padding(
                                padding: EdgeInsets.only(right: 20),
                                child: Image(
                                  image: AssetImage(
                                      'assets/images/Piggy bank.png'),
                                  height: 96,
                                  width: 90,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // HomeVedioPage(),
                  const SizedBox(height: 12),
                  const CloudImageSlider(limit: 5),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BlinkingBellBadge extends StatefulWidget {
  const _BlinkingBellBadge();

  @override
  State<_BlinkingBellBadge> createState() => _BlinkingBellBadgeState();
}

class _BlinkingBellBadgeState extends State<_BlinkingBellBadge>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 950),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final t = _controller.value;
        return Opacity(
          opacity: 0.6 + (0.4 * t),
          child: Transform.scale(
            scale: 0.9 + (0.2 * t),
            child: Container(
              height: 18,
              width: 18,
              decoration: BoxDecoration(
                color: const Color(0xFF7F1D1D),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFEF4444).withOpacity(0.65),
                    blurRadius: 6 + (6 * t),
                    spreadRadius: 0.8,
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: const Icon(
                Icons.notifications_active_rounded,
                size: 11,
                color: Colors.white,
              ),
            ),
          ),
        );
      },
    );
  }
}
