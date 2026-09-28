import 'package:flutter/material.dart';

import '../models/dating_profile.dart';
import '../services/dating_profile_service.dart';
import '../services/like_service.dart';

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({super.key});

  @override
  State<DiscoverScreen> createState() =>
      _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  late final List<DatingProfile> _profiles;

  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();

    _profiles = DatingProfileService.getProfiles();
  }

  void _passProfile() {
    final profile = _profiles[_currentIndex];

    LikeService.passProfile(profile);

    _showMessage(
      'Profil passé',
    );

    _nextProfile();
  }

  void _likeProfile() {
    final profile = _profiles[_currentIndex];

    LikeService.likeProfile(profile);

    _showMessage(
      'Tu as aimé ${profile.name} ❤️',
    );

    _nextProfile();
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
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
    if (_profiles.isEmpty) {
      return const Center(
        child: Text(
          'Aucun profil disponible pour le moment.',
        ),
      );
    }

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
                      flex: 5,
                      child: Container(
                        width: double.infinity,
                        color: Colors.pink.shade50,
                        child: Center(
                          child: Text(
                            profile.emoji,
                            style: const TextStyle(
                              fontSize: 115,
                            ),
                          ),
                        ),
                      ),
                    ),

                    Expanded(
                      flex: 5,
                      child: Padding(
                        padding: const EdgeInsets.all(18),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      '${profile.name}, '
                                      '${profile.age}',
                                      style: const TextStyle(
                                        fontSize: 27,
                                        fontWeight:
                                            FontWeight.bold,
                                      ),
                                    ),
                                  ),

                                  if (profile.verified)
                                    Icon(
                                      Icons.verified,
                                      color:
                                          Colors.pink.shade400,
                                    ),
                                ],
                              ),

                              const SizedBox(height: 6),

                              Row(
                                children: [
                                  Icon(
                                    Icons.location_on_outlined,
                                    size: 18,
                                    color:
                                        Colors.grey.shade600,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    profile.city,
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
                                profile.bio,
                                style: const TextStyle(
                                  fontSize: 16,
                                  height: 1.4,
                                ),
                              ),

                              const SizedBox(height: 14),

                              const Text(
                                'Centres d’intérêt',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight:
                                      FontWeight.bold,
                                ),
                              ),

                              const SizedBox(height: 8),

                              Wrap(
                                spacing: 6,
                                runSpacing: 6,
                                children: profile.interests
                                    .map(
                                      (interest) => Chip(
                                        label:
                                            Text(interest),
                                      ),
                                    )
                                    .toList(),
                              ),
                            ],
                          ),
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
