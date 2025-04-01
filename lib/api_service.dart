import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String _baseUrl = 'http://<your_server_ip>:5000';  // Use the IP or domain of your Node.js server

  // Function to fetch data from the server
  Future<List<dynamic>> fetchData() async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/data'));

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception('Failed to connect to the server');
    }
  }

  // Function to add data to the server
  Future<void> addData(Map<String, String> data) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/data'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(data),
      );

      if (response.statusCode != 201) {
        throw Exception('Failed to save data');
      }
    } catch (e) {
      throw Exception('Failed to connect to the server');
    }
  }
}
