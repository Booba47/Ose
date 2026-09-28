import 'package:flutter/material.dart';

import 'discover_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    DiscoverScreen(),
    _MessagesPage(),
    _MatchesPage(),
    _ProfilePage(),
  ];

  final List<String> _titles = [
    'Découvrir',
    'Messages',
    'Matchs',
    'Mon profil',
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

class _MessagesPage extends StatelessWidget {
  const _MessagesPage();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.chat_bubble_outline,
            size: 70,
            color: Colors.grey,
          ),
          SizedBox(height: 20),
          Text(
            'Tes conversations',
            style: TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Tes messages apparaîtront ici.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}

class _MatchesPage extends StatelessWidget {
  const _MatchesPage();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.favorite_border,
            size: 70,
            color: Colors.pink,
          ),
          SizedBox(height: 20),
          Text(
            'Tes Matchs',
            style: TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Quand quelqu’un t’aime aussi, '
            'votre Match apparaîtra ici.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey,
            ),
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
            leading: const Icon(Icons.edit_outlined),
            title: const Text('Modifier mon profil'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),

          const Divider(),

          ListTile(
            leading: const Icon(Icons.settings_outlined),
            title: const Text('Paramètres'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),

          const Divider(),

          ListTile(
            leading: const Icon(Icons.security_outlined),
            title: const Text('Sécurité et confidentialité'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
