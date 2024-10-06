import 'dart:convert'; // Para codificar y decodificar JSON
import 'dart:developer';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl;

  ApiService(this.baseUrl);

  // Método para realizar una solicitud POST
  Future<Map<String, dynamic>> postData(String route, Map<String, dynamic> data) async {
    final url = Uri.parse('$baseUrl/predict/$route');

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
  Future<Map<String, dynamic>> getData(String route) async {
    final url = Uri.parse('$baseUrl?$route');

    log('URL: $url');

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
