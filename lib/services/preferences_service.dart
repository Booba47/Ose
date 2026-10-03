class PreferencesService {
  static bool _notificationsEnabled = true;
  static bool _showOnlineStatus = true;
  static bool _showReadReceipts = true;

  /// Notifications activées ou désactivées.
  static bool get notificationsEnabled {
    return _notificationsEnabled;
  }

  static Future<void> setNotificationsEnabled(
    bool value,
  ) async {
    _notificationsEnabled = value;
  }

  /// Afficher ou masquer le statut en ligne.
  static bool get showOnlineStatus {
    return _showOnlineStatus;
  }

  static Future<void> setShowOnlineStatus(
    bool value,
  ) async {
    _showOnlineStatus = value;
  }

  /// Afficher ou masquer les accusés de lecture.
  static bool get showReadReceipts {
    return _showReadReceipts;
  }

  static Future<void> setShowReadReceipts(
    bool value,
  ) async {
    _showReadReceipts = value;
  }

  /// Active toutes les notifications.
  static Future<void> enableNotifications() async {
    _notificationsEnabled = true;
  }

  /// Désactive toutes les notifications.
  static Future<void> disableNotifications() async {
    _notificationsEnabled = false;
  }

  /// Active l'affichage du statut en ligne.
  static Future<void> enableOnlineStatus() async {
    _showOnlineStatus = true;
  }

  /// Désactive l'affichage du statut en ligne.
  static Future<void> disableOnlineStatus() async {
    _showOnlineStatus = false;
  }

  /// Active les accusés de lecture.
  static Future<void> enableReadReceipts() async {
    _showReadReceipts = true;
  }

  /// Désactive les accusés de lecture.
  static Future<void> disableReadReceipts() async {
    _showReadReceipts = false;
  }

  /// Réinitialise toutes les préférences.
  static Future<void> clear() async {
    _notificationsEnabled = true;
    _showOnlineStatus = true;
    _showReadReceipts = true;
  }

  /// Réinitialise les préférences aux valeurs par défaut.
  static Future<void> resetToDefaults() async {
    await clear();
  }
}
