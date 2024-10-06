import 'package:agro_xplore/services/service.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class TemperaturePrediction extends StatefulWidget {
  const TemperaturePrediction({super.key});

  @override
  State<TemperaturePrediction> createState() => _TemperaturePredictionState();
}

class _TemperaturePredictionState extends State<TemperaturePrediction> {
  // Mock data for temperature predictions
  Map<String, double> temperatureData = {}; // Initialize as an empty map
  LatLng? userLocation;
  bool isLoading = true; // State to track loading

  @override
  void initState() {
    super.initState();
    // Llama a la función que realiza la petición a la API
    getService();
    // Llama a la función que obtiene la ubicación del usuario
    getLocation();
  }

  // Método para obtener la ubicación del usuario
  void getLocation() async {
    // Obtiene la ubicación actual del usuario
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    // Actualiza el estado con la ubicación del usuario
    setState(() {
      userLocation = LatLng(position.latitude, position.longitude);
    });
  }

  void getService() async {
    // Crea una instancia de ApiService
    final apiService = ApiService('https://toucan-free-wholly.ngrok-free.app');

    // Datos que deseas enviar
    Map<String, dynamic> requestData = {
      'lat': userLocation?.latitude,
      'lon': userLocation?.longitude,
      'year': DateTime.now().year,
      // Agrega más pares clave-valor según sea necesario
    };

    try {
      Map<String, dynamic> response = await apiService.postData('ruta', requestData);

      // Extraer solo la parte "data"
      Map<String, double> fetchedTemperatureData = Map<String, double>.from(response['data']);

      // Actualiza el estado con los datos de temperatura
      setState(() {
        temperatureData = fetchedTemperatureData;
        isLoading = false; // Set loading to false after fetching data
      });

      // Imprimir los datos extraídos
      print('Datos de temperatura: $temperatureData');
    } catch (e) {
      print('Error: $e');
      // Handle error case, you can show a message or similar
      setState(() {
        isLoading = false; // Ensure loading is set to false even on error
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Detect orientation
    var isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Temperature Prediction'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isLoading // Show loading indicator if data is being fetched
            ? Center(child: CircularProgressIndicator())
            : Column(
          children: [
            const Text(
              'Temperature Predictions for the Year',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            // Graph displaying temperature data
            Expanded(
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  barTouchData: BarTouchData(enabled: false),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (double value, TitleMeta meta) {
                          const style = TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          );
                          // Rotate the text labels in portrait mode
                          return SideTitleWidget(
                            axisSide: meta.axisSide,
                            space: isPortrait ? 12 : 4, // Adjust spacing
                            child: Transform.rotate(
                              angle: isPortrait ? -0.5 : 0, // Rotate in portrait
                              child: Text(
                                temperatureData.keys.toList()[value.toInt()],
                                style: style,
                              ),
                            ),
                          );
                        },
                        reservedSize: isPortrait ? 50 : 40, // More space for labels
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 28,
                        getTitlesWidget: (value, _) {
                          return Text(
                            '${value.toInt()}°C',
                            style: const TextStyle(fontSize: 12),
                          );
                        },
                      ),
                    ),
                  ),
                  gridData: FlGridData(show: true),
                  borderData: FlBorderData(show: false),
                  barGroups: temperatureData.entries
                      .toList()
                      .asMap()
                      .map((index, entry) => MapEntry(
                      index,
                      BarChartGroupData(x: index, barRods: [
                        BarChartRodData(
                          toY: entry.value,
                          width: isPortrait ? 12 : 22, // Adjust bar width for portrait
                          color: entry.value < 0
                              ? Colors.blue
                              : Colors.orange,
                          borderRadius: BorderRadius.circular(4),
                        )
                      ])))
                      .values
                      .toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
