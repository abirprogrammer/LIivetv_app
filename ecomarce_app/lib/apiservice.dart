import 'package:dio/dio.dart';

class ApiService {
  final Dio dio = Dio(
    BaseOptions(
      baseUrl: 'https://your-domain.com/api/',
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
    ),
  );

  Future<Response> login({
    required String email,
    required String password,
  }) async {
    return await dio.post(
      'login.php',
      data: {
        'email': email,
        'password': password,
      },
    );
  }

  Future<Response> signup({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    return await dio.post(
      'signup.php',
      data: {
        'name': name,
        'email': email,
        'phone': phone,
        'password': password,
      },
    );
  }

  Future<Response> getWorkouts() async {
    return await dio.get('workouts.php');
  }

  Future<Response> getFoods() async {
    return await dio.get('foods.php');
  }

  Future<Response> getBanners() async {
    return await dio.get('banners.php');
  }
}