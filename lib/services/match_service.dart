import '../models/dating_profile.dart';
import 'like_service.dart';

class MatchService {
  static final Set<String> _matchedProfileIds = {};

  /// Vérifie si un profil est déjà un match.
  static bool isMatched(
    DatingProfile profile,
  ) {
    return _matchedProfileIds.contains(profile.id);
  }

  /// Crée un match pour un profil.
  ///
  /// Pour l'instant, le système reste local.
  /// Il sera ensuite relié au backend pour vérifier
  /// un véritable like réciproque.
  static Future<bool> createMatch(
    DatingProfile profile,
  ) async {
    final profileId = profile.id.trim();

    if (profileId.isEmpty) {
      return false;
    }

    // Un match ne peut être créé que si le profil
    // a déjà été liké par l'utilisateur.
    if (!LikeService.hasLiked(profile)) {
      return false;
    }

    if (_matchedProfileIds.contains(profileId)) {
      return false;
    }

    _matchedProfileIds.add(profileId);

    return true;
  }

  /// Vérifie si le profil est à la fois liké et matché.
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

  /// Liste des identifiants des matchs.
  static List<String> get matchedProfileIds {
    return List.unmodifiable(_matchedProfileIds);
  }

  /// Nombre de matchs.
  static int get matchCount {
    return _matchedProfileIds.length;
  }

  /// Indique s'il existe au moins un match.
  static bool get hasMatches {
    return _matchedProfileIds.isNotEmpty;
  }

  /// Recherche un match par identifiant.
  static bool isMatchedById(
    String profileId,
  ) {
    return _matchedProfileIds.contains(
      profileId.trim(),
    );
  }

  /// Initialise les matchs de démonstration.
  ///
  /// Ces profils servent uniquement au fonctionnement
  /// de la version locale actuelle.
  static void initializeDemoMatches() {
    _matchedProfileIds.addAll([
      'profile_1',
      'profile_3',
    ]);
  }

  /// Supprime tous les matchs locaux.
  static Future<void> clear() async {
    _matchedProfileIds.clear();
  }
} 
