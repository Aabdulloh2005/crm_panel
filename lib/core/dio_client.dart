import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DioClient {
  final Dio _dio;

  DioClient({required String baseUrl})
      : _dio = Dio(BaseOptions(baseUrl: baseUrl)) {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Await the token retrieval
          final token = await _getToken();
          if (token != null) {
            options.headers["Authorization"] = 'Bearer $token';
          }
          print("Request: ${options.method} ${options.path}");
          return handler.next(options); // Continue
        },
        onResponse: (response, handler) {
          // Do something with response data
          print("Response: ${response.statusCode} ${response.data}");
          return handler.next(response); // Continue
        },
        onError: (DioException e, handler) {
          // Do something with response error
          print("Error: ${e.message}");
          return handler.next(e); // Continue
        },
      ),
    );
  }

  Dio get dio => _dio;

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString('userData');
    if (userData != null && userData.isNotEmpty) {
      final token = jsonDecode(userData)['token'];
      return token;
    }
    return null;
  }
}
