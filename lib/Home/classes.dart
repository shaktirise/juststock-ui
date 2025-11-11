import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Dark mode.dart';
import '../config/common.dart';

class ClassesPage extends StatelessWidget {
  const ClassesPage({super.key});

  static final Uri _classesUri = Uri.parse('https://juststock.in/classes/');

  Future<void> _openClasses() async {
    await launchUrl(_classesUri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    final notifier = Provider.of<ColorNotifire>(context, listen: true);

    // Requested items
    const items = [
      (
        'JustStock Classes',
        'Learn trading the fun and simple way. Swipe, watch, and grow your skills daily.'
      ),
      (
        'How to Use the App',
        'Learn How to Use the App Step by Step'
      ),
      (
        'How to Register',
        'How to Register and Create Your Account Easily'
      ),
      (
        'How to Recharge',
        'How to Recharge Your Account in Just a Few Steps'
      ),
      (
        'How to Open Calls',
        'How to Open and Make Calls Instantly'
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
              // Cards content (each opens the classes URL)
              ...items.map((e) => _courseCard(
                    context,
                    notifier,
                    title: e.$1,
                    description: e.$2,
                  )),
              // Access Videos button removed per request
            ],
          ),
        ),
      ),
    );
  }

  Widget _courseCard(
    BuildContext context,
    ColorNotifire n, {
    required String title,
    required String description,
  }) {
    return GestureDetector(
      onTap: _openClasses,
      child: Container(
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
                child: Image.asset(
                  'assets/images/card_1.png',
                  width: 84,
                  height: 84,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: 'Manrope-Bold',
                        fontSize: 16,
                        color: n.textColor,
                      ),
                    ),
                    if (description.isNotEmpty) ...[
                      AppConstants.Height(6),
                      Text(
                        description,
                        style: const TextStyle(fontSize: 14, color: Color(0xff64748B)),
                      ),
                    ]
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
