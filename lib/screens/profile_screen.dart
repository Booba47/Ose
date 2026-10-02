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
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late UserProfile _profile;
  bool _isLoading = false;

  static const Color primaryColor = Color(0xFFE6005C);
  static const Color backgroundColor = Color(0xFFFFF7FA);

  @override
  void initState() {
    super.initState();
    _profile = widget.profile;
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final savedProfile = await UserService.getProfile();

    if (!mounted || savedProfile == null) {
      return;
    }

    setState(() {
      _profile = savedProfile;
    });
  }

  Future<void> _refreshProfile() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    await _loadProfile();

    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });
  }

  void _openSettings() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const SettingsScreen(),
      ),
    ).then((_) {
      _loadProfile();
    });
  }

  void _showComingSoon(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: const Color(0xFF333333),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
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
          return _buildPhotoPlaceholder();
        },
      );
    }

    return Image.file(
      File(path),
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) {
        return _buildPhotoPlaceholder();
      },
    );
  }

  Widget _buildPhotoPlaceholder() {
    return Container(
      color: const Color(0xFFFFE5EF),
      child: const Center(
        child: Icon(
          Icons.person,
          size: 55,
          color: Color(0xFFC52A70),
        ),
      ),
    );
  }

  Widget _buildPhotoGallery() {
    if (_profile.photos.isEmpty) {
      return Container(
        height: 250,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(26),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 18,
              offset: const Offset(0, 7),
            ),
          ],
        ),
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.add_a_photo_outlined,
                size: 58,
                color: Color(0xFFE7A5BD),
              ),
              SizedBox(height: 12),
              Text(
                'Ajoute tes premières photos',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF777777),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return SizedBox(
      height: 250,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _profile.photos.length,
        separatorBuilder: (_, __) {
          return const SizedBox(width: 12);
        },
        itemBuilder: (context, index) {
          final isPrimary = index == 0;

          return Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(26),
                child: SizedBox(
                  width: 190,
                  height: 250,
                  child: _buildPhoto(
                    _profile.photos[index],
                  ),
                ),
              ),

              if (isPrimary)
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(
                        alpha: 0.92,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.star,
                          size: 15,
                          color: primaryColor,
                        ),
                        SizedBox(width: 5),
                        Text(
                          'Principale',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            color: primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              Positioned(
                bottom: 12,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 9,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(
                      alpha: 0.55,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    '${index + 1}/${_profile.photos.length}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        4,
        8,
        4,
        22,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${_profile.name}, ${_profile.age}',
                  style: const TextStyle(
                    fontSize: 29,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 7),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      size: 18,
                      color: primaryColor,
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        _profile.city,
                        style: const TextStyle(
                          fontSize: 15,
                          color: Color(0xFF777777),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFFFFE5EF),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.favorite,
              color: primaryColor,
              size: 23,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(
    String title,
    IconData icon,
  ) {
    return Row(
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: const Color(0xFFFFE5EF),
            borderRadius: BorderRadius.circular(11),
          ),
          child: Icon(
            icon,
            size: 18,
            color: primaryColor,
          ),
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }

  Widget _buildInterestChip(String interest) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 13,
        vertical: 9,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFFFE8F0),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Text(
        interest,
        style: const TextStyle(
          color: Color(0xFFC52A70),
          fontWeight: FontWeight.w700,
          fontSize: 13,
        ),
      ),
    );
  }

  Widget _buildLookingForCard() {
    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: const Color(0xFFFFE5EF),
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Icon(
              Icons.favorite_border,
              color: primaryColor,
            ),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Text(
              _profile.lookingFor.isEmpty
                  ? 'Pas encore renseigné'
                  : _profile.lookingFor,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Color(0xFF444444),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCard() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 18,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildStat(
              '${_profile.photoCount}',
              'Photos',
              Icons.photo_library_outlined,
            ),
          ),
          Container(
            width: 1,
            height: 45,
            color: const Color(0xFFEEEEEE),
          ),
          Expanded(
            child: _buildStat(
              '${_profile.interests.length}',
              'Intérêts',
              Icons.interests_outlined,
            ),
          ),
          Container(
            width: 1,
            height: 45,
            color: const Color(0xFFEEEEEE),
          ),
          Expanded(
            child: _buildStat(
              _profile.hasBio ? 'Oui' : 'Non',
              'Bio',
              Icons.person_outline,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStat(
    String value,
    String label,
    IconData icon,
  ) {
    return Column(
      children: [
        Icon(
          icon,
          size: 20,
          color: primaryColor,
        ),
        const SizedBox(height: 5),
        Text(
          value,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: Color(0xFF888888),
          ),
        ),
      ],
    );
  }

  Widget _buildEditButton() {
    return SizedBox(
      height: 55,
      child: ElevatedButton.icon(
        onPressed: () {
          _showComingSoon(
            'La modification du profil sera disponible prochainement.',
          );
        },
        icon: const Icon(Icons.edit_outlined),
        label: const Text(
          'Modifier mon profil',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w800,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Mon profil',
          style: TextStyle(
            fontWeight: FontWeight.w900,
          ),
        ),
        actions: [
          IconButton(
            onPressed: _openSettings,
            tooltip: 'Paramètres',
            icon: const Icon(
              Icons.settings_outlined,
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        color: primaryColor,
        onRefresh: _refreshProfile,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(
            20,
            8,
            20,
            35,
          ),
          children: [
            _buildPhotoGallery(),

            const SizedBox(height: 22),

            _buildProfileHeader(),

            _buildStatsCard(),

            const SizedBox(height: 25),

            if (_profile.hasBio) ...[
              _buildSectionTitle(
                'À propos de moi',
                Icons.person_outline,
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(17),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  _profile.bio,
                  style: const TextStyle(
                    fontSize: 15,
                    height: 1.55,
                    color: Color(0xFF555555),
                  ),
                ),
              ),
              const SizedBox(height: 25),
            ],

            _buildSectionTitle(
              'Mes centres d’intérêt',
              Icons.auto_awesome_outlined,
            ),

            const SizedBox(height: 12),

            if (_profile.interests.isEmpty)
              Container(
                padding: const EdgeInsets.all(17),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'Aucun centre d’intérêt ajouté.',
                  style: TextStyle(
                    color: Color(0xFF777777),
                  ),
                ),
              )
            else
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _profile.interests
                    .map(_buildInterestChip)
                    .toList(),
              ),

            const SizedBox(height: 25),

            _buildSectionTitle(
              'Je recherche',
              Icons.favorite_border,
            ),

            const SizedBox(height: 12),

            _buildLookingForCard(),

            const SizedBox(height: 28),

            _buildEditButton(),

            const SizedBox(height: 12),

            OutlinedButton.icon(
              onPressed: _openSettings,
              icon: const Icon(
                Icons.settings_outlined,
              ),
              label: const Text(
                'Paramètres',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                ),
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: primaryColor,
                side: const BorderSide(
                  color: primaryColor,
                ),
                minimumSize: const Size.fromHeight(52),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
            ),

            const SizedBox(height: 25),

            const Center(
              child: Text(
                'Ose faire le premier pas. 💕',
                style: TextStyle(
                  color: Color(0xFFAAAAAA),
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
