import 'package:agro_xplore/screens/AddCrops/provider/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CropsScreen extends StatefulWidget {
  const CropsScreen({super.key});

  @override
  State<CropsScreen> createState() => _CropsSplashState();
}

class _CropsSplashState extends State<CropsScreen> {
  List<Map<String, dynamic>> _crops = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadCrops();
  }

  Future<void> _loadCrops() async {
    try {
      final crops = await getUserCrops(); // Llama al método para obtener los crops
      setState(() {
        _crops = crops;
        _isLoading = false; // Datos cargados correctamente
      });
    } catch (e) {
      setState(() {
        _error = 'Error loading crops: $e'; // Manejo de errores
        _isLoading = false;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Crops'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator()) // Mostrar indicador de carga mientras se obtienen los datos
          : _error != null
          ? Center(child: Text(_error!)) // Mostrar error si ocurrió
          : _crops.isEmpty
          ? const Center(child: Text('No crops available')) // Mostrar mensaje si no hay cultivos
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Dos columnas
            crossAxisSpacing: 16, // Espacio horizontal entre las tarjetas
            mainAxisSpacing: 16, // Espacio vertical entre las tarjetas
          ),
          itemCount: _crops.length,
          itemBuilder: (context, index) {
            final crop = _crops[index];
            return CropCard(
              title: crop['title'] ?? 'No title',
              imageUrl: crop['imageURL'] ?? 'assets/placeholder.jpg',
              location: crop['referenceLocation'] ?? 'Unknown location',
              showingDate: crop['showingDate'] != null
                  ? DateFormat('dd/MM/yyyy').format((crop['showingDate'] as Timestamp).toDate())
                  : 'Unknown date',
            );
          },
        ),
      ),
    );
  }
}

class CropCard extends StatelessWidget {
  final String title;
  final String imageUrl;
  final String location;
  final String showingDate;

  const CropCard({
    super.key,
    required this.title,
    required this.imageUrl,
    required this.location,
    required this.showingDate,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navegación a la pantalla de descripción del cultivo
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CropDescriptionScreen(name: title),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(12), // Bordes suaves
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1), // Color de la sombra
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 2), // Posición de la sombra
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Alinea el texto a la izquierda
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12), // Bordes suaves para la imagen
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover, // Ajuste de la imagen
                ),
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                location,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                'Sembrado el: $showingDate',
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

// Suponiendo que tienes una pantalla de descripción del cultivo
class CropDescriptionScreen extends StatelessWidget {
  final String name;

  const CropDescriptionScreen({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(name),
      ),
      body: Center(
        child: Text('Detalles sobre $name'),
      ),
    );
  }
}