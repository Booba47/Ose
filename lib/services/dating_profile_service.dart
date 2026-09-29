import '../models/dating_profile.dart';

class DatingProfileService {
  static const List<DatingProfile> demoProfiles = [
    DatingProfile(
      id: 'profile_1',
      name: 'Sophie',
      age: 27,
      city: 'Paris',
      bio:
          'J’aime les voyages, la musique et les soirées tranquilles.',
      emoji: '👩🏻',
      interests: [
        '🎵 Musique',
        '✈️ Voyage',
        '☕ Sorties tranquilles',
      ],
      verified: true,
    ),

    DatingProfile(
      id: 'profile_2',
      name: 'Emma',
      age: 29,
      city: 'Lyon',
      bio:
          'Curieuse, souriante et toujours partante pour découvrir.',
      emoji: '👩🏼',
      interests: [
        '🎬 Films',
        '🍳 Cuisine',
        '🎨 Art',
      ],
      verified: true,
    ),

    DatingProfile(
      id: 'profile_3',
      name: 'Aïcha',
      age: 26,
      city: 'Marseille',
      bio:
          'J’aime les discussions sincères, la cuisine et les voyages.',
      emoji: '👩🏿',
      interests: [
        '🍳 Cuisine',
        '✈️ Voyage',
        '📚 Lecture',
      ],
      verified: true,
    ),

    DatingProfile(
      id: 'profile_4',
      name: 'Camille',
      age: 25,
      city: 'Bordeaux',
      bio:
          'Cinéma, cuisine et longues discussions autour d’un café.',
      emoji: '👩🏽',
      interests: [
        '🎬 Films',
        '🍳 Cuisine',
        '☕ Sorties tranquilles',
      ],
      verified: false,
    ),

    DatingProfile(
      id: 'profile_5',
      name: 'Julie',
      age: 28,
      city: 'Toulouse',
      bio:
          'J’adore les balades, les voyages et les conversations sincères.',
      emoji: '👩🏻',
      interests: [
        '✈️ Voyage',
        '🐾 Animaux',
        '🎵 Musique',
      ],
      verified: true,
    ),
  ];

  /// Retourne les profils disponibles pour la découverte.
  ///
  /// Pour l'instant, les profils sont des données de démonstration.
  /// Cette méthode sera ensuite remplacée par une récupération
  /// depuis Firebase Firestore.
  static List<DatingProfile> getProfiles() {
    return List.unmodifiable(
      demoProfiles,
    );
  }

  /// Recherche un profil par son identifiant.
  static DatingProfile? getProfileById(String id) {
    for (final profile in demoProfiles) {
      if (profile.id == id) {
        return profile;
      }
    }

    return null;
  }

  /// Retourne uniquement les profils vérifiés.
  static List<DatingProfile> getVerifiedProfiles() {
    return List.unmodifiable(
      demoProfiles.where(
        (profile) => profile.verified,
      ),
    );
  }

  /// Nombre total de profils disponibles.
  static int get profileCount {
    return demoProfiles.length;
  }
}
