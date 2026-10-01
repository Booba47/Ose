class DatingProfile {
  final String id;
  final String name;
  final int age;
  final String city;
  final String bio;
  final String emoji;
  final List<String> interests;
  final bool verified;

  const DatingProfile({
    required this.id,
    required this.name,
    required this.age,
    required this.city,
    required this.bio,
    required this.emoji,
    required this.interests,
    this.verified = false,
  });

  bool get hasBio {
    return bio.trim().isNotEmpty;
  }

  bool get hasInterests {
    return interests.isNotEmpty;
  }

  int get interestCount {
    return interests.length;
  }

  DatingProfile copyWith({
    String? id,
    String? name,
    int? age,
    String? city,
    String? bio,
    String? emoji,
    List<String>? interests,
    bool? verified,
  }) {
    return DatingProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      age: age ?? this.age,
      city: city ?? this.city,
      bio: bio ?? this.bio,
      emoji: emoji ?? this.emoji,
      interests: interests ?? this.interests,
      verified: verified ?? this.verified,
    );
  }
}
