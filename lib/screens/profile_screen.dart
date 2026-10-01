import 'dart:io';

import 'package:flutter/material.dart';

import '../models/user_profile.dart';

class ProfileScreen extends StatelessWidget {
  final UserProfile profile;

  const ProfileScreen({
    super.key,
    required this.profile,
  });

  void _showComingSoon(
    BuildContext context,
    String message,
  ) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showPhoto(
    BuildContext context,
    String photoPath,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(16),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: _buildPhoto(
              photoPath,
              fit: BoxFit.contain,
            ),
          ),
        );
      },
    );
  }

  Widget _buildPhoto(
    String path, {
    BoxFit fit = BoxFit.cover,
  }) {
    final cleanPath = path.startsWith('file://')
        ? path.substring(7)
        : path;

    if (cleanPath.startsWith('/')) {
      return Image.file(
        File(cleanPath),
        fit: fit,
        errorBuilder: (
          context,
          error,
          stackTrace,
        ) {
          return _buildPhotoPlaceholder();
        },
      );
    }

    return Image.network(
      cleanPath,
      fit: fit,
      errorBuilder: (
        context,
        error,
        stackTrace,
      ) {
        return _buildPhotoPlaceholder();
      },
    );
  }

  Widget _buildPhotoPlaceholder() {
    return Container(
      color: Colors.pink.shade50,
      alignment: Alignment.center,
      child: Icon(
        Icons.person_rounded,
        size: 80,
        color: Colors.pink.shade200,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            16,
            16,
            16,
            30,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              const SizedBox(height: 20),
              _buildProfileCard(context),
              const SizedBox(height: 16),
              _buildInterestsCard(),
              const SizedBox(height: 16),
              _buildLookingForCard(),
              const SizedBox(height: 16),
              _buildSettingsCard(context),
              const SizedBox(height: 20),
              const Center(
                child: Text(
                  'Ose faire le premier pas ❤️',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black45,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Mon profil',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Présente-toi sous ton meilleur jour.',
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
        IconButton(
          tooltip: 'Modifier le profil',
          onPressed: () {
            _showComingSoon(
              context,
              'La modification du profil sera bientôt disponible.',
            );
          },
          icon: const Icon(
            Icons.edit_outlined,
          ),
        ),
      ],
    );
  }

  Widget _buildProfileCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: 0.05,
            ),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildMainPhoto(context),
          const SizedBox(height: 18),
          Text(
            '${profile.name}, ${profile.age}',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 7),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.location_on_outlined,
                size: 18,
                color: Colors.pink.shade400,
              ),
              const SizedBox(width: 4),
              Text(
                profile.city,
                style: const TextStyle(
                  color: Colors.black54,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          if (profile.hasBio) ...[
            const SizedBox(height: 16),
            Text(
              profile.bio,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 15,
                height: 1.5,
                color: Colors.black87,
              ),
            ),
          ],
          const SizedBox(height: 18),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _InfoBadge(
                icon: Icons.photo_library_outlined,
                label: '${profile.photoCount} photo(s)',
              ),
              const SizedBox(width: 8),
              _InfoBadge(
                icon: Icons.cake_outlined,
                label: '${profile.age} ans',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMainPhoto(BuildContext context) {
    if (!profile.hasPhotos) {
      return Container(
        width: double.infinity,
        height: 280,
        decoration: BoxDecoration(
          color: Colors.pink.shade50,
          borderRadius: BorderRadius.circular(22),
        ),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.person_rounded,
              size: 80,
              color: Colors.pink.shade200,
            ),
            const SizedBox(height: 8),
            const Text(
              'Aucune photo',
              style: TextStyle(
                color: Colors.black54,
              ),
            ),
          ],
        ),
      );
    }

    return GestureDetector(
      onTap: () {
        _showPhoto(
          context,
          profile.photos.first,
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: SizedBox(
          width: double.infinity,
          height: 280,
          child: _buildPhoto(
            profile.photos.first,
          ),
        ),
      ),
    );
  }

  Widget _buildInterestsCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Centres d’intérêt',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 12),
          if (profile.interests.isEmpty)
            const Text(
              'Aucun centre d’intérêt renseigné.',
              style: TextStyle(
                color: Colors.black54,
              ),
            )
          else
            Wrap(
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
                      color: Colors.pink.shade50,
                      borderRadius: BorderRadius.circular(20),
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
        ],
      ),
    );
  }

  Widget _buildLookingForCard() {
    String lookingForText;

    switch (profile.lookingFor) {
      case 'relationship':
        lookingForText = 'Une relation sérieuse ❤️';
        break;
      case 'serious':
        lookingForText = 'Une relation sérieuse ❤️';
        break;
      case 'friendship':
        lookingForText = 'Faire de nouvelles rencontres 🤝';
        break;
      case 'casual':
        lookingForText = 'Une rencontre sans pression 😊';
        break;
      default:
        lookingForText = profile.lookingFor.isEmpty
            ? 'Pas encore renseigné'
            : profile.lookingFor;
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.pink.shade50,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: const Icon(
              Icons.favorite_border_rounded,
              color: Colors.pink,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Je recherche',
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  lookingForText,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsCard(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(
              18,
              18,
              18,
              8,
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Paramètres',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
          _ProfileAction(
            icon: Icons.edit_outlined,
            title: 'Modifier mon profil',
            onTap: () {
              _showComingSoon(
                context,
                'La modification du profil sera bientôt disponible.',
              );
            },
          ),
          _ProfileAction(
            icon: Icons.notifications_none_rounded,
            title: 'Notifications',
            onTap: () {
              _showComingSoon(
                context,
                'Les notifications seront bientôt disponibles.',
              );
            },
          ),
          _ProfileAction(
            icon: Icons.lock_outline_rounded,
            title: 'Confidentialité et sécurité',
            onTap: () {
              _showComingSoon(
                context,
                'Les réglages de confidentialité seront bientôt disponibles.',
              );
            },
          ),
          _ProfileAction(
            icon: Icons.help_outline_rounded,
            title: 'Aide et assistance',
            onTap: () {
              _showComingSoon(
                context,
                'Le centre d’aide sera bientôt disponible.',
              );
            },
          ),
          _ProfileAction(
            icon: Icons.info_outline_rounded,
            title: 'À propos de Ose',
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: 'Ose',
                applicationVersion: '1.0.0',
                applicationLegalese:
                    'Ose faire le premier pas ❤️',
              );
            },
            showDivider: false,
          ),
        ],
      ),
    );
  }
}

class _InfoBadge extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoBadge({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 11,
        vertical: 7,
      ),
      decoration: BoxDecoration(
        color: Colors.pink.shade50,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: Colors.pink,
          ),
          const SizedBox(width: 5),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileAction extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final bool showDivider;

  const _ProfileAction({
    required this.icon,
    required this.title,
    required this.onTap,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          onTap: onTap,
          leading: Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: Colors.pink.shade50,
              borderRadius: BorderRadius.circular(13),
            ),
            alignment: Alignment.center,
            child: Icon(
              icon,
              color: Colors.pink,
              size: 21,
            ),
          ),
          title: Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          trailing: const Icon(
            Icons.chevron_right_rounded,
            color: Colors.black38,
          ),
        ),
        if (showDivider)
          Divider(
            height: 1,
            indent: 76,
            endIndent: 18,
            color: Colors.grey.shade100,
          ),
      ],
    );
  }
}
