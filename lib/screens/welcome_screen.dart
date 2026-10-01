import 'package:flutter/material.dart';

import 'register_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8FB),
      body: SafeArea(
        child: Stack(
          children: [
            // Cercle décoratif en haut à droite
            Positioned(
              top: 0,
              right: -35,
              child: Container(
                width: 150,
                height: 150,
                decoration: const BoxDecoration(
                  color: Color(0xFFF7B6CF),
                  shape: BoxShape.circle,
                ),
              ),
            ),

            // Cercle décoratif à gauche
            Positioned(
              top: 250,
              left: -65,
              child: Container(
                width: 155,
                height: 155,
                decoration: const BoxDecoration(
                  color: Color(0xFFFBE1EB),
                  shape: BoxShape.circle,
                ),
              ),
            ),

            // Cercle décoratif en bas à droite
            Positioned(
              bottom: 180,
              right: -45,
              child: Container(
                width: 125,
                height: 125,
                decoration: const BoxDecoration(
                  color: Color(0xFFFBE1EB),
                  shape: BoxShape.circle,
                ),
              ),
            ),

            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 28,
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 80),

                    // Logo
                    Container(
                      width: 245,
                      height: 245,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(0xFFEF4B8A),
                            Color(0xFFE6005C),
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFE6005C)
                                .withValues(alpha: 0.20),
                            blurRadius: 30,
                            spreadRadius: 5,
                            offset: const Offset(0, 12),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Text(
                          '❤️',
                          style: TextStyle(
                            fontSize: 90,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 55),

                    // Nom de l'application
                    const Text(
                      'Ose',
                      style: TextStyle(
                        fontSize: 58,
                        fontWeight: FontWeight.w800,
                        color: Colors.black,
                        height: 1,
                      ),
                    ),

                    const SizedBox(height: 25),

                    // Slogan principal
                    const Text(
                      'Ose faire le premier pas.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFFB51F61),
                      ),
                    ),

                    const SizedBox(height: 25),

                    // Description
                    const Text(
                      'Une application pensée pour les personnes qui '
                      'préfèrent prendre leur temps et faire de vraies '
                      'rencontres.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        height: 1.45,
                        color: Color(0xFF666666),
                      ),
                    ),

                    const SizedBox(height: 40),

                    // Les 3 avantages
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: const [
                        _FeatureItem(
                          icon: Icons.favorite_border,
                          label: 'Rencontres',
                        ),
                        _FeatureItem(
                          icon: Icons.shield_outlined,
                          label: 'Sécurisé',
                        ),
                        _FeatureItem(
                          icon: Icons.chat_bubble_outline,
                          label: 'Échanges',
                        ),
                      ],
                    ),

                    const SizedBox(height: 55),

                    // Bouton créer un compte
                    SizedBox(
                      width: double.infinity,
                      height: 72,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const RegisterScreen(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFED1767),
                          foregroundColor: Colors.white,
                          elevation: 6,
                          shadowColor: const Color(0xFFED1767)
                              .withValues(alpha: 0.25),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Text(
                          'Créer mon compte',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 22),

                    // Bouton connexion
                    SizedBox(
                      width: double.infinity,
                      height: 72,
                      child: OutlinedButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'La connexion sera bientôt disponible.',
                              ),
                            ),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF9F2458),
                          side: const BorderSide(
                            color: Color(0xFFD98AAE),
                            width: 2,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Text(
                          "J'ai déjà un compte",
                          style: TextStyle(
                            fontSize: 21,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 35),

                    // Mention adulte
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '🔒',
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        SizedBox(width: 7),
                        Text(
                          'Application réservée aux adultes.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFF777777),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 15),

                    // NOUVEAU TEXTE
                    const Text(
                      'Ici, pas de pression. Juste de belles rencontres. 💕',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFFAAAAAA),
                      ),
                    ),

                    const SizedBox(height: 25),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FeatureItem extends StatelessWidget {
  final IconData icon;
  final String label;

  const _FeatureItem({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          icon,
          size: 38,
          color: const Color(0xFFC52A70),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: Color(0xFF666666),
          ),
        ),
      ],
    );
  }
}
