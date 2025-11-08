enum NotificationViewFilter { all, read, unread }

extension NotificationViewFilterX on NotificationViewFilter {
  bool allows(bool isRead) {
    switch (this) {
      case NotificationViewFilter.all:
        return true;
      case NotificationViewFilter.read:
        return isRead;
      case NotificationViewFilter.unread:
        return !isRead;
    }
  }
}
