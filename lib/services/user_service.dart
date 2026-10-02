import '../models/user_profile.dart';

class UserService {
  static UserProfile? _currentProfile;

  /// Profil actuellement chargé dans l'application.
  static UserProfile? get currentProfile {
    return _currentProfile;
  }

  /// Enregistre temporairement le profil de l'utilisateur.
  static Future<void> saveProfile(
    UserProfile profile,
  ) async {
    _currentProfile = profile;
  }

  /// Récupère le profil actuellement enregistré.
  static Future<UserProfile?> getProfile() async {
    return _currentProfile;
  }

  /// Met à jour le profil.
  static Future<void> updateProfile(
    UserProfile profile,
  ) async {
    _currentProfile = profile;
  }

  /// Supprime temporairement le profil.
  static Future<void> deleteProfile() async {
    _currentProfile = null;
  }

  /// Vérifie si un profil existe.
  static bool get hasProfile {
    return _currentProfile != null;
  }

  /// Réinitialise les données locales de démonstration.
  static void clear() {
    _currentProfile = null;
  }
}
