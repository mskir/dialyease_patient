import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/patient.dart';

class AuthService {
  static const _storage = FlutterSecureStorage();
  static const _keyToken = 'auth_token';
  static const _keyPatient = 'patient_data';

  static Future<void> saveAuthData(String token, Patient patient) async {
    await _storage.write(key: _keyToken, value: token);
    await _storage.write(
      key: _keyPatient,
      value: json.encode(patient.toJson()),
    );
  }

  static Future<String?> getToken() async {
    return await _storage.read(key: _keyToken);
  }

  static Future<Patient?> getPatient() async {
    final patientJson = await _storage.read(key: _keyPatient);
    if (patientJson != null) {
      return Patient.fromJson(json.decode(patientJson));
    }
    return null;
  }

  static Future<void> clearAuthData() async {
    await _storage.delete(key: _keyToken);
    await _storage.delete(key: _keyPatient);
  }
}