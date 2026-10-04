class PhotoService {
  static const int maxPhotos = 6;

  static final List<String> _photos = [];

  /// Toutes les photos enregistrées.
  static List<String> get photos {
    return List.unmodifiable(_photos);
  }

  /// Nombre de photos.
  static int get photoCount {
    return _photos.length;
  }

  /// Vérifie si l'utilisateur possède des photos.
  static bool get hasPhotos {
    return _photos.isNotEmpty;
  }

  /// Vérifie si une photo principale existe.
  static bool get hasPrimaryPhoto {
    return _photos.isNotEmpty;
  }

  /// Première photo = photo principale.
  static String? get primaryPhoto {
    if (_photos.isEmpty) {
      return null;
    }

    return _photos.first;
  }

  /// Ajoute une photo.
  static Future<bool> addPhoto(String path) async {
    final cleanPath = path.trim();

    if (cleanPath.isEmpty) {
      return false;
    }

    if (_photos.length >= maxPhotos) {
      return false;
    }

    // Évite d'ajouter deux fois exactement la même photo.
    if (_photos.contains(cleanPath)) {
      return false;
    }

    _photos.add(cleanPath);

    return true;
  }

  /// Supprime une photo.
  static Future<void> removePhoto(String path) async {
    _photos.remove(path);
  }

  /// Définit plusieurs photos.
  ///
  /// Maximum : 6 photos.
  static Future<void> setPhotos(
    List<String> photos,
  ) async {
    final cleanedPhotos = photos
        .map((photo) => photo.trim())
        .where((photo) => photo.isNotEmpty)
        .toSet()
        .take(maxPhotos)
        .toList();

    _photos
      ..clear()
      ..addAll(cleanedPhotos);
  }

  /// Déplace une photo à la première position.
  ///
  /// La première photo est considérée comme la photo principale.
  static Future<bool> setPrimaryPhoto(
    String path,
  ) async {
    final cleanPath = path.trim();

    if (cleanPath.isEmpty) {
      return false;
    }

    final index = _photos.indexOf(cleanPath);

    if (index == -1) {
      return false;
    }

    if (index == 0) {
      return true;
    }

    _photos.removeAt(index);
    _photos.insert(0, cleanPath);

    return true;
  }

  /// Supprime toutes les photos locales.
  static Future<void> clear() async {
    _photos.clear();
  }
} 
