import 'package:flutter/material.dart';

class CropsScreen extends StatefulWidget {
  const CropsScreen({super.key});

  @override
  State<CropsScreen> createState() => _CropsSplashState();
}

class _CropsSplashState extends State<CropsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Crops'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2, // Dos columnas
          crossAxisSpacing: 16, // Espacio horizontal entre las tarjetas
          mainAxisSpacing: 16, // Espacio vertical entre las tarjetas
          children: const [
            CropCard(
              name: 'Campo de Chupaca',
              imageUrl: 'assets/plant1.jpg',
              location: 'Chupaca, Junín',
              plantingDate: '12/03/2024',
            ),
            CropCard(
              name: 'Terreno 2',
              imageUrl: 'assets/plant2.jpg',
              location: 'Huancayo, Junín',
              plantingDate: '25/06/2024',
            ),
            CropCard(
              name: 'Chacra 1',
              imageUrl: 'assets/plant3.jpg',
              location: 'Concepción, Junín',
              plantingDate: '01/04/2024',
            ),
            CropCard(
              name: 'Chacra 2',
              imageUrl: 'assets/plant1.jpg',
              location: 'Jauja, Junín',
              plantingDate: '08/02/2024',
            ),
            CropCard(
              name: 'Chacra 3',
              imageUrl: 'assets/plant2.jpg',
              location: 'Tarma, Junín',
              plantingDate: '19/05/2024',
            ),
            CropCard(
              name: 'Chacra 4',
              imageUrl: 'assets/plant3.jpg',
              location: 'Satipo, Junín',
              plantingDate: '10/07/2024',
            ),
          ],
        ),
      ),
    );
  }
}

class CropCard extends StatelessWidget {
  final String name;
  final String imageUrl;
  final String location;
  final String plantingDate;

  const CropCard({
    super.key,
    required this.name,
    required this.imageUrl,
    required this.location,
    required this.plantingDate,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navegación a la pantalla de descripción del cultivo
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CropDescriptionScreen(name: name),
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
                child: Image.asset(
                  imageUrl,
                  fit: BoxFit.cover, // Ajuste de la imagen
                ),
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                name,
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
                'Plantado el: $plantingDate',
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