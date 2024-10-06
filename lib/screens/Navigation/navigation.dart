import 'dart:developer';
import 'package:agro_xplore/screens/AddCrops/view/add_crop_screen.dart';
import 'package:agro_xplore/screens/Crops/Crops.dart';
import 'package:agro_xplore/screens/Map/map.dart';
import 'package:agro_xplore/screens/Navigation/home/home.dart';
import 'package:agro_xplore/screens/profile/cubit/my_user_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../profile/model/user.dart';
import '../profile/provider/my_user_repository.dart';

MyUser me = MyUser('', '');

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
    return BlocProvider(
      create: (_) => MyUserCubit(MyUserRepository())..getMyUser(),
      child: BlocBuilder<MyUserCubit, MyUserState>(builder: (_, state) {
        if (state is MyUserReadyState) {
          me = state.user;
          print('My user ID: ${me.id}');
          return Scaffold(
            body: IndexedStack(
              index: _selectedIndex,
              children: [
                HomeScreen(
                    onTapSeeAll: onTapSeeAll), // Pasa la función correctamente
                const MapScreen(),
                // const AddCropScreen(),
                const CropsScreen(),
                const Center(child: Text('Care Guide')),
              ],
            ),
            floatingActionButton: FloatingActionButton(
              backgroundColor: Theme.of(context).colorScheme.primary,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AddCropScreen()),
                );
                // setState(() {
                //   _selectedIndex =
                //       2; // Ejemplo: cuando se presiona cambia a "My Plants"
                // });
              },
              shape: const CircleBorder(),
              child: Icon(Icons.add,
                  color: Theme.of(context).colorScheme.onPrimary),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
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
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      }),
    );
  }
}
