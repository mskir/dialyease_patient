import 'package:flutter/foundation.dart';
import 'dart:convert';
import '../models/patient.dart';
import '../services/auth_service.dart';
import '../api/auth_api.dart';
import 'package:http/http.dart' as http;

class AuthProvider with ChangeNotifier {
  Patient? _patient;
  String? _token;

  Patient? get patient => _patient;
  String? get token => _token;
  bool get isAuth => _token != null;

  Future<void> autoLogin() async {
    final token = await AuthService.getToken();
    final patient = await AuthService.getPatient();
    
    if (token != null && patient != null) {
      _token = token;
      _patient = patient;
      notifyListeners();
    }
  }

  Future<void> login(String email, String password) async {
  try {
    print("Logging in with email: $email"); 

    final response = await AuthApi.loginPatient({
      'email': email,
      'password': password,
    });

    print("Response status: ${response.statusCode}"); 
    print("Raw response body: ${response.body}"); 

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      _patient = Patient.fromJson(responseData['patient']); 
      _token = responseData['token'];

      await AuthService.saveAuthData(_token!, _patient!);
      notifyListeners();
    } else {
      final errorData = json.decode(response.body);
      throw errorData['message'] ?? 'Login failed';
    }
  } catch (e) {
    print("Login error: $e");
    rethrow;
  }
}


  Future<void> register(Map<String, dynamic> data) async {
  try {
    final registrationData = Map<String, dynamic>.from(data);
    registrationData.remove('confirmPassword');

    print("Sending: ${json.encode(registrationData)}"); 

    final response = await AuthApi.registerPatient(registrationData);
    
    print("Response status: ${response.statusCode}"); 
    print("Raw response body: ${response.body}"); 

    if (response.statusCode == 201) {
      final responseData = json.decode(response.body);
      
      // Validate response format
      if (responseData['patient'] == null || responseData['token'] == null) {
        throw 'Invalid server response format';
      }

      print("Parsed response: $responseData"); 

      _patient = Patient.fromJson(responseData['patient']);
      _token = responseData['token'];

      await AuthService.saveAuthData(_token!, _patient!);
      notifyListeners();
    } else {
      // Handle error responses
      final errorMessage = _handleErrorResponse(response);
      throw errorMessage;
    }
  } catch (e) {
    print("Registration error: $e"); 
    rethrow;
  }
}

// Error handling function
String _handleErrorResponse(http.Response response) {
  try {
    final errorData = json.decode(response.body);
    return errorData['message'] ?? 'Registration failed (${response.statusCode})';
  } catch (_) {
    return 'Server returned an invalid response (${response.statusCode})';
  }
}

  Future<void> logout() async {
    await AuthService.clearAuthData();
    _token = null;
    _patient = null;
    notifyListeners();
  }
}