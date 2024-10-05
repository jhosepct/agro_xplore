import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  File? _image;
  Position? _currentPosition;
  String _locationMessage = '';

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _requestPermissions();
  }

  // Método para solicitar permisos
  Future<void> _requestPermissions() async {
    var statusCamera = await Permission.camera.status;
    var statusLocation = await Permission.locationWhenInUse.status;

    // Si los permisos no se han concedido, solicitarlos
    if (statusCamera.isDenied || statusLocation.isDenied) {
      await [
        Permission.camera,
        Permission.locationWhenInUse,
      ].request();
    }

    // Verificar si los permisos fueron concedidos
    if (await Permission.camera.isPermanentlyDenied ||
        await Permission.locationWhenInUse.isPermanentlyDenied) {
      openAppSettings(); // Abrir la configuración para habilitar los permisos manualmente
    }
  }

  // Método para capturar la imagen y obtener la ubicación
  Future<void> _getImageAndLocation() async {
    // Tomar la foto
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });

      // Obtener la ubicación actual
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      setState(() {
        _currentPosition = position;
        _locationMessage =
            "Lat: ${position.latitude}, Lng: ${position.longitude}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Theme.of(context).colorScheme.primary, // Color de la barra de estado
      statusBarIconBrightness: Brightness.light, // Color de los íconos en la barra de estado
    ));
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            _image == null
                ? const Text(
              'No has tomado ninguna foto.',
              style: TextStyle(fontSize: 18),
            )
                : Image.file(_image!),
            const SizedBox(height: 20),
            Text(
              _image == null
                  ? 'Presiona el botón para tomar una foto.'
                  : 'Ubicación: $_locationMessage',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _getImageAndLocation,
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
              child: const Text(
                'Tomar Foto',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
