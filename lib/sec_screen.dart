import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:new_pro/Home.dart';
import 'package:new_pro/Search.dart';
import 'package:new_pro/Profile.dart';

class SecScreen extends StatefulWidget {
  const SecScreen({super.key});

  @override
  State<SecScreen> createState() => _SecScreenState();
}

class _SecScreenState extends State<SecScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    Home(),
    Search(),
    Profile(profileUserId: FirebaseAuth.instance.currentUser!.uid),
  ];

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      body: _pages[_selectedIndex],

      bottomNavigationBar: NavigationBar(
        height: 80,
        backgroundColor: Color(0xFF0755C9),
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.transparent,
        selectedIndex: _selectedIndex,
        onDestinationSelected: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },

        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.home, color: Color(0xFFFFC107)),
            icon: Icon(Icons.home_outlined, color: Colors.white),
            label: ('Home'),
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.search_sharp, color: Color(0xFFFFC107)),
            icon: Icon(Icons.search, color: Colors.white),
            label: 'Search',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.person, color: Color(0xFFFFC107)),
            icon: Icon(Icons.person_2_outlined, color: Colors.white),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
