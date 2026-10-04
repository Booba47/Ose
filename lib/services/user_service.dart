import '../models/user_profile.dart';

class UserService {
  static UserProfile? _currentProfile;

  /// Profil actuellement connecté.
  static UserProfile? get currentProfile {
    return _currentProfile;
  }

  /// Enregistre le profil de l'utilisateur.
  static Future<void> saveProfile(
    UserProfile profile,
  ) async {
    _currentProfile = profile;
  }

  /// Récupère le profil actuel.
  static Future<UserProfile?> getProfile() async {
    return _currentProfile;
  }

  /// Met à jour le profil existant.
  static Future<void> updateProfile(
    UserProfile profile,
  ) async {
    _currentProfile = profile;
  }

  /// Supprime le profil local.
  static Future<void> deleteProfile() async {
    _currentProfile = null;
  }

  /// Vérifie si un profil existe.
  static bool get hasProfile {
    return _currentProfile != null;
  }

  /// Vérifie si le profil possède une biographie.
  static bool get hasBio {
    final profile = _currentProfile;

    if (profile == null) {
      return false;
    }

    return profile.bio.trim().isNotEmpty;
  }

  /// Vérifie si le profil possède au moins une photo.
  static bool get hasPhotos {
    final profile = _currentProfile;

    if (profile == null) {
      return false;
    }

    return profile.photos.isNotEmpty;
  }

  /// Nombre de photos du profil.
  static int get photoCount {
    return _currentProfile?.photos.length ?? 0;
  }

  /// Réinitialise complètement le profil local.
  static void clear() {
    _currentProfile = null;
  }
} 
