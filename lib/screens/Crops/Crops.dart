import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../Navigation/navigation.dart';

class CropsScreen extends StatefulWidget {
  const CropsScreen({super.key});

  @override
  State<CropsScreen> createState() => _CropsSplashState();
}

class _CropsSplashState extends State<CropsScreen> {
  CollectionReference projectsCollection =
      FirebaseFirestore.instance.collection('crops');

  CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  Future<List> getCrops() async {
    List projectsInside = [];
    final projectSnapshot =
        await userCollection.doc(me.id).collection('myCrops').get();
    if (projectSnapshot.docs.isNotEmpty) {
      projectsInside = projectSnapshot.docs.map((doc) => doc.data()).toList();
    }
    return projectsInside;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Crops'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: FutureBuilder(
        future: getCrops(),
        builder: ((BuildContext conatext, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData && snapshot.data.isNotEmpty) {
            List projects = snapshot.data;
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                // childAspectRatio: 3 / 2,
                // crossAxisSpacing: 10,
                // mainAxisSpacing: 1,
              ),
              itemCount: projects.length,
              itemBuilder: (context, index) {
                return CropCard(
                  name: projects[index]['title'],
                  imageUrl: projects[index]['imageURL'],
                  location: projects[index]['referenceLocation'],
                  plantingDate:
                      projects[index]['showingDate'].toDate().toString(),
                );
              },
            );
          } else {
            return const Center(child: Text('Empieza a añadir proyectos'));
          }
        }),
      ),
    );
  }
}

class CropCard extends StatelessWidget {
  final String name;
  final String? imageUrl;
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
          crossAxisAlignment:
              CrossAxisAlignment.start, // Alinea el texto a la izquierda
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius:
                    BorderRadius.circular(12), // Bordes suaves para la imagen
                child: imageUrl == null
                    ? Image.asset(
                        'assets/plant1.jpg',
                        fit: BoxFit.cover, // Ajuste de la imagen
                      )
                    : Image.network(
                        imageUrl!,
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
