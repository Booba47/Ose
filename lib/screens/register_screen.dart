import 'package:flutter/material.dart';

import 'profile_setup_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController =
      TextEditingController();

  DateTime? _birthDate;
  bool _acceptedTerms = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  int _calculateAge(DateTime birthDate) {
    final today = DateTime.now();

    int age = today.year - birthDate.year;

    if (today.month < birthDate.month ||
        (today.month == birthDate.month &&
            today.day < birthDate.day)) {
      age--;
    }

    return age;
  }

  Future<void> _selectBirthDate() async {
    final now = DateTime.now();

    final latestDate = DateTime(
      now.year - 18,
      now.month,
      now.day,
    );

    final firstDate = DateTime(
      now.year - 100,
      now.month,
      now.day,
    );

    final initialDate = _birthDate ??
        DateTime(
          now.year - 25,
          now.month,
          now.day,
        );

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: latestDate,
      helpText: 'Sélectionne ta date de naissance',
      cancelText: 'Annuler',
      confirmText: 'Valider',
    );

    if (pickedDate == null) {
      return;
    }

    setState(() {
      _birthDate = pickedDate;
    });
  }

  void _register() {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_birthDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Sélectionne ta date de naissance.',
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final age = _calculateAge(_birthDate!);

    if (age < 18) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Ose est réservée aux personnes majeures.',
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    if (!_acceptedTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Tu dois accepter les conditions d’utilisation.',
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProfileSetupScreen(
          name: _nameController.text.trim(),
          birthDate: _birthDate!,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Créer mon compte'),
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
                  'Bienvenue sur Ose ❤️',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  'Quelques informations pour commencer '
                  'ton aventure.',
                  style: TextStyle(
                    fontSize: 15,
                    height: 1.4,
                    color: Colors.grey.shade700,
                  ),
                ),

                const SizedBox(height: 26),

                const Text(
                  'Comment doit-on t’appeler ?',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                TextFormField(
                  controller: _nameController,
                  textCapitalization:
                      TextCapitalization.words,
                  decoration: InputDecoration(
                    labelText: 'Prénom ou pseudo',
                    hintText: 'Ex. Alex',
                    prefixIcon: const Icon(
                      Icons.person_outline,
                    ),
                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(14),
                    ),
                  ),
                  validator: (value) {
                    final text = value?.trim() ?? '';

                    if (text.isEmpty) {
                      return 'Indique ton prénom ou ton pseudo.';
                    }

                    if (text.length < 2) {
                      return 'Utilise au moins 2 caractères.';
                    }

                    if (text.length > 30) {
                      return '30 caractères maximum.';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 20),

                const Text(
                  'Date de naissance',
                  style:t.bold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                Center(
                  child: Text(
                    'Ose est réservé aux personnes de 18 ans et plus.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ),

                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}             child: Text(
                    'Ose est réservé aux personnes de 18 ans et plus.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ),

                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
