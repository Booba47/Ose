class ReportItem {
  final String id;
  final String profileId;
  final String reason;
  final DateTime createdAt;

  const ReportItem({
    required this.id,
    required this.profileId,
    required this.reason,
    required this.createdAt,
  });

  ReportItem copyWith({
    String? id,
    String? profileId,
    String? reason,
    DateTime? createdAt,
  }) {
    return ReportItem(
      id: id ?? this.id,
      profileId: profileId ?? this.profileId,
      reason: reason ?? this.reason,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class ReportService {
  static final List<ReportItem> _reports = [];

  /// Signale un profil.
  static Future<bool> reportProfile({
    required String profileId,
    required String reason,
  }) async {
    final cleanProfileId = profileId.trim();
    final cleanReason = reason.trim();

    if (cleanProfileId.isEmpty ||
        cleanReason.isEmpty) {
      return false;
    }

    final report = ReportItem(
      id: 'report_${DateTime.now().microsecondsSinceEpoch}',
      profileId: cleanProfileId,
      reason: cleanReason,
      createdAt: DateTime.now(),
    );

    _reports.insert(0, report);

    return true;
  }

  /// Retourne tous les signalements.
  static List<ReportItem> get reports {
    return List.unmodifiable(_reports);
  }

  /// Vérifie si un profil a déjà été signalé.
  static bool hasReportedProfile(
    String profileId,
  ) {
    final cleanProfileId = profileId.trim();

    if (cleanProfileId.isEmpty) {
      return false;
    }

    return _reports.any(
      (report) =>
          report.profileId == cleanProfileId,
    );
  }

  /// Retourne les signalements concernant un profil.
  static List<ReportItem> getReportsForProfile(
    String profileId,
  ) {
    final cleanProfileId = profileId.trim();

    if (cleanProfileId.isEmpty) {
      return const [];
    }

    return List.unmodifiable(
      _reports.where(
        (report) =>
            report.profileId == cleanProfileId,
      ),
    );
  }

  /// Retourne le nombre total de signalements.
  static int get reportCount {
    return _reports.length;
  }

  /// Supprime un signalement grâce à son identifiant.
  static Future<void> removeReport(
    String reportId,
  ) async {
    final cleanId = reportId.trim();

    if (cleanId.isEmpty) {
      return;
    }

    _reports.removeWhere(
      (report) => report.id == cleanId,
    );
  }

  /// Supprime tous les signalements concernant un profil.
  static Future<void> removeReportsForProfile(
    String profileId,
  ) async {
    final cleanProfileId = profileId.trim();

    if (cleanProfileId.isEmpty) {
      return;
    }

    _reports.removeWhere(
      (report) =>
          report.profileId == cleanProfileId,
    );
  }

  /// Supprime tous les signalements.
  static Future<void> clear() async {
    _reports.clear();
  }
}
