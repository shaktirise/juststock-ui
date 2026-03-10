// ignore_for_file: file_names

import 'package:flutter/material.dart';

import 'mutual_fund.dart';

/// Kept for backward compatibility with old routes.
/// Portfolio now shows the Mutual Fund enrollment form.
class Portfolio extends StatelessWidget {
  const Portfolio({super.key});

  @override
  Widget build(BuildContext context) {
    return const MutualFundPage();
  }
}
