
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
  State<EditProfileScreen> createState() =>
      _EditProfileScreenState();
}

class _EditProfileScreenState
    extends State<EditProfileScreen> {
  static const Color primaryColor = Color(0xFFE6005C);
  static const Color backgroundColor = Color(0xFFFFF7FA);

  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _cityController;
  late final TextEditingController _bioController;
  late final TextEditingController _interestsController;
  late final TextEditingController _lookingForController;

  bool _isSaving = false;

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

    _interestsController = TextEditingController(
      text: widget.profile.interests.join(', '),
    );

    _lookingForController = TextEditingController(
      text: widget.profile.lookingFor,
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _cityController.dispose();
    _bioController.dispose();
    _interestsController.dispose();
    _lookingForController.dispose();
    super.dispose();
  }

  List<String> _getInterests() {
    final interests = _interestsController.text
        .split(',')
        .map((interest) => interest.trim())
        .where((interest) => interest.isNotEmpty)
        .toSet()
        .take(8)
        .toList();

    return interests;
  }

  Future<void> _saveProfile() async {
    if (_isSaving) return;

    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSaving = true;
    });

    final updatedProfile = widget.profile.copyWith(
      name: _nameController.text.trim(),
      city: _cityController.text.trim(),
      bio: _bioController.text.trim(),
      interests: _getInterests(),
      lookingFor: _lookingForController.text.trim(),
    );

    try {
      await UserService.updateProfile(updatedProfile);

      if (!mounted) return;

      Navigator.pop(context, updatedProfile);
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _isSaving = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Impossible d’enregistrer les modifications.',
          ),
        ),
      );
    }
  }

  Widget _buildLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 9),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    String? hint,
    int maxLines = 1,
    int? maxLength,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(label),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          maxLength: maxLength,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: Colors.white,
            counterStyle: const TextStyle(
              color: Color(0xFF999999),
            ),
            contentPadding: const EdgeInsets.all(16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(17),
              borderSide: const BorderSide(
                color: Color(0xFFEEEEEE),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(17),
              borderSide: const BorderSide(
                color: Color(0xFFEEEEEE),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(17),
              borderSide: const BorderSide(
                color: primaryColor,
                width: 1.5,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(17),
              borderSide: const BorderSide(
                color: Colors.red,
              ),
            ),
          ),
        ),
      ],
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
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            20,
            12,
            20,
            35,
          ),
          children: [
            Container(
              padding: const EdgeInsets.all(17),
              decoration: BoxDecoration(
                color: const Color(0xFFFFE5EF),
                borderRadius: BorderRadius.circular(19),
              ),
              child: const Row(
                children: [
                  Icon(
                    Icons.favorite,
                    color: primaryColor,
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Ton profil te représente. Fais-le découvrir aux autres !',
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

            const SizedBox(height: 25),

            _buildTextField(
              label: 'Prénom',
              controller: _nameController,
              hint: 'Ton prénom',
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Entre ton prénom.';
                }
                if (value.trim().length < 2) {
                  return 'Le prénom est trop court.';
                }
                return null;
              },
            ),

            const SizedBox(height: 20),

            _buildTextField(
              label: 'Ville',
              controller: _cityController,
              hint: 'Ta ville',
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Entre ta ville.';
                }
                return null;
              },
            ),

            const SizedBox(height: 20),

            _buildTextField(
              label: 'À propos de moi',
              controller: _bioController,
              hint: 'Présente-toi en quelques mots...',
              maxLines: 4,
              maxLength: 300,
            ),

            const SizedBox(height: 20),

            _buildTextField(
              label: 'Mes centres d’intérêt',
              controller: _interestsController,
              hint: 'Musique, voyage, cinéma...',
              maxLines: 2,
              maxLength: 200,
            ),

            const Padding(
              padding: EdgeInsets.only(top: 6),
              child: Text(
                'Sépare tes centres d’intérêt par des virgules. 8 maximum.',
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFF888888),
                ),
              ),
            ),

            const SizedBox(height: 20),

            _buildTextField(
              label: 'Je recherche',
              controller: _lookingForController,
              hint: 'Une relation sérieuse, de l’amitié...',
              maxLines: 2,
              maxLength: 150,
            ),

            const SizedBox(height: 30),

            SizedBox(
              height: 55,
              child: ElevatedButton(
                onPressed: _isSaving ? null : _saveProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor:
                      const Color(0xFFE8B8CB),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                child: _isSaving
                    ? const SizedBox(
                        width: 23,
                        height: 23,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2.5,
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
            ),
          ],
        ),
      ),
    );
  }
}
