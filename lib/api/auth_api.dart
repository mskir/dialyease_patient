import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AuthApi {
  static final String? _baseUrl = dotenv.env['API_BASE_URL'];

  static Future<http.Response> registerPatient(Map<String, dynamic> data) async {
    return await http.post(
      Uri.parse('$_baseUrl/api/patients/register'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(data),
    );
  }

  static Future<http.Response> loginPatient(Map<String, dynamic> credentials) async {
    return await http.post(
      Uri.parse('$_baseUrl/api/patients/login'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(credentials),
    );
  }
}