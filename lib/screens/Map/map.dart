import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:agro_xplore/screens/AddCrops/provider/cloud_firestore.dart';
import 'package:agro_xplore/screens/CropDescription/crop_description.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final Completer<GoogleMapController> _controller = Completer<GoogleMapController>();
  Position? _currentPosition;
  String _locationMessage = '';
  Marker? _userMarker;
  Set<Marker> _cropMarkers = {}; // Set para almacenar los markers de los crops
  bool _isCardVisible = false; // Controla la visibilidad de la tarjeta
  Map<String, dynamic>? _selectedCrop; // Almacena el crop seleccionado

  @override
  void initState() {
    super.initState();
    _requestPermissions();
    _getCurrentLocation();
    _loadCropMarkers(); // Llama para obtener los markers de los crops
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
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    setState(() {
      _currentPosition = position;
      _locationMessage = "Lat: ${position.latitude}, Lng: ${position.longitude}";

      // Mover la cámara del mapa a la ubicación actual
      _moveCameraToPosition(position);

      // Crear o actualizar el marcador del usuario
      _userMarker = Marker(
        markerId: const MarkerId('user_marker'),
        position: LatLng(position.latitude, position.longitude),
        icon: BitmapDescriptor.defaultMarker, // Ícono personalizado
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

  Future<void> _loadCropMarkers() async {
    try {
      final crops = await getUserCrops();

      setState(() {
        _cropMarkers = crops.map((crop) {
          return Marker(
            markerId: MarkerId(crop['id']),
            position: LatLng(crop['latitude'], crop['longitude']),
            infoWindow: InfoWindow(
              title: crop['title'],
              snippet: 'Ubicación: ${crop['referenceLocation']}',
              onTap: () => _onMarkerTap(crop), // Maneja el clic en el marcador
            ),
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
          );
        }).toSet();
      });
    } catch (e) {
      log('Error al cargar los markers de los crops: $e');
    }
  }
  void _onMarkerTap(Map<String, dynamic> crop) {
    setState(() {
      _selectedCrop = crop;
      _isCardVisible = true;
    });
  }

  String formattedDate(Timestamp date) {
    DateTime dateTime = date.toDate();
    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _currentPosition == null
              ? const Center(child: CircularProgressIndicator())
              : GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(-12.070547, -75.208819),
              zoom: 16.0,
            ),
            markers: {
              if (_userMarker != null) _userMarker!,
              ..._cropMarkers,
            },
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
            onTap: (position) {
              // Cierra la tarjeta al tocar fuera de un marcador
              setState(() {
                _isCardVisible = false;
              });
            },
          ),
          _buildAnimatedCard(), // Tarjeta animada que aparece al hacer clic en un marcador
        ],
      ),
    );
  }
  Widget _buildAnimatedCard() {
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 300),
      bottom: _isCardVisible ? 0 : -200, // Se oculta fuera de la pantalla
      left: 0,
      right: 0,
      child: _selectedCrop != null
          ? Card(
        margin: const EdgeInsets.all(16.0),
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _selectedCrop!['title'],
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text('Reference: ${_selectedCrop!['referenceLocation']}'),
              const SizedBox(height: 8),
              Text('Date: ${formattedDate(_selectedCrop!['showingDate'])}'),
              const SizedBox(height: 16),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _isCardVisible = false; // Oculta la tarjeta
                      });
                    },
                    child: const Text('Close'),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CropDescriptionScreen(
                                id: _selectedCrop!['id'],
                              )));
                    },
                    child: const Text('View Details'),
                  ),
                ],
              )
            ],
          ),
        ),
      )
          : Container(),
    );
  }
}
