class NotificationService {
  static final List<String> _notifications = [];

  /// Retourne toutes les notifications.
  static List<String> get notifications {
    return List.unmodifiable(_notifications);
  }

  /// Ajoute une notification.
  static Future<void> addNotification(
    String message,
  ) async {
    final text = message.trim();

    if (text.isEmpty) {
      return;
    }

    _notifications.insert(0, text);
  }

  /// Indique si des notifications existent.
  static bool get hasNotifications {
    return _notifications.isNotEmpty;
  }

  /// Nombre de notifications.
  static int get notificationCount {
    return _notifications.length;
  }

  /// Supprime une notification.
  static Future<void> removeNotification(
    String message,
  ) async {
    _notifications.remove(message);
  }

  /// Supprime toutes les notifications.
  static Future<void> clear() async {
    _notifications.clear();
  }
}
