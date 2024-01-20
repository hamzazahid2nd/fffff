import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:augmntx/constants/constants.dart';

class Auth extends ChangeNotifier {
  String? _userId;

  bool get isAuth {
    return _userId != null;
  }

  Future<void> loginWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final endpointUrl = Uri.parse('${ConstantValues.apiLink}login');
      final response = await http.post(
        endpointUrl,
        body: {
          'email': email,
          'password': password,
        },
      );
      final info = json.decode(response.body);
      if (info['message'] == 'Login successful') {
        final prefs = await SharedPreferences.getInstance();
        final userData = json.encode({
          'id': info['user']['id'],
          'unique_id': info['user']['unique_id'],
          'name': info['user']['name'],
          'email': info['user']['email'],
          'job_title': info['user']['job_title'],
          'company': info['user']['company'],
          'phone': info['user']['phone'],
        });
        prefs.setString('userData', userData);
        notifyListeners();
      } else {
        throw Exception('Login Failed!');
      }
    } catch (err) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> registerAccount({
    required String firstName,
    required String jobTitle,
    required String companyName,
    required String workEmail,
    required String phone,
  }) async {
    try {
      // https://repo.ashwinsrivastava.com/
      final endpointUrl = Uri.parse('${ConstantValues.apiLink}register');
      final response = await http.post(
        endpointUrl,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'first_name': firstName,
          'job_title': jobTitle,
          'org_name': companyName,
          'email': workEmail,
          'tel': phone,
          'otp_verified': '1',
        }),
      );

      final responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        final email = responseData['email'];
        final password = responseData['password'];
        final otp = responseData['otp'];
        return {'email': email, 'password': password, 'otp': otp};
      } else {
        // Handle registration failure or validation errors
        throw Exception('Failed to register: ${responseData['message']}');
      }
    } catch (error) {
      // Handle other errors, such as network issues
      throw Exception('Failed to register: $error');
    }
  }

  Future<Map<String, dynamic>> otpVerification({
    required String firstName,
    required String jobTitle,
    required String companyName,
    required String workEmail,
    required String phone,
  }) async {
    try {
      final endpointUrl = Uri.parse('${ConstantValues.apiLink}register');
      final response = await http.post(
        endpointUrl,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'first_name': firstName,
          'job_title': jobTitle,
          'org_name': companyName,
          'email': workEmail,
          'tel': phone,
          'otp_verified': '0',
        }),
      );

      final responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        final otp = responseData['otp'];
        return {'otp': otp};
      } else {
        throw Exception('Failed to register: ${responseData['message']}');
      }
    } catch (error) {
      throw Exception('Failed to register: $error');
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      final googleSignIn = GoogleSignIn();
      final gUser = await googleSignIn.signIn();

      if (gUser == null) {
        return;
      }

      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        'id': gUser.id,
        'name': gUser.displayName,
        'email': gUser.email,
      });
      prefs.setString('userData', userData);
      notifyListeners();
    } catch (_) {
      rethrow;
    }
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }
    final userData =
        json.decode(prefs.getString('userData')!) as Map<String, dynamic>;
    _userId = userData['id'];
    notifyListeners();
    return true;
  }

  void logout() async {
    await GoogleSignIn().signOut();
    _userId = null;
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
    notifyListeners();
  }
}
