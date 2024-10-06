import 'package:agro_xplore/screens/CropDescription/crop_description.dart';
import 'package:agro_xplore/screens/profile/view/profile_body.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  final Function onTapSeeAll;
  const HomeScreen({super.key, required this.onTapSeeAll});

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
                  onTap: () => onTapSeeAll(),
                  child: Text(
                    'See all',
                    style:
                        TextStyle(color: Theme.of(context).colorScheme.primary),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const MyGardenSection(),
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
  const MyGardenSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: const [
          GardenPlantCard(
              name: 'Campo de Chupaca', imageUrl: 'assets/plant1.jpg'),
          GardenPlantCard(name: 'Terreno 2', imageUrl: 'assets/plant2.jpg'),
          GardenPlantCard(name: 'Chacra 1', imageUrl: 'assets/plant3.jpg'),
          GardenPlantCard(name: 'Chacra 2', imageUrl: 'assets/plant1.jpg'),
          GardenPlantCard(name: 'Chacra 3', imageUrl: 'assets/plant2.jpg'),
          GardenPlantCard(name: 'Chacra 4', imageUrl: 'assets/plant3.jpg')
        ],
      ),
    );
  }
}

class GardenPlantCard extends StatelessWidget {
  final String name;
  final String imageUrl;

  const GardenPlantCard(
      {super.key, required this.name, required this.imageUrl});

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
                  builder: (context) => const CropDescriptionScreen()));
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
                  child: Image.asset(
                    imageUrl,
                    fit: BoxFit.cover, // Ajuste de la imagen
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              name,
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
          imageUrl: 'assets/plant1.jpg',
        ),
        SizedBox(height: 16),
        IrrigationScheduleCard(
          name: 'Campo de Chupaca',
          imageUrl: 'assets/plant1.jpg',
        ),
      ],
    );
  }
}

class IrrigationScheduleCard extends StatelessWidget {
  final String name;
  final String imageUrl;

  const IrrigationScheduleCard(
      {super.key, required this.name, required this.imageUrl});

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
            child: Image.asset(
              imageUrl,
              fit: BoxFit.cover, // Ajuste de la imagen
            ),
          ),
          const SizedBox(width: 8),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Campo de Chupaca',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              Text('Next watering on', style: TextStyle(fontSize: 16)),
              SizedBox(height: 8),
              Text('22 Jun, 2021',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text('Fertilize on Sep, 2021',
                  style: TextStyle(fontSize: 16, color: Colors.grey)),
            ],
          ),
        ],
      ),
    );
  }
}
