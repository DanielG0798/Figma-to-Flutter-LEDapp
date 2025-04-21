import 'package:flutter/material.dart';
import 'rooms_screen.dart';
import 'tutorials_screen.dart';
import 'profile_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _pages = [
    RoomsScreen(),
    TutorialsScreen(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: SizedBox(
        height: 120,
      child: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Rooms',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'Tutorials',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        iconSize: 35,
        selectedFontSize: 18,
        unselectedFontSize: 16,
        currentIndex: _selectedIndex,
        selectedItemColor: theme.colorScheme.onPrimary,
        unselectedItemColor: theme.colorScheme.onPrimary.withOpacity(0.6),
        backgroundColor: theme.colorScheme.primary,
        onTap: _onItemTapped,
        ),
      ),
    );
  }
} 