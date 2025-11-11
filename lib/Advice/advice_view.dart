import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:crowwn/api/advice_api.dart';
import '../Dark mode.dart';

class AdviceViewPage extends StatelessWidget {
  final AdviceDetail advice;
  AdviceViewPage({super.key, required this.advice});

  final _fmt = DateFormat('dd MMM, hh:mm a');

  @override
  Widget build(BuildContext context) {
    final notifier = Provider.of<ColorNotifire>(context, listen: true);
    return Scaffold(
      backgroundColor: notifier.background,
      appBar: AppBar(
        backgroundColor: notifier.background,
        elevation: 0,
        title: Text(advice.category.toUpperCase(), style: TextStyle(color: notifier.textColor)),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            (advice.text ?? '').toUpperCase(),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: notifier.textColor,
              fontSize: 22,
              height: 1.5,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ),
    );
  }

  // Additional details are intentionally hidden per UX: only message is shown.
}

