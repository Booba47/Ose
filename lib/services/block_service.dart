import '../models/dating_profile.dart';

class BlockService {
  static final Set<String> _blockedProfileIds = {};

  /// Bloque un profil.
  static Future<void> blockProfile(
    DatingProfile profile,
  ) async {
    _blockedProfileIds.add(profile.id);
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
    return _blockedProfileIds.contains(profile.id);
  }

  /// Retourne les identifiants des profils bloqués.
  static List<String> get blockedProfileIds {
    return List.unmodifiable(
      _blockedProfileIds,
    );
  }

  /// Nombre de profils bloqués.
  static int get blockedCount {
    return _blockedProfileIds.length;
  }

  /// Supprime tous les blocages locaux.
  static Future<void> clear() async {
    _blockedProfileIds.clear();
  }
}
