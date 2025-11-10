import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Dark mode.dart';
import '../config/common.dart';

class ClassesPage extends StatelessWidget {
  const ClassesPage({super.key});

  Future<void> _openClasses() async {
    // Open JustStock classes page
    final uri = Uri.parse('https://juststock.in/classes');
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    final notifier = Provider.of<ColorNotifire>(context, listen: true);
    final items = const [
      (
        'JustStock Classes',
        'Learn trading the fun and simple way.\nSwipe, watch, and grow your skills daily.'
      ),
      (
        'Welcome to JustStock!',
        'Jump into easy, practical lessons on trading — built for real-world results.'
      ),
      (
        'JustStock Learning Space',
        'Where confident traders begin their journey.\nExplore, learn, and trade smarter.'
      ),
      (
        'Hey Trader 👋',
        'Your JustStock Classes are ready.\nLet’s learn, practice, and win together!'
      ),
    ];

    return Scaffold(
      backgroundColor: notifier.background,
      appBar: AppBar(
        backgroundColor: notifier.background,
        elevation: 0,
        title: Text('Classes', style: TextStyle(color: notifier.textColor)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Cards content
              ...items.map((e) => _courseCard(context, notifier,
                  title: e.$1, description: e.$2)),
              AppConstants.Height(16),
              // CTA button at the bottom
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8B0000),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: _openClasses,
                  child: const Text('Access Videos', style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _courseCard(BuildContext context, ColorNotifire n,
      {required String title, required String description}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: n.background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: n.getContainerBorder),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset('assets/images/card_1.png', width: 84, height: 84, fit: BoxFit.cover),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontFamily: 'Manrope-Bold', fontSize: 14, color: n.textColor)),
                  AppConstants.Height(6),
                  Text(
                    description,
                    style: const TextStyle(fontSize: 12, color: Color(0xff64748B)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
