import 'package:flutter/material.dart';

import '../models/user_profile.dart';
import 'discover_screen.dart';
import 'messages_screen.dart';
import 'matches_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  final UserProfile profile;

  const HomeScreen({
    super.key,
    required this.profile,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final List<String> titles = [
      'Découvrir',
      'Messages',
      'Matchs',
      'Mon profil',
    ];

    final List<Widget> pages = [
      const DiscoverScreen(),
      const MessagesScreen(),
      const MatchesScreen(),
      ProfileScreen(
        profile: widget.profile,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          titles[_currentIndex],
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),

      body: IndexedStack(
        index: _currentIndex,
        children: pages,
      ),

      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
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
