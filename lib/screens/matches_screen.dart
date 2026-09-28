import 'package:flutter/material.dart';

import '../models/dating_profile.dart';
import '../services/dating_profile_service.dart';
import '../services/match_service.dart';

class MatchesScreen extends StatelessWidget {
  const MatchesScreen({super.key});

  List<DatingProfile> _getMatches() {
    final profiles = DatingProfileService.getProfiles();

    return profiles
        .where(
          (profile) => MatchService.isMatched(profile),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final matches = _getMatches();

    if (matches.isEmpty) {
      return const _EmptyMatches();
    }

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Tes matchs ❤️',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            'Les personnes avec qui tu as créé une connexion.',
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey.shade700,
            ),
          ),

          const SizedBox(height: 20),

          ...matches.map(
            (profile) => _MatchCard(
              profile: profile,
              onChat: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'La conversation avec ${profile.name} sera bientôt disponible.',
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 12),

          Center(
            child: Text(
              'Prends ton temps. ❤️',
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MatchCard extends StatelessWidget {
  final DatingProfile profile;
  final VoidCallback onChat;

  const _MatchCard({
    required this.profile,
    required this.onChat,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Container(
              width: 62,
              height: 62,
              decoration: BoxDecoration(
                color: Colors.pink.shade50,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  profile.emoji,
                  style: const TextStyle(
                    fontSize: 34,
                  ),
                ),
              ),
            ),

            const SizedBox(width: 14),

            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          '${profile.name}, ${profile.age}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      if (profile.verified) ...[
                        const SizedBox(width: 5),
                        Icon(
                          Icons.verified,
                          size: 18,
                          color: Colors.pink.shade400,
                        ),
                      ],
                    ],
                  ),

                  const SizedBox(height: 4),

                  Text(
                    profile.city,
                    style: TextStyle(
                      color: Colors.grey.shade700,
                    ),
                  ),

                  const SizedBox(height: 4),

                  const Text(
                    'Match ❤️',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),

            IconButton(
              onPressed: onChat,
              icon: const Icon(
                Icons.chat_bubble_outline,
              ),
              color: Colors.pink,
              tooltip: 'Discuter',
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyMatches extends StatelessWidget {
  const _EmptyMatches();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.center,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.pink.shade50,
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Text(
                    '❤️',
                    style: TextStyle(
                      fontSize: 48,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              const Text(
                'Pas encore de match',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              Text(
                'Quand quelqu’un que tu as aimé '
                't’aime aussi, votre match apparaîtra ici.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  height: 1.4,
                  color: Colors.grey.shade700,
                ),
              ),

              const SizedBox(height: 24),

              const Text(
                'Ose faire le premier pas. ❤️',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
