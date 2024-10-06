import 'package:agro_xplore/screens/AddCrops/provider/cloud_firestore.dart';
import 'package:agro_xplore/screens/CropDescription/crop_description.dart';
import 'package:agro_xplore/screens/profile/view/profile_body.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  final Function onTapSeeAll;
  const HomeScreen({super.key, required this.onTapSeeAll});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
      final crops =
          await getUserCrops(); // Llama al método para obtener los crops
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: MediaQuery.of(context)
                  .padding
                  .top, // + AppBar().preferredSize.height
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Good morning!',
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                    Text(
                      '0 tasks today',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ProfileBody()));
                  },
                  child: const CircleAvatar(
                    backgroundImage: AssetImage('assets/profile.jpg'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const InfoCard(),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'My crops',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                GestureDetector(
                  onTap: () => widget.onTapSeeAll(),
                  child: Text(
                    'See all',
                    style:
                        TextStyle(color: Theme.of(context).colorScheme.primary),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _error != null
                    ? Text(_error!)
                    : _crops.isEmpty
                        ? const Text('No crops found')
                        : MyGardenSection(crops: _crops),
            const SizedBox(height: 24),
            const Text(
              'Irrigation schedule',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const CalendarCard(),
          ],
        ),
      ),
    );
  }
}

class InfoCard extends StatelessWidget {
  const InfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green[100],
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Row(
        children: [
          Icon(Icons.info, color: Colors.green),
          SizedBox(width: 16),
          Expanded(
            child: Text(
              'Your dedication and effort are the seed of a prosperous future. Every day in the field is an opportunity to cultivate not only the land, but also your dreams.',
              style: TextStyle(fontSize: 16, color: Colors.green),
            ),
          ),
        ],
      ),
    );
  }
}

class MyGardenSection extends StatelessWidget {
  final List<Map<String, dynamic>> crops;
  MyGardenSection({super.key, required this.crops});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: crops.length,
        itemBuilder: (context, index) {
          final crop = crops[index];
          return GardenPlantCard(
            id: crop['id'] ?? '0',
            title: crop['title'] ?? 'Unknown',
            imageUrl: crop['imageURL'] ??
                'assets/placeholder.jpg', // Imagen por defecto si no hay URL
          );
        },
      ),
    );
  }
}

class GardenPlantCard extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;

  const GardenPlantCard(
      {super.key,
      required this.id,
      required this.title,
      required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      margin: const EdgeInsets.only(right: 16),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CropDescriptionScreen(
                        id: id,
                      )));
        },
        child: Column(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(12), // Bordes suaves
                  boxShadow: [
                    BoxShadow(
                      color:
                          Colors.black.withOpacity(0.2), // Color de la sombra
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3), // Posición de la sombra
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius:
                      BorderRadius.circular(8), // Bordes suaves para la imagen
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.cover, // Ajuste de la imagen
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                  fontSize: 14, overflow: TextOverflow.ellipsis),
            ),
          ],
        ),
      ),
    );
  }
}

class CalendarCard extends StatelessWidget {
  const CalendarCard({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        IrrigationScheduleCard(
          name: 'Campo de Chupaca',
          imageUrl: "https://firebasestorage.googleapis.com/v0/b/agroxplore-20288.appspot.com/o/crops%2Fv8vEFRQSL1pu5glvEPYY?alt=media&token=32539a3b-1849-422e-baa7-cd218e97a881"
          ,description: "Cerca al convento de concepción ",
          showingDate: "8 Oct, 2024",
        ),
        SizedBox(height: 16),
        IrrigationScheduleCard(
          name: "Siembra de pasos"
          ,
          imageUrl: "https://firebasestorage.googleapis.com/v0/b/agroxplore-20288.appspot.com/o/crops%2FLjTtPyAOLEOMbPZ6Um8T?alt=media&token=d4e872d8-d4bc-4d3a-9727-f9f0964414fa"
          ,description: "Cerca al convento de concepción ",
          showingDate: "25 Oct, 2024",
        ),
      ],
    );
  }
}

class IrrigationScheduleCard extends StatelessWidget {
  final String name;
  final String imageUrl;
  final String description;
  final String showingDate;

  const IrrigationScheduleCard(
      {super.key, required this.name, required this.imageUrl, required this.description, required this.showingDate});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onPrimary,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2), // Color de la sombra
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3), // Posición de la sombra
          ),
        ],
      ),
      margin: const EdgeInsets.only(right: 16),
      child: Row(
        children: [
          Expanded(
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover, // Ajuste de la imagen
            ),
          ),
          const SizedBox(width: 8),
           Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              Text(description, style: TextStyle(fontSize: 16)),
              SizedBox(height: 8),
              Text(showingDate,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }
}
