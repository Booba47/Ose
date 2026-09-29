import 'package:flutter/material.dart';

import 'register_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.pink.shade50,
              Colors.white,
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              Positioned(
                top: 35,
                right: -25,
                child: _DecorativeCircle(
                  size: 95,
                  color: Colors.pink.shade100,
                ),
              ),

              Positioned(
                top: 150,
                left: -35,
                child: _DecorativeCircle(
                  size: 80,
                  color: Colors.pink.shade50,
                ),
              ),

              Positioned(
                bottom: 170,
                right: -30,
                child: _DecorativeCircle(
                  size: 70,
                  color: Colors.pink.shade50,
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 20,
                ),
                child: Column(
                  children: [
                    const Spacer(),

                    Container(
                      width: 125,
                      height: 125,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.pink.shade300,
                            Colors.pink.shade600,
                          ],
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.pink.withValues(
                              alpha: 0.22,
                            ),
                            blurRadius: 25,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Text(
                          '❤️',
                          style: TextStyle(
                            fontSize: 58,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 26),

                    const Text(
                      'Ose',
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -1,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      'Ose faire le premier pas.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.w700,
                        color: Colors.pink.shade700,
                      ),
                    ),

                    const SizedBox(height: 16),

                    Text(
                      'Une application pensée pour les '
                      'personnes qui préfèrent prendre leur temps '
                      'et faire de vraies rencontres.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15.5,
                        height: 1.5,
                        color: Colors.grey.shade700,
                      ),
                    ),

                    const SizedBox(height: 18),

                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.center,
                      children: [
                        _FeatureItem(
                          icon: Icons.favorite_outline,
                          text: 'Rencontres',
                        ),
                        const SizedBox(width: 16),
                        _FeatureItem(
                          icon: Icons.shield_outlined,
                          text: 'Sécurisé',
                        ),
                        const SizedBox(width: 16),
                        _FeatureItem(
                          icon: Icons.chat_bubble_outline,
                          text: 'Échanges',
                        ),
                      ],
                    ),

                    const Spacer(),

                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  const RegisterScreen(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.pink,
                          foregroundColor: Colors.white,
                          elevation: 5,
                          shadowColor: Colors.pink
                              .withValues(alpha: 0.25),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(18),
                          ),
                        ),
                        child: const Text(
                          'Créer mon compte',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: OutlinedButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(
                            const SnackBar(
                              content: Text(
                                'La connexion sera ajoutée '
                                'prochainement.',
                              ),
                              behavior:
                                  SnackBarBehavior.floating,
                            ),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.pink.shade700,
                          side: BorderSide(
                            color: Colors.pink.shade200,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(18),
                          ),
                        ),
                        child: const Text(
                          "J'ai déjà un compte",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 18),

                    Text(
                      '🔒 Application réservée aux adultes.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      'Ose faire le premier pas. ❤️',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade500,
                      ),
                    ),

                    const SizedBox(height: 6),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DecorativeCircle extends StatelessWidget {
  final double size;
  final Color color;

  const _DecorativeCircle({
    required this.size,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}

class _FeatureItem extends StatelessWidget {
  final IconData icon;
  final String text;

  const _FeatureItem({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          icon,
          size: 20,
          color: Colors.pink.shade600,
        ),
        const SizedBox(height: 4),
        Text(
          text,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade700,
          ),
        ),
      ],
    );
  }
}
