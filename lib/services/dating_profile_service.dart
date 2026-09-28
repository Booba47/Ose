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

  static List<DatingProfile> getProfiles() {
    return List.unmodifiable(demoProfiles);
  }
}
