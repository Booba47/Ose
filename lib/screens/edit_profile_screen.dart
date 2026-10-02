import 'package:flutter/material.dart';

import '../models/user_profile.dart';
import '../services/user_service.dart';

class EditProfileScreen extends StatefulWidget {
  final UserProfile profile;

  const EditProfileScreen({
    super.key,
    required this.profile,
  });

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  static const Color primaryColor = Color(0xFFE6005C);
  static const Color backgroundColor = Color(0xFFFFF7FA);

  late final TextEditingController _nameController;
  late final TextEditingController _cityController;
  late final TextEditingController _bioController;

  String _lookingFor = '';
  late List<String> _selectedInterests;

  bool _isSaving = false;

  final List<String> _availableInterests = [
    '🎵 Musique',
    '✈️ Voyage',
    '🎬 Films',
    '🍳 Cuisine',
    '🎨 Art',
    '📚 Lecture',
    '☕ Sorties tranquilles',
    '🐾 Animaux',
    '🏋️ Sport',
    '🎮 Jeux vidéo',
    '🌿 Nature',
    '💃 Danse',
  ];

  final List<String> _lookingForOptions = [
    'Une relation sérieuse ❤️',
    'Faire des rencontres 💕',
    'Une relation amicale 🤝',
    'Discuter et apprendre à se connaître 💬',
  ];

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController(
      text: widget.profile.name,
    );

    _cityController = TextEditingController(
      text: widget.profile.city,
    );

    _bioController = TextEditingController(
      text: widget.profile.bio,
    );

    _lookingFor = widget.profile.lookingFor;

    _selectedInterests =
        List<String>.from(widget.profile.interests);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _cityController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  void _toggleInterest(String interest) {
    setState(() {
      if (_selectedInterests.contains(interest)) {
        _selectedInterests.remove(interest);
      } else {
        if (_selectedInterests.length >= 8) {
          _showMessage(
            'Tu peux sélectionner jusqu’à 8 centres d’intérêt.',
          );
          return;
        }

        _selectedInterests.add(interest);
      }
    });
  }

  Future<void> _saveProfile() async {
    final name = _nameController.text.trim();
    final city = _cityController.text.trim();
    final bio = _bioController.text.trim();

    if (name.isEmpty) {
      _showMessage('Indique ton prénom.');
      return;
    }

    if (city.isEmpty) {
      _showMessage('Indique ta ville.');
      return;
    }

    setState(() {
      _isSaving = true;
    });

    final updatedProfile = widget.profile.copyWith(
      name: name,
      city: city,
      bio: bio,
      interests: List<String>.from(_selectedInterests),
      lookingFor: _lookingFor,
    );

    await UserService.updateProfile(updatedProfile);

    if (!mounted) return;

    setState(() {
      _isSaving = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Ton profil a été mis à jour. 💕',
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );

    Navigator.pop(context, updatedProfile);
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
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
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: const Color(0xFFFFE5EF),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: primaryColor,
            size: 19,
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    int maxLines = 1,
    int? maxLength,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      maxLength: maxLength,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Padding(
          padding: EdgeInsets.only(
            left: 14,
            right: maxLines > 1 ? 0 : 4,
            top: maxLines > 1 ? 14 : 0,
          ),
          child: Icon(
            icon,
            color: primaryColor,
          ),
        ),
        filled: true,
        fillColor: Colors.white,
        counterStyle: const TextStyle(
          color: Color(0xFF999999),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(
            color: primaryColor,
            width: 1.5,
          ),
        ),
      ),
    );
  }

  Widget _buildInterestChip(String interest) {
    final selected = _selectedInterests.contains(interest);

    return GestureDetector(
      onTap: () => _toggleInterest(interest),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(
          horizontal: 13,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color: selected
              ? primaryColor
              : const Color(0xFFFFE8F0),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: selected
                ? primaryColor
                : const Color(0xFFFFD0DF),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              interest,
              style: TextStyle(
                color: selected
                    ? Colors.white
                    : const Color(0xFFC52A70),
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
            ),
            if (selected) ...[
              const SizedBox(width: 5),
              const Icon(
                Icons.check,
                size: 16,
                color: Colors.white,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildLookingForSelector() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: _lookingForOptions.map((option) {
          final selected = _lookingFor == option;

          return RadioListTile<String>(
            value: option,
            groupValue: _lookingFor,
            activeColor: primaryColor,
            title: Text(
              option,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            onChanged: (value) {
              if (value == null) return;

              setState(() {
                _lookingFor = value;
              });
            },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            selected: selected,
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: _isSaving ? null : _saveProfile,
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          disabledBackgroundColor:
              const Color(0xFFFFA9C7),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
        child: _isSaving
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: Colors.white,
                ),
              )
            : const Text(
                'Enregistrer les modifications',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
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
          'Modifier mon profil',
          style: TextStyle(
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            20,
            8,
            20,
            35,
          ),
          children: [
            Container(
              padding: const EdgeInsets.all(17),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFFFFDCE9),
                    Color(0xFFFFF0F5),
                  ],
                ),
                borderRadius: BorderRadius.circular(22),
              ),
              child: const Row(
                children: [
                  Text(
                    '💕',
                    style: TextStyle(
                      fontSize: 30,
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Ton profil te ressemble. Mets-le à jour quand tu veux.',
                      style: TextStyle(
                        color: Color(0xFF9F2458),
                        fontSize: 13,
                        height: 1.4,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            _buildSectionTitle(
              'Informations',
              Icons.person_outline,
            ),

            const SizedBox(height: 14),

            _buildTextField(
              controller: _nameController,
              label: 'Prénom',
              hint: 'Ton prénom',
              icon: Icons.person_outline,
              maxLength: 30,
            ),

            const SizedBox(height: 14),

            _buildTextField(
              controller: _cityController,
              label: 'Ville',
              hint: 'Ta ville',
              icon: Icons.location_on_outlined,
              maxLength: 50,
            ),

            const SizedBox(height: 14),

            _buildTextField(
              controller: _bioController,
              label: 'À propos de moi',
              hint: 'Présente-toi en quelques mots...',
              icon: Icons.edit_note_outlined,
              maxLines: 5,
              maxLength: 300,
            ),

            const SizedBox(height: 28),

            _buildSectionTitle(
              'Mes centres d’intérêt',
              Icons.auto_awesome_outlined,
            ),

            const SizedBox(height: 8),

            const Text(
              'Choisis jusqu’à 8 centres d’intérêt.',
              style: TextStyle(
                color: Color(0xFF777777),
                fontSize: 13,
              ),
            ),

            const SizedBox(height: 13),

            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _availableInterests
                  .map(_buildInterestChip)
                  .toList(),
            ),

            const SizedBox(height: 28),

            _buildSectionTitle(
              'Je recherche',
              Icons.favorite_border,
            ),

            const SizedBox(height: 12),

            _buildLookingForSelector(),

            const SizedBox(height: 30),

            _buildSaveButton(),

            const SizedBox(height: 15),

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
