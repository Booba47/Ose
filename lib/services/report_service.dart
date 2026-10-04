class ReportService {
  static final List<Map<String, String>> _reports = [];

  /// Enregistre un signalement.
  static Future<void> reportProfile({
    required String profileId,
    required String reason,
  }) async {
    final cleanProfileId = profileId.trim();
    final cleanReason = reason.trim();

    if (cleanProfileId.isEmpty ||
        cleanReason.isEmpty) {
      return;
    }

    _reports.add({
      'profileId': cleanProfileId,
      'reason': cleanReason,
    });
  }

  /// Tous les signalements locaux.
  static List<Map<String, String>> get reports {
    return List.unmodifiable(
      _reports,
    );
  }

  /// Nombre de signalements.
  static int get reportCount {
    return _reports.length;
  }

  /// Vérifie si un profil a déjà été signalé.
  static bool hasReported(
    String profileId,
  ) {
    final cleanProfileId = profileId.trim();

    if (cleanProfileId.isEmpty) {
      return false;
    }

    return _reports.any(
      (report) =>
          report['profileId'] == cleanProfileId,
    );
  }

  /// Supprime les signalements d'un profil.
  static Future<void> clearReportsForProfile(
    String profileId,
  ) async {
    final cleanProfileId = profileId.trim();

    if (cleanProfileId.isEmpty) {
      return;
    }

    _reports.removeWhere(
      (report) =>
          report['profileId'] == cleanProfileId,
    );
  }

  /// Supprime tous les signalements locaux.
  static Future<void> clear() async {
    _reports.clear();
  }
} 
