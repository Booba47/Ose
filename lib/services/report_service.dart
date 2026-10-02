class ReportService {
  static final List<Map<String, String>> _reports = [];

  /// Signale un profil.
  static Future<void> reportProfile({
    required String profileId,
    required String reason,
  }) async {
    final cleanProfileId = profileId.trim();
    final cleanReason = reason.trim();

    if (cleanProfileId.isEmpty || cleanReason.isEmpty) {
      return;
    }

    _reports.add({
      'profileId': cleanProfileId,
      'reason': cleanReason,
    });
  }

  /// Retourne les signalements enregistrés.
  static List<Map<String, String>> get reports {
    return List.unmodifiable(_reports);
  }

  /// Nombre de signalements.
  static int get reportCount {
    return _reports.length;
  }

  /// Supprime tous les signalements locaux.
  static Future<void> clear() async {
    _reports.clear();
  }
}
