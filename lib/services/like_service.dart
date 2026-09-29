import '../models/dating_profile.dart';

class LikeService {
  static final Set<String> _likedProfileIds = {};
  static final Set<String> _passedProfileIds = {};

  /// Ajoute un profil aux profils aimés.
  static void likeProfile(DatingProfile profile) {
    _likedProfileIds.add(profile.id);
    _passedProfileIds.remove(profile.id);
  }

  /// Ajoute un profil aux profils refusés.
  static void passProfile(DatingProfile profile) {
    _passedProfileIds.add(profile.id);
    _likedProfileIds.remove(profile.id);
  }

  /// Vérifie si un profil a été aimé.
  static bool hasLiked(DatingProfile profile) {
    return _likedProfileIds.contains(profile.id);
  }

  /// Vérifie si un profil a été refusé.
  static bool hasPassed(DatingProfile profile) {
    return _passedProfileIds.contains(profile.id);
  }

  /// Retourne tous les identifiants des profils aimés.
  static List<String> get likedProfileIds {
    return List.unmodifiable(
      _likedProfileIds,
    );
  }

  /// Retourne tous les identifiants des profils refusés.
  static List<String> get passedProfileIds {
    return List.unmodifiable(
      _passedProfileIds,
    );
  }

  /// Nombre de profils aimés.
  static int get likeCount {
    return _likedProfileIds.length;
  }

  /// Nombre de profils refusés.
  static int get passCount {
    return _passedProfileIds.length;
  }

  /// Supprime toutes les données de likes et de refus.
  static void clear() {
    _likedProfileIds.clear();
    _passedProfileIds.clear();
  }
}
