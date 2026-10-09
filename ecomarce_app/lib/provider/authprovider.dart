import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
// =========================================
// DIO
// =========================================

  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://programmingpulse.xyz/api',
      connectTimeout: const Duration(seconds: 20),
      receiveTimeout: const Duration(seconds: 20),
      sendTimeout: const Duration(seconds: 20),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );

// =========================================
// STATE
// =========================================

  bool _isLoading = false;
  bool _isLoggedIn = false;

  String? _userName;
  String? _userEmail;
  String? _userPhone;
  String? _userImage;

// =========================================
// GETTERS
// =========================================

  bool get isLoading => _isLoading;

  bool get isLoggedIn => _isLoggedIn;

  String? get userName => _userName;

  String? get userEmail => _userEmail;

  String? get userPhone => _userPhone;

  String? get userImage => _userImage;

// =========================================
// SIGN UP
// =========================================

  Future<String?> signup({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    _isLoading = true;
    notifyListeners();


    try {
    final response = await _dio.post(
    '/signup.php',
    data: {
    'name': name.trim(),
    'email': email.trim().toLowerCase(),
    'phone': phone.trim(),
    'password': password,
    },
    options: Options(
    validateStatus: (status) {
    return status != null && status < 600;
    },
    ),
    );

    debugPrint('==============================');
    debugPrint('SIGNUP STATUS: ${response.statusCode}');
    debugPrint('SIGNUP RESPONSE: ${response.data}');
    debugPrint('==============================');

    dynamic data = response.data;

    // -----------------------------------------
    // Convert JSON String to Map
    // -----------------------------------------

    if (data is String) {
    try {
    data = jsonDecode(data);
    } catch (e) {
    debugPrint('SIGNUP JSON ERROR: $e');

    return 'Server returned invalid JSON';
    }
    }

    // -----------------------------------------
    // Validate response
    // -----------------------------------------

    if (data is! Map) {
    return 'Invalid server response';
    }

    // -----------------------------------------
    // SUCCESS
    // -----------------------------------------

    if (data['success'] == true) {
    return null;
    }

    // -----------------------------------------
    // ERROR
    // -----------------------------------------

    return data['message']?.toString() ??
    'Registration failed';

    } on DioException catch (e) {
    debugPrint('==============================');
    debugPrint('SIGNUP DIO ERROR');
    debugPrint('MESSAGE: ${e.message}');
    debugPrint('STATUS: ${e.response?.statusCode}');
    debugPrint('RESPONSE: ${e.response?.data}');
    debugPrint('==============================');

    final responseData = e.response?.data;

    if (responseData is Map) {
    return responseData['message']?.toString() ??
    'Server error';
    }

    if (responseData is String &&
    responseData.trim().isNotEmpty) {
    return responseData;
    }

    return 'Could not connect to server';

    } catch (e) {
    debugPrint('SIGNUP ERROR: $e');

    return 'Signup error: $e';

    } finally {
    _isLoading = false;
    notifyListeners();
    }


  }

// =========================================
// LOGIN
// =========================================

  Future<String?> login({
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    notifyListeners();


    try {
    final response = await _dio.post(
    '/login.php',
    data: {
    'email': email.trim().toLowerCase(),
    'password': password,
    },
    options: Options(
    validateStatus: (status) {
    return status != null && status < 600;
    },
    ),
    );

    debugPrint('==============================');
    debugPrint('LOGIN STATUS: ${response.statusCode}');
    debugPrint('LOGIN RESPONSE: ${response.data}');
    debugPrint('==============================');

    dynamic data = response.data;

    // -----------------------------------------
    // Convert JSON String to Map
    // -----------------------------------------

    if (data is String) {
    try {
    data = jsonDecode(data);
    } catch (e) {
    debugPrint('LOGIN JSON ERROR: $e');

    return 'Server returned invalid JSON';
    }
    }

    // -----------------------------------------
    // Validate response
    // -----------------------------------------

    if (data is! Map) {
    return 'Invalid server response';
    }

    // -----------------------------------------
    // LOGIN SUCCESS
    // -----------------------------------------

    if (data['success'] == true) {
    final dynamic userData = data['user'];

    if (userData is! Map) {
    return 'User data missing from server';
    }

    final Map<String, dynamic> user =
    Map<String, dynamic>.from(userData);

    // ---------------------------------------
    // Set current user
    // ---------------------------------------

    _isLoggedIn = true;

    _userName = user['name']?.toString();

    _userEmail = user['email']?.toString();

    _userPhone = user['phone']?.toString();

    _userImage = user['image']?.toString();

    // ---------------------------------------
    // Save user
    // ---------------------------------------

    final prefs =
    await SharedPreferences.getInstance();

    await prefs.setBool(
    'is_logged_in',
    true,
    );

    await prefs.setString(
    'user',
    jsonEncode(user),
    );

    notifyListeners();

    return null;
    }

    // -----------------------------------------
    // LOGIN FAILED
    // -----------------------------------------

    return data['message']?.toString() ??
    'Invalid email or password';

    } on DioException catch (e) {
    debugPrint('==============================');
    debugPrint('LOGIN DIO ERROR');
    debugPrint('MESSAGE: ${e.message}');
    debugPrint('STATUS: ${e.response?.statusCode}');
    debugPrint('RESPONSE: ${e.response?.data}');
    debugPrint('==============================');

    final responseData = e.response?.data;

    if (responseData is Map) {
    return responseData['message']?.toString() ??
    'Server error';
    }

    if (responseData is String &&
    responseData.trim().isNotEmpty) {
    return responseData;
    }

    return 'Could not connect to server';

    } catch (e) {
    debugPrint('LOGIN ERROR: $e');

    return 'Login error: $e';

    } finally {
    _isLoading = false;
    notifyListeners();
    }


  }

// =========================================
// LOAD SAVED USER
// =========================================

  Future<void> loadUser() async {
    try {
      final prefs =
      await SharedPreferences.getInstance();


    final bool loggedIn =
    prefs.getBool('is_logged_in') ?? false;

    final String? userString =
    prefs.getString('user');

    if (!loggedIn || userString == null) {
    return;
    }

    final dynamic decoded =
    jsonDecode(userString);

    if (decoded is! Map) {
    await logout();
    return;
    }

    final Map<String, dynamic> user =
    Map<String, dynamic>.from(decoded);

    _isLoggedIn = true;

    _userName = user['name']?.toString();

    _userEmail = user['email']?.toString();

    _userPhone = user['phone']?.toString();

    _userImage = user['image']?.toString();

    notifyListeners();

    debugPrint('Saved user loaded successfully');

    } catch (e) {
    debugPrint('LOAD USER ERROR: $e');

    // Corrupted saved data হলে clear করে দেবে
    final prefs =
    await SharedPreferences.getInstance();

    await prefs.remove('is_logged_in');
    await prefs.remove('user');

    _isLoggedIn = false;

    _userName = null;
    _userEmail = null;
    _userPhone = null;
    _userImage = null;

    notifyListeners();
    }


  }

// =========================================
// LOGOUT
// =========================================

  Future<void> logout() async {
    try {
      final prefs =
      await SharedPreferences.getInstance();


    await prefs.remove('is_logged_in');

    await prefs.remove('user');
    } catch (e) {
    debugPrint('LOGOUT STORAGE ERROR: $e');
    }

    _isLoggedIn = false;

    _userName = null;

    _userEmail = null;

    _userPhone = null;

    _userImage = null;

    notifyListeners();


  }
}
