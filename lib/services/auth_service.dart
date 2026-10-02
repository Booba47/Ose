class AuthService {
  /// Indique si un utilisateur est actuellement connecté.
  static bool _isLoggedIn = false;

  /// Identifiant de l'utilisateur actuellement connecté.
  static String? _currentUserId;

  /// Vérifie si un utilisateur est connecté.
  static bool get isLoggedIn {
    return _isLoggedIn;
  }

  /// Retourne l'identifiant de l'utilisateur connecté.
  static String? get currentUserId {
    return _currentUserId;
  }

  /// Connexion temporaire pour la version de démonstration.
  static Future<bool> signIn({
    required String email,
    required String password,
  }) async {
    if (email.trim().isEmpty || password.isEmpty) {
      return false;
    }

    _isLoggedIn = true;
    _currentUserId = 'demo_user';

    return true;
  }

  /// Création temporaire d'un compte.
  static Future<bool> register({
    required String email,
    required String password,
  }) async {
    if (email.trim().isEmpty || password.length < 6) {
      return false;
    }

    _isLoggedIn = true;
    _currentUserId = 'demo_user';

    return true;
  }

  /// Déconnexion temporaire.
  static Future<void> signOut() async {
    _isLoggedIn = false;
    _currentUserId = null;
  }

  /// Réinitialisation temporaire du mot de passe.
  static Future<bool> resetPassword({
    required String email,
  }) async {
    if (email.trim().isEmpty) {
      return false;
    }

    return true;
  }

  /// Réinitialise complètement la session de démonstration.
  static void clearSession() {
    _isLoggedIn = false;
    _currentUserId = null;
  }
}
