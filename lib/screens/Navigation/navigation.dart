import 'dart:developer';

import 'package:agro_xplore/screens/Crops/Crops.dart';
import 'package:agro_xplore/screens/Map/map.dart';
import 'package:agro_xplore/screens/Navigation/home/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({super.key});

  @override
  State<NavigationScreen> createState() => _NavigationState();
}

class _NavigationState extends State<NavigationScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void onTapSeeAll() {
    setState(() {
      _selectedIndex = 2; // Cambiar al índice deseado
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          HomeScreen(onTapSeeAll: onTapSeeAll), // Pasa la función correctamente
          MapScreen(),
          CropsScreen(),
          Center(child: Text('Care Guide')),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.primary,
        onPressed: () {
          setState(() {
            _selectedIndex = 2; // Ejemplo: cuando se presiona cambia a "My Plants"
          });
        },
        shape: const CircleBorder(),
        child: Icon(Icons.add, color: Theme.of(context).colorScheme.onPrimary),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.location_on),
            label: 'Map',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_florist_rounded),
            label: 'My Crops',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info),
            label: 'Care Guide',
          ),
        ],
      ),
    );
  }
}
