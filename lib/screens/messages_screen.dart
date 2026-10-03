import 'package:flutter/material.dart';

import '../models/dating_profile.dart';
import '../services/block_service.dart';
import '../services/dating_profile_service.dart';
import '../services/match_service.dart';
import '../services/message_service.dart';
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

    _loadConversations();
  }

  void _loadConversations() {
    final profiles = DatingProfileService.getProfiles();

    _conversations = profiles.where((profile) {
      return MatchService.isMatched(profile) &&
          !BlockService.isBlocked(profile);
    }).toList();

    _conversations.sort(
      (a, b) {
        final aMessage =
            MessageService.getLastMessage(a);

        final bMessage =
            MessageService.getLastMessage(b);

        if (aMessage == null && bMessage == null) {
          return 0;
        }

        if (aMessage == null) {
          return 1;
        }

        if (bMessage == null) {
          return -1;
        }

        return bMessage.sentAt.compareTo(
          aMessage.sentAt,
        );
      },
    );
  }

  Future<void> _refreshConversations() async {
    if (!mounted) return;

    setState(() {
      _loadConversations();
    });
  }

  void _openChat(DatingProfile profile) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ChatScreen(
          profile: profile,
        ),
      ),
    ).then((_) {
      if (!mounted) return;

      setState(() {
        _loadConversations();
      });
    });
  }

  Future<void> _removeConversation(
    DatingProfile profile,
  ) async {
    await MessageService.deleteConversation(profile);

    if (!mounted) return;

    setState(() {
      _loadConversations();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'La conversation avec ${profile.name} a été supprimée.',
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _blockProfile(
    DatingProfile profile,
  ) async {
    await BlockService.blockProfile(profile);

    await MessageService.deleteConversation(
      profile,
    );

    if (!mounted) return;

    setState(() {
      MatchService.removeMatch(profile);
      _loadConversations();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${profile.name} a été bloqué(e).',
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  String _getLastMessage(
    DatingProfile profile,
  ) {
    final message =
        MessageService.getLastMessage(profile);

    if (message == null) {
      return 'Commence la conversation 💬';
    }

    if (message.isMine) {
      return 'Toi : ${message.text}';
    }

    return message.text;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8FB),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                20,
                15,
                20,
                10,
              ),
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Messages',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  Container(
                    width: 45,
                    height: 45,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFE5EF),
                      borderRadius:
                          BorderRadius.circular(15),
                    ),
                    child: const Icon(
                      Icons.chat_bubble_outline,
                      color: Color(0xFFC52A70),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: _conversations.isEmpty
                  ? const Center(
                      child: Text(
                        'Aucun message pour le moment 💬',
                        style: TextStyle(
                          fontSize: 17,
                          color: Color(0xFF777777),
                        ),
                      ),
                    )
                  : RefreshIndicator(
                      color: Color(0xFFED1767),
                      onRefresh:
                          _refreshConversations,
                      child: ListView.builder(
                        padding:
                            const EdgeInsets.all(18),
                        itemCount:
                            _conversations.length,
                        itemBuilder:
                            (context, index) {
                          final profile =
                              _conversations[index];

                          return Padding(
                            padding:
                                const EdgeInsets.only(
                              bottom: 12,
                            ),
                            child:
                                _ConversationCard(
                              profile: profile,
                              lastMessage:
                                  _getLastMessage(
                                      profile),
                              onTap: () {
                                _openChat(profile);
                              },
                            ),
                          );
                        },
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
  final VoidCallback onTap;

  const _ConversationCard({
    required this.profile,
    required this.lastMessage,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius:
          BorderRadius.circular(24),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius:
              BorderRadius.circular(24),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 32,
              backgroundColor:
                  const Color(0xFFFFE5EF),
              child: Text(
                profile.emoji,
                style:
                    const TextStyle(fontSize: 32),
              ),
            ),

            const SizedBox(width: 14),

            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    '${profile.name}, ${profile.age}',
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight:
                          FontWeight.w900,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    lastMessage,
                    maxLines: 1,
                    overflow:
                        TextOverflow.ellipsis,
                    style: const TextStyle(
                      color:
                          Color(0xFF777777),
                    ),
                  ),
                ],
              ),
            ),

            const Icon(
              Icons.chevron_right,
              color: Color(0xFFBBBBBB),
            ),
          ],
        ),
      ),
    );
  }
}
