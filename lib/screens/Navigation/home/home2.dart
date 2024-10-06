import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Completer<GoogleMapController> _controller =
  Completer<GoogleMapController>();
  File? _image;
  Position? _currentPosition;
  String _locationMessage = '';
  Marker? _userMarker;
  int _selectedIndex = 0;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _requestPermissions();
    _getCurrentLocation();
  }

  @override
  void dispose() {
    super.dispose();
  }

  // Solicitar permisos de ubicación y cámara
  Future<void> _requestPermissions() async {
    var statusLocation = await Permission.locationWhenInUse.status;

    if (statusLocation.isDenied) {
      await [Permission.locationWhenInUse].request();
    }

    if (await Permission.locationWhenInUse.isPermanentlyDenied) {
      openAppSettings();
    }
  }

  // Obtener ubicación actual y actualizar el mapa y marcador
  Future<void> _getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    setState(() {
      _currentPosition = position;
      _locationMessage =
      "Lat: ${position.latitude}, Lng: ${position.longitude}";

      // Mover la cámara del mapa a la ubicación actual
      _moveCameraToPosition(position);

      // Crear o actualizar el marcador del usuario
      _userMarker = Marker(
        markerId: const MarkerId('user_marker'),
        position: LatLng(position.latitude, position.longitude),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen), // Ícono personalizado
        infoWindow: const InfoWindow(title: 'Tu ubicación actual'),
      );
    });
  }

  // Mover la cámara del mapa a la posición actual
  Future<void> _moveCameraToPosition(Position position) async {
    final GoogleMapController controller = await _controller.future;
    CameraPosition cameraPosition = CameraPosition(
      target: LatLng(position.latitude, position.longitude),
      zoom: 16.0,
    );
    controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  }

  // Método para capturar imagen y obtener la ubicación
  Future<void> _getImageAndLocation() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });

      // Obtener la ubicación actual
      await _getCurrentLocation();
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  static const List<Widget> _pages = <Widget>[
    Center(child: Text('Home')),
    Center(child: Text('Search')),
    Center(child: Text('My Plants')),
    Center(child: Text('Care Guide')),
  ];


  @override
  Widget build(BuildContext context) {
   /* SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Theme.of(context).colorScheme.primary,
      statusBarIconBrightness: Brightness.light,
    ));*/

    return Scaffold(
      /*body: _currentPosition == null
          ? const Center(child: CircularProgressIndicator())
          : GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
          zoom: 16.0,
        ),
        markers: _userMarker != null ? {_userMarker!} : {},
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),*/
      body: Padding(
          padding:  const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).padding.top, // + AppBar().preferredSize.height
                color: Colors.blue, // Color del AppBar simulado
                alignment: Alignment.center,
                child: const Text(
                  'Simulated AppBar',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
              _pages.elementAt(_selectedIndex),
            ],
          )),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.primary,
        onPressed: () {
          // Acción para el botón central
          setState(() {
            _selectedIndex = 2; // Ejemplo: cuando se presiona cambia a "My Plants"
          });
        }, // Cambia por el ícono que quieras
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
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_florist_rounded),
            label: 'My Plants',
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

