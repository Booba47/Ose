import 'package:flutter/material.dart';

import '../models/dating_profile.dart';
import '../services/dating_profile_service.dart';
import '../services/like_service.dart';
import '../services/match_service.dart';

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({super.key});

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  late List<DatingProfile> _profiles;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();

    _profiles = DatingProfileService.getProfiles();

    MatchService.initializeDemoMatches();
  }

  DatingProfile? get _currentProfile {
    if (_profiles.isEmpty ||
        _currentIndex >= _profiles.length) {
      return null;
    }

    return _profiles[_currentIndex];
  }

  void _passProfile() {
    final profile = _currentProfile;

    if (profile == null) {
      return;
    }

    LikeService.passProfile(profile);

    setState(() {
      _currentIndex++;
    });
  }

  void _likeProfile() {
    final profile = _currentProfile;

    if (profile == null) {
      return;
    }

    LikeService.likeProfile(profile);

    final isMatch = MatchService.isMatched(profile);

    setState(() {
      _currentIndex++;
    });

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text(
          isMatch
              ? 'C’est un match avec ${profile.name} ! ❤️'
              : 'Tu as aimé ${profile.name} ❤️',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final profile = _currentProfile;

    if (profile == null) {
      return const _DiscoverFinished();
    }

    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              18,
              14,
              18,
              8,
            ),
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    'Découvrir',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Les filtres seront ajoutés prochainement.',
                        ),
                        behavior:
                            SnackBarBehavior.floating,
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.tune_rounded,
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 18,
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Prends ton temps pour faire connaissance.',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade700,
                ),
              ),
            ),
          ),

          const SizedBox(height: 14),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                16,
                0,
                16,
                8,
              ),
              child: _ProfileCard(
                profile: profile,
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(
              30,
              4,
              30,
              10,
            ),
            child: Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceEvenly,
              children: [
                _ActionButton(
                  icon: Icons.close_rounded,
                  label: 'Passer',
                  color: Colors.grey.shade700,
                  backgroundColor:
                      Colors.grey.shade100,
                  onPressed: _passProfile,
                ),
                _ActionButton(
                  icon: Icons.favorite_rounded,
                  label: 'J’aime',
                  color: Colors.white,
                  backgroundColor: Colors.pink,
                  onPressed: _likeProfile,
                  large: true,
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(
              bottom: 8,
            ),
            child: Text(
              'Ose faire le premier pas. ❤️',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileCard extends StatelessWidget {
  final DatingProfile profile;

  const _ProfileCard({
    required this.profile,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(26),
      ),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.pink.shade50,
              Colors.white,
            ],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            20,
            20,
            20,
            22,
          ),
          child: Column(
            children: [
              Container(
                width: 130,
                height: 130,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.pink.shade100,
                    width: 3,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black
                          .withValues(alpha: 0.08),
                      blurRadius: 12,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    profile.emoji,
                    style: const TextStyle(
                      fontSize: 72,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              Row(
                mainAxisAlignment:
                    MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Text(
                      '${profile.name}, ${profile.age}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  if (profile.verified) ...[
                    const SizedBox(width: 6),
                    const Icon(
                      Icons.verified,
                      color: Colors.pink,
                      size: 22,
                    ),
                  ],
                ],
              ),

              const SizedBox(height: 7),

              Row(
                mainAxisAlignment:
                    MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.location_on_outlined,
                    size: 17,
                    color: Colors.grey.shade600,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    profile.city,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 18),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  profile.bio,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    height: 1.45,
                    color: Colors.grey.shade800,
                  ),
                ),
              ),

              const SizedBox(height: 18),

              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Centres d’intérêt',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade900,
                  ),
                ),
              ),

              const SizedBox(height: 10),

              Align(
                alignment: Alignment.centerLeft,
                child: Wrap(
                  spacing: 7,
                  runSpacing: 7,
                  children:
                      profile.interests.map((interest) {
                    return Container(
                      padding:
                          const EdgeInsets.symmetric(
                        horizontal: 11,
                        vertical: 7,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.pink.shade50,
                        borderRadius:
                            BorderRadius.circular(20),
                      ),
                      child: Text(
                        interest,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.pink.shade800,
                          fontWeight:
                              FontWeight.w600,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),

              const SizedBox(height: 16),

              if (profile.verified)
                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.verified_user_outlined,
                      size: 16,
                      color: Colors.pink.shade700,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      'Profil vérifié',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.pink.shade700,
                        fontWeight:
                            FontWeight.w600,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final Color backgroundColor;
  final VoidCallback onPressed;
  final bool large;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.backgroundColor,
    required this.onPressed,
    this.large = false,
  });

  @override
  Widget build(BuildContext context) {
    final size = large ? 64.0 : 58.0;

    return Column(
      children: [
        SizedBox(
          width: size,
          height: size,
          child: Material(
            color: backgroundColor,
            shape: const CircleBorder(),
            elevation: large ? 3 : 1,
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: onPressed,
              child: Icon(
                icon,
                size: large ? 30 : 27,
                color: color,
              ),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade700,
          ),
        ),
      ],
    );
  }
}

class _DiscoverFinished extends StatelessWidget {
  const _DiscoverFinished();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
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
                child: const Icon(
                  Icons.favorite_border_rounded,
                  size: 52,
                  color: Colors.pink,
                ),
              ),

              const SizedBox(height: 24),

              const Text(
                'Tu as fait le tour !',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              Text(
                'De nouveaux profils pourront apparaître '
                'ici prochainement.',
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
      ),
    );
  }
}
