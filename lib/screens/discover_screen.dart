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

    // Quelques matchs de démonstration pour rendre l'application
    // immédiatement vivante.
    MatchService.initializeDemoMatches();
  }

  DatingProfile? get _currentProfile {
    if (_currentIndex >= _profiles.length) {
      return null;
    }

    return _profiles[_currentIndex];
  }

  void _nextProfile() {
    if (!mounted) {
      return;
    }

    setState(() {
      if (_currentIndex < _profiles.length - 1) {
        _currentIndex++;
      } else {
        _currentIndex = _profiles.length;
      }
    });
  }

  void _passProfile() {
    final profile = _currentProfile;

    if (profile == null) {
      return;
    }

    LikeService.passProfile(profile);

    _nextProfile();
  }

  void _likeProfile() {
    final profile = _currentProfile;

    if (profile == null) {
      return;
    }

    LikeService.likeProfile(profile);

    // Les profils de démonstration déjà présents dans les matchs
    // permettent de montrer l'écran de Match.
    if (MatchService.isMatched(profile)) {
      _showMatchDialog(profile);
      return;
    }

    _nextProfile();
  }

  void _showMatchDialog(DatingProfile profile) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 25,
          ),
          child: Container(
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(32),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFFFF6FA5),
                        Color(0xFFE6005C),
                      ],
                    ),
                  ),
                  child: Center(
                    child: Text(
                      profile.emoji,
                      style: const TextStyle(
                        fontSize: 48,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 22),

                const Text(
                  'C’est un Match ! 💕',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 29,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFFC52A70),
                  ),
                ),

                const SizedBox(height: 10),

                Text(
                  'Toi et ${profile.name} vous vous plaisez.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 17,
                    color: Color(0xFF666666),
                    height: 1.4,
                  ),
                ),

                const SizedBox(height: 8),

                const Text(
                  'C’est peut-être le moment de faire le premier pas. 😊',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF999999),
                    height: 1.4,
                  ),
                ),

                const SizedBox(height: 25),

                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _nextProfile();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFED1767),
                      foregroundColor: Colors.white,
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text(
                      'Continuer à découvrir',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _restartDiscovery() {
    setState(() {
      _currentIndex = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final profile = _currentProfile;

    if (profile == null) {
      return _buildEndScreen();
    }

    return Scaffold(
      backgroundColor: const Color(0xFFFFF8FB),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(
                  18,
                  5,
                  18,
                  15,
                ),
                child: Column(
                  children: [
                    _buildProfileCard(profile),

                    const SizedBox(height: 18),

                    _buildActionButtons(),
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
                  'Découvrir',
                  style: TextStyle(
                    fontSize: 29,
                    fontWeight: FontWeight.w900,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  'Une rencontre commence parfois par un simple ❤️',
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFF888888),
                  ),
                ),
              ],
            ),
          ),

          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFFFFE5EF),
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Icon(
              Icons.tune,
              color: Color(0xFFC52A70),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileCard(DatingProfile profile) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.07),
            blurRadius: 22,
            offset: const Offset(0, 9),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            _buildProfileHeader(profile),

            Padding(
              padding: const EdgeInsets.fromLTRB(
                20,
                18,
                20,
                22,
              ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          '${profile.name}, ${profile.age}',
                          style: const TextStyle(
                            fontSize: 27,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),

                      if (profile.verified)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 9,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEAF7FF),
                            borderRadius:
                                BorderRadius.circular(20),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.verified,
                                size: 16,
                                color: Color(0xFF3298DB),
                              ),
                              SizedBox(width: 4),
                              Text(
                                'Vérifié',
                                style: TextStyle(
                                  color: Color(0xFF3298DB),
                                  fontWeight: FontWeight.w700,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        size: 19,
                        color: Color(0xFFC52A70),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        profile.city,
                        style: const TextStyle(
                          color: Color(0xFF777777),
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 18),

                  Text(
                    profile.bio,
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.45,
                      color: Color(0xFF555555),
                    ),
                  ),

                  const SizedBox(height: 18),

                  const Text(
                    'Ses centres d’intérêt',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF9F2458),
                    ),
                  ),

                  const SizedBox(height: 10),

                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: profile.interests.map(
                      (interest) {
                        return Container(
                          padding:
                              const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFE8F0),
                            borderRadius:
                                BorderRadius.circular(20),
                          ),
                          child: Text(
                            interest,
                            style: const TextStyle(
                              color: Color(0xFFC52A70),
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                        );
                      },
                    ).toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(DatingProfile profile) {
    return Container(
      height: 310,
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFFFD6E5),
            Color(0xFFFFEEF4),
          ],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -45,
            right: -30,
            child: Container(
              width: 145,
              height: 145,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.30),
                shape: BoxShape.circle,
              ),
            ),
          ),

          Positioned(
            bottom: -55,
            left: -35,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                color: const Color(0xFFF6A8C7)
                    .withValues(alpha: 0.25),
                shape: BoxShape.circle,
              ),
            ),
          ),

          Center(
            child: Container(
              width: 175,
              height: 175,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.10),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  profile.emoji,
                  style: const TextStyle(
                    fontSize: 92,
                  ),
                ),
              ),
            ),
          ),

          Positioned(
            left: 16,
            top: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 11,
                vertical: 7,
              ),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.92),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.auto_awesome,
                    size: 15,
                    color: Color(0xFFC52A70),
                  ),
                  SizedBox(width: 5),
                  Text(
                    'Découverte',
                    style: TextStyle(
                      color: Color(0xFFC52A70),
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _ActionButton(
          icon: Icons.close,
          label: 'Passer',
          color: const Color(0xFF777777),
          backgroundColor: Colors.white,
          onPressed: _passProfile,
        ),

        const SizedBox(width: 18),

        _ActionButton(
          icon: Icons.favorite,
          label: "J'aime",
          color: Colors.white,
          backgroundColor: const Color(0xFFED1767),
          onPressed: _likeProfile,
          large: true,
        ),
      ],
    );
  }

  Widget _buildEndScreen() {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8FB),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(28),
            child: Column(
              mainAxisAlignment:
                  MainAxisAlignment.center,
              children: [
                Container(
                  width: 125,
                  height: 125,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFFE5EF),
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Text(
                      '💕',
                      style: TextStyle(
                        fontSize: 55,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                const Text(
                  'Tu as fait le tour !',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                  ),
                ),

                const SizedBox(height: 12),

                const Text(
                  'De nouvelles rencontres arriveront bientôt. '
                  'En attendant, pourquoi ne pas regarder tes matchs ?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    height: 1.45,
                    color: Color(0xFF777777),
                  ),
                ),

                const SizedBox(height: 30),

                SizedBox(
                  width: double.infinity,
                  height: 58,
                  child: ElevatedButton.icon(
                    onPressed: _restartDiscovery,
                    icon: const Icon(
                      Icons.refresh,
                    ),
                    label: const Text(
                      'Recommencer',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          const Color(0xFFED1767),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 18),

                const Text(
                  'Ose faire le premier pas. 💕',
                  style: TextStyle(
                    color: Color(0xFFAAAAAA),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
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
    final double size = large ? 76 : 66;

    return Column(
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onPressed,
            borderRadius: BorderRadius.circular(50),
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                color: backgroundColor,
                shape: BoxShape.circle,
                border: large
                    ? null
                    : Border.all(
                        color: const Color(0xFFE0E0E0),
                        width: 1.5,
                      ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 12,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Icon(
                icon,
                color: color,
                size: large ? 32 : 28,
              ),
            ),
          ),
        ),

        const SizedBox(height: 7),

        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: Color(0xFF777777),
          ),
        ),
      ],
    );
  }
}
