import 'package:flutter/material.dart';

import '../models/dating_profile.dart';
import '../services/dating_profile_service.dart';
import '../services/match_service.dart';
import 'chat_screen.dart';

class MatchesScreen extends StatefulWidget {
  const MatchesScreen({super.key});

  @override
  State<MatchesScreen> createState() => _MatchesScreenState();
}

class _MatchesScreenState extends State<MatchesScreen> {
  late List<DatingProfile> _matches;

  @override
  void initState() {
    super.initState();

    MatchService.initializeDemoMatches();
    _loadMatches();
  }

  void _loadMatches() {
    final profiles = DatingProfileService.getProfiles();

    _matches = profiles.where((profile) {
      return MatchService.isMatched(profile);
    }).toList();
  }

  void _openChat(DatingProfile profile) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ChatScreen(
          profile: profile,
        ),
      ),
    );
  }

  void _removeMatch(DatingProfile profile) {
    MatchService.removeMatch(profile);

    setState(() {
      _loadMatches();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${profile.name} a été retiré de tes matchs.',
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                20,
                18,
                20,
                12,
              ),
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Mes matchs',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.pink.shade50,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.favorite,
                          size: 16,
                          color: Colors.pink,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          '${_matches.length}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.pink.shade800,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: _matches.isEmpty
                  ? _buildEmptyState()
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(
                        16,
                        8,
                        16,
                        24,
                      ),
                      itemCount: _matches.length,
                      separatorBuilder: (_, __) {
                        return const SizedBox(height: 12);
                      },
                      itemBuilder: (context, index) {
                        final profile = _matches[index];

                        return _MatchCard(
                          profile: profile,
                          onChat: () {
                            _openChat(profile);
                          },
                          onRemove: () {
                            _removeMatch(profile);
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 105,
              height: 105,
              decoration: BoxDecoration(
                color: Colors.pink.shade50,
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Text(
                  '💕',
                  style: TextStyle(
                    fontSize: 50,
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

            const SizedBox(height: 10),

            Text(
              'Continue à découvrir des profils. '
              'Quand quelqu’un t’aime aussi, '
              'vous apparaîtrez ici.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                height: 1.5,
                color: Colors.grey.shade700,
              ),
            ),

            const SizedBox(height: 24),

            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 11,
              ),
              decoration: BoxDecoration(
                color: Colors.pink.shade50,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'Ose faire le premier pas ❤️',
                style: TextStyle(
                  color: Colors.pink.shade800,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MatchCard extends StatelessWidget {
  final DatingProfile profile;
  final VoidCallback onChat;
  final VoidCallback onRemove;

  const _MatchCard({
    required this.profile,
    required this.onChat,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.grey.shade200,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: 0.05,
            ),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Stack(
            children: [
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: Colors.pink.shade50,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    profile.emoji,
                    style: const TextStyle(
                      fontSize: 38,
                    ),
                  ),
                ),
              ),

              Positioned(
                right: 1,
                bottom: 2,
                child: Container(
                  width: 17,
                  height: 17,
                  decoration: BoxDecoration(
                    color: Colors.green.shade500,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white,
                      width: 3,
                    ),
                  ),
                ),
              ),
            ],
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
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    if (profile.verified) ...[
                      const SizedBox(width: 5),
                      Icon(
                        Icons.verified,
                        size: 18,
                        color: Colors.blue.shade600,
                      ),
                    ],
                  ],
                ),

                const SizedBox(height: 5),

                Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: 15,
                      color: Colors.grey.shade600,
                    ),
                    const SizedBox(width: 3),
                    Expanded(
                      child: Text(
                        profile.city,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 6),

                Text(
                  'Vous vous êtes aimés ❤️',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.pink.shade700,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          Column(
            children: [
              SizedBox(
                width: 48,
                height: 42,
                child: Material(
                  color: Colors.pink,
                  borderRadius: BorderRadius.circular(14),
                  child: InkWell(
                    onTap: onChat,
                    borderRadius: BorderRadius.circular(14),
                    child: const Icon(
                      Icons.chat_bubble_outline,
                      color: Colors.white,
                      size: 21,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 3),

              IconButton(
                onPressed: onRemove,
                visualDensity: VisualDensity.compact,
                tooltip: 'Retirer le match',
                icon: Icon(
                  Icons.more_horiz,
                  color: Colors.grey.shade500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
