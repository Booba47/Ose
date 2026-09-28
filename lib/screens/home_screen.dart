import 'package:flutter/material.dart';

import 'discover_screen.dart';
import 'messages_screen.dart';
import 'matches_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<String> _titles = [
    'Découvrir',
    'Messages',
    'Matchs',
    'Mon profil',
  ];

  final List<Widget> _pages = const [
    DiscoverScreen(),
    MessagesScreen(),
    MatchesScreen(),
    _ProfilePage(),
  ];

  void _onTabSelected(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _titles[_currentIndex],
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: _onTabSelected,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.favorite_border),
            selectedIcon: Icon(Icons.favorite),
            label: 'Découvrir',
          ),
          NavigationDestination(
            icon: Icon(Icons.chat_bubble_outline),
            selectedIcon: Icon(Icons.chat_bubble),
            label: 'Messages',
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite_outline),
            selectedIcon: Icon(Icons.favorite),
            label: 'Matchs',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}

class _ProfilePage extends StatelessWidget {
  const _ProfilePage();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const SizedBox(height: 20),

          const CircleAvatar(
            radius: 55,
            child: Icon(
              Icons.person,
              size: 60,
            ),
          ),

          const SizedBox(height: 18),

          const Text(
            'Mon profil',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            'Ton profil apparaîtra ici.',
            style: TextStyle(
              color: Colors.grey.shade700,
            ),
          ),

          const SizedBox(height: 30),

          ListTile(
            leading: const Icon(
              Icons.edit_outlined,
            ),
            title: const Text(
              'Modifier mon profil',
            ),
            trailing: const Icon(
              Icons.chevron_right,
            ),
            onTap: () {},
          ),

          const Divider(),

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
            onTap: () {},
          ),

          const Divider(),

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
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
