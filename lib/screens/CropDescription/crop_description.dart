import 'package:flutter/material.dart';

class CropDescriptionScreen extends StatefulWidget {
  const CropDescriptionScreen({super.key});

  @override
  State<CropDescriptionScreen> createState() => _CropDescriptionScreenState();
}

class _CropDescriptionScreenState extends State<CropDescriptionScreen> {
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
              'Monstera Deliciosa',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Swiss Cheese Plant',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            _buildCareInfo('Watering', 'Once a week'),
            _buildCareInfo('Fertilizing', 'Every 6 months'),
            _buildCareInfo('Indoors', 'Medium light'),
            _buildCareInfo('Difficulty level', 'Medium'),
            SizedBox(height: 20),
            Text(
              'More',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Monstera deliciosas, commonly called split-leaf philodendron, is native to Central America. It is a climbing, evergreen perennial vine that is perhaps most noted for its large perforated leaves on thick plant stems and its long cord-like aerial roots. ',
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(height: 10),
            TextButton(
              onPressed: () {
                // Action for "Read more"
              },
              child: Text('Read more'),
            ),
            Spacer(),
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
      bottomNavigationBar: SizedBox(
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
