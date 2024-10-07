import 'package:agro_xplore/services/service.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class WindSpeedPrediction extends StatefulWidget {
  const WindSpeedPrediction({super.key});

  @override
  State<WindSpeedPrediction> createState() => _WindSpeedPredictionState();
}

class _WindSpeedPredictionState extends State<WindSpeedPrediction> {
  Map<String, double> windSpeedData = {}; // Inicializa como un mapa vacío
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
      Map<String, dynamic> response =
          await ApiService.postData('windSpeed', requestData);

      Map<String, double> fetchedWindSpeedData =
          Map<String, double>.from(response['data']);

      setState(() {
        windSpeedData = fetchedWindSpeedData;
        isLoading =
            false; // Establece la carga en falso después de obtener los datos
      });

      print('Datos de velocidad del viento: $windSpeedData');
    } catch (e) {
      print('Error: $e');
      setState(() {
        isLoading =
            false; // Asegúrate de que la carga se establezca en falso incluso en caso de error
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Wind Speed Prediction'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : windSpeedData.isEmpty
                ? Center(child: Text('No data found'))
                : Column(
                    children: [
                      const Text(
                        'Wind Speed',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 20),
                      // Gráfico que muestra los datos de velocidad del viento como LineChart
                      Expanded(
                        child: LineChart(
                          LineChartData(
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
                                      axisSide: meta.axisSide,
                                      space: isPortrait ? 12 : 4,
                                      child: Transform.rotate(
                                        angle: isPortrait ? -0.5 : 0,
                                        child: Text(
                                          windSpeedData.keys
                                              .toList()[value.toInt()],
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
                                  reservedSize: 28,
                                  getTitlesWidget: (value, _) {
                                    // Solo mostrar algunos valores en el eje y para evitar repeticiones
                                    if (value % 5 == 0) {
                                      return Text(
                                        '${value.toInt()} km/h',
                                        style: const TextStyle(fontSize: 12),
                                      );
                                    }
                                    return const Text('');
                                  },
                                ),
                              ),
                            ),
                            gridData: FlGridData(show: true),
                            borderData: FlBorderData(show: true),
                            lineBarsData: [
                              LineChartBarData(
                                spots: windSpeedData.entries
                                    .map((entry) => FlSpot(
                                          windSpeedData.keys
                                              .toList()
                                              .indexOf(entry.key)
                                              .toDouble(),
                                          entry.value,
                                        ))
                                    .toList(),
                                isCurved: true,
                                color: Colors.blue,
                                // Cambia el color según lo que necesites
                                barWidth: 4,
                                isStrokeCapRound: true,
                                dotData: FlDotData(show: false),
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
