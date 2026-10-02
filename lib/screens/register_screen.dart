import 'package:flutter/material.dart';

import '../services/auth_service.dart';
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
  final _confirmPasswordController = TextEditingController();

  DateTime? _birthDate;
  bool _acceptedTerms = false;
  bool _isLoading = false;
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

  Future<void> _selectBirthDate() async {
    final now = DateTime.now();

    final initialDate = DateTime(
      now.year - 25,
      now.month,
      now.day,
    );

    final firstDate = DateTime(
      now.year - 100,
      now.month,
      now.day,
    );

    final lastDate = DateTime(
      now.year - 18,
      now.month,
      now.day,
    );

    final selectedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
      helpText: 'Sélectionne ta date de naissance',
    );

    if (selectedDate != null) {
      setState(() {
        _birthDate = selectedDate;
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

  Future<void> _register() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_birthDate == null) {
      _showMessage(
        'Sélectionne ta date de naissance.',
      );
      return;
    }

    final age = _calculateAge(_birthDate!);

    if (age < 18) {
      _showMessage(
        'Ose est réservé aux personnes majeures.',
      );
      return;
    }

    if (!_acceptedTerms) {
      _showMessage(
        'Tu dois accepter les conditions d’utilisation.',
      );
      return;
    }

    if (_passwordController.text !=
        _confirmPasswordController.text) {
      _showMessage(
        'Les mots de passe ne correspondent pas.',
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final success = await AuthService.register(
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );

    if (!mounted) {
      return;
    }

    setState(() {
      _isLoading = false;
    });

    if (!success) {
      _showMessage(
        'Impossible de créer le compte.',
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
          'Créer mon compte',
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
              16,
              24,
              32,
            ),
            children: [
              const Text(
                'Bienvenue sur Ose 💕',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Crée ton compte et commence à faire de belles rencontres.',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.black54,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 28),

              TextFormField(
                controller: _nameController,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  labelText: 'Prénom',
                  hintText: 'Ton prénom',
                  prefixIcon: const Icon(Icons.person_outline),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
                validator: (value) {
                  if (value == null ||
                      value.trim().isEmpty) {
                    return 'Entre ton prénom.';
                  }

                  if (value.trim().length < 2) {
                    return 'Ton prénom est trop court.';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 16),

              InkWell(
                onTap: _selectBirthDate,
                borderRadius: BorderRadius.circular(16),
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: 'Date de naissance',
                    prefixIcon: const Icon(
                      Icons.cake_outlined,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  child: Text(
                    _birthDate == null
                        ? 'Sélectionner ma date'
                        : '${_birthDate!.day.toString().padLeft(2, '0')}/'
                            '${_birthDate!.month.toString().padLeft(2, '0')}/'
                            '${_birthDate!.year}',
                    style: TextStyle(
                      color: _birthDate == null
                          ? Colors.black54
                          : Colors.black87,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Adresse e-mail',
                  hintText: 'exemple@email.com',
                  prefixIcon: const Icon(
                    Icons.email_outlined,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
                validator: (value) {
                  final email = value?.trim() ?? '';

                  if (email.isEmpty) {
                    return 'Entre ton adresse e-mail.';
                  }

                  if (!email.contains('@') ||
                      !email.contains('.')) {
                    return 'Entre une adresse e-mail valide.';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  labelText: 'Mot de passe',
                  hintText: 'Minimum 6 caractères',
                  prefixIcon: const Icon(
                    Icons.lock_outline,
                  ),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _obscurePassword =
                            !_obscurePassword;
                      });
                    },
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                    ),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
                validator: (value) {
                  if (value == null ||
                      value.isEmpty) {
                    return 'Entre un mot de passe.';
                  }

                  if (value.length < 6) {
                    return 'Le mot de passe doit contenir au moins 6 caractères.';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: _confirmPasswordController,
                obscureText: _obscureConfirmPassword,
                decoration: InputDecoration(
                  labelText: 'Confirmer le mot de passe',
                  prefixIcon: const Icon(
                    Icons.lock_reset_outlined,
                  ),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _obscureConfirmPassword =
                            !_obscureConfirmPassword;
                      });
                    },
                    icon: Icon(
                      _obscureConfirmPassword
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                    ),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
                validator: (value) {
                  if (value == null ||
                      value.isEmpty) {
                    return 'Confirme ton mot de passe.';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 16),

              Row(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Checkbox(
                    value: _acceptedTerms,
                    activeColor: primaryColor,
                    onChanged: (value) {
                      setState(() {
                        _acceptedTerms =
                            value ?? false;
                      });
                    },
                  ),
                  const Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(top: 12),
                      child: Text(
                        'J’accepte les conditions d’utilisation et la politique de confidentialité de Ose.',
                        style: TextStyle(
                          fontSize: 13,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: primaryColor.withValues(
                    alpha: 0.08,
                  ),
                  borderRadius:
                      BorderRadius.circular(16),
                ),
                child: const Row(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.verified_user_outlined,
                      color: primaryColor,
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Ose est réservé aux personnes âgées de 18 ans ou plus.',
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
                      _isLoading ? null : _register,
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
                  child: _isLoading
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
                          'Créer mon compte',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),

              const SizedBox(height: 20),

              const Text(
                'En créant un compte, tu confirmes avoir 18 ans ou plus.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.black45,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
