import 'package:agro_xplore/services/service.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SpecificHumidity extends StatefulWidget {
  const SpecificHumidity({super.key});

  @override
  State<SpecificHumidity> createState() => _SpecificHumidityState();
}

class _SpecificHumidityState extends State<SpecificHumidity> {
  Map<String, double> humidityData = {};
  LatLng? userLocation;
  bool isLoading = true; // Estado para rastrear la carga

  @override
  void initState() {
    super.initState();
    getLocation();
  }

  // Método para obtener la ubicación del usuario
  void getLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    setState(() {
      userLocation = LatLng(position.latitude, position.longitude);
    });
    getService();
  }

  void getService() async {
    Map<String, dynamic> requestData = {
      'lat': userLocation?.latitude,
      'lon': userLocation?.longitude,
      'year': DateTime.now().year,
    };

    try {
      Map<String, dynamic> response = await ApiService.postData('specificHumidity', requestData);

      Map<String, double> fetchedHumidityData = Map<String, double>.from(response['data']);

      setState(() {
        humidityData = fetchedHumidityData;
        isLoading = false; // Establece la carga en falso después de obtener los datos
      });

      print('Datos de humedad específica: $humidityData');
    } catch (e) {
      print('Error: $e');
      setState(() {
        isLoading = false; // Asegúrate de que la carga se establezca en falso incluso en caso de error
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Specific Humidity'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            :humidityData.isEmpty ? Center(child: Text('No data found')) :  Column(
          children: [
            const Text(
              'Specific Humidity (%)',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            // Gráfico que muestra los datos de humedad específica
            Expanded(
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: true),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) {
                          const style = TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          );
                          return SideTitleWidget(
                            space: isPortrait ? 12 : 4,
                            axisSide: meta.axisSide,
                            child: Transform.rotate(
                              angle: isPortrait ? -0.5 : 0,
                              child: Text(
                                humidityData.keys.toList()[value.toInt()],
                                style: style,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (value, _) {
                          if (value % 1 == 0) {
                            return Text(
                              '${value.toInt()} %',
                              style: const TextStyle(fontSize: 12),
                            );
                          }
                          return const Text('');
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: true),
                  lineBarsData: [
                    LineChartBarData(
                      spots: humidityData.entries
                          .map((entry) => FlSpot(
                          humidityData.keys.toList().indexOf(entry.key).toDouble(),
                          entry.value))
                          .toList(),
                      isCurved: true,
                      //colors: [Colors.blueAccent],
                      dotData: FlDotData(show: true),
                      belowBarData: BarAreaData(show: false),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
