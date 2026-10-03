import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../models/user_profile.dart';
import '../services/photo_service.dart';
import '../services/user_service.dart';

class ManagePhotosScreen extends StatefulWidget {
  final UserProfile profile;

  const ManagePhotosScreen({
    super.key,
    required this.profile,
  });

  @override
  State<ManagePhotosScreen> createState() =>
      _ManagePhotosScreenState();
}

class _ManagePhotosScreenState
    extends State<ManagePhotosScreen> {
  static const Color primaryColor = Color(0xFFE6005C);
  static const Color backgroundColor = Color(0xFFFFF7FA);

  final ImagePicker _picker = ImagePicker();

  late List<String> _photos;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();

    _photos = List<String>.from(widget.profile.photos);

    _initializePhotos();
  }

  Future<void> _initializePhotos() async {
    await PhotoService.setPhotos(_photos);
  }

  Future<void> _savePhotos() async {
    await PhotoService.setPhotos(_photos);

    final updatedProfile = widget.profile.copyWith(
      photos: List<String>.from(_photos),
    );

    await UserService.updateProfile(updatedProfile);
  }

  Future<void> _addPhotos() async {
    if (_photos.length >= 6) {
      _showMessage(
        'Tu peux avoir maximum 6 photos.',
      );
      return;
    }

    try {
      final remainingSlots = 6 - _photos.length;

      final selectedPhotos =
          await _picker.pickMultiImage(
        imageQuality: 85,
      );

      if (selectedPhotos.isEmpty) {
        return;
      }

      final photosToAdd =
          selectedPhotos.take(remainingSlots);

      setState(() {
        _photos.addAll(
          photosToAdd.map(
            (photo) => photo.path,
          ),
        );
      });

      await _savePhotos();

      if (!mounted) return;

      _showMessage(
        'Photo${selectedPhotos.length > 1 ? 's' : ''} ajoutée${selectedPhotos.length > 1 ? 's' : ''}.',
      );
    } catch (_) {
      if (!mounted) return;

      _showMessage(
        'Impossible d’ajouter les photos.',
      );
    }
  }

  Future<void> _takePhoto() async {
    if (_photos.length >= 6) {
      _showMessage(
        'Tu peux avoir maximum 6 photos.',
      );
      return;
    }

    try {
      final photo = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
      );

      if (photo == null) {
        return;
      }

      setState(() {
        _photos.add(photo.path);
      });

      await _savePhotos();

      if (!mounted) return;

      _showMessage('Photo ajoutée.');
    } catch (_) {
      if (!mounted) return;

      _showMessage(
        'Impossible de prendre la photo.',
      );
    }
  }

  Future<void> _showAddPhotoOptions() async {
    if (_photos.length >= 6) {
      _showMessage(
        'Tu peux avoir maximum 6 photos.',
      );
      return;
    }

    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(28),
        ),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              20,
              20,
              20,
              25,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 45,
                  height: 5,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE5E5E5),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const SizedBox(height: 22),
                const Text(
                  'Ajouter une photo',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 20),
                ListTile(
                  leading: Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFE5EF),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: const Icon(
                      Icons.photo_library_outlined,
                      color: primaryColor,
                    ),
                  ),
                  title: const Text(
                    'Choisir dans la galerie',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  subtitle: const Text(
                    'Sélectionner une ou plusieurs photos',
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _addPhotos();
                  },
                ),
                const SizedBox(height: 8),
                ListTile(
                  leading: Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFE5EF),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: const Icon(
                      Icons.camera_alt_outlined,
                      color: primaryColor,
                    ),
                  ),
                  title: const Text(
                    'Prendre une photo',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  subtitle: const Text(
                    'Utiliser l’appareil photo',
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _takePhoto();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _deletePhoto(int index) async {
    if (index < 0 || index >= _photos.length) {
      return;
    }

    final wasPrimary = index == 0;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Supprimer cette photo ?',
            style: TextStyle(
              fontWeight: FontWeight.w900,
            ),
          ),
          content: const Text(
            'Cette photo sera retirée de ton profil.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text(
                'Annuler',
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
              ),
              child: const Text(
                'Supprimer',
              ),
            ),
          ],
        );
      },
    );

    if (confirmed != true) {
      return;
    }

    setState(() {
      _photos.removeAt(index);
    });

    await _savePhotos();

    if (!mounted) return;

    if (wasPrimary && _photos.isNotEmpty) {
      _showMessage(
        'La photo suivante est maintenant principale.',
      );
    } else {
      _showMessage('Photo supprimée.');
    }
  }

  Future<void> _setPrimaryPhoto(int index) async {
    if (index <= 0 || index >= _photos.length) {
      return;
    }

    setState(() {
      final selectedPhoto = _photos.removeAt(index);
      _photos.insert(0, selectedPhoto);
    });

    await _savePhotos();

    if (!mounted) return;

    _showMessage(
      'Photo principale mise à jour.',
    );
  }

  Widget _buildPhotoImage(String path) {
    final isNetworkImage =
        path.startsWith('http://') ||
        path.startsWith('https://');

    if (isNetworkImage) {
      return Image.network(
        path,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        errorBuilder: (_, __, ___) {
          return _buildPlaceholder();
        },
      );
    }

    return Image.file(
      File(path),
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
      errorBuilder: (_, __, ___) {
        return _buildPlaceholder();
      },
    );
  }

  Widget _buildPlaceholder() {
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

  Widget _buildPhotoCard(
    String path,
    int index,
  ) {
    final isPrimary = index == 0;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: 0.05,
            ),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: Stack(
          fit: StackFit.expand,
          children: [
            _buildPhotoImage(path),

            Positioned(
              top: 10,
              left: 10,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 9,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(
                    alpha: 0.55,
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Text(
                  '${index + 1}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),

            if (isPrimary)
              Positioned(
                top: 10,
                right: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 9,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(
                      alpha: 0.93,
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.star,
                        size: 14,
                        color: primaryColor,
                      ),
                      SizedBox(width: 4),
                      Text(
                        'Principale',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          color: primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            Positioned(
              bottom: 10,
              right: 10,
              child: Row(
                children: [
                  if (!isPrimary)
                    _buildPhotoAction(
                      icon: Icons.star_border,
                      tooltip: 'Définir principale',
                      onPressed: () {
                        _setPrimaryPhoto(index);
                      },
                    ),
                  if (!isPrimary)
                    const SizedBox(width: 7),
                  _buildPhotoAction(
                    icon: Icons.delete_outline,
                    tooltip: 'Supprimer',
                    onPressed: () {
                      _deletePhoto(index);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhotoAction({
    required IconData icon,
    required String tooltip,
    required VoidCallback onPressed,
  }) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.black.withValues(
          alpha: 0.60,
        ),
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(14),
          child: SizedBox(
            width: 40,
            height: 40,
            child: Icon(
              icon,
              color: Colors.white,
              size: 20,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 25,
        vertical: 45,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
      ),
      child: const Column(
        children: [
          Icon(
            Icons.photo_library_outlined,
            size: 65,
            color: Color(0xFFE7A5BD),
          ),
          SizedBox(height: 15),
          Text(
            'Aucune photo',
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.w900,
            ),
          ),
          SizedBox(height: 7),
          Text(
            'Ajoute quelques photos pour rendre ton profil plus vivant.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF777777),
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
          backgroundColor: primaryColor,
        ),
      );
  }

  Future<void> _saveAndClose() async {
    if (_isSaving) {
      return;
    }

    setState(() {
      _isSaving = true;
    });

    await _savePhotos();

    if (!mounted) {
      return;
    }

    final updatedProfile = widget.profile.copyWith(
      photos: List<String>.from(_photos),
    );

    Navigator.pop(
      context,
      updatedProfile,
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
          'Mes photos',
          style: TextStyle(
            fontWeight: FontWeight.w900,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios_new,
          ),
        ),
        actions: [
          TextButton(
            onPressed: _saveAndClose,
            child: const Text(
              'Terminer',
              style: TextStyle(
                color: primaryColor,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            20,
            8,
            20,
            30,
          ),
          children: [
            Container(
              padding: const EdgeInsets.all(17),
              decoration: BoxDecoration(
                color: const Color(0xFFFFE5EF),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Row(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.info_outline,
                    color: primaryColor,
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Ta première photo est automatiquement utilisée comme photo principale.',
                      style: TextStyle(
                        color: Color(0xFF7A3453),
                        fontSize: 13,
                        height: 1.4,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 22),

            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Mes photos',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                Text(
                  '${_photos.length}/6',
                  style: const TextStyle(
                    color: primaryColor,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            if (_photos.isEmpty)
              _buildEmptyState()
            else
              GridView.builder(
                shrinkWrap: true,
                physics:
                    const NeverScrollableScrollPhysics(),
                itemCount: _photos.length,
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.82,
                ),
                itemBuilder: (context, index) {
                  return _buildPhotoCard(
                    _photos[index],
                    index,
                  );
                },
              ),

            const SizedBox(height: 18),

            SizedBox(
              height: 54,
              child: ElevatedButton.icon(
                onPressed: _photos.length >= 6
                    ? null
                    : _showAddPhotoOptions,
                icon: const Icon(
                  Icons.add_a_photo_outlined,
                ),
                label: Text(
                  _photos.length >= 6
                      ? '6 photos maximum atteint'
                      : 'Ajouter une photo',
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor:
                      const Color(0xFFE8B8CB),
                  disabledForegroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            const Text(
              'Tu peux ajouter jusqu’à 6 photos. Appuie sur ⭐ pour choisir ta photo principale.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF888888),
                fontSize: 12,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
