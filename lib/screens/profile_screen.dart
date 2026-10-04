import 'dart:io';

import 'package:flutter/material.dart';

import '../models/user_profile.dart';
import '../services/photo_service.dart';
import '../services/user_service.dart';
import 'edit_profile_screen.dart';
import 'manage_photos_screen.dart';

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

  @override
  void initState() {
    super.initState();

    _profile = widget.profile;

    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final savedProfile = await UserService.getProfile();

    if (!mounted) return;

    if (savedProfile != null) {
      setState(() {
        _profile = savedProfile;
      });
    }
  }

  Future<void> _openEditProfile() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EditProfileScreen(
          profile: _profile,
        ),
      ),
    );

    await _loadProfile();
  }

  Future<void> _openManagePhotos() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ManagePhotosScreen(
          profile: _profile,
        ),
      ),
    );

    await _loadProfile();
  }

  Widget _buildPhotoPreview(String path) {
    final file = File(path);

    if (file.existsSync()) {
      return Image.file(
        file,
        fit: BoxFit.cover,
      );
    }

    if (path.startsWith('http://') ||
        path.startsWith('https://')) {
      return Image.network(
        path,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) {
          return _buildPhotoPlaceholder();
        },
      );
    }

    return _buildPhotoPlaceholder();
  }

  Widget _buildPhotoPlaceholder() {
    return Container(
      color: Colors.pink.shade50,
      child: const Center(
        child: Icon(
          Icons.person,
          size: 45,
          color: Colors.pink,
        ),
      ),
    );
  }

  Widget _buildMainPhoto() {
    final photos = _profile.photos;

    if (photos.isEmpty) {
      return GestureDetector(
        onTap: _openManagePhotos,
        child: Container(
          width: double.infinity,
          height: 280,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.pink.shade100,
                Colors.pink.shade50,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(28),
          ),
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.add_a_photo_outlined,
                size: 48,
                color: Colors.pink,
              ),
              SizedBox(height: 12),
              Text(
                'Ajouter ma première photo',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: Colors.pink,
                ),
              ),
              SizedBox(height: 6),
              Text(
                'Une belle photo aide à faire le premier pas ❤️',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: Stack(
        children: [
          SizedBox(
            width: double.infinity,
            height: 280,
            child: _buildPhotoPreview(photos.first),
          ),
          Positioned(
            left: 16,
            bottom: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 7,
              ),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.55),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '${photos.length}/6 photos',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          Positioned(
            right: 12,
            bottom: 12,
            child: Material(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              child: InkWell(
                onTap: _openManagePhotos,
                borderRadius: BorderRadius.circular(30),
                child: const Padding(
                  padding: EdgeInsets.all(12),
                  child: Icon(
                    Icons.edit,
                    color: Colors.pink,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhotoGallery() {
    final photos = _profile.photos;

    if (photos.length <= 1) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Row(
          children: [
            const Expanded(
              child: Text(
                'Mes photos',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            TextButton(
              onPressed: _openManagePhotos,
              child: const Text(
                'Gérer',
                style: TextStyle(
                  color: Colors.pink,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 100,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: photos.length,
            separatorBuilder: (_, __) =>
                const SizedBox(width: 10),
            itemBuilder: (context, index) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: SizedBox(
                  width: 100,
                  height: 100,
                  child: _buildPhotoPreview(
                    photos[index],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildProfileInfo() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.pink.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  '${_profile.name}, ${_profile.age}',
                  style: const TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              IconButton(
                onPressed: _openEditProfile,
                icon: const Icon(
                  Icons.edit_outlined,
                  color: Colors.pink,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(
                Icons.location_on_outlined,
                size: 19,
                color: Colors.pink,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  _profile.city,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.black54,
                  ),
                ),
              ),
            ],
          ),
          if (_profile.hasBio) ...[
            const SizedBox(height: 18),
            const Text(
              'À propos de moi',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
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
          ],
          if (_profile.interests.isNotEmpty) ...[
            const SizedBox(height: 18),
            const Text(
              'Mes centres d’intérêt',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _profile.interests.map((interest) {
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
                      color: Colors.pink,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
          if (_profile.lookingFor.trim().isNotEmpty) ...[
            const SizedBox(height: 18),
            const Text(
              'Je recherche',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _profile.lookingFor,
              style: const TextStyle(
                fontSize: 15,
                color: Colors.black87,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPhotoButton() {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: _openManagePhotos,
        icon: const Icon(
          Icons.photo_library_outlined,
        ),
        label: Text(
          _profile.photos.isEmpty
              ? 'Ajouter mes photos'
              : 'Gérer mes photos',
        ),
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.pink,
          side: const BorderSide(
            color: Colors.pink,
          ),
          padding: const EdgeInsets.symmetric(
            vertical: 15,
          ),
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
      backgroundColor: const Color(0xFFFFF7FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Mon profil',
          style: TextStyle(
            fontWeight: FontWeight.w800,
          ),
        ),
        actions: [
          IconButton(
            onPressed: _openEditProfile,
            icon: const Icon(
              Icons.edit_outlined,
            ),
            tooltip: 'Modifier mon profil',
          ),
        ],
      ),
      body: RefreshIndicator(
        color: Colors.pink,
        onRefresh: _loadProfile,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            16,
            8,
            16,
            30,
          ),
          children: [
            _buildMainPhoto(),

            _buildPhotoGallery(),

            const SizedBox(height: 20),

            _buildPhotoButton(),

            const SizedBox(height: 20),

            _buildProfileInfo(),

            const SizedBox(height: 20),

            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.pink.shade50,
                    Colors.purple.shade50,
                  ],
                ),
                borderRadius: BorderRadius.circular(22),
              ),
              child: const Row(
                children: [
                  Text(
                    '💗',
                    style: TextStyle(
                      fontSize: 30,
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Ose faire le premier pas. '
                      'Ton profil est ta première impression.',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        height: 1.4,
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
} 
