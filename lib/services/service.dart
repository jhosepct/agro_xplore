import 'dart:convert'; // Para codificar y decodificar JSON
import 'dart:developer';
import 'package:agro_xplore/screens/AddCrops/provider/cloud_firestore.dart';
import 'package:http/http.dart' as http;

class ApiService {

  ApiService();

  // Método para realizar una solicitud POST
  static Future<Map<String, dynamic>> postData(String route, Map<String, dynamic> data) async {
    Map<String, String> endpoints = await getEndpoints();
    String? postURI = endpoints['post'];
    final url = Uri.parse('$postURI/predict/$route');

    log('URL: $url');
    log('Data: $data');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json', // Asegúrate de establecer el tipo de contenido
        },
        body: json.encode(data), // Convierte el mapa de datos a JSON
      );

      if (response.statusCode == 200) {
        // Si la respuesta es exitosa, devuelve el cuerpo de la respuesta como un mapa
        return json.decode(response.body);
      } else {
        // Maneja el error aquí
        throw Exception('Error al realizar la solicitud: ${response.statusCode}');
      }
    } catch (e) {
      // Maneja cualquier excepción aquí
      throw Exception('Error al conectarse a la API: $e');
    }
  }

  // Método para realizar una solicitud GET
  static Future<Map<String, dynamic>> getData(String route) async {
    Map<String, String> endpoints = await getEndpoints();
    String? getURI = endpoints['get'];
    final url = Uri.parse('$getURI?$route');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        // Si la respuesta es exitosa, devuelve el cuerpo de la respuesta como un mapa
        return json.decode(response.body);
      } else {
        // Maneja el error aquí
        throw Exception('Error al realizar la solicitud: ${response.statusCode}');
      }
    } catch (e) {
      // Maneja cualquier excepción aquí
      throw Exception('Error al conectarse a la API: $e');
    }
  }
}
