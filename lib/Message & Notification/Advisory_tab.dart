
// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../Dark mode.dart';
import '../config/common.dart';
import '../services/in_app_notification_center.dart';
import 'notification_filter.dart';

class AdvisoryTab extends StatelessWidget {
  const AdvisoryTab({super.key, required this.filter});

  final NotificationViewFilter filter;

  @override
  Widget build(BuildContext context) {
    final notifier = Provider.of<ColorNotifire>(context, listen: true);
    final center = context.watch<NotificationCenter>();
    final items = center.advisoryNotifications.where((item) => filter.allows(item.isRead)).toList();

    if (items.isEmpty) {
      return _EmptyState(
        icon: Icons.support_agent_outlined,
        message: "No advisory calls yet.\nYou’ll be notified the moment admin posts one.",
        notifier: notifier,
      );
    }

    return RefreshIndicator(
      onRefresh: () => center.refreshAdvisories(),
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        itemCount: items.length,
        separatorBuilder: (_, __) => Divider(color: notifier.getContainerBorder),
        itemBuilder: (context, index) {
          final item = items[index];
          return ListTile(
            contentPadding: EdgeInsets.zero,
            onTap: () => _openDetail(context, center, item),
            leading: CircleAvatar(
              backgroundColor: notifier.onboardBackgroundColor,
              child: const Icon(Icons.campaign_rounded, color: Color(0xFF8B0000)),
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
                if (!item.isRead)
                  Container(
                    height: 10,
                    width: 10,
                    decoration: const BoxDecoration(
                      color: Color(0xFF8B0000),
                      shape: BoxShape.circle,
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
                AppConstants.Height(6),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF8B0000).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Text(
                        item.category ?? 'ADVISORY',
                        style: const TextStyle(
                          fontSize: 11,
                          fontFamily: "Manrope-Bold",
                          color: Color(0xFF8B0000),
                        ),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      _formatTimestamp(item),
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xff94A3B8),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _openDetail(
    BuildContext context,
    NotificationCenter center,
    InAppNotification item,
  ) {
    center.markAsRead(item.id);
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.title,
                style: const TextStyle(
                  fontSize: 16,
                  fontFamily: "Manrope-Bold",
                ),
              ),
              AppConstants.Height(10),
              Text(
                item.body,
                style: const TextStyle(
                  fontSize: 14,
                  fontFamily: "Manrope-Regular",
                  color: Color(0xff475569),
                ),
              ),
              AppConstants.Height(15),
              Text(
                "Posted on ${item.createdAtLocalText ?? DateFormat('MMM d, yyyy – hh:mm a').format(item.createdAt)}",
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xff94A3B8),
                ),
              ),
              AppConstants.Height(5),
              Text(
                "Category: ${item.category ?? 'N/A'}",
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xff94A3B8),
                ),
              ),
              AppConstants.Height(20),
              FilledButton(
                onPressed: () => Navigator.of(ctx).pop(),
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(48),
                ),
                child: const Text("Close"),
              ),
            ],
          ),
        );
      },
    );
  }

  static String _formatTimestamp(InAppNotification item) {
    final timestamp = item.createdAt;
    final now = DateTime.now();
    final diff = now.difference(timestamp);
    if (diff.inMinutes < 1) return "Just now";
    if (diff.inHours < 1) return "${diff.inMinutes}m ago";
    if (diff.inDays < 1) return "${diff.inHours}h ago";
    return item.createdAtLocalText ?? DateFormat("d MMM, hh:mm a").format(timestamp);
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
