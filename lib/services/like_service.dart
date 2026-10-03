import '../models/dating_profile.dart';

class LikeService {
  static final Set<String> _likedProfileIds = {};
  static final Set<String> _passedProfileIds = {};

  /// Ajoute un profil aux profils aimés.
  static Future<void> likeProfile(
    DatingProfile profile,
  ) async {
    final profileId = profile.id.trim();

    if (profileId.isEmpty) {
      return;
    }

    _likedProfileIds.add(profileId);

    // Un profil aimé ne peut plus être dans les profils refusés.
    _passedProfileIds.remove(profileId);
  }

  /// Refuse un profil.
  static Future<void> passProfile(
    DatingProfile profile,
  ) async {
    final profileId = profile.id.trim();

    if (profileId.isEmpty) {
      return;
    }

    _passedProfileIds.add(profileId);

    // Un profil refusé ne peut plus être dans les profils aimés.
    _likedProfileIds.remove(profileId);
  }

  /// Vérifie si le profil a été aimé.
  static bool hasLiked(
    DatingProfile profile,
  ) {
    return _likedProfileIds.contains(profile.id);
  }

  /// Vérifie si le profil a été refusé.
  static bool hasPassed(
    DatingProfile profile,
  ) {
    return _passedProfileIds.contains(profile.id);
  }

  /// Vérifie si le profil n'a encore reçu aucune décision.
  static bool hasNoDecision(
    DatingProfile profile,
  ) {
    return !hasLiked(profile) && !hasPassed(profile);
  }

  /// Retourne les identifiants des profils aimés.
  static List<String> get likedProfileIds {
    return List.unmodifiable(_likedProfileIds);
  }

  /// Retourne les identifiants des profils refusés.
  static List<String> get passedProfileIds {
    return List.unmodifiable(_passedProfileIds);
  }

  /// Nombre de likes.
  static int get likeCount {
    return _likedProfileIds.length;
  }

  /// Nombre de profils refusés.
  static int get passCount {
    return _passedProfileIds.length;
  }

  /// Nombre total de profils ayant reçu une décision.
  static int get decisionCount {
    return _likedProfileIds.length +
        _passedProfileIds.length;
  }

  /// Vérifie si un profil a reçu une décision.
  static bool hasDecision(
    DatingProfile profile,
  ) {
    return hasLiked(profile) || hasPassed(profile);
  }

  /// Retire le like d'un profil.
  static Future<void> removeLike(
    DatingProfile profile,
  ) async {
    _likedProfileIds.remove(profile.id);
  }

  /// Retire le refus d'un profil.
  static Future<void> removePass(
    DatingProfile profile,
  ) async {
    _passedProfileIds.remove(profile.id);
  }

  /// Réinitialise tous les likes et refus locaux.
  static Future<void> clear() async {
    _likedProfileIds.clear();
    _passedProfileIds.clear();
  }
}
