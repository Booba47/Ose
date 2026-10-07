class PreferencesService {
  static bool _notificationsEnabled = true;
  static bool _showOnlineStatus = true;
  static bool _showReadReceipts = true;

  /// Notifications activées ou non.
  static bool get notificationsEnabled {
    return _notificationsEnabled;
  }

  static Future<void> setNotificationsEnabled(
    bool value,
  ) async {
    _notificationsEnabled = value;
  }

  /// Affichage du statut en ligne.
  static bool get showOnlineStatus {
    return _showOnlineStatus;
  }

  static Future<void> setShowOnlineStatus(
    bool value,
  ) async {
    _showOnlineStatus = value;
  }

  /// Affichage des accusés de lecture.
  static bool get showReadReceipts {
    return _showReadReceipts;
  }

  static Future<void> setShowReadReceipts(
    bool value,
  ) async {
    _showReadReceipts = value;
  }

  /// Active/désactive les notifications.
  static Future<void> toggleNotifications() async {
    _notificationsEnabled = !_notificationsEnabled;
  }

  /// Active/désactive le statut en ligne.
  static Future<void> toggleOnlineStatus() async {
    _showOnlineStatus = !_showOnlineStatus;
  }

  /// Active/désactive les accusés de lecture.
  static Future<void> toggleReadReceipts() async {
    _showReadReceipts = !_showReadReceipts;
  }

  /// Réinitialise toutes les préférences.
  static Future<void> clear() async {
    _notificationsEnabled = true;
    _showOnlineStatus = true;
    _showReadReceipts = true;
  }
} 
