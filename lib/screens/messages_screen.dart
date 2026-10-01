import 'package:flutter/material.dart';

import '../models/dating_profile.dart';
import '../services/dating_profile_service.dart';
import '../services/match_service.dart';
import 'chat_screen.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  late List<DatingProfile> _conversations;

  @override
  void initState() {
    super.initState();

    MatchService.initializeDemoMatches();
    _loadConversations();
  }

  void _loadConversations() {
    final profiles = DatingProfileService.getProfiles();

    _conversations = profiles.where((profile) {
      return MatchService.isMatched(profile);
    }).toList();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8FB),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: _conversations.isEmpty
                  ? _buildEmptyState()
                  : ListView(
                      padding: const EdgeInsets.fromLTRB(
                        18,
                        5,
                        18,
                        25,
                      ),
                      children: [
                        _buildTopCard(),
                        const SizedBox(height: 20),
                        const Text(
                          'Tes conversations',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 12),
                        ..._conversations.map(
                          (profile) => Padding(
                            padding: const EdgeInsets.only(
                              bottom: 12,
                            ),
                            child: _ConversationCard(
                              profile: profile,
                              onTap: () {
                                _openChat(profile);
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Messages',
                  style: TextStyle(
                    fontSize: 29,
                    fontWeight: FontWeight.w900,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  'Tes échanges et tes nouvelles rencontres 💬',
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
              Icons.chat_bubble_outline,
              color: Color(0xFFC52A70),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopCard() {
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
                '💬',
                style: TextStyle(
                  fontSize: 29,
                ),
              ),
            ),
          ),
          const SizedBox(width: 15),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'La conversation commence ici.',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF9F2458),
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Un simple « Salut 😊 » peut parfois changer une journée.',
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
          mainAxisAlignment: MainAxisAlignment.center,
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
                  '💬',
                  style: TextStyle(
                    fontSize: 58,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 25),
            const Text(
              'Aucun message',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 27,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Tes conversations apparaîtront ici '
              'lorsque tu auras fait un Match.',
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
                '💕 Ose envoyer le premier message',
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

class _ConversationCard extends StatelessWidget {
  final DatingProfile profile;
  final VoidCallback onTap;

  const _ConversationCard({
    required this.profile,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.055),
                blurRadius: 16,
                offset: const Offset(0, 6),
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
                          fontSize: 37,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 1,
                    bottom: 2,
                    child: Container(
                      width: 18,
                      height: 18,
                      decoration: BoxDecoration(
                        color: const Color(0xFF45B96B),
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
                        Expanded(
                          child: Text(
                            '${profile.name}, ${profile.age}',
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                        const Text(
                          'Aujourd’hui',
                          style: TextStyle(
                            fontSize: 11,
                            color: Color(0xFFAAAAAA),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Salut 😊',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF777777),
                      ),
                    ),
                    const SizedBox(height: 7),
                    Row(
                      children: [
                        const Icon(
                          Icons.circle,
                          size: 8,
                          color: Color(0xFF45B96B),
                        ),
                        const SizedBox(width: 5),
                        const Text(
                          'En ligne',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF45B96B),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (profile.verified) ...[
                          const SizedBox(width: 9),
                          const Icon(
                            Icons.verified,
                            size: 14,
                            color: Color(0xFF3298DB),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                width: 43,
                height: 43,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFE5EF),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Icon(
                  Icons.chevron_right,
                  color: Color(0xFFC52A70),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
