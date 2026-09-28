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

  int get age {
    final today = DateTime.now();

    int calculatedAge =
        today.year - birthDate.year;

    if (today.month < birthDate.month ||
        (today.month == birthDate.month &&
            today.day < birthDate.day)) {
      calculatedAge--;
    }

    return calculatedAge;
  }

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

  String? get primaryPhoto {
    if (photos.isEmpty) {
      return null;
    }

    return photos.first;
  }
}
