import 'package:flutter/material.dart';

import '../models/user_profile.dart';
import '../services/user_service.dart';
import 'photo_setup_screen.dart';

class ProfileSetupScreen extends StatefulWidget {
  final String name;
  final DateTime birthDate;

  const ProfileSetupScreen({
    super.key,
    required this.name,
    required this.birthDate,
  });

  @override
  State<ProfileSetupScreen> createState() =>
      _ProfileSetupScreenState();
}

class _ProfileSetupScreenState
    extends State<ProfileSetupScreen> {
  final _formKey = GlobalKey<FormState>();

  final _cityController = TextEditingController();
  final _bioController = TextEditingController();

  final List<String> _availableInterests = [
    '🎵 Musique',
    '✈️ Voyage',
    '🎬 Films',
    '🍳 Cuisine',
    '🎨 Art',
    '📚 Lecture',
    '🐾 Animaux',
    '⚽ Sport',
    '☕ Sorties tranquilles',
    '🎮 Jeux vidéo',
    '🌿 Nature',
    '📸 Photographie',
  ];

  final List<String> _selectedInterests = [];

  String _lookingFor = 'Une relation sérieuse';
  bool _isSaving = false;

  @override
  void dispose() {
    _cityController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  Future<void> _continue() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedInterests.isEmpty) {
      _showMessage(
        'Sélectionne au moins un centre d’intérêt.',
      );
      return;
    }

    setState(() {
      _isSaving = true;
    });

    final profile = UserProfile(
      name: widget.name,
      birthDate: widget.birthDate,
      city: _cityController.text.trim(),
      bio: _bioController.text.trim(),
      interests: List.unmodifiable(
        _selectedInterests,
      ),
      lookingFor: _lookingFor,
      photos: const [],
    );

    await UserService.saveProfile(profile);

    if (!mounted) {
      return;
    }

    setState(() {
      _isSaving = false;
    });

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PhotoSetupScreen(
          profile: profile,
        ),
      ),
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
          'Ton profil',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(
              24,
              12,
              24,
              32,
            ),
            children: [
              const Text(
                'Parle-nous un peu de toi 💕',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Ces informations permettront aux autres membres de mieux te découvrir.',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.black54,
                  height: 1.4,
                ),
              ),

              const SizedBox(height: 28),

              TextFormField(
                controller: _cityController,
                textCapitalization:
                    TextCapitalization.words,
                decoration: InputDecoration(
                  labelText: 'Ville',
                  hintText: 'Ex. Paris',
                  prefixIcon: const Icon(
                    Icons.location_on_outlined,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
                validator: (value) {
                  if (value == null ||
                      value.trim().isEmpty) {
                    return 'Entre ta ville.';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 18),

              TextFormField(
                controller: _bioController,
                maxLines: 5,
                maxLength: 300,
                textCapitalization:
                    TextCapitalization.sentences,
                decoration: InputDecoration(
                  labelText: 'À propos de toi',
                  hintText:
                      'Quelques mots pour te présenter...',
                  alignLabelWithHint: true,
                  prefixIcon: const Padding(
                    padding: EdgeInsets.only(
                      bottom: 80,
                    ),
                    child: Icon(
                      Icons.edit_note_outlined,
                    ),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 12),

              const Text(
                'Tes centres d’intérêt',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 6),

              const Text(
                'Choisis jusqu’à 6 centres d’intérêt.',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.black54,
                ),
              ),

              const SizedBox(height: 14),

              Wrap(
                spacing: 8,
                runSpacing: 8,
                children:
                    _availableInterests.map((interest) {
                  final selected =
                      _selectedInterests
                          .contains(interest);

                  return FilterChip(
                    label: Text(interest),
                    selected: selected,
                    selectedColor:
                        primaryColor.withValues(
                      alpha: 0.15,
                    ),
                    checkmarkColor: primaryColor,
                    side: BorderSide(
                      color: selected
                          ? primaryColor
                          : Colors.black12,
                    ),
                    onSelected: (value) {
                      setState(() {
                        if (value) {
                          if (_selectedInterests
                                  .length <
                              6) {
                            _selectedInterests
                                .add(interest);
                          } else {
                            _showMessage(
                              'Tu peux choisir au maximum 6 intérêts.',
                            );
                          }
                        } else {
                          _selectedInterests
                              .remove(interest);
                        }
                      });
                    },
                  );
                }).toList(),
              ),

              const SizedBox(height: 28),

              const Text(
                'Je recherche',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              RadioGroup<String>(
                groupValue: _lookingFor,
                onChanged: (value) {
                  if (value == null) {
                    return;
                  }

                  setState(() {
                    _lookingFor = value;
                  });
                },
                child: Column(
                  children: [
                    RadioListTile<String>(
                      value: 'Une relation sérieuse',
                      title: const Text(
                        'Une relation sérieuse',
                      ),
                      subtitle: const Text(
                        'Construire quelque chose de durable',
                      ),
                      contentPadding:
                          EdgeInsets.zero,
                    ),
                    RadioListTile<String>(
                      value: 'Faire connaissance',
                      title: const Text(
                        'Faire connaissance',
                      ),
                      subtitle: const Text(
                        'Prendre le temps de découvrir quelqu’un',
                      ),
                      contentPadding:
                          EdgeInsets.zero,
                    ),
                    RadioListTile<String>(
                      value: 'Une rencontre',
                      title: const Text(
                        'Une rencontre',
                      ),
                      subtitle: const Text(
                        'Voir où la rencontre nous mène',
                      ),
                      contentPadding:
                          EdgeInsets.zero,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 22),

              Container(
                padding: const EdgeInsets.all(14),
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
                      Icons.favorite_border,
                      color: primaryColor,
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Sur Ose, prends ton temps. Le but est de créer de vraies connexions, sans pression.',
                        style: TextStyle(
                          fontSize: 13,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              SizedBox(
                height: 56,
                child: ElevatedButton(
                  onPressed:
                      _isSaving ? null : _continue,
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
                          'Continuer',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
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
