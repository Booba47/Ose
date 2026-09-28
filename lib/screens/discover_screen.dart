import 'package:flutter/material.dart';

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({super.key});

  @override
  State<DiscoverScreen> createState() =>
      _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  final List<Map<String, dynamic>> _profiles = [
    {
      'name': 'Sophie',
      'age': 27,
      'city': 'Paris',
      'bio':
          'J’aime les voyages, la musique et les soirées tranquilles.',
      'emoji': '👩🏻',
    },
    {
      'name': 'Emma',
      'age': 29,
      'city': 'Lyon',
      'bio':
          'Curieuse, souriante et toujours partante pour découvrir.',
      'emoji': '👩🏼',
    },
    {
      'name': 'Camille',
      'age': 25,
      'city': 'Marseille',
      'bio':
          'Cinéma, cuisine et longues discussions autour d’un café.',
      'emoji': '👩🏽',
    },
    {
      'name': 'Julie',
      'age': 28,
      'city': 'Bordeaux',
      'bio':
          'J’adore les balades, les voyages et les conversations sincères.',
      'emoji': '👩🏻',
    },
  ];

  int _currentIndex = 0;

  void _passProfile() {
    _showActionMessage('Profil passé');
    _nextProfile();
  }

  void _likeProfile() {
    final profile = _profiles[_currentIndex];

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Tu as aimé ${profile['name']} ❤️',
        ),
        duration: const Duration(seconds: 2),
      ),
    );

    _nextProfile();
  }

  void _showActionMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _nextProfile() {
    setState(() {
      if (_currentIndex < _profiles.length - 1) {
        _currentIndex++;
      } else {
        _currentIndex = 0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final profile = _profiles[_currentIndex];

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          16,
          10,
          16,
          8,
        ),
        child: Column(
          children: [
            Expanded(
              child: Card(
                clipBehavior: Clip.antiAlias,
                elevation: 4,
                child: Column(
                  children: [
                    Expanded(
                      flex: 6,
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.pink.shade50,
                        ),
                        child: Center(
                          child: Text(
                            profile['emoji'],
                            style: const TextStyle(
                              fontSize: 115,
                            ),
                          ),
                        ),
                      ),
                    ),

                    Expanded(
                      flex: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    '${profile['name']}, '
                                    '${profile['age']}',
                                    style: const TextStyle(
                                      fontSize: 27,
                                      fontWeight:
                                          FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Icon(
                                  Icons.verified,
                                  color: Colors.pink.shade400,
                                ),
                              ],
                            ),

                            const SizedBox(height: 6),

                            Row(
                              children: [
                                Icon(
                                  Icons.location_on_outlined,
                                  size: 18,
                                  color: Colors.grey.shade600,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  profile['city'],
                                  style: TextStyle(
                                    color:
                                        Colors.grey.shade700,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 14),

                            Text(
                              profile['bio'],
                              maxLines: 3,
                              overflow:
                                  TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 16,
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
            ),

            const SizedBox(height: 16),

            Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceEvenly,
              children: [
                _ActionButton(
                  icon: Icons.close,
                  label: 'Passer',
                  onPressed: _passProfile,
                  color: Colors.grey,
                ),

                _ActionButton(
                  icon: Icons.favorite,
                  label: 'J’aime',
                  onPressed: _likeProfile,
                  color: Colors.pink,
                ),
              ],
            ),

            const SizedBox(height: 10),

            Text(
              'Prends ton temps. Il n’y a aucune pression. ❤️',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  final Color color;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onPressed,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: 70,
          height: 70,
          child: FloatingActionButton(
            heroTag: label,
            onPressed: onPressed,
            backgroundColor: color,
            child: Icon(
              icon,
              size: 32,
              color: Colors.white,
            ),
          ),
        ),

        const SizedBox(height: 6),

        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
