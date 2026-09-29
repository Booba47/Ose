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
    return LikeService.hasLiked(profile) &&
        isMatched(profile);
  }

  /// Crée un match avec un profil.
  static void createMatch(DatingProfile profile) {
    _matchedProfileIds.add(profile.id);
  }

  /// Supprime un match.
  static void removeMatch(DatingProfile profile) {
    _matchedProfileIds.remove(profile.id);
  }

  /// Retourne les identifiants de tous les matchs.
  static List<String> get matchedProfileIds {
    return List.unmodifiable(
      _matchedProfileIds,
    );
  }

  /// Retourne le nombre de matchs.
  static int get matchCount {
    return _matchedProfileIds.length;
  }

  /// Retourne true s'il existe au moins un match.
  static bool get hasMatches {
    return _matchedProfileIds.isNotEmpty;
  }

  /// Réinitialise tous les matchs.
  static void clear() {
    _matchedProfileIds.clear();
  }

  /// Initialise les matchs de démonstration.
  ///
  /// Pour la version actuelle, Sophie et Aïcha
  /// sont utilisées comme matchs de démonstration.
  ///
  /// Cette méthode sera remplacée par les données
  /// provenant de Firebase lorsque le backend sera connecté.
  static void initializeDemoMatches() {
    _matchedProfileIds.addAll([
      'profile_1',
      'profile_3',
    ]);
  }
}
