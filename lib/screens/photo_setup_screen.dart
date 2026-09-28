import 'package:flutter/material.dart';

import '../models/user_profile.dart';
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
  final List<String?> _photos = [
    null,
    null,
    null,
    null,
    null,
    null,
  ];

  void _addPhoto(int index) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'La sélection de photos sera activée prochainement.',
        ),
      ),
    );
  }

  void _continue() {
    final selectedPhotos = _photos
        .whereType<String>()
        .toList();

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
        title: const Text('Mes photos'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Text(
                'Montre-nous ton sourire ❤️',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 27,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              Text(
                'Ajoute quelques photos pour permettre '
                'aux autres de mieux te découvrir.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade700,
                  height: 1.4,
                ),
              ),

              const SizedBox(height: 30),

              GridView.builder(
                shrinkWrap: true,
                physics:
                    const NeverScrollableScrollPhysics(),
                itemCount: _photos.length,
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                  childAspectRatio: 0.85,
                ),
                itemBuilder: (context, index) {
                  final photo = _photos[index];

                  return GestureDetector(
                    onTap: () => _addPhoto(index),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.pink.shade50,
                        borderRadius:
                            BorderRadius.circular(18),
                        border: Border.all(
                          color: Colors.pink.shade100,
                        ),
                      ),
                      child: photo == null
                          ? Column(
                              mainAxisAlignment:
                                  MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.add_a_photo_outlined,
                                  size: 42,
                                  color:
                                      Colors.pink.shade400,
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  index == 0
                                      ? 'Photo principale'
                                      : 'Ajouter une photo',
                                  textAlign:
                                      TextAlign.center,
                                  style: TextStyle(
                                    fontWeight:
                                        FontWeight.w600,
                                    color:
                                        Colors.pink.shade700,
                                  ),
                                ),
                              ],
                            )
                          : ClipRRect(
                              borderRadius:
                                  BorderRadius.circular(18),
                              child: Image.network(
                                photo,
                                fit: BoxFit.cover,
                              ),
                            ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 20),

              Text(
                'Tu pourras ajouter tes vraies photos '
                'lorsque la sélection de photos sera activée.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade600,
                ),
              ),

              const SizedBox(height: 30),

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

              const SizedBox(height: 15),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: TextButton(
                  onPressed: _continue,
                  child: const Text(
                    'Je le ferai plus tard',
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
