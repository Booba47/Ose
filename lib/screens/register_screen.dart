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

  DateTime? _birthDate;
  bool _hidePassword = true;
  bool _acceptedTerms = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _selectBirthDate() async {
    final now = DateTime.now();

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime(
        now.year - 25,
        now.month,
        now.day,
      ),
      firstDate: DateTime(1900),
      lastDate: now,
      helpText: 'Choisis ta date de naissance',
      cancelText: 'Annuler',
      confirmText: 'Valider',
    );

    if (pickedDate != null) {
      setState(() {
        _birthDate = pickedDate;
      });
    }
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

  void _continueRegistration() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_birthDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Choisis ta date de naissance.',
          ),
        ),
      );
      return;
    }

    if (_calculateAge(_birthDate!) < 18) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Ose est réservé aux personnes de 18 ans et plus.',
          ),
        ),
      );
      return;
    }

    if (!_acceptedTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Tu dois accepter les conditions pour continuer.',
          ),
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
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                const Center(
                  child: Text(
                    'Bienvenue sur Ose ❤️',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                Center(
                  child: Text(
                    'Créons ton profil en quelques étapes.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                const Text(
                  'Nom ou pseudo',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                TextFormField(
                  controller: _nameController,
                  textCapitalization:
                      TextCapitalization.words,
                  decoration: const InputDecoration(
                    hintText: 'Ex. Alex',
                    prefixIcon: Icon(
                      Icons.person_outline,
                    ),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null ||
                        value.trim().length < 2) {
                      return 'Entre au moins 2 caractères.';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 20),

                const Text(
                  'Date de naissance',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                InkWell(
                  onTap: _selectBirthDate,
                  borderRadius: BorderRadius.circular(4),
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      prefixIcon: Icon(
                        Icons.cake_outlined,
                      ),
                      border: OutlineInputBorder(),
                    ),
                    child: Text(
                      _birthDate == null
                          ? 'Choisir ma date de naissance'
                          : '${_birthDate!.day.toString().padLeft(2, '0')}/'
                              '${_birthDate!.month.toString().padLeft(2, '0')}/'
                              '${_birthDate!.year}',
                      style: TextStyle(
                        fontSize: 16,
                        color: _birthDate == null
                            ? Colors.grey.shade600
                            : Colors.black,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                const Text(
                  'Adresse e-mail',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                TextFormField(
                  controller: _emailController,
                  keyboardType:
                      TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    hintText: 'Ex. alex@email.com',
                    prefixIcon: Icon(
                      Icons.email_outlined,
                    ),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null ||
                        value.trim().isEmpty) {
                      return 'Entre ton adresse e-mail.';
                    }

                    final emailRegex = RegExp(
                      r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
                    );

                    if (!emailRegex.hasMatch(
                      value.trim(),
                    )) {
                      return 'Entre une adresse e-mail valide.';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 20),

                const Text(
                  'Mot de passe',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                TextFormField(
                  controller: _passwordController,
                  obscureText: _hidePassword,
                  decoration: InputDecoration(
                    hintText: 'Minimum 6 caractères',
                    prefixIcon: const Icon(
                      Icons.lock_outline,
                    ),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _hidePassword = !_hidePassword;
                        });
                      },
                      icon: Icon(
                        _hidePassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                      ),
                    ),
                    border: const OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null ||
                        value.length < 6) {
                      return 'Le mot de passe doit contenir au moins 6 caractères.';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 20),

                CheckboxListTile(
                  value: _acceptedTerms,
                  contentPadding: EdgeInsets.zero,
                  controlAffinity:
                      ListTileControlAffinity.leading,
                  title: const Text(
                    'J’accepte les conditions d’utilisation '
                    'et la politique de confidentialité.',
                  ),
                  onChanged: (value) {
                    setState(() {
                      _acceptedTerms =
                          value ?? false;
                    });
                  },
                ),

                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: _continueRegistration,
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
