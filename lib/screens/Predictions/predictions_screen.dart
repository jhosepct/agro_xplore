import 'package:agro_xplore/screens/Predictions/Screens/precipitacion_average_prediction.dart';
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            //Button to navigate to the next screen for predictions to temperature
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const PrecipitationAverage()));
              },
              child: const Text('Precipitation'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const TemperaturePrediction(type: "Max",)));
              },
              child: const Text('Temperature Max'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const TemperaturePrediction(type: "Min",)));
              },
              child: const Text('Temperature Min'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const WindSpeedPrediction(),
                  ),
                );
              },
              child: const Text('Wind Speed'),
            ),
          ],
        ),
      ),
    );
  }
}
