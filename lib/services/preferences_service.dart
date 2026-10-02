class PreferencesService {
  static bool _notificationsEnabled = true;
  static bool _showOnlineStatus = true;
  static bool _showReadReceipts = true;

  /// Notifications activées ou non.
  static bool get notificationsEnabled {
    return _notificationsEnabled;
  }

  /// Modifie l'état des notifications.
  static Future<void> setNotificationsEnabled(
    bool value,
  ) async {
    _notificationsEnabled = value;
  }

  /// Affichage du statut en ligne.
  static bool get showOnlineStatus {
    return _showOnlineStatus;
  }

  /// Modifie l'affichage du statut en ligne.
  static Future<void> setShowOnlineStatus(
    bool value,
  ) async {
    _showOnlineStatus = value;
  }

  /// Affichage des confirmations de lecture.
  static bool get showReadReceipts {
    return _showReadReceipts;
  }

  /// Modifie l'affichage des confirmations de lecture.
  static Future<void> setShowReadReceipts(
    bool value,
  ) async {
    _showReadReceipts = value;
  }

  /// Réinitialise les préférences.
  static Future<void> clear() async {
    _notificationsEnabled = true;
    _showOnlineStatus = true;
    _showReadReceipts = true;
  }
}
