import 'package:flutter/material.dart';

class MatchesScreen extends StatelessWidget {
  const MatchesScreen({super.key});

  final List<Map<String, String>> _matches = const [
    {
      'name': 'Sophie',
      'age': '27',
      'city': 'Paris',
      'emoji': '👩🏻',
    },
    {
      'name': 'Emma',
      'age': '29',
      'city': 'Lyon',
      'emoji': '👩🏼',
    },
  ];

  void _openConversation(
    BuildContext context,
    String name,
  ) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'La conversation avec $name sera disponible prochainement.',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_matches.isEmpty) {
      return _EmptyMatches();
    }

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),

            const Center(
              child: Text(
                'Tes Matchs ❤️',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 10),

            Center(
              child: Text(
                'Vous vous êtes aimés mutuellement.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade700,
                ),
              ),
            ),

            const SizedBox(height: 30),

            const Text(
              'Tes Matchs',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 14),

            ListView.separated(
              shrinkWrap: true,
              physics:
                  const NeverScrollableScrollPhysics(),
              itemCount: _matches.length,
              separatorBuilder: (_, __) =>
                  const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final match = _matches[index];

                return Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 32,
                          backgroundColor:
                              Colors.pink.shade50,
                          child: Text(
                            match['emoji']!,
                            style: const TextStyle(
                              fontSize: 32,
                            ),
                          ),
                        ),

                        const SizedBox(width: 14),

                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${match['name']}, '
                                '${match['age']}',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight:
                                      FontWeight.bold,
                                ),
                              ),

                              const SizedBox(height: 4),

                              Row(
                                children: [
                                  Icon(
                                    Icons
                                        .location_on_outlined,
                                    size: 15,
                                    color: Colors
                                        .grey.shade600,
                                  ),
                                  const SizedBox(width: 3),
                                  Text(
                                    match['city']!,
                                    style: TextStyle(
                                      color: Colors
                                          .grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        IconButton(
                          onPressed: () {
                            _openConversation(
                              context,
                              match['name']!,
                            );
                          },
                          icon: const Icon(
                            Icons
                                .chat_bubble_outline,
                          ),
                          color: Colors.pink,
                          tooltip: 'Envoyer un message',
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 25),

            Center(
              child: Text(
                'De nouvelles rencontres apparaîtront ici. ❤️',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade600,
                ),
              ),
            ),

            const SizedBox(height: 20),
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
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 20),

            const Icon(
              Icons.favorite,
              size: 80,
              color: Colors.pink,
            ),

            const SizedBox(height: 20),

            const Text(
              'Tes Matchs ❤️',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            Text(
              'Quand quelqu’un t’aime aussi, '
              'vous aurez un Match.',
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
                      Icons.people_outline,
                      size: 70,
                      color: Colors.grey.shade400,
                    ),

                    const SizedBox(height: 16),

                    const Text(
                      'Pas encore de Match',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      'Continue à découvrir des profils.\n'
                      'Ton prochain Match est peut-être tout proche.',
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
