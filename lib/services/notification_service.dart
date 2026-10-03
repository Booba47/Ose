class NotificationItem {
  final String id;
  final String message;
  final String type;
  final DateTime createdAt;
  final bool isRead;

  const NotificationItem({
    required this.id,
    required this.message,
    required this.type,
    required this.createdAt,
    this.isRead = false,
  });

  NotificationItem copyWith({
    String? id,
    String? message,
    String? type,
    DateTime? createdAt,
    bool? isRead,
  }) {
    return NotificationItem(
      id: id ?? this.id,
      message: message ?? this.message,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
      isRead: isRead ?? this.isRead,
    );
  }
}

class NotificationService {
  static final List<NotificationItem> _notifications = [];

  /// Retourne toutes les notifications.
  static List<NotificationItem> get notifications {
    return List.unmodifiable(_notifications);
  }

  /// Ajoute une notification.
  static Future<void> addNotification({
    required String message,
    String type = 'general',
  }) async {
    final cleanMessage = message.trim();
    final cleanType = type.trim();

    if (cleanMessage.isEmpty) {
      return;
    }

    final notification = NotificationItem(
      id: 'notification_${DateTime.now().microsecondsSinceEpoch}',
      message: cleanMessage,
      type: cleanType.isEmpty ? 'general' : cleanType,
      createdAt: DateTime.now(),
      isRead: false,
    );

    _notifications.insert(0, notification);
  }

  /// Notification pour un nouveau match.
  static Future<void> addMatchNotification({
    required String profileName,
  }) async {
    final name = profileName.trim();

    if (name.isEmpty) {
      return;
    }

    await addNotification(
      message: 'Tu as un nouveau match avec $name 💕',
      type: 'match',
    );
  }

  /// Notification pour un nouveau message.
  static Future<void> addMessageNotification({
    required String profileName,
    required String message,
  }) async {
    final name = profileName.trim();
    final text = message.trim();

    if (name.isEmpty || text.isEmpty) {
      return;
    }

    await addNotification(
      message: '$name t’a envoyé un message 💬',
      type: 'message',
    );
  }

  /// Marque une notification comme lue.
  static Future<void> markAsRead(
    String notificationId,
  ) async {
    final index = _notifications.indexWhere(
      (notification) =>
          notification.id == notificationId,
    );

    if (index == -1) {
      return;
    }

    _notifications[index] =
        _notifications[index].copyWith(
      isRead: true,
    );
  }

  /// Marque toutes les notifications comme lues.
  static Future<void> markAllAsRead() async {
    for (var i = 0; i < _notifications.length; i++) {
      if (!_notifications[i].isRead) {
        _notifications[i] =
            _notifications[i].copyWith(
          isRead: true,
        );
      }
    }
  }

  /// Supprime une notification.
  static Future<void> removeNotification(
    String notificationId,
  ) async {
    _notifications.removeWhere(
      (notification) =>
          notification.id == notificationId,
    );
  }

  /// Nombre total de notifications.
  static int get notificationCount {
    return _notifications.length;
  }

  /// Nombre de notifications non lues.
  static int get unreadCount {
    return _notifications
        .where((notification) => !notification.isRead)
        .length;
  }

  /// Vérifie s'il existe des notifications non lues.
  static bool get hasUnreadNotifications {
    return unreadCount > 0;
  }

  /// Retourne la dernière notification.
  static NotificationItem? get latestNotification {
    if (_notifications.isEmpty) {
      return null;
    }

    return _notifications.first;
  }

  /// Supprime toutes les notifications.
  static Future<void> clear() async {
    _notifications.clear();
  }
}
