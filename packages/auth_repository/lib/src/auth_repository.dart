import 'dart:convert';
import 'dart:developer';
import 'package:auth_repository/auth_repository.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  String apiKey = 'AIzaSyBUQzviZANpeTc2dtACHPdDlPtVxX1NJF4';
  Dio dio = Dio();
  Future<User> _authenticate(String email, String password) async {
    try {
      final response = await dio.post(
        "http://3.120.192.20:4001/auth/register",
        data: {
          "email": email,
          "password": password,
        },
      );
      log("-----------------------------------------");
      print(response.data);
      if (response.data['sendOtp']) {
        final data = response.data;
        final user = User.fromMap(data['newUser']);
        print('++++++++++++++++');
        print(user);
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

  Future<User> register(String email, String password) async {
    return await _authenticate(email, password);
  }

  Future<User> signIn(String email, String password) async {
    return await _authenticate(email, password);
  }

  Future<void> logout() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.remove('userData');
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
    if (userData == null) {
      return null;
    }

    final user = jsonDecode(userData);

    if (DateTime.now().isBefore(
      DateTime.parse("2024-02-27"),
    )) {
      return User.fromJson(user);
    }

    return null;
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
