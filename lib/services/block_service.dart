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

  /// Débloque un profil.
  static Future<void> unblockProfile(
    DatingProfile profile,
  ) async {
    _blockedProfileIds.remove(profile.id);
  }

  /// Vérifie si un profil est bloqué.
  static bool isBlocked(
    DatingProfile profile,
  ) {
    return _blockedProfileIds.contains(
      profile.id,
    );
  }

  /// Vérifie un blocage à partir d'un identifiant.
  static bool isBlockedById(
    String profileId,
  ) {
    final cleanId = profileId.trim();

    if (cleanId.isEmpty) {
      return false;
    }

    return _blockedProfileIds.contains(cleanId);
  }

  /// Liste des profils bloqués.
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

  /// Supprime tous les blocages locaux.
  static Future<void> clear() async {
    _blockedProfileIds.clear();
  }
} 
