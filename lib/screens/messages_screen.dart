import 'package:flutter/material.dart';

import '../models/dating_profile.dart';
import '../services/dating_profile_service.dart';
import '../services/match_service.dart';
import 'chat_screen.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key});

  @override
  State<MessagesScreen> createState() =>
      _MessagesScreenState();
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
        builder: (_) => ChatScreen(
          profile: profile,
        ),
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
                      'Messages',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  if (_conversations.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 7,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.pink.shade50,
                        borderRadius:
                            BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.chat_bubble,
                            size: 15,
                            color: Colors.pink,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            '${_conversations.length}',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight:
                                  FontWeight.bold,
                              color:
                                  Colors.pink.shade800,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),

            Expanded(
              child: _conversations.isEmpty
                  ? _buildEmptyState()
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(
                        16,
                        8,
                        16,
                        24,
                      ),
                      itemCount: _conversations.length,
                      separatorBuilder: (_, __) {
                        return const SizedBox(height: 10);
                      },
                      itemBuilder: (context, index) {
                        final profile =
                            _conversations[index];

                        return _ConversationCard(
                          profile: profile,
                          lastMessage: index == 0
                              ? 'Salut 😊'
                              : 'Content(e) de faire ta connaissance !',
                          time: index == 0
                              ? 'Maintenant'
                              : 'Hier',
                          unreadCount:
                              index == 0 ? 2 : 0,
                          onTap: () {
                            _openChat(profile);
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
          mainAxisAlignment:
              MainAxisAlignment.center,
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
                  '💬',
                  style: TextStyle(
                    fontSize: 48,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            const Text(
              'Aucune conversation',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              'Quand tu auras un match, tu pourras '
              'commencer une conversation ici.',
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
                borderRadius:
                    BorderRadius.circular(20),
              ),
              child: Text(
                'Ose envoyer le premier message ❤️',
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

class _ConversationCard extends StatelessWidget {
  final DatingProfile profile;
  final String lastMessage;
  final String time;
  final int unreadCount;
  final VoidCallback onTap;

  const _ConversationCard({
    required this.profile,
    required this.lastMessage,
    required this.time,
    required this.unreadCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: unreadCount > 0
                ? Colors.pink.shade50.withValues(
                    alpha: 0.55,
                  )
                : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.grey.shade200,
            ),
          ),
          child: Row(
            children: [
              Stack(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: Colors.pink.shade50,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        profile.emoji,
                        style: const TextStyle(
                          fontSize: 35,
                        ),
                      ),
                    ),
                  ),

                  Positioned(
                    right: 0,
                    bottom: 1,
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

              const SizedBox(width: 13),

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
                            overflow:
                                TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight:
                                  unreadCount > 0
                                      ? FontWeight.bold
                                      : FontWeight.w600,
                            ),
                          ),
                        ),

                        if (profile.verified) ...[
                          const SizedBox(width: 5),
                          Icon(
                            Icons.verified,
                            size: 17,
                            color: Colors.blue.shade600,
                          ),
                        ],

                        const Spacer(),

                        Text(
                          time,
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 6),

                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            lastMessage,
                            maxLines: 1,
                            overflow:
                                TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 13,
                              color: unreadCount > 0
                                  ? Colors.black87
                                  : Colors.grey.shade600,
                              fontWeight:
                                  unreadCount > 0
                                      ? FontWeight.w600
                                      : FontWeight.normal,
                            ),
                          ),
                        ),

                        if (unreadCount > 0) ...[
                          const SizedBox(width: 8),
                          Container(
                            width: 23,
                            height: 23,
                            decoration:
                                const BoxDecoration(
                              color: Colors.pink,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                '$unreadCount',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight:
                                      FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),

                    const SizedBox(height: 5),

                    Row(
                      children: [
                        Icon(
                          Icons.favorite,
                          size: 12,
                          color: Colors.pink.shade400,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Match',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
