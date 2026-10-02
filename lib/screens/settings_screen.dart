import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import '../services/block_service.dart';
import '../services/like_service.dart';
import '../services/match_service.dart';
import '../services/message_service.dart';
import '../services/notification_service.dart';
import '../services/photo_service.dart';
import '../services/preferences_service.dart';
import '../services/report_service.dart';
import '../services/user_service.dart';
import 'welcome_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _showOnlineStatus = true;
  bool _showReadReceipts = true;

  @override
  void initState() {
    super.initState();

    _notificationsEnabled =
        PreferencesService.notificationsEnabled;
    _showOnlineStatus =
        PreferencesService.showOnlineStatus;
    _showReadReceipts =
        PreferencesService.showReadReceipts;
  }

  Future<void> _toggleNotifications(bool value) async {
    setState(() {
      _notificationsEnabled = value;
    });

    await PreferencesService.setNotificationsEnabled(value);
  }

  Future<void> _toggleOnlineStatus(bool value) async {
    setState(() {
      _showOnlineStatus = value;
    });

    await PreferencesService.setShowOnlineStatus(value);
  }

  Future<void> _toggleReadReceipts(bool value) async {
    setState(() {
      _showReadReceipts = value;
    });

    await PreferencesService.setShowReadReceipts(value);
  }

  Future<void> _logout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Se déconnecter ?'),
          content: const Text(
            'Tu pourras te reconnecter à ton compte plus tard.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Annuler'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Se déconnecter'),
            ),
          ],
        );
      },
    );

    if (confirmed != true) return;

    await AuthService.signOut();

    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => const WelcomeScreen(),
      ),
      (route) => false,
    );
  }

  Future<void> _deleteLocalData() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Supprimer les données ?'),
          content: const Text(
            'Cette action supprimera les données actuellement enregistrées sur cet appareil : profil, photos, likes, matchs, messages, notifications et blocages.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Annuler'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Supprimer'),
            ),
          ],
        );
      },
    );

    if (confirmed != true) return;

    await UserService.deleteProfile();
    await PhotoService.clear();

    LikeService.clear();
    MatchService.clear();

    await MessageService.clear();
    await NotificationService.clear();
    await ReportService.clear();
    await BlockService.clear();

    await PreferencesService.clear();
    await AuthService.signOut();

    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => const WelcomeScreen(),
      ),
      (route) => false,
    );
  }

  void _showInfo(String title, String message) {
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Fermer'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 4,
        bottom: 10,
        top: 22,
      ),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildCard({
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: children,
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(
      height: 1,
      indent: 60,
      endIndent: 16,
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
          'Paramètres',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          20,
          4,
          20,
          32,
        ),
        children: [
          _buildSectionTitle('Notifications'),

          _buildCard(
            children: [
              SwitchListTile(
                value: _notificationsEnabled,
                activeColor: primaryColor,
                secondary: const Icon(
                  Icons.notifications_none_outlined,
                ),
                title: const Text('Notifications'),
                subtitle: const Text(
                  'Recevoir les nouveaux messages et matchs',
                ),
                onChanged: _toggleNotifications,
              ),
            ],
          ),

          _buildSectionTitle('Confidentialité'),

          _buildCard(
            children: [
              SwitchListTile(
                value: _showOnlineStatus,
                activeColor: primaryColor,
                secondary: const Icon(
                  Icons.circle_outlined,
                ),
                title: const Text('Statut en ligne'),
                subtitle: const Text(
                  'Permettre aux autres de voir si tu es en ligne',
                ),
                onChanged: _toggleOnlineStatus,
              ),
              _buildDivider(),
              SwitchListTile(
                value: _showReadReceipts,
                activeColor: primaryColor,
                secondary: const Icon(
                  Icons.done_all_outlined,
                ),
                title: const Text(
                  'Confirmations de lecture',
                ),
                subtitle: const Text(
                  'Indiquer quand un message a été lu',
                ),
                onChanged: _toggleReadReceipts,
              ),
            ],
          ),

          _buildSectionTitle('Aide et informations'),

          _buildCard(
            children: [
              ListTile(
                leading: const Icon(Icons.help_outline),
                title: const Text('Centre d’aide'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  _showInfo(
                    'Centre d’aide',
                    'Le centre d’aide de Ose sera disponible prochainement.',
                  );
                },
              ),
              _buildDivider(),
              ListTile(
                leading: const Icon(
                  Icons.description_outlined,
                ),
                title: const Text(
                  'Conditions d’utilisation',
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  _showInfo(
                    'Conditions d’utilisation',
                    'Les conditions d’utilisation complètes seront ajoutées avant la mise en ligne de Ose.',
                  );
                },
              ),
              _buildDivider(),
              ListTile(
                leading: const Icon(
                  Icons.privacy_tip_outlined,
                ),
                title: const Text(
                  'Politique de confidentialité',
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  _showInfo(
                    'Confidentialité',
                    'La politique de confidentialité complète sera ajoutée avant la mise en ligne de Ose.',
                  );
                },
              ),
              _buildDivider(),
              ListTile(
                leading: const Icon(Icons.info_outline),
                title: const Text('À propos de Ose'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  _showInfo(
                    'Ose',
                    'Ose — Ose faire le premier pas. 💕\n\nVersion 1.0.0',
                  );
                },
              ),
            ],
          ),

          _buildSectionTitle('Compte'),

          _buildCard(
            children: [
              ListTile(
                leading: const Icon(
                  Icons.logout,
                  color: primaryColor,
                ),
                title: const Text('Se déconnecter'),
                onTap: _logout,
              ),
              _buildDivider(),
              ListTile(
                leading: const Icon(
                  Icons.delete_outline,
                  color: Colors.red,
                ),
                title: const Text(
                  'Supprimer mes données',
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
                subtitle: const Text(
                  'Supprimer toutes les données locales',
                ),
                onTap: _deleteLocalData,
              ),
            ],
          ),

          const SizedBox(height: 24),

          const Center(
            child: Text(
              'Ose faire le premier pas. 💕',
              style: TextStyle(
                color: Colors.black45,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
