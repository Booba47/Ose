import 'package:flutter/material.dart';

import '../models/user_profile.dart';
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

  final List<String> _selectedInterests = [];

  String _lookingFor = 'Une relation sérieuse';

  final List<String> _interests = [
    '🎵 Musique',
    '🎬 Films',
    '✈️ Voyage',
    '🍳 Cuisine',
    '🎨 Art',
    '📚 Lecture',
    '🐾 Animaux',
    '☕ Sorties tranquilles',
    '🏃 Sport',
    '🎮 Jeux vidéo',
    '🌿 Nature',
    '📷 Photographie',
  ];

  final List<String> _lookingForOptions = [
    'Une relation sérieuse',
    'Faire de nouvelles rencontres',
    'Discuter et apprendre à se connaître',
    'Voir où ça nous mène',
  ];

  @override
  void dispose() {
    _cityController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  void _toggleInterest(String interest) {
    setState(() {
      if (_selectedInterests.contains(interest)) {
        _selectedInterests.remove(interest);
      } else {
        if (_selectedInterests.length >= 6) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Tu peux sélectionner jusqu’à 6 centres d’intérêt.',
              ),
              behavior: SnackBarBehavior.floating,
            ),
          );
          return;
        }

        _selectedInterests.add(interest);
      }
    });
  }

  void _continue() {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedInterests.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Sélectionne au moins un centre d’intérêt.',
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

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

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PhotoSetupScreen(
          profile: profile,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ton profil'),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(
              20,
              12,
              20,
              30,
            ),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                const Text(
                  'Parle-nous un peu de toi',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  'Ces informations permettront aux autres '
                  'personnes de mieux te découvrir.',
                  style: TextStyle(
                    fontSize: 15,
                    height: 1.4,
                    color: Colors.grey.shade700,
                  ),
                ),

                const SizedBox(height: 26),

                const Text(
                  'Où habites-tu ?',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

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
                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(14),
                    ),
                  ),
                  validator: (value) {
                    final city = value?.trim() ?? '';

                    if (city.isEmpty) {
                      return 'Indique ta ville.';
                    }

                    if (city.length < 2) {
                      return 'Ville invalide.';
                    }

                    if (city.length > 50) {
                      return '50 caractères maximum.';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 24),

                const Text(
                  'Présente-toi',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                TextFormField(
                  controller: _bioController,
                  maxLines: 5,
                  maxLength: 300,
                  textCapitalization:
                      TextCapitalization.sentences,
                  decoration: InputDecoration(
                    labelText: 'Ma présentation',
                    hintText:
                        'Quelques mots sur toi...',
                    alignLabelWithHint: true,
                    prefixIcon: const Padding(
                      padding: EdgeInsets.only(
                        bottom: 70,
                      ),
                      child: Icon(
                        Icons.edit_outlined,
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(14),
                    ),
                  ),
                  validator: (value) {
                    final bio = value?.trim() ?? '';

                    if (bio.isEmpty) {
                      return 'Écris quelques mots sur toi.';
                    }

                    if (bio.length < 10) {
                      return '10 caractères minimum.';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 22),

                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Mes centres d’intérêt',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Text(
                      '${_selectedInterests.length}/6',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 6),

                Text(
                  'Choisis ceux qui te correspondent.',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                  ),
                ),

                const SizedBox(height: 12),

                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _interests.map(
                    (interest) {
                      final selected =
                          _selectedInterests
                              .contains(interest);

                      return GestureDetector(
                        onTap: () {
                          _toggleInterest(interest);
                        },
                        child: AnimatedContainer(
                          duration:
                              const Duration(
                            milliseconds: 180,
                          ),
                          padding:
                              const EdgeInsets.symmetric(
                            horizontal: 13,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: selected
                                ? Colors.pink
                                : Colors.pink.shade50,
                            borderRadius:
                                BorderRadius.circular(22),
                            border: Border.all(
                              color: selected
                                  ? Colors.pink
                                  : Colors.pink.shade100,
                            ),
                          ),
                          child: Text(
                            interest,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight:
                                  FontWeight.w600,
                              color: selected
                                  ? Colors.white
                                  : Colors.pink.shade800,
                            ),
                          ),
                        ),
                      );
                    },
                  ).toList(),
                ),

                const SizedBox(height: 26),

                const Text(
                  'Qu’est-ce que tu recherches ?',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  'Il n’y a pas de mauvaise réponse.',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                  ),
                ),

                const SizedBox(height: 10),

                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius:
                        BorderRadius.circular(14),
                    border: Border.all(
                      color: Colors.grey.shade200,
                    ),
                  ),
                  child: RadioGroup<String>(
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
                      children:
                          _lookingForOptions.map(
                        (option) {
                          return RadioListTile<String>(
                            value: option,
                            title: Text(
                              option,
                              style:
                                  const TextStyle(
                                fontSize: 14,
                              ),
                            ),
                            activeColor: Colors.pink,
                          );
                        },
                      ).toList(),
                    ),
                  ),
                ),

                const SizedBox(height: 28),

                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: _continue,
                    child: const Text(
                      'Continuer vers mes photos',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                Center(
                  child: Text(
                    'Tu pourras modifier ton profil plus tard.',
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
      ),
    );
  }
}
