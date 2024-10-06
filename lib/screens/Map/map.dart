import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class MapScreen extends StatefulWidget {

  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
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
  Future<void> _requestPermissions() async {
    var statusLocation = await Permission.locationWhenInUse.status;

    if (statusLocation.isDenied) {
      await [Permission.locationWhenInUse].request();
    }

    if (await Permission.locationWhenInUse.isPermanentlyDenied) {
      openAppSettings();
    }
  }

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

  Future<void> _moveCameraToPosition(Position position) async {
    final GoogleMapController controller = await _controller.future;
    CameraPosition cameraPosition = CameraPosition(
      target: LatLng(position.latitude, position.longitude),
      zoom: 16.0,
    );
    controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _currentPosition == null
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
      ),
    );
  }
}
