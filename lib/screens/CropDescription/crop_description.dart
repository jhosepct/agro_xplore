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

  Map crop = {};

  Future getCrop() async {
    final cropSnapshot = await cropsCollection.doc(widget.id).get();
    if (cropSnapshot.exists) {
      crop = cropSnapshot.data() as Map<dynamic, dynamic>? ?? {};
    }
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              crop['name'] ?? 'unknown',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              crop['referenceLocation'] ?? 'unknown',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            _buildCareInfo('Watering', crop['watering'] ?? '80'),
            _buildCareInfo('Fertilizing', crop['fertilizing'] ?? '50'),
            _buildCareInfo('Indoors', crop['indoors'] ?? 'Medium light'),
            const SizedBox(height: 20),
            const Text(
              'More',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              crop['description'] ?? 'No description available.',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () {
                // Action for "Read more"
              },
              child: const Text('Read more'),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Action for "Something wrong?"
                  },
                  child: Text('Something wrong?'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Action for "Scan plant"
                  },
                  child: Text('Scan plant'),
                ),
              ],
            ),
          ],
        ),
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
            style: TextStyle(fontSize: 16),
          ),
          Text(
            detail,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
          ),
        ],
      ),
    );
  }
}
