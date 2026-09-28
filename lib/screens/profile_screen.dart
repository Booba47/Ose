import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const SizedBox(height: 20),

          // Photo de profil
          const CircleAvatar(
            radius: 65,
            child: Icon(
              Icons.person,
              size: 70,
            ),
          ),

          const SizedBox(height: 18),

          // Nom
          const Text(
            'Mon profil',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          // Ville
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.location_on_outlined,
                size: 18,
                color: Colors.grey.shade600,
              ),
              const SizedBox(width: 4),
              Text(
                'Ma ville',
                style: TextStyle(
                  color: Colors.grey.shade700,
                  fontSize: 15,
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Présentation
          Card(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  const Text(
                    'À propos de moi',
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    'Ta présentation apparaîtra ici. '
                    'Tu pourras expliquer qui tu es, '
                    'ce que tu aimes et ce que tu recherches.',
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Centres d'intérêt
          Card(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Mes centres d’intérêt',
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 14),

                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: const [
                      Chip(
                        label: Text('🎵 Musique'),
                      ),
                      Chip(
                        label: Text('🎬 Films'),
                      ),
                      Chip(
                        label: Text('✈️ Voyage'),
                      ),
                      Chip(
                        label: Text('☕ Sorties'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Modifier le profil
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context)
                    .showSnackBar(
                  const SnackBar(
                    content: Text(
                      'La modification du profil sera ajoutée prochainement.',
                    ),
                  ),
                );
              },
              icon: const Icon(
                Icons.edit_outlined,
              ),
              label: const Text(
                'Modifier mon profil',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Paramètres
          ListTile(
            leading: const Icon(
              Icons.settings_outlined,
            ),
            title: const Text(
              'Paramètres',
            ),
            trailing: const Icon(
              Icons.chevron_right,
            ),
            onTap: () {
              ScaffoldMessenger.of(context)
                  .showSnackBar(
                const SnackBar(
                  content: Text(
                    'Les paramètres seront ajoutés prochainement.',
                  ),
                ),
              );
            },
          ),

          const Divider(),

          // Sécurité
          ListTile(
            leading: const Icon(
              Icons.security_outlined,
            ),
            title: const Text(
              'Sécurité et confidentialité',
            ),
            trailing: const Icon(
              Icons.chevron_right,
            ),
            onTap: () {
              ScaffoldMessenger.of(context)
                  .showSnackBar(
                const SnackBar(
                  content: Text(
                    'Les options de sécurité seront ajoutées prochainement.',
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
