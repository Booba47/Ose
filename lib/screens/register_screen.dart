
import 'package:flutter/material.dart';

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

    final selected = await showDatePicker(
      context: context,
      initialDate: DateTime(now.year - 25),
      firstDate: DateTime(1920),
      lastDate: now,
      helpText: 'Choisis ta date de naissance',
    );

    if (selected != null && mounted) {
      setState(() {
        _birthDate = selected;
      });
    }
  }

  int _calculateAge(DateTime birthDate) {
    final now = DateTime.now();
    int age = now.year - birthDate.year;

    if (now.month < birthDate.month ||
        (now.month == birthDate.month &&
            now.day < birthDate.day)) {
      age--;
    }

    return age;
  }

  void _continueRegistration() {
    if (!_formKey.currentState!.validate()) return;

    if (_birthDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Choisis ta date de naissance.'),
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

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Formulaire validé ! La connexion sera ajoutée ensuite.',
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: Text(
                    'Fais le premier pas ❤️',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                Center(
                  child: Text(
                    'Quelques informations pour commencer.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey.shade700,
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                const Text('Ton prénom ou pseudo'),

                const SizedBox(height: 8),

                TextFormField(
                  controller: _nameController,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(
                    hintText: 'Ex. Alex',
                    prefixIcon: Icon(Icons.person_outline),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().length < 2) {
                      return 'Entre un prénom ou pseudo valide.';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 20),

                const Text('Ta date de naissance'),

                const SizedBox(height: 8),

                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: _selectBirthDate,
                    icon: const Icon(Icons.calendar_month),
                    label: Text(
                      _birthDate == null
                          ? 'Choisir ma date de naissance'
                          : '${_birthDate!.day.toString().padLeft(2, '0')}/'
                            '${_birthDate!.month.toString().padLeft(2, '0')}/'
                            '${_birthDate!.year}',
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                const Text('Ton adresse email'),

                const SizedBox(height: 8),

                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  autocorrect: false,
                  decoration: const InputDecoration(
                    hintText: 'exemple@email.com',
                    prefixIcon: Icon(Icons.email_outlined),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    final email = value?.trim() ?? '';
                    if (!RegExp(
                      r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
                    ).hasMatch(email)) {
                      return 'Entre une adresse email valide.';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 20),

                const Text('Choisis un mot de passe'),

                const SizedBox(height: 8),

                TextFormField(
                  controller: _passwordController,
                  obscureText: _hidePassword,
                  autocorrect: false,
                  decoration: InputDecoration(
                    hintText: '6 caractères minimum',
                    prefixIcon: const Icon(Icons.lock_outline),
                    border: const OutlineInputBorder(),
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
                  ),
                  validator: (value) {
                    if (value == null || value.length < 8) {
                      return 'Utilise au moins 8 caractères.';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 20),

                CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  value: _acceptedTerms,
                  controlAffinity: ListTileControlAffinity.leading,
                  onChanged: (value) {
                    setState(() {
                      _acceptedTerms = value ?? false;
                    });
                  },
                  title: const Text(
                    'J’accepte les conditions d’utilisation '
                    'et la politique de confidentialité.',
                    style: TextStyle(fontSize: 13),
                  ),
                ),

                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  height: 54,
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
