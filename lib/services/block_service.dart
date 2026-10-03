import '../models/dating_profile.dart';

class BlockService {
  static final Set<String> _blockedProfileIds = {};

  /// Bloque un profil.
  static Future<void> blockProfile(
    DatingProfile profile,
  ) async {
    final profileId = profile.id.trim();

    if (profileId.isEmpty) {
      return;
    }

    _blockedProfileIds.add(profileId);
  }

  /// Bloque un profil directement avec son identifiant.
  static Future<void> blockProfileById(
    String profileId,
  ) async {
    final cleanId = profileId.trim();

    if (cleanId.isEmpty) {
      return;
    }

    _blockedProfileIds.add(cleanId);
  }

  /// Débloque un profil.
  static Future<void> unblockProfile(
    DatingProfile profile,
  ) async {
    _blockedProfileIds.remove(profile.id);
  }

  /// Débloque un profil avec son identifiant.
  static Future<void> unblockProfileById(
    String profileId,
  ) async {
    _blockedProfileIds.remove(profileId.trim());
  }

  /// Vérifie si un profil est bloqué.
  static bool isBlocked(
    DatingProfile profile,
  ) {
    return _blockedProfileIds.contains(profile.id);
  }

  /// Vérifie si un identifiant est bloqué.
  static bool isBlockedById(
    String profileId,
  ) {
    return _blockedProfileIds.contains(
      profileId.trim(),
    );
  }

  /// Retourne tous les identifiants bloqués.
  static List<String> get blockedProfileIds {
    return List.unmodifiable(
      _blockedProfileIds,
    );
  }

  /// Nombre de profils bloqués.
  static int get blockedCount {
    return _blockedProfileIds.length;
  }

  /// Vérifie s'il existe au moins un profil bloqué.
  static bool get hasBlockedProfiles {
    return _blockedProfileIds.isNotEmpty;
  }

  /// Retire tous les blocages.
  static Future<void> clear() async {
    _blockedProfileIds.clear();
  }
}
