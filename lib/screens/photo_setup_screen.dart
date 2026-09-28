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

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final _formKey = GlobalKey<FormState>();

  final _cityController = TextEditingController();
  final _bioController = TextEditingController();

  String? _lookingFor;

  final List<String> _interests = [
    '🎵 Musique',
    '🎬 Films',
    '⚽ Sport',
    '✈️ Voyage',
    '🍳 Cuisine',
    '🎮 Jeux',
    '📚 Lecture',
    '🎨 Art',
    '🐾 Animaux',
    '☕ Sorties tranquilles',
  ];

  final Set<String> _selectedInterests = {};

  @override
  void dispose() {
    _cityController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  void _continue() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedInterests.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Choisis au moins un centre d’intérêt.',
          ),
        ),
      );
      return;
    }

    if (_lookingFor == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Indique ce que tu recherches.',
          ),
        ),
      );
      return;
    }

    final profile = UserProfile(
      name: widget.name,
      birthDate: widget.birthDate,
      city: _cityController.text.trim(),
      bio: _bioController.text.trim(),
      interests: _selectedInterests.toList(),
      lookingFor: _lookingFor!,
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
        title: const Text('Mon profil'),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                const Center(
                  child: Text(
                    'Parle-nous un peu de toi ❤️',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                Center(
                  child: Text(
                    'Ces informations aideront Ose à te présenter '
                    'à des personnes compatibles.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey.shade700,
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                const Text(
                  'Ta ville',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                TextFormField(
                  controller: _cityController,
                  textCapitalization:
                      TextCapitalization.words,
                  decoration: const InputDecoration(
                    hintText: 'Ex. Paris',
                    prefixIcon: Icon(
                      Icons.location_city_outlined,
                    ),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null ||
                        value.trim().length < 2) {
                      return 'Indique ta ville.';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 24),

                const Text(
                  'Présente-toi',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                TextFormField(
                  controller: _bioController,
                  maxLines: 5,
                  maxLength: 300,
                  textCapitalization:
                      TextCapitalization.sentences,
                  decoration: const InputDecoration(
                    hintText:
                        'Ex. J’aime voyager, découvrir de '
                        'nouveaux endroits et passer des soirées '
                        'tranquilles...',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null ||
                        value.trim().length < 10) {
                      return 'Écris quelques mots sur toi.';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 24),

                const Text(
                  'Tes centres d’intérêt',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children:
                      _interests.map((interest) {
                    final selected =
                        _selectedInterests.contains(
                      interest,
                    );

                    return FilterChip(
                      label: Text(interest),
                      selected: selected,
                      onSelected: (value) {
                        setState(() {
                          if (value) {
                            _selectedInterests.add(
                              interest,
                            );
                          } else {
                            _selectedInterests.remove(
                              interest,
                            );
                          }
                        });
                      },
                    );
                  }).toList(),
                ),

                const SizedBox(height: 24),

                const Text(
                  'Qu’est-ce que tu recherches ?',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                RadioGroup<String>(
                  groupValue: _lookingFor,
                  onChanged: (value) {
                    setState(() {
                      _lookingFor = value;
                    });
                  },
                  child: const Column(
                    children: [
                      RadioListTile<String>(
                        value: 'Faire connaissance',
                        title: Text(
                          'Faire connaissance',
                        ),
                      ),
                      RadioListTile<String>(
                        value: 'Relation sérieuse',
                        title: Text(
                          'Une relation sérieuse',
                        ),
                      ),
                      RadioListTile<String>(
                        value: 'Sorties',
                        title: Text(
                          'Faire des sorties',
                        ),
                      ),
                      RadioListTile<String>(
                        value: 'Amitié',
                        title: Text(
                          'Une amitié qui pourrait évoluer',
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

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

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
