import 'dart:async';
import 'dart:io';

import 'package:agro_xplore/home/view/main_screen.dart';
import 'package:agro_xplore/login/widgets/glassmorphic_box.dart';
import 'package:agro_xplore/screens/AddCrops/provider/cloud_firestore.dart';
import 'package:agro_xplore/screens/Navigation/navigation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_picker/image_picker.dart';

// import '../provider/util.dart';

class AddCropScreen extends StatefulWidget {
  static Widget create(BuildContext context) {
    return const AddCropScreen();
  }

  const AddCropScreen({super.key});
  @override
  State<AddCropScreen> createState() => _AddCropScreenState();
}

class _AddCropScreenState extends State<AddCropScreen> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  // final mapboxAccessToken =
  // final mapboxStyle = 'mapbox/streets-v12';

  final formKey = GlobalKey<FormState>();
  // final utils = Utils();
  DateTime? selectedDateTime;
  TextEditingController title = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController reference = TextEditingController();
  TextEditingController area = TextEditingController();
  TextEditingController dateTime = TextEditingController();
  LatLng? markerLocation;
  File? imageGallery;

  Position? _currentPosition;
  String _locationMessage = '';

  Marker? _userMarker;

  bool isOk = false;
  bool isLoading = false;
  // bool isVirtual = false;

  int typeSelected = 0;
  List types = [
    {
      'index': 0,
      'name': 'Rocoso',
      'image': 'assets/plant1.jpg',
    },
    {
      'index': 1,
      'name': 'Arenoso',
      'image': 'assets/plant2.jpg',
    },
    {
      'index': 2,
      'name': 'Arcilloso',
      'image': 'assets/plant3.jpg',
    },
  ];

  Future<void> _selectDateTime(BuildContext context) async {
    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 21)),
    );
    if (date != null) {
      setState(() {
        selectedDateTime = DateTime(
          date.year,
          date.month,
          date.day,
        );
        dateTime.text = 'fecha: ${date.day}/${date.month}/${date.year}';
      });
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
        icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueGreen), // Ícono personalizado
        infoWindow: const InfoWindow(title: 'Tu ubicación actual'),
      );
    });
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

  Future<void> _moveCameraToPosition(Position position) async {
    final GoogleMapController controller = await _controller.future;
    CameraPosition cameraPosition = CameraPosition(
      target: LatLng(position.latitude, position.longitude),
      zoom: 16.0,
    );
    controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  }

  @override
  void initState() {
    _requestPermissions();
    _getCurrentLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget image = const Icon(Icons.sunny, color: Colors.amberAccent,);

    if (imageGallery != null) {
      image = Image.file(imageGallery!);
    }

    if (title.text.isNotEmpty &&
        description.text.isNotEmpty &&
        selectedDateTime != null &&
        !isLoading) {
      setState(() {
        isOk = true;
      });
    } else {
      setState(() {
        isOk = false;
      });
    }
    return Scaffold(
      // backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('New Crop'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: AbsorbPointer(
        absorbing: isLoading,
        child: SingleChildScrollView(
          child: Form(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    SizedBox(
                        height: 300,
                        child: GoogleMap(
                          mapType: MapType.normal,
                          initialCameraPosition: CameraPosition(
                            target: LatLng(_currentPosition?.latitude ?? 0,
                                _currentPosition?.longitude ?? 0),
                            zoom: 16,
                          ),
                          onMapCreated: (GoogleMapController controller) {
                            _controller.complete(controller);
                          },
                          markers: {
                            if (_userMarker != null) _userMarker!,
                          },
                          // select the location of the crop
                          onTap: (LatLng location) {
                            setState(() {
                              markerLocation = location;
                            });
                          },
                        )),
                    const Text('Select the location of the crop',
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.bold)),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: title,
                    keyboardType: TextInputType.text,
                    textCapitalization: TextCapitalization.sentences,
                    maxLength: 35,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a title';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      labelText: 'Title',
                      border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(10.0))),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: description,
                    keyboardType: TextInputType.text,
                    textCapitalization: TextCapitalization.sentences,
                    maxLines: 3,
                    maxLength: 120,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a description';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      labelText: 'Description',
                      border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(10.0))),
                    ),
                  ),
                ),
                const Divider(
                  color: Colors.grey,
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: reference,
                    keyboardType: TextInputType.text,
                    textCapitalization: TextCapitalization.sentences,
                    maxLines: 3,
                    maxLength: 120,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a reference';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      labelText: 'Reference',
                      border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(10.0))),
                    ),
                  ),
                ),
                const Divider(
                  color: Colors.grey,
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: dateTime,
                    keyboardType: TextInputType.text,
                    textCapitalization: TextCapitalization.sentences,
                    maxLines: 1,
                    maxLength: 120,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a date';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      labelText: 'Date',
                      border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(10.0))),
                    ),
                    onTap: () {
                      _selectDateTime(context);
                    },
                  ),
                ),
                const Divider(
                  color: Colors.grey,
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: area,
                    keyboardType: TextInputType.number,
                    textCapitalization: TextCapitalization.sentences,
                    maxLines: 1,
                    maxLength: 120,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a area of the crop in m2';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      labelText: 'Area (m2)',
                      border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(10.0))),
                    ),
                  ),
                ),
                Column(
                  children: [
                    const Text('Select type of soil',
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: types.map((map) {
                        bool isSelected = typeSelected == map['index'];
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              if (!isSelected) {
                                typeSelected = map['index'];
                              }
                            });
                          },
                          child: Column(
                            children: [
                              Text(map['name']),
                              Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color:
                                        isSelected ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.onPrimary,
                                    width: isSelected ? 3 : 5,
                                  ),
                                ),
                                child:
                                    Image.asset(map['image'], fit: BoxFit.fill),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                    SizedBox(
                      height: 50,
                      width: 50,
                      child: image,
                    ),
                    ElevatedButton(
                        onPressed: () async {
                          final image = await ImagePicker().pickImage(
                            source: ImageSource.gallery,
                          );
                          if (image != null) {
                            setState(() {
                              imageGallery = File(image.path);
                            });
                          }
                        },
                        child: const Text("Add a image of the crop",
                            style: TextStyle(
                                fontSize: 17, fontWeight: FontWeight.bold)))
                  ],
                ),
                const Divider(
                  color: Colors.grey,
                  height: 30,
                ),
                isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : const SizedBox(height: 10),
                GlassBox(
                  onTap: isLoading
                      ? null
                      : () async {
                          if (isOk) {
                            setState(() {
                              isLoading = true;
                            });


                            await addCrop(
                              title.text,
                              description.text,
                              reference.text,
                              types[typeSelected]['name'],
                              imageGallery,
                              _currentPosition?.latitude,
                              _currentPosition?.longitude,
                              selectedDateTime ?? DateTime.now(),
                              area.text.isEmpty ? 0 : double.parse(area.text) / 10000,
                            ).then((value) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => NavigationScreen(),
                                ),
                              );
                            });
                          } else {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) =>
                                  CupertinoAlertDialog(
                                title:
                                    const Text('Falta rellenar algunos campos'),
                                actions: <Widget>[
                                  TextButton(
                                    child: const Text('ok'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  )
                                ],
                              ),
                            );
                          }
                        },
                  color: isOk ? Theme.of(context).colorScheme.primary : Colors.grey,
                  child: Text('Guardar',
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: isOk ? Colors.white : Colors.grey)),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
