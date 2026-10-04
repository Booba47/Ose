class AuthService {
  static bool _isLoggedIn = false;
  static String? _currentUserId;
  static String? _currentEmail;

  static bool get isLoggedIn => _isLoggedIn;

  static String? get currentUserId => _currentUserId;

  static String? get currentEmail => _currentEmail;

  /// Connexion locale temporaire.
  ///
  /// Cette méthode sera ensuite reliée à Firebase Authentication
  /// sans avoir besoin de modifier les écrans qui l'utilisent.
  static Future<bool> signIn({
    required String email,
    required String password,
  }) async {
    final cleanEmail = email.trim();

    if (cleanEmail.isEmpty || password.isEmpty) {
      return false;
    }

    if (password.length < 6) {
      return false;
    }

    _isLoggedIn = true;
    _currentUserId = 'demo_user';
    _currentEmail = cleanEmail;

    return true;
  }

  /// Création de compte locale temporaire.
  ///
  /// Le contrôle de l'âge >= 18 ans reste effectué
  /// dans l'écran d'inscription.
  static Future<bool> register({
    required String email,
    required String password,
  }) async {
    final cleanEmail = email.trim();

    if (cleanEmail.isEmpty || password.length < 6) {
      return false;
    }

    _isLoggedIn = true;
    _currentUserId = 'demo_user';
    _currentEmail = cleanEmail;

    return true;
  }

  /// Déconnexion.
  static Future<void> signOut() async {
    _isLoggedIn = false;
    _currentUserId = null;
    _currentEmail = null;
  }

  /// Demande de réinitialisation du mot de passe.
  ///
  /// Sera reliée à Firebase Authentication plus tard.
  static Future<bool> resetPassword({
    required String email,
  }) async {
    final cleanEmail = email.trim();

    if (cleanEmail.isEmpty) {
      return false;
    }

    return true;
  }

  /// Réinitialisation complète de la session locale.
  static void clearSession() {
    _isLoggedIn = false;
    _currentUserId = null;
    _currentEmail = null;
  }

  /// Indique si une adresse e-mail est actuellement enregistrée.
  static bool get hasEmail {
    return _currentEmail != null &&
        _currentEmail!.trim().isNotEmpty;
  }
} 
