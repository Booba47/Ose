import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  void _showMessage(
    BuildContext context,
    String message,
  ) {
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

  void _showConfirmation(
    BuildContext context,
    String title,
    String message,
  ) {
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          title: Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w800,
            ),
          ),
          content: Text(
            message,
            style: const TextStyle(
              height: 1.4,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Fermer'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8FB),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFF8FB),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Paramètres',
          style: TextStyle(
            fontWeight: FontWeight.w800,
            color: Colors.black,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          20,
          15,
          20,
          30,
        ),
        children: [
          // En-tête
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFFFE1EC),
                  Color(0xFFFFF3F7),
                ],
              ),
              borderRadius: BorderRadius.circular(26),
            ),
            child: const Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Color(0xFFE91E63),
                  child: Icon(
                    Icons.favorite,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Ton espace Ose',
                        style: TextStyle(
                          fontSize: 21,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF9F2458),
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'Personnalise ton expérience.',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF777777),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 25),

          const _SectionTitle(
            title: 'Mon compte',
          ),

          _SettingsTile(
            icon: Icons.person_outline,
            title: 'Modifier mon profil',
            subtitle: 'Nom, bio, ville et centres d’intérêt',
            onTap: () {
              _showMessage(
                context,
                'La modification du profil sera bientôt disponible.',
              );
            },
          ),

          _SettingsTile(
            icon: Icons.photo_library_outlined,
            title: 'Mes photos',
            subtitle: 'Gérer les photos de ton profil',
            onTap: () {
              _showMessage(
                context,
                'La gestion des photos sera bientôt disponible.',
              );
            },
          ),

          const SizedBox(height: 20),

          const _SectionTitle(
            title: 'Confidentialité et sécurité',
          ),

          _SettingsTile(
            icon: Icons.lock_outline,
            title: 'Confidentialité',
            subtitle: 'Contrôle tes informations personnelles',
            onTap: () {
              _showConfirmation(
                context,
                'Confidentialité',
                'Tes informations personnelles seront protégées '
                'et contrôlées par les paramètres de confidentialité '
                'de ton compte.',
              );
            },
          ),

          _SettingsTile(
            icon: Icons.shield_outlined,
            title: 'Sécurité',
            subtitle: 'Conseils pour utiliser Ose en sécurité',
            onTap: () {
              _showConfirmation(
                context,
                'Sécurité sur Ose',
                'Ne partage jamais tes informations sensibles '
                'avec une personne que tu viens de rencontrer. '
                'Privilégie les lieux publics pour une première rencontre.',
              );
            },
          ),

          _SettingsTile(
            icon: Icons.block_outlined,
            title: 'Profils bloqués',
            subtitle: 'Gérer les personnes bloquées',
            onTap: () {
              _showMessage(
                context,
                'La gestion des profils bloqués sera bientôt disponible.',
              );
            },
          ),

          const SizedBox(height: 20),

          const _SectionTitle(
            title: 'Aide',
          ),

          _SettingsTile(
            icon: Icons.help_outline,
            title: 'Aide et assistance',
            subtitle: 'Besoin d’aide avec Ose ?',
            onTap: () {
              _showConfirmation(
                context,
                'Aide et assistance',
                'Le centre d’aide de Ose sera bientôt disponible.',
              );
            },
          ),

          _SettingsTile(
            icon: Icons.feedback_outlined,
            title: 'Donner mon avis',
            subtitle: 'Partager une suggestion',
            onTap: () {
              _showMessage(
                context,
                'La fonctionnalité sera bientôt disponible.',
              );
            },
          ),

          const SizedBox(height: 20),

          const _SectionTitle(
            title: 'À propos',
          ),

          _SettingsTile(
            icon: Icons.favorite_border,
            title: 'À propos de Ose',
            subtitle: 'Ose faire le premier pas. 💕',
            onTap: () {
              _showConfirmation(
                context,
                'Ose',
                'Ose est une application de rencontres pensée '
               
