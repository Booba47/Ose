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
  @override
  void initState() {
    super.initState();

    MatchService.initializeDemoMatches();
  }

  List<DatingProfile> _getMatches() {
    final profiles = DatingProfileService.getProfiles();

    return profiles
        .where(
          (profile) => MatchService.isMatched(profile),
        )
        .toList();
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

  @override
  Widget build(BuildContext context) {
    final matches = _getMatches();

    return SafeArea(
      child: matches.isEmpty
          ? const _EmptyMatches()
          : ListView(
              padding: const EdgeInsets.fromLTRB(
                16,
                18,
                16,
                30,
              ),
              children: [
                const Text(
                  'Tes matchs ❤️',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  'Les personnes avec qui le feeling est réciproque.',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey.shade700,
                  ),
                ),

                const SizedBox(height: 22),

                ...matches.map(
                  (profile) => _MatchCard(
                    profile: profile,
                    onChat: () => _openChat(profile),
                  ),
                ),

                const SizedBox(height: 14),

                Center(
                  child: Text(
                    'Ose faire le premier pas. ❤️',
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
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: Colors.grey.shade200,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Stack(
              children: [
                Container(
                  width: 78,
                  height: 78,
                  decoration: BoxDecoration(
                    color: Colors.pink.shade50,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.pink.shade100,
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      profile.emoji,
                      style: const TextStyle(
                        fontSize: 43,
                      ),
                    ),
                  ),
                ),

                Positioned(
                  right: 1,
                  bottom: 1,
                  child: Container(
                    width: 21,
                    height: 21,
                    decoration: BoxDecoration(
                      color: Colors.green,
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
                        const Icon(
                          Icons.verified,
                          color: Colors.pink,
                          size: 18,
                        ),
                      ],
                    ],
                  ),

                  const SizedBox(height: 6),

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
                            fontSize: 13,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 9,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.pink.shade50,
                      borderRadius:
                          BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Match ❤️',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.pink.shade800,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),

            SizedBox(
              width: 46,
              height: 46,
              child: Material(
                color: Colors.pink,
                shape: const CircleBorder(),
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: onChat,
                  child: const Icon(
                    Icons.chat_bubble_outline,
                    color: Colors.white,
                    size: 21,
                  ),
                ),
              ),
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
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                color: Colors.pink.shade50,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.favorite_border_rounded,
                size: 54,
                color: Colors.pink,
              ),
            ),

            const SizedBox(height: 24),

            const Text(
              'Pas encore de match',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            Text(
              'Continue à découvrir des personnes. '
              'Ton prochain match est peut-être juste là.',
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
    );
  }
}
