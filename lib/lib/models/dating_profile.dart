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
}
