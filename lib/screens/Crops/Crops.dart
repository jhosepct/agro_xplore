import 'package:agro_xplore/screens/CropDescription/crop_description.dart';
import 'package:agro_xplore/screens/Navigation/navigation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CropsScreen extends StatefulWidget {
  const CropsScreen({super.key});

  @override
  State<CropsScreen> createState() => _CropsSplashState();
}

class _CropsSplashState extends State<CropsScreen> {
  CollectionReference userCollection = FirebaseFirestore.instance.collection('users');

  Future<List> getCrops() async {
    List projectsInside = [];
    final projectSnapshot = await userCollection.doc(me.id).collection('myCrops').get();
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
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData && snapshot.data.isNotEmpty) {
            List projects = snapshot.data;
            return Padding(
              padding: const EdgeInsets.all(4.0),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.75, // Ajustado para una forma más rectangular
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: projects.length,
                itemBuilder: (context, index) {
                  return CropCard(
                    id: projects[index]['id'],
                    name: projects[index]['title'],
                    imageUrl: projects[index]['imageURL'],
                    location: projects[index]['referenceLocation'],
                    plantingDate: projects[index]['showingDate'].toDate().toString(),
                  );
                },
              ),
            );
          } else {
            return const Center(child: Text('Empieza a añadir proyectos'));
          }
        },
      ),
    );
  }
}

class CropCard extends StatelessWidget {
  final String id;
  final String name;
  final String? imageUrl;
  final String location;
  final String plantingDate;

  const CropCard({
    super.key,
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.location,
    required this.plantingDate,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CropDescriptionScreen(id: id),
          ),
        );
      },
      child: Card(
        elevation: 4, // Sombra
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15), // Bordes redondeados
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
              child: Container(
                height: 140, // Altura fija para la imagen
                width: double.infinity, // Asegura que ocupe todo el ancho
                child: imageUrl == null
                    ? Image.asset(
                  'assets/plant1.jpg',
                  fit: BoxFit.cover,
                )
                    : Image.network(
                  imageUrl!,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Text(
                name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Text(
                location,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Text(
                'Sembrado el: $plantingDate',
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
