import 'dart:developer';

import 'package:agro_xplore/screens/AddCrops/provider/cloud_firestore.dart';
import 'package:agro_xplore/services/service.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PrecipitationAverage extends StatefulWidget {
  const PrecipitationAverage({super.key});

  @override
  State<PrecipitationAverage> createState() => _PrecipitationAverageState();
}

class _PrecipitationAverageState extends State<PrecipitationAverage> {
  Map<String, double> precipitationData = {};
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

    log("Position: $position");
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
          await ApiService.postData('precipitationAverage', requestData);

      Map<String, double> fetchedPrecipitationData =
          Map<String, double>.from(response['data']);

      setState(() {
        precipitationData = fetchedPrecipitationData;
        isLoading =
            false; // Establece la carga en falso después de obtener los datos
      });
    } catch (e) {
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
        title: const Text('Average Precipitation'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : precipitationData.isEmpty
                ? Center(child: Text('No precipitation data found'))
                : Column(
                    children: [
                      const Text(
                        'Average Precipitation (mm)',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 20),
                      // Gráfico que muestra los datos de precipitación
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
                                  reservedSize: 40,
                                  getTitlesWidget: (value, meta) {
                                    const style = TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    );
                                    return SideTitleWidget(
                                      axisSide: meta.axisSide,
                                      child: Text(
                                        precipitationData.keys
                                            .toList()[value.toInt()],
                                        style: style,
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
                                    if (value % 1 == 0) {
                                      return Text(
                                        '${value.toInt()} mm',
                                        style: const TextStyle(fontSize: 12),
                                      );
                                    }
                                    return const Text('');
                                  },
                                ),
                              ),
                            ),
                            gridData: FlGridData(show: true),
                            borderData: FlBorderData(show: false),
                            barGroups: precipitationData.entries
                                .toList()
                                .asMap()
                                .map((index, entry) => MapEntry(
                                    index,
                                    BarChartGroupData(x: index, barRods: [
                                      BarChartRodData(
                                        toY: entry.value,
                                        width: isPortrait ? 12 : 22,
                                        color: entry.value < 1
                                            ? Colors.green
                                            : Colors.blue,
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
