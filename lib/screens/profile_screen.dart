import 'dart:io';

import 'package:flutter/material.dart';

import '../models/user_profile.dart';

class ProfileScreen extends StatelessWidget {
  final UserProfile profile;

  const ProfileScreen({
    super.key,
    required this.profile,
  });

  bool _isLocalPhoto(String path) {
    return path.startsWith('/') ||
        path.startsWith('file://');
  }

  Widget _buildProfilePhoto() {
    final photo = profile.primaryPhoto;

    if (photo == null || photo.isEmpty) {
      return Container(
        width: 110,
        height: 110,
        decoration: BoxDecoration(
          color: Colors.pink.shade50,
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.person,
          size: 58,
          color: Colors.pink,
        ),
      );
    }

    if (_isLocalPhoto(photo)) {
      final localPath = photo.startsWith('file://')
          ? photo.replaceFirst('file://', '')
          : photo;

      return ClipOval(
        child: Image.file(
          File(localPath),
          width: 110,
          height: 110,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) {
            return Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                color: Colors.pink.shade50,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.person,
                size: 58,
                color: Colors.pink,
              ),
            );
          },
        ),
      );
    }

    return ClipOval(
      child: Image.network(
        photo,
        width: 110,
        height: 110,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) {
          return Container(
            width: 110,
            height: 110,
            decoration: BoxDecoration(
              color: Colors.pink.shade50,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.person,
              size: 58,
              color: Colors.pink,
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            20,
            20,
            20,
            30,
          ),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              const Center(
                child: Text(
                  'Mon profil',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 24),

              Center(
                child: Stack(
                  children: [
                    _buildProfilePhoto(),

                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        width: 34,
                        height: 34,
                        decoration: const BoxDecoration(
                          color: Colors.pink,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.edit,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              Center(
                child: Text(
                  '${profile.name}, ${profile.age}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 6),

              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: 18,
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
              ),

              const SizedBox(height: 24),

              _SectionCard(
                title: 'À propos de moi',
                icon: Icons.person_outline,
                child: Text(
                  profile.bio,
                  style: const TextStyle(
                    fontSize: 15,
                    height: 1.5,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              _SectionCard(
                title: 'Mes centres d’intérêt',
                icon: Icons.favorite_border,
                child: Wrap(
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
                          color: Colors.pink.shade50,
                          borderRadius:
                              BorderRadius.circular(20),
                        ),
                        child: Text(
                          interest,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight:
                                FontWeight.w600,
                            color: Colors.pink.shade800,
                          ),
                        ),
                      );
                    },
                  ).toList(),
                ),
              ),

              const SizedBox(height: 16),

              _SectionCard(
                title: 'Ce que je recherche',
                icon: Icons.search,
                child: Text(
                  profile.lookingFor,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: OutlinedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(
                      const SnackBar(
                        content: Text(
                          'La modification du profil sera '
                          'ajoutée prochainement.',
                        ),
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.edit_outlined,
                  ),
                  label: const Text(
                    'Modifier mon profil',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: OutlinedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Les réglages du compte seront '
                          'ajoutés prochainement.',
                        ),
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.settings_outlined,
                  ),
                  label: const Text(
                    'Réglages du compte',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              Center(
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
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;

  const _SectionCard({
    required this.title,
    required this.icon,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colors.grey.shade200,
        ),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: Colors.pink,
                size: 21,
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          child,
        ],
      ),
    );
  }
}        title: 'Aide et assistance',
              onTap: () {
                _showComingSoon(
                  context,
                  'Le centre d’aide sera ajouté prochainement.',
                );
              },
            ),

            const SizedBox(height: 20),

            Center(
              child: Text(
                'Ose faire le premier pas. ❤️',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileAction extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _ProfileAction({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 8),
      color: Colors.grey.shade50,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 14,
          ),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: Colors.pink,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: Colors.grey.shade500,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
