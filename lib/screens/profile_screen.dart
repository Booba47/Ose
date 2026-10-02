import 'dart:io';

import 'package:flutter/material.dart';

import '../models/user_profile.dart';
import '../services/user_service.dart';
import 'settings_screen.dart';

class ProfileScreen extends StatefulWidget {
  final UserProfile profile;

  const ProfileScreen({
    super.key,
    required this.profile,
  });

  @override
  State<ProfileScreen> createState() =>
      _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late UserProfile _profile;

  @override
  void initState() {
    super.initState();
    _profile = widget.profile;
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final savedProfile =
        await UserService.getProfile();

    if (!mounted || savedProfile == null) {
      return;
    }

    setState(() {
      _profile = savedProfile;
    });
  }

  void _openSettings() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const SettingsScreen(),
      ),
    );
  }

  Widget _buildPhoto(String path) {
    final isNetworkImage =
        path.startsWith('http://') ||
        path.startsWith('https://');

    if (isNetworkImage) {
      return Image.network(
        path,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) {
          return const Center(
            child: Icon(
              Icons.person,
              size: 50,
              color: Colors.black26,
            ),
          );
        },
      );
    }

    return Image.file(
      File(path),
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) {
        return const Center(
          child: Icon(
            Icons.person,
            size: 50,
            color: Colors.black26,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFFE6005C);

    return Scaffold(
      backgroundColor: const Color(0xFFFFF7FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Mon profil',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: _openSettings,
            icon: const Icon(
              Icons.settings_outlined,
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        color: primaryColor,
        onRefresh: _loadProfile,
        child: ListView(
          physics:
              const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(
            20,
            8,
            20,
            32,
          ),
          children: [
            if (_profile.photos.isNotEmpty)
              SizedBox(
                height: 230,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _profile.photos.length,
                  separatorBuilder: (_, __) =>
                      const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    return ClipRRect(
                      borderRadius:
                          BorderRadius.circular(22),
                      child: SizedBox(
                        width: 180,
                        child: _buildPhoto(
                          _profile.photos[index],
                        ),
                      ),
                    );
                  },
                ),
              )
            else
              Container(
                height: 230,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.circular(22),
                ),
                child: const Center(
                  child: Icon(
                    Icons.person_outline,
                    size: 70,
                    color: Colors.black26,
                  ),
                ),
              ),

            const SizedBox(height: 20),

            Text(
              '${_profile.name}, ${_profile.age}',
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 6),

            Row(
              children: [
                const Icon(
                  Icons.location_on_outlined,
                  size: 18,
                  color: Colors.black54,
                ),
                const SizedBox(width: 4),
                Text(
                  _profile.city,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            if (_profile.hasBio) ...[
              const Text(
                'À propos de moi',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _profile.bio,
                style: const TextStyle(
                  fontSize: 15,
                  height: 1.5,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 24),
            ],

            const Text(
              'Mes centres d’intérêt',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            if (_profile.interests.isEmpty)
              const Text(
                'Aucun centre d’intérêt ajouté.',
                style: TextStyle(
                  color: Colors.black54,
                ),
              )
            else
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _profile.interests
                    .map(
                      (interest) => Chip(
                        label: Text(interest),
                        backgroundColor:
                            primaryColor.withValues(
                          alpha: 0.08,
                        ),
                        side: BorderSide.none,
                      ),
                    )
                    .toList(),
              ),

            const SizedBox(height: 24),

            const Text(
              'Je recherche',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.circular(18),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.favorite_border,
                    color: primaryColor,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      _profile.lookingFor,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            SizedBox(
              height: 54,
              child: OutlinedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(
                    const SnackBar(
                      content: Text(
                        'La modification du profil sera disponible prochainement.',
                      ),
                      behavior:
                          SnackBarBehavior.floating,
                    ),
                  );
                },
                icon: const Icon(
                  Icons.edit_outlined,
                ),
                label: const Text(
                  'Modifier mon profil',
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: primaryColor,
                  side: const BorderSide(
                    color: primaryColor,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
