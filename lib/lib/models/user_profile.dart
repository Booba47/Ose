class UserProfile {
  final String name;
  final DateTime birthDate;
  final String city;
  final String bio;
  final List<String> interests;
  final String lookingFor;
  final List<String> photos;

  const UserProfile({
    required this.name,
    required this.birthDate,
    required this.city,
    required this.bio,
    required this.interests,
    required this.lookingFor,
    required this.photos,
  });

  /// Âge calculé automatiquement à partir de la date de naissance.
  int get age {
    final today = DateTime.now();

    int calculatedAge = today.year - birthDate.year;

    if (today.month < birthDate.month ||
        (today.month == birthDate.month &&
            today.day < birthDate.day)) {
      calculatedAge--;
    }

    return calculatedAge;
  }

  /// Photo principale du profil.
  String? get primaryPhoto {
    if (photos.isEmpty) {
      return null;
    }

    return photos.first;
  }

  /// Indique si le profil possède au moins une photo.
  bool get hasPhotos {
    return photos.isNotEmpty;
  }

  /// Nombre de photos du profil.
  int get photoCount {
    return photos.length;
  }

  /// Indique si le profil possède une biographie.
  bool get hasBio {
    return bio.trim().isNotEmpty;
  }

  /// Crée une copie du profil avec certaines informations modifiées.
  UserProfile copyWith({
    String? name,
    DateTime? birthDate,
    String? city,
    String? bio,
    List<String>? interests,
    String? lookingFor,
    List<String>? photos,
  }) {
    return UserProfile(
      name: name ?? this.name,
      birthDate: birthDate ?? this.birthDate,
      city: city ?? this.city,
      bio: bio ?? this.bio,
      interests: interests ?? this.interests,
      lookingFor: lookingFor ?? this.lookingFor,
      photos: photos ?? this.photos,
    );
  }
}
