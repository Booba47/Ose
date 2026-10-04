class NotificationService {
  static final List<Map<String, dynamic>> _notifications = [];

  /// Ajoute une notification locale.
  static Future<void> addNotification({
    required String message,
  }) async {
    final cleanMessage = message.trim();

    if (cleanMessage.isEmpty) {
      return;
    }

    _notifications.insert(
      0,
      {
        'id': DateTime.now()
            .microsecondsSinceEpoch
            .toString(),
        'message': cleanMessage,
        'createdAt': DateTime.now(),
        'isRead': false,
      },
    );
  }

  /// Toutes les notifications.
  static List<Map<String, dynamic>> get notifications {
    return List.unmodifiable(
      _notifications,
    );
  }

  /// Nombre total de notifications.
  static int get notificationCount {
    return _notifications.length;
  }

  /// Nombre de notifications non lues.
  static int get unreadCount {
    return _notifications.where(
      (notification) {
        return notification['isRead'] != true;
      },
    ).length;
  }

  /// Indique s'il existe des notifications non lues.
  static bool get hasUnreadNotifications {
    return unreadCount > 0;
  }

  /// Marque toutes les notifications comme lues.
  static Future<void> markAllAsRead() async {
    for (var i = 0; i < _notifications.length; i++) {
      _notifications[i] = {
        ..._notifications[i],
        'isRead': true,
      };
    }
  }

  /// Marque une notification précise comme lue.
  static Future<void> markAsRead(
    String notificationId,
  ) async {
    final index = _notifications.indexWhere(
      (notification) =>
          notification['id'] == notificationId,
    );

    if (index == -1) {
      return;
    }

    _notifications[index] = {
      ..._notifications[index],
      'isRead': true,
    };
  }

  /// Supprime une notification.
  static Future<void> removeNotification(
    String notificationId,
  ) async {
    _notifications.removeWhere(
      (notification) =>
          notification['id'] == notificationId,
    );
  }

  /// Supprime toutes les notifications.
  static Future<void> clear() async {
    _notifications.clear();
  }
} 
