import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CropDescriptionScreen extends StatefulWidget {
  final String id;
  const CropDescriptionScreen({super.key, required this.id});

  @override
  State<CropDescriptionScreen> createState() => _CropDescriptionScreenState();
}

class _CropDescriptionScreenState extends State<CropDescriptionScreen> {
  CollectionReference cropsCollection =
  FirebaseFirestore.instance.collection('crops');

  Map<String, dynamic> crop = {};

  Future<void> getCrop() async {
    final cropSnapshot = await cropsCollection.doc(widget.id).get();
    if (cropSnapshot.exists) {
      crop = cropSnapshot.data() as Map<String, dynamic>? ?? {};
    }
    setState(() {}); // Actualiza la interfaz después de obtener los datos
  }

  @override
  void initState() {
    super.initState();
    getCrop(); // Llama a la función para obtener los datos del cultivo
  }
  String formattedDate(Timestamp date) {
    DateTime dateTime = date.toDate();
    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        leading: IconButton(
            icon: Icon(
              Icons.chevron_left,
              color: Theme.of(context).colorScheme.primary,
              size: 24,
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: crop.isNotEmpty
            ? SingleChildScrollView(
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    crop['title'] ?? 'Sin título',
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    crop['referenceLocation'] ?? 'Ubicación desconocida',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Imagen del cultivo
                  Image.network(
                    crop['imageURL'] ??
                        'https://via.placeholder.com/150',
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(height: 20),
                  _buildCareInfo('Requires water', '${crop['watering'].toStringAsFixed(2)}L' ?? '80'),
                  _buildCareInfo('Fertilizing', '${crop['fertilizing'] ?? 50}Kg'),
                  _buildCareInfo('Indoor/Outdoor', crop['indoors'] ?? 'Medium light'),
                  const SizedBox(height: 20),
                  const Text(
                    'Description',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text('Sowing date: ${formattedDate(crop['showingDate'])}'),
                  const SizedBox(height: 10),
                  Text(
                    crop['plantingDate'] ?? 'Desconocida',
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: () {
                      // Acción para "Leer más"
                    },
                    child: const Text('Read more'),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          // Acción para "¿Algo mal?"
                        },
                        child: const Text('Something wrong?'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // Acción para "Escanear planta"
                        },
                        child: const Text('Scan plant'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        )
            : const Center(child: CircularProgressIndicator()), // Indicador de carga mientras se obtiene la información
      ),
      bottomNavigationBar: const SizedBox(
        height: 60,
        child: BottomAppBar(
          color: Colors.white,
          child: Center(
            child: Text(
              'Activity | Calendar',
              style: TextStyle(color: Colors.black),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCareInfo(String title, String detail) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16),
          ),
          Text(
            detail,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
          ),
        ],
      ),
    );
  }
}
