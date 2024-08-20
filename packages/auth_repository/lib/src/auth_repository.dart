import 'dart:convert';
import 'dart:developer';
import 'package:auth_repository/auth_repository.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  String apiKey = 'AIzaSyBUQzviZANpeTc2dtACHPdDlPtVxX1NJF4';
  Dio dio = Dio();
  Future<User> _authenticate(
    String query,
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await dio.post(
        "http://millima.flutterwithakmaljon.uz/api/$query",
        data: data,
      );
      if (response.data['success']) {
        final data = response.data;
        final user = User.fromMap(data['data']);
        _saveUserData(user);

        return user;
      }
      throw response.data['error'];
    } on DioException {
      rethrow;
    } catch (e) {
      print("Error:  $e");

      rethrow;
    }
  }

  Future<User> register(String phone, String password, String userName) async {
    return _authenticate(
      'register',
      {
        "name": userName,
        "phone": phone,
        "password": password,
        "password_confirmation": password,
      },
    );
  }

  Future<User> signIn(String phone, String password) async {
    return _authenticate(
      "login",
      {
        "phone": phone,
        "password": password,
      },
    );
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    final token = jsonDecode(prefs.getString('userData')!);
    print(token['token']);
    try {
      final response = await dio.post(
        "http://millima.flutterwithakmaljon.uz/api/logout",
        options: Options(
          headers: {"Authorization": 'Bearer ${token['token']}'},
        ),
      );
      await prefs.remove('userData');
    } on DioException {
      rethrow;
    } catch (e) {
      print("Error:  $e");
      rethrow;
    }
  }

  Future<void> resetPassword(String email) async {
    final response = await dio.post(
      "https://identitytoolkit.googleapis.com/v1/accounts:sendOobCode?key=$apiKey",
      data: {
        "requestType": "PASSWORD_RESET",
        "email": email,
      },
    );
  }

  Future<User?> checkTokenExpiry() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    final userData = sharedPreferences.getString("userData");
    print(userData);
    if (userData == null) {
      return null;
    }

    final user = jsonDecode(userData);

    // if (DateTime.now().isBefore(
    //   DateTime.parse("2024-09-27"),
    // )) {

    return User.fromMap(user);
    // }

    // return null;
  }

  Future<void> _saveUserData(User user) async {
    final sharedPreferences = await SharedPreferences.getInstance();

    sharedPreferences.setString(
      'userData',
      jsonEncode(
        user.toMap(),
      ),
    );
    final data = jsonDecode(sharedPreferences.getString("userData")!);
    print(sharedPreferences.getString('userData'));
  }
}
