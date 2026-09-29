import '../models/dating_profile.dart';
import 'like_service.dart';

class MatchService {
  static final Set<String> _matchedProfileIds = {};

  /// Vérifie si un profil est actuellement un match.
  static bool isMatched(DatingProfile profile) {
    return _matchedProfileIds.contains(profile.id);
  }

  /// Vérifie si l'utilisateur a aimé le profil
  /// et si un match existe.
  static bool checkForMatch(DatingProfile profile) {
    if (!LikeService.hasLiked(profile)) {
      return false;
    }

    return isMatched(profile);
  }

  /// Crée un match.
  static void createMatch(DatingProfile profile) {
    _matchedProfileIds.add(profile.id);
  }

  /// Supprime un match.
  static void removeMatch(DatingProfile profile) {
    _matchedProfileIds.remove(profile.id);
  }

  /// Retourne tous les identifiants des matchs.
  static List<String> get matchedProfileIds {
    return List.unmodifiable(
      _matchedProfileIds,
    );
  }

  /// Retourne le nombre de matchs.
  static int get matchCount {
    return _matchedProfileIds.length;
  }

  /// Supprime tous les matchs.
  static void clear() {
    _matchedProfileIds.clear();
  }

  /// Matchs de démonstration.
  ///
  /// Cette partie sera remplacée par Firebase
  /// lorsque le vrai système de comptes sera connecté.
  static void initializeDemoMatches() {
    _matchedProfileIds.addAll([
      'profile_1',
      'profile_3',
    ]);
  }
}
