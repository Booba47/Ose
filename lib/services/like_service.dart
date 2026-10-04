import '../models/dating_profile.dart';

class LikeService {
  static final Set<String> _likedProfileIds = {};
  static final Set<String> _passedProfileIds = {};

  /// Like un profil.
  static Future<void> likeProfile(
    DatingProfile profile,
  ) async {
    final profileId = profile.id.trim();

    if (profileId.isEmpty) {
      return;
    }

    _likedProfileIds.add(profileId);

    // Un profil ne peut pas être à la fois liké et passé.
    _passedProfileIds.remove(profileId);
  }

  /// Passe un profil.
  static Future<void> passProfile(
    DatingProfile profile,
  ) async {
    final profileId = profile.id.trim();

    if (profileId.isEmpty) {
      return;
    }

    _passedProfileIds.add(profileId);

    // Un profil ne peut pas être à la fois passé et liké.
    _likedProfileIds.remove(profileId);
  }

  /// Vérifie si un profil a été liké.
  static bool hasLiked(
    DatingProfile profile,
  ) {
    return _likedProfileIds.contains(profile.id);
  }

  /// Vérifie si un profil a été passé.
  static bool hasPassed(
    DatingProfile profile,
  ) {
    return _passedProfileIds.contains(profile.id);
  }

  /// Vérifie si aucune décision n'a encore été prise.
  static bool hasNoDecision(
    DatingProfile profile,
  ) {
    return !hasLiked(profile) && !hasPassed(profile);
  }

  /// Vérifie si une décision existe déjà.
  static bool hasDecision(
    DatingProfile profile,
  ) {
    return hasLiked(profile) || hasPassed(profile);
  }

  /// Liste des profils likés.
  static List<String> get likedProfileIds {
    return List.unmodifiable(_likedProfileIds);
  }

  /// Liste des profils passés.
  static List<String> get passedProfileIds {
    return List.unmodifiable(_passedProfileIds);
  }

  /// Nombre de likes.
  static int get likeCount {
    return _likedProfileIds.length;
  }

  /// Nombre de profils passés.
  static int get passCount {
    return _passedProfileIds.length;
  }

  /// Nombre total de décisions.
  static int get decisionCount {
    return _likedProfileIds.length +
        _passedProfileIds.length;
  }

  /// Retire un like.
  static Future<void> removeLike(
    DatingProfile profile,
  ) async {
    _likedProfileIds.remove(profile.id);
  }

  /// Retire un pass.
  static Future<void> removePass(
    DatingProfile profile,
  ) async {
    _passedProfileIds.remove(profile.id);
  }

  /// Réinitialise tous les likes et passes.
  static Future<void> clear() async {
    _likedProfileIds.clear();
    _passedProfileIds.clear();
  }
} 
