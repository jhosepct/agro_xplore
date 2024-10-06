import 'package:agro_xplore/screens/Predictions/Screens/precipitation_average_prediction.dart';
import 'package:agro_xplore/screens/Predictions/Screens/specific_humidity_prediction.dart';
import 'package:agro_xplore/screens/Predictions/Screens/temperature_prediction.dart';
import 'package:agro_xplore/screens/Predictions/Screens/wind_speed_prediction.dart';
import 'package:flutter/material.dart';

class PredictionsScreen extends StatefulWidget {
  const PredictionsScreen({super.key});

  @override
  State<PredictionsScreen> createState() => _PredictionsScreenState();
}

class _PredictionsScreenState extends State<PredictionsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Predictions'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: <Widget>[
            _buildPredictionCard(
              context,
              'Precipitation',
              Icons.cloud,
              const PrecipitationAverage(),
            ),
            _buildPredictionCard(
              context,
              'Humidity',
              Icons.water_drop,
              const SpecificHumidity(),
            ),
            _buildPredictionCard(
              context,
              'Temperature Max',
              Icons.thermostat,
              const TemperaturePrediction(type: "Max"),
            ),
            _buildPredictionCard(
              context,
              'Temperature Min',
              Icons.thermostat_outlined,
              const TemperaturePrediction(type: "Min"),
            ),
            _buildPredictionCard(
              context,
              'Wind Speed',
              Icons.air,
              const WindSpeedPrediction(),
            ),
          ],
        ),
      ),
    );
  }

  // Método para construir la tarjeta de predicción
  Widget _buildPredictionCard(
      BuildContext context, String title, IconData icon, Widget screen) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      elevation: 4,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.secondary,
          child: Icon(icon, color: Colors.white),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => screen),
          );
        },
      ),
    );
  }
}
