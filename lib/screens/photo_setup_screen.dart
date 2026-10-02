import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../models/user_profile.dart';
import '../services/photo_service.dart';
import '../services/user_service.dart';
import 'home_screen.dart';

class PhotoSetupScreen extends StatefulWidget {
  final UserProfile profile;

  const PhotoSetupScreen({
    super.key,
    required this.profile,
  });

  @override
  State<PhotoSetupScreen> createState() =>
      _PhotoSetupScreenState();
}

class _PhotoSetupScreenState
    extends State<PhotoSetupScreen> {
  final ImagePicker _picker = ImagePicker();

  final List<String> _photoPaths = [];

  bool _isSaving = false;

  Future<void> _pickPhoto() async {
    if (_photoPaths.length >= 6) {
      _showMessage(
        'Tu peux ajouter au maximum 6 photos.',
      );
      return;
    }

    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
      maxWidth: 1600,
    );

    if (image == null) {
      return;
    }

    if (_photoPaths.contains(image.path)) {
      _showMessage(
        'Cette photo est déjà ajoutée.',
      );
      return;
    }

    setState(() {
      _photoPaths.add(image.path);
    });
  }

  Future<void> _takePhoto() async {
    if (_photoPaths.length >= 6) {
      _showMessage(
        'Tu peux ajouter au maximum 6 photos.',
      );
      return;
    }

    final XFile? image = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 85,
      maxWidth: 1600,
    );

    if (image == null) {
      return;
    }

    setState(() {
      _photoPaths.add(image.path);
    });
  }

  Future<void> _savePhotos() async {
    if (_photoPaths.isEmpty) {
      _showMessage(
        'Ajoute au moins une photo pour continuer.',
      );
      return;
    }

    setState(() {
      _isSaving = true;
    });

    await PhotoService.setPhotos(
      _photoPaths,
    );

    final updatedProfile = widget.profile.copyWith(
      photos: List.unmodifiable(
        _photoPaths,
      ),
    );

    await UserService.updateProfile(
      updatedProfile,
    );

    if (!mounted) {
      return;
    }

    setState(() {
      _isSaving = false;
    });

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => HomeScreen(
          profile: updatedProfile,
        ),
      ),
      (route) => false,
    );
  }

  void _removePhoto(int index) {
    final path = _photoPaths[index];

    setState(() {
      _photoPaths.removeAt(index);
    });

    PhotoService.removePhoto(path);
  }

  void _showPhotoOptions() {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(
                  Icons.photo_library_outlined,
                ),
                title: const Text(
                  'Choisir dans la galerie',
                ),
                onTap: () {
                  Navigator.pop(context);
                  _pickPhoto();
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.camera_alt_outlined,
                ),
                title: const Text(
                  'Prendre une photo',
                ),
                onTap: () {
                  Navigator.pop(context);
                  _takePhoto();
                },
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
      ),
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
        foregroundColor: Colors.black87,
        title: const Text(
          'Tes photos',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(
                  24,
                  12,
                  24,
                  24,
                ),
                children: [
                  const Text(
                    'Montre-nous qui tu es 📸',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Ajoute au moins une photo. Ta première photo sera utilisée comme photo principale.',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.black54,
                      height: 1.4,
                    ),
                  ),

                  const SizedBox(height: 24),

                  if (_photoPaths.isEmpty)
                    GestureDetector(
                      onTap: _showPhotoOptions,
                      child: Container(
                        height: 260,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              BorderRadius.circular(24),
                          border: Border.all(
                            color: primaryColor
                                .withValues(alpha: 0.25),
                            width: 1.5,
                          ),
                        ),
                        child: const Column(
                          mainAxisAlignment:
                              MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons
                                  .add_a_photo_outlined,
                              size: 54,
                              color: primaryColor,
                            ),
                            SizedBox(height: 14),
                            Text(
                              'Ajouter une photo',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight:
                                    FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 6),
                            Text(
                              'Galerie ou appareil photo',
                              style: TextStyle(
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    GridView.builder(
                      shrinkWrap: true,
                      physics:
                          const NeverScrollableScrollPhysics(),
                      itemCount: _photoPaths.length + 1,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 0.85,
                      ),
                      itemBuilder: (context, index) {
                        if (index ==
                            _photoPaths.length) {
                          return GestureDetector(
                            onTap: _showPhotoOptions,
                            child: Container(
                              decoration:
                                  BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.circular(
                                  20,
                                ),
                                border: Border.all(
                                  color: primaryColor
                                      .withValues(
                                    alpha: 0.25,
                                  ),
                                  width: 1.5,
                                ),
                              ),
                              child: const Icon(
                                Icons.add_a_photo_outlined,
                                size: 42,
                                color: primaryColor,
                              ),
                            ),
                          );
                        }

                        final path =
                            _photoPaths[index];

                        return Stack(
                          fit: StackFit.expand,
                          children: [
                            ClipRRect(
                              borderRadius:
                                  BorderRadius.circular(
                                20,
                              ),
                              child: Image.file(
                                File(path),
                                fit: BoxFit.cover,
                              ),
                            ),

                            if (index == 0)
                              Positioned(
                                left: 10,
                                bottom: 10,
                                child: Container(
                                  padding:
                                      const EdgeInsets
                                          .symmetric(
                                    horizontal: 10,
                                    vertical: 6,
                                  ),
                                  decoration:
                                      BoxDecoration(
                                    color: Colors.black87,
                                    borderRadius:
                                        BorderRadius
                                            .circular(
                                      20,
                                    ),
                                  ),
                                  child: const Text(
                                    'Photo principale',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 11,
                                      fontWeight:
                                          FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),

                            Positioned(
                              top: 8,
                              right: 8,
                              child: Material(
                                color: Colors.black54,
                                shape:
                                    const CircleBorder(),
                                child: InkWell(
                                  customBorder:
                                      const CircleBorder(),
                                  onTap: () {
                                    _removePhoto(
                                      index,
                                    );
                                  },
                                  child: const Padding(
                                    padding:
                                        EdgeInsets.all(
                                      7,
                                    ),
                                    child: Icon(
                                      Icons.close,
                                      color: Colors.white,
                                      size: 18,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),

                  const SizedBox(height: 20),

                  Text(
                    '${_photoPaths.length}/6 photos',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.black54,
                      fontSize: 13,
                    ),
                  ),

                  const SizedBox(height: 20),

                  Container(
                    padding:
                        const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: primaryColor.withValues(
                        alpha: 0.07,
                      ),
                      borderRadius:
                          BorderRadius.circular(16),
                    ),
                    child: const Row(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: primaryColor,
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Choisis des photos qui te représentent bien. Tu pourras les modifier plus tard.',
                            style: TextStyle(
                              fontSize: 13,
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

            Padding(
              padding: const EdgeInsets.fromLTRB(
                24,
                8,
                24,
                24,
              ),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed:
                      _isSaving ? null : _savePhotos,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor:
                        primaryColor.withValues(
                      alpha: 0.5,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(18),
                    ),
                    elevation: 0,
                  ),
                  child: _isSaving
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child:
                              CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          'Terminer mon profil',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
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
