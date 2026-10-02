import 'package:flutter/material.dart';

import '../models/dating_profile.dart';
import '../services/block_service.dart';
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
      return MatchService.isMatched(profile) &&
          !BlockService.isBlocked(profile);
    }).toList();
  }

  void _removeMatch(DatingProfile profile) {
    setState(() {
      MatchService.removeMatch(profile);
      _loadMatches();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${profile.name} a été retiré de tes matchs.',
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    );
  }

  Future<void> _blockProfile(
    DatingProfile profile,
  ) async {
    await BlockService.blockProfile(profile);

    if (!mounted) {
      return;
    }

    setState(() {
      MatchService.removeMatch(profile);
      _loadMatches();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${profile.name} a été bloqué(e).',
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    );
  }

  void _openChat(DatingProfile profile) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatScreen(
          profile: profile,
        ),
      ),
    );
  }

  void _showProfileOptions(
    DatingProfile profile,
  ) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.fromLTRB(
            22,
            12,
            22,
            28,
          ),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(30),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 45,
                height: 5,
                decoration: BoxDecoration(
                  color: const Color(0xFFE0E0E0),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 22),
              Text(
                profile.name,
                style: const TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 18),
              ListTile(
                leading: const Icon(
                  Icons.chat_bubble_outline,
                  color: Color(0xFFED1767),
                ),
                title: const Text(
                  'Envoyer un message',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _openChat(profile);
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.person_remove_outlined,
                  color: Color(0xFFC52A70),
                ),
                title: const Text(
                  'Retirer le Match',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _removeMatch(profile);
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.block_outlined,
                  color: Color(0xFFD32F2F),
                ),
                title: const Text(
                  'Bloquer cette personne',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _confirmBlock(profile);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _confirmBlock(DatingProfile profile) {
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Bloquer cette personne ?',
            style: TextStyle(
              fontWeight: FontWeight.w900,
            ),
          ),
          content: Text(
            '${profile.name} ne sera plus affiché(e) dans tes rencontres.',
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _blockProfile(profile);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFD32F2F),
                foregroundColor: Colors.white,
              ),
              child: const Text('Bloquer'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8FB),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: _matches.isEmpty
                  ? _buildEmptyState()
                  : RefreshIndicator(
                      color: const Color(0xFFED1767),
                      onRefresh: () async {
                        setState(() {
                          _loadMatches();
                        });
                      },
                      child: ListView(
                        physics:
                            const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.fromLTRB(
                          18,
                          5,
                          18,
                          25,
                        ),
                        children: [
                          _buildIntroCard(),
                          const SizedBox(height: 20),
                          Text(
                            'Tes rencontres (${_matches.length})',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const SizedBox(height: 12),
                          ..._matches.map(
                            (profile) => Padding(
                              padding:
                                  const EdgeInsets.only(
                                bottom: 14,
                              ),
                              child: _MatchCard(
                                profile: profile,
                                onTap: () {
                                  _openChat(profile);
                                },
                                onRemove: () {
                                  _removeMatch(profile);
                                },
                                onMore: () {
                                  _showProfileOptions(
                                    profile,
                                  );
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Center(
                            child: Text(
                              'Ose faire le premier pas. 💕',
                              style: TextStyle(
                                color: Color(0xFFAAAAAA),
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        20,
        12,
        20,
        8,
      ),
      child: Row(
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  'Tes Matchs',
                  style: TextStyle(
                    fontSize: 29,
                    fontWeight: FontWeight.w900,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  'Des personnes qui pourraient te plaire 💕',
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFF888888),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              color: const Color(0xFFFFE5EF),
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Icon(
              Icons.favorite,
              color: Color(0xFFC52A70),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIntroCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFFFDCE9),
            Color(0xFFFFF0F5),
          ],
        ),
        borderRadius: BorderRadius.circular(26),
      ),
      child: Row(
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Text(
                '💗',
                style: TextStyle(
                  fontSize: 29,
                ),
              ),
            ),
          ),
          const SizedBox(width: 15),
          const Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  'Un Match, c’est le début.',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF9F2458),
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'N’attends pas forcément. Ose envoyer le premier message.',
                  style: TextStyle(
                    fontSize: 13,
                    height: 1.35,
                    color: Color(0xFF777777),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            Container(
              width: 130,
              height: 130,
              decoration: const BoxDecoration(
                color: Color(0xFFFFE5EF),
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Text(
                  '💗',
                  style: TextStyle(
                    fontSize: 58,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 25),
            const Text(
              'Pas encore de Match',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Continue à découvrir de nouvelles personnes. '
              'Un Match peut arriver à tout moment.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                height: 1.45,
                color: Color(0xFF777777),
              ),
            ),
            const SizedBox(height: 25),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 12,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFFFFEAF2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                '💕 Ose faire le premier pas',
                style: TextStyle(
                  color: Color(0xFFC52A70),
                  fontWeight: FontWeight.w700,
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
  final VoidCallback onTap;
  final VoidCallback onRemove;
  final VoidCallback onMore;

  const _MatchCard({
    required this.profile,
    required this.onTap,
    required this.onRemove,
    required this.onMore,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.055),
            blurRadius: 17,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(25),
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Row(
              children: [
                Stack(
                  children: [
                    Container(
                      width: 76,
                      height: 76,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color(0xFFFFD2E2),
                            Color(0xFFFFEEF4),
                          ],
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          profile.emoji,
                          style: const TextStyle(
                            fontSize: 40,
                          ),
                        ),
                      ),
                    ),
                    if (profile.verified)
                      Positioned(
                        right: 0,
                        bottom: 2,
                        child: Container(
                          width: 24,
                          height: 24,
                          decoration:
                              const BoxDecoration(
                            color: Color(0xFF3298DB),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 15,
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
                      Text(
                        '${profile.name}, ${profile.age}',
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on_outlined,
                            size: 15,
                            color: Color(0xFFC52A70),
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              profile.city,
                              overflow:
                                  TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 13,
                                color: Color(0xFF888888),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Row(
                        children: [
                          Icon(
                            Icons.circle,
                            size: 8,
                            color: Color(0xFF45B96B),
                          ),
                          SizedBox(width: 5),
                          Text(
                            'Prêt(e) à discuter',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF777777),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color(0xFFED1767),
                    borderRadius:
                        BorderRadius.circular(17),
                  ),
                  child: const Icon(
                    Icons.chat_bubble_outline,
                    color: Colors.white,
                    size: 23,
                  ),
                ),
                const SizedBox(width: 4),
                PopupMenuButton<String>(
                  icon: const Icon(
                    Icons.more_vert,
                    color: Color(0xFFAAAAAA),
                  ),
                  onSelected: (value) {
                    if (value == 'remove') {
                      onRemove();
                    }

                    if (value == 'options') {
                      onMore();
                    }
                  },
                  itemBuilder: (context) {
                    return const [
                      PopupMenuItem<String>(
                        value: 'options',
                        child: Row(
                          children: [
                            Icon(
                              Icons.more_horiz,
                              color: Color(0xFFC52A70),
                            ),
                            SizedBox(width: 10),
                            Text('Plus d’options'),
                          ],
                        ),
                      ),
                      PopupMenuItem<String>(
                        value: 'remove',
                        child: Row(
                          children: [
                            Icon(
                              Icons.person_remove_outlined,
                              color: Color(0xFFC52A70),
                            ),
                            SizedBox(width: 10),
                            Text('Retirer le Match'),
                          ],
                        ),
                      ),
                    ];
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
