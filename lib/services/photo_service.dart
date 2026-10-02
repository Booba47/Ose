class PhotoService {
  static final List<String> _photos = [];

  /// Retourne les photos actuellement enregistrées.
  static List<String> get photos {
    return List.unmodifiable(_photos);
  }

  /// Ajoute une photo au profil.
  static Future<bool> addPhoto(String path) async {
    if (path.trim().isEmpty) {
      return false;
    }

    if (_photos.length >= 6) {
      return false;
    }

    _photos.add(path);

    return true;
  }

  /// Supprime une photo.
  static Future<void> removePhoto(String path) async {
    _photos.remove(path);
  }

  /// Remplace toutes les photos.
  static Future<void> setPhotos(
    List<String> photos,
  ) async {
    _photos
      ..clear()
      ..addAll(photos.take(6));
  }

  /// Supprime toutes les photos.
  static Future<void> clear() async {
    _photos.clear();
  }

  /// Nombre de photos enregistrées.
  static int get photoCount {
    return _photos.length;
  }

  /// Indique si une photo principale existe.
  static bool get hasPrimaryPhoto {
    return _photos.isNotEmpty;
  }

  /// Retourne la première photo.
  static String? get primaryPhoto {
    if (_photos.isEmpty) {
      return null;
    }

    return _photos.first;
  }
}
