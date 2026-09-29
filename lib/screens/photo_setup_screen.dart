import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../models/user_profile.dart';
import 'home_screen.dart';

class PhotoSetupScreen extends StatefulWidget {
  final UserProfile profile;

  const PhotoSetupScreen({
    super.key,
    required this.profile,
  });

  @override
  State<PhotoSetupScreen> createState() => _PhotoSetupScreenState();
}

class _PhotoSetupScreenState extends State<PhotoSetupScreen> {
  final ImagePicker _picker = ImagePicker();

  final List<String?> _photos = List<String?>.filled(6, null);

  Future<void> _addPhoto(int index) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
        maxWidth: 1200,
      );

      if (image == null) {
        return;
      }

      setState(() {
        _photos[index] = image.path;
      });
    } catch (e) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Impossible d’ouvrir la galerie.',
          ),
        ),
      );
    }
  }

  void _removePhoto(int index) {
    setState(() {
      _photos[index] = null;
    });
  }

  void _continue() {
    final selectedPhotos = _photos
        .whereType<String>()
        .toList();

    if (selectedPhotos.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Ajoute au moins une photo pour continuer.',
          ),
        ),
      );

      return;
    }

    final updatedProfile = widget.profile.copyWith(
      photos: selectedPhotos,
    );

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tes photos'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              const Text(
                'Ajoute tes photos',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              Text(
                'Choisis au moins une photo pour montrer '
                'qui tu es. Tu pourras en ajouter plusieurs.',
                style: TextStyle(
                  fontSize: 15,
                  height: 1.4,
                  color: Colors.grey.shade700,
                ),
              ),

              const SizedBox(height: 24),

              GridView.builder(
                shrinkWrap: true,
                physics:
                    const NeverScrollableScrollPhysics(),
                itemCount: 6,
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.9,
                ),
                itemBuilder: (context, index) {
                  return _PhotoSlot(
                    imagePath: _photos[index],
                    isMain: index == 0,
                    onTap: () => _addPhoto(index),
                    onRemove: () => _removePhoto(index),
                  );
                },
              ),

              const SizedBox(height: 24),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.pink.shade50,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.lightbulb_outline,
                      color: Colors.pink,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Conseil : utilise une photo récente '
                        'où ton visage est clairement visible.',
                        style: TextStyle(
                          fontSize: 14,
                          height: 1.4,
                          color: Colors.pink.shade900,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: _continue,
                  child: const Text(
                    'Continuer',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              Center(
                child: Text(
                  'Tes photos resteront privées et sécurisées.',
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

class _PhotoSlot extends StatelessWidget {
  final String? imagePath;
  final bool isMain;
  final VoidCallback onTap;
  final VoidCallback onRemove;

  const _PhotoSlot({
    required this.imagePath,
    required this.isMain,
    required this.onTap,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final hasPhoto = imagePath != null;

    return GestureDetector(
      onTap: hasPhoto ? null : onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: Colors.grey.shade300,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: hasPhoto
            ? Stack(
                fit: StackFit.expand,
                children: [
                  Image.file(
                    File(imagePath!),
                    fit: BoxFit.cover,
                  ),

                  if (isMain)
                    Positioned(
                      left: 10,
                      top: 10,
                      child: Container(
                        padding:
                            const EdgeInsets.symmetric(
                          horizontal: 9,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.pink,
                          borderRadius:
                              BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'Principale',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                  Positioned(
                    right: 8,
                    top: 8,
                    child: GestureDetector(
                      onTap: onRemove,
                      child: Container(
                        width: 34,
                        height: 34,
                        decoration: const BoxDecoration(
                          color: Colors.black54,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              )
            : InkWell(
                onTap: onTap,
                child: Column(
                  mainAxisAlignment:
                      MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: Colors.pink.shade50,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.add_a_photo_outlined,
                        color: Colors.pink,
                        size: 25,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      isMain
                          ? 'Photo principale'
                          : 'Ajouter une photo',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
