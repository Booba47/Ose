import '../models/dating_profile.dart';
import 'like_service.dart';

class MatchService {
  static final Set<String> _matchedProfileIds = {};

  /// Vérifie si un profil est actuellement en match.
  static bool isMatched(
    DatingProfile profile,
  ) {
    return _matchedProfileIds.contains(profile.id);
  }

  /// Crée un match avec un profil.
  static Future<bool> createMatch(
    DatingProfile profile,
  ) async {
    final profileId = profile.id.trim();

    if (profileId.isEmpty) {
      return false;
    }

    // Un profil doit avoir été aimé avant de pouvoir
    // devenir un match.
    if (!LikeService.hasLiked(profile)) {
      return false;
    }

    final alreadyMatched =
        _matchedProfileIds.contains(profileId);

    _matchedProfileIds.add(profileId);

    return !alreadyMatched;
  }

  /// Vérifie si un like peut aboutir à un match.
  ///
  /// Pour l'instant, cette méthode simule la réponse
  /// de l'autre personne avec les matchs de démonstration.
  static bool checkForMatch(
    DatingProfile profile,
  ) {
    return LikeService.hasLiked(profile) &&
        isMatched(profile);
  }

  /// Supprime un match.
  static Future<void> removeMatch(
    DatingProfile profile,
  ) async {
    _matchedProfileIds.remove(profile.id);
  }

  /// Retourne tous les identifiants des matchs.
  static List<String> get matchedProfileIds {
    return List.unmodifiable(
      _matchedProfileIds,
    );
  }

  /// Nombre de matchs.
  static int get matchCount {
    return _matchedProfileIds.length;
  }

  /// Vérifie s'il existe au moins un match.
  static bool get hasMatches {
    return _matchedProfileIds.isNotEmpty;
  }

  /// Vérifie si l'identifiant correspond à un match.
  static bool isMatchedById(
    String profileId,
  ) {
    return _matchedProfileIds.contains(
      profileId.trim(),
    );
  }

  /// Supprime tous les matchs locaux.
  static Future<void> clear() async {
    _matchedProfileIds.clear();
  }

  /// Initialise les matchs de démonstration.
  ///
  /// À supprimer/remplacer lorsque Firebase sera connecté.
  static void initializeDemoMatches() {
    _matchedProfileIds.addAll([
      'profile_1',
      'profile_3',
    ]);
  }
}
