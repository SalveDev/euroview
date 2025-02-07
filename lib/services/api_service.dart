import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  Future<Map<String, dynamic>> postRequest(String endpoint, Map<String, dynamic> body) async {
    try {
      final response = await http.post(
        Uri.parse(endpoint),
        headers: {
          "Content-Type": "application/json",
        },
        body: json.encode(body),
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return {
          "success": true,
          "data": response.body.isNotEmpty ? json.decode(response.body) : null,
        };
      } else {
        return {
          "success": false,
          "error": json.decode(response.body),
        };
      }
    } catch (e) {
      return {
        "success": false,
        "error": "Error en la solicitud: $e",
      };
    }
  }
}