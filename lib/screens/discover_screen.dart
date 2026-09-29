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
    if (_currentIndex >= _profiles.length) {
      return null;
    }

    return _profiles[_currentIndex];
  }

  void _pass() {
    final profile = _currentProfile;

    if (profile == null) {
      return;
    }

    LikeService.passProfile(profile);

    setState(() {
      _currentIndex++;
    });
  }

  void _like() {
    final profile = _currentProfile;

    if (profile == null) {
      return;
    }

    LikeService.likeProfile(profile);

    if (MatchService.isMatched(profile)) {
      MatchService.createMatch(profile);
      _showMatchDialog(profile);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Tu as aimé ${profile.name} ❤️',
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }

    setState(() {
      _currentIndex++;
    });
  }

  void _showMatchDialog(DatingProfile profile) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          title: const Text(
            'C’est un match ! 💕',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w800,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  color: Colors.pink.shade50,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  profile.emoji,
                  style: const TextStyle(
                    fontSize: 50,
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Text(
                'Toi et ${profile.name} vous vous êtes aimés.',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Tu peux maintenant commencer une conversation.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black54,
                ),
              ),
            ],
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            FilledButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: FilledButton.styleFrom(
                backgroundColor: Colors.pink,
              ),
              child: const Text(
                'Continuer',
              ),
            ),
          ],
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
      return _buildEndState();
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        16,
        8,
        16,
        16,
      ),
      child: Column(
        children: [
          Expanded(
            child: _buildProfileCard(profile),
          ),
          const SizedBox(height: 14),
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildProfileCard(DatingProfile profile) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.pink.shade50,
            Colors.white,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: 0.08,
            ),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: 230,
                  decoration: BoxDecoration(
                    color: Colors.pink.shade100,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    profile.emoji,
                    style: const TextStyle(
                      fontSize: 100,
                    ),
                  ),
                ),
                if (profile.verified)
                  Positioned(
                    top: 14,
                    right: 14,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 7,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.verified,
                            size: 18,
                            color: Colors.blue,
                          ),
                          SizedBox(width: 5),
                          Text(
                            'Vérifié',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 18),

            Row(
              children: [
                Expanded(
                  child: Text(
                    '${profile.name}, ${profile.age}',
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 6),

            Row(
              children: [
                Icon(
                  Icons.location_on_outlined,
                  size: 19,
                  color: Colors.pink.shade400,
                ),
                const SizedBox(width: 5),
                Text(
                  profile.city,
                  style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 15,
                  ),
                ),
              ],
            ),

            if (profile.hasBio) ...[
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  profile.bio,
                  style: const TextStyle(
                    fontSize: 16,
                    height: 1.4,
                  ),
                ),
              ),
            ],

            if (profile.hasInterests) ...[
              const SizedBox(height: 18),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Centres d’intérêt',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerLeft,
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: profile.interests.map(
                    (interest) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.pink.shade100,
                          ),
                        ),
                        child: Text(
                          interest,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      );
                    },
                  ).toList(),
                ),
              ),
            ],

            const SizedBox(height: 18),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Row(
                children: [
                  Icon(
                    profile.verified
                        ? Icons.verified_user_outlined
                        : Icons.shield_outlined,
                    color: profile.verified
                        ? Colors.blue
                        : Colors.black45,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      profile.verified
                          ? 'Profil vérifié par Ose'
                          : 'Profil non vérifié pour le moment',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
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

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _ActionButton(
          icon: Icons.close_rounded,
          label: 'Passer',
          backgroundColor: Colors.white,
          foregroundColor: Colors.grey.shade700,
          borderColor: Colors.grey.shade300,
          onPressed: _pass,
        ),
        const SizedBox(width: 22),
        _ActionButton(
          icon: Icons.favorite_rounded,
          label: 'J’aime',
          backgroundColor: Colors.pink,
          foregroundColor: Colors.white,
          borderColor: Colors.pink,
          onPressed: _like,
        ),
      ],
    );
  }

  Widget _buildEndState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.pink.shade50,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: const Text(
                '💕',
                style: TextStyle(
                  fontSize: 52,
                ),
              ),
            ),
            const SizedBox(height: 22),
            const Text(
              'Tu as fait le tour !',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Il n’y a plus de profils à découvrir pour le moment.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black54,
                fontSize: 16,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: _restartDiscovery,
              icon: const Icon(
                Icons.refresh_rounded,
              ),
              label: const Text(
                'Recommencer',
              ),
              style: FilledButton.styleFrom(
                backgroundColor: Colors.pink,
                padding: const EdgeInsets.symmetric(
                  horizontal: 22,
                  vertical: 14,
                ),
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
  final Color backgroundColor;
  final Color foregroundColor;
  final Color borderColor;
  final VoidCallback onPressed;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.borderColor,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Material(
          color: backgroundColor,
          shape: CircleBorder(
            side: BorderSide(
              color: borderColor,
              width: 1.5,
            ),
          ),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: onPressed,
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Icon(
                icon,
                size: 30,
                color: foregroundColor,
              ),
            ),
          ),
        ),
        const SizedBox(height: 5),
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
