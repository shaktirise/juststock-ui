// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../Dark mode.dart';
import '../config/common.dart';
import '../services/in_app_notification_center.dart';
import 'notification_filter.dart';

class InformationTab extends StatelessWidget {
  const InformationTab({super.key, required this.filter});

  final NotificationViewFilter filter;

  @override
  Widget build(BuildContext context) {
    final notifier = Provider.of<ColorNotifire>(context, listen: true);
    final center = context.watch<NotificationCenter>();
    final items = center.informationNotifications.where((item) => filter.allows(item.isRead)).toList();

    if (items.isEmpty) {
      return _EmptyState(
        icon: Icons.notifications_off_outlined,
        message: "No deposit or withdraw activity yet.",
        notifier: notifier,
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      itemCount: items.length,
      separatorBuilder: (_, __) => Divider(color: notifier.getContainerBorder),
      itemBuilder: (context, index) {
        final item = items[index];
        final tag = (item.tag ?? 'info').toLowerCase();
        final color = _tagColor(tag);
        final amount = item.amount != null ? _formatAmount(item.amount!, item.currency) : null;
        return ListTile(
          contentPadding: EdgeInsets.zero,
          leading: CircleAvatar(
            backgroundColor: notifier.onboardBackgroundColor,
            child: Icon(
              tag == 'deposit' ? Icons.south_west : Icons.north_east,
              color: color,
            ),
          ),
          title: Row(
            children: [
              Expanded(
                child: Text(
                  item.title,
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: "Manrope-Bold",
                    color: notifier.textColor,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                _relativeTime(item.createdAt),
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xff94A3B8),
                ),
              ),
            ],
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppConstants.Height(5),
              Text(
                item.body,
                style: const TextStyle(
                  fontSize: 12,
                  fontFamily: "Manrope-Regular",
                  color: Color(0xff64748B),
                ),
              ),
              if (amount != null) ...[
                AppConstants.Height(5),
                Text(
                  amount,
                  style: const TextStyle(
                    fontSize: 12,
                    fontFamily: "Manrope-Bold",
                    color: Color(0xff0F172A),
                  ),
                ),
              ],
              AppConstants.Height(6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  tag.toUpperCase(),
                  style: TextStyle(
                    fontSize: 11,
                    fontFamily: "Manrope-Bold",
                    color: color,
                  ),
                ),
              ),
            ],
          ),
          onTap: () => center.markAsRead(item.id),
        );
      },
    );
  }

  static Color _tagColor(String tag) {
    switch (tag) {
      case 'deposit':
        return const Color(0xFF16A34A);
      case 'withdraw':
        return const Color(0xFFF97316);
      default:
        return const Color(0xFF0F172A);
    }
  }

  static String _relativeTime(DateTime timestamp) {
    final now = DateTime.now();
    final diff = now.difference(timestamp);
    if (diff.inMinutes < 1) return "Just now";
    if (diff.inHours < 1) return "${diff.inMinutes}m ago";
    if (diff.inDays < 1) return "${diff.inHours}h ago";
    return DateFormat("d MMM, hh:mm a").format(timestamp);
  }

  static String _formatAmount(double value, String? currency) {
    final upper = currency?.toUpperCase();
    final symbol = upper == 'USD'
        ? '\$'
        : upper == null || upper == 'INR'
            ? '₹'
            : upper;
    final formatter = NumberFormat.currency(symbol: symbol, decimalDigits: 2);
    return formatter.format(value);
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({
    required this.icon,
    required this.message,
    required this.notifier,
  });

  final IconData icon;
  final String message;
  final ColorNotifire notifier;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: notifier.getContainerBorder),
            AppConstants.Height(20),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                fontFamily: "Manrope-Medium",
                color: Color(0xff94A3B8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
