import 'package:flutter/material.dart';

class MessagesScreen extends StatelessWidget {
  const MessagesScreen({super.key});

  final List<Map<String, String>> _conversations = const [
    {
      'name': 'Sophie',
      'message': 'Salut 😊 Comment vas-tu ?',
      'time': '18:42',
      'emoji': '👩🏻',
      'unread': '2',
    },
    {
      'name': 'Emma',
      'message': 'J’ai aussi beaucoup aimé voyager !',
      'time': '17:15',
      'emoji': '👩🏼',
      'unread': '0',
    },
    {
      'name': 'Aïcha',
      'message': 'Ça me ferait plaisir de discuter avec toi ❤️',
      'time': 'Hier',
      'emoji': '👩🏿',
      'unread': '1',
    },
  ];

  void _openConversation(
    BuildContext context,
    String name,
  ) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'La conversation avec $name sera bientôt disponible.',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_conversations.isEmpty) {
      return const _EmptyMessages();
    }

    return SafeArea(
      child: Column(
        children: [
          const SizedBox(height: 15),

          const Text(
            'Mes messages 💬',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            'Tes conversations avec tes Matchs.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey.shade700,
            ),
          ),

          const SizedBox(height: 20),

          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(
                16,
                5,
                16,
                20,
              ),
              itemCount: _conversations.length,
              separatorBuilder: (_, __) =>
                  const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final conversation =
                    _conversations[index];

                final unread =
                    int.tryParse(
                      conversation['unread'] ?? '0',
                    ) ??
                    0;

                return Card(
                  elevation: 2,
                  child: InkWell(
                    borderRadius:
                        BorderRadius.circular(12),
                    onTap: () {
                      _openConversation(
                        context,
                        conversation['name']!,
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundColor:
                                Colors.pink.shade50,
                            child: Text(
                              conversation['emoji']!,
                              style:
                                  const TextStyle(
                                fontSize: 30,
                              ),
                            ),
                          ),

                          const SizedBox(width: 14),

                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment
                                      .start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        conversation[
                                            'name']!,
                                        style:
                                            const TextStyle(
                                          fontSize: 18,
                                          fontWeight:
                                              FontWeight
                                                  .bold,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      conversation[
                                          'time']!,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors
                                            .grey
                                            .shade600,
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 5),

                                Text(
                                  conversation[
                                      'message']!,
                                  maxLines: 1,
                                  overflow:
                                      TextOverflow
                                          .ellipsis,
                                  style: TextStyle(
                                    color: unread > 0
                                        ? Colors.black
                                        : Colors
                                            .grey
                                            .shade600,
                                    fontWeight: unread > 0
                                        ? FontWeight.w600
                                        : FontWeight
                                            .normal,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          if (unread > 0) ...[
                            const SizedBox(width: 10),

                            Container(
                              width: 24,
                              height: 24,
                              decoration:
                                  const BoxDecoration(
                                color: Colors.pink,
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  '$unread',
                                  style:
                                      const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight:
                                        FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyMessages extends StatelessWidget {
  const _EmptyMessages();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 20),

            const Icon(
              Icons.chat_bubble,
              size: 75,
              color: Colors.pink,
            ),

            const SizedBox(height: 20),

            const Text(
              'Mes messages 💬',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            Text(
              'Tes conversations avec tes Matchs '
              'apparaîtront ici.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade700,
                height: 1.4,
              ),
            ),

            const SizedBox(height: 35),

            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment:
                      MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.forum_outlined,
                      size: 70,
                      color: Colors.grey.shade400,
                    ),

                    const SizedBox(height: 16),

                    const Text(
                      'Aucune conversation',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      'Quand tu auras un Match, '
                      'vous pourrez commencer à discuter.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        height: 1.4,
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
}
