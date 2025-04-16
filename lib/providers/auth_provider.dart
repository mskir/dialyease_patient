import 'dart:convert';
import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/patient.dart';
import '../services/auth_service.dart';
import '../api/auth_api.dart';

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
      developer.log("Attempting login with email: $email");

      final response = await AuthApi.loginPatient({
        'email': email,
        'password': password,
      });

      developer.log("Login response: ${response.statusCode} ${response.body}");

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
      developer.log("Login error", error: e);
      rethrow;
    }
  }

  Future<void> register(Map<String, dynamic> data) async {
    try {
      final registrationData = {
        for (var entry in data.entries)
          if (entry.key != 'confirmPassword') entry.key: entry.value,
      };

      developer.log("Registering patient: ${json.encode(registrationData)}");

      final response = await AuthApi.registerPatient(registrationData);

      developer.log("Register response: ${response.statusCode} ${response.body}");

      if (response.statusCode == 201) {
        final responseData = json.decode(response.body);

        if (responseData['patient'] == null || responseData['token'] == null) {
          throw 'Invalid server response format';
        }

        _patient = Patient.fromJson(responseData['patient']);
        _token = responseData['token'];

        await AuthService.saveAuthData(_token!, _patient!);
        notifyListeners();
      } else {
        final errorMessage = _handleErrorResponse(response);
        throw errorMessage;
      }
    } catch (e) {
      developer.log("Registration error", error: e);
      rethrow;
    }
  }

  String _handleErrorResponse(http.Response response) {
    try {
      final errorData = json.decode(response.body);
      return errorData['message'] ?? 'Error (${response.statusCode})';
    } catch (_) {
      return 'Unexpected response format (${response.statusCode})';
    }
  }

  Future<void> logout() async {
    await AuthService.clearAuthData();
    _token = null;
    _patient = null;
    notifyListeners();
  }
}
