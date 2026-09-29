import 'package:flutter/material.dart';

import '../models/user_profile.dart';
import 'discover_screen.dart';
import 'matches_screen.dart';
import 'messages_screen.dart';
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

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();

    _screens = [
      const DiscoverScreen(),
      const MessagesScreen(),
      const MatchesScreen(),
      ProfileScreen(
        profile: widget.profile,
      ),
    ];
  }

  void _onNavigationTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  String get _title {
    switch (_currentIndex) {
      case 0:
        return 'Découvrir';
      case 1:
        return 'Messages';
      case 2:
        return 'Matchs';
      case 3:
        return 'Mon profil';
      default:
        return 'Ose';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              '❤️',
              style: TextStyle(
                fontSize: 22,
              ),
            ),
            const SizedBox(width: 7),
            Text(
              _title,
              style: const TextStyle(
                fontWeight: FontWeight.w800,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Notifications',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Les notifications seront bientôt disponibles.',
                  ),
                ),
              );
            },
            icon: const Icon(
              Icons.notifications_none_rounded,
              color: Colors.black87,
            ),
          ),
        ],
      ),

      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),

      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: _onNavigationTap,
        backgroundColor: Colors.white,
        indicatorColor: Colors.pink.shade50,
        destinations: const [
          NavigationDestination(
            icon: Icon(
              Icons.explore_outlined,
            ),
            selectedIcon: Icon(
              Icons.explore,
              color: Colors.pink,
            ),
            label: 'Découvrir',
          ),
          NavigationDestination(
            icon: Icon(
              Icons.chat_bubble_outline_rounded,
            ),
            selectedIcon: Icon(
              Icons.chat_bubble_rounded,
              color: Colors.pink,
            ),
            label: 'Messages',
          ),
          NavigationDestination(
            icon: Icon(
              Icons.favorite_border_rounded,
            ),
            selectedIcon: Icon(
              Icons.favorite_rounded,
              color: Colors.pink,
            ),
            label: 'Matchs',
          ),
          NavigationDestination(
            icon: Icon(
              Icons.person_outline_rounded,
            ),
            selectedIcon: Icon(
              Icons.person_rounded,
              color: Colors.pink,
            ),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}
