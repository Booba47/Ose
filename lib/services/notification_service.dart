class NotificationService {
  static final List<String> _notifications = [];

  static List<String> get notifications {
    return List.unmodifiable(_notifications);
  }

  static Future<void> addNotification(String message) async {
    final text = message.trim();

    if (text.isEmpty) {
      return;
    }

    _notifications.insert(0, text);
  }

  static Future<void> removeNotification(String message) async {
    _notifications.remove(message);
  }

  static Future<void> clear() async {
    _notifications.clear();
  }

  static bool get hasNotifications {
    return _notifications.isNotEmpty;
  }

  static int get notificationCount {
    return _notifications.length;
  }

  static String? get latestNotification {
    if (_notifications.isEmpty) {
      return null;
    }

    return _notifications.first;
  }
}
