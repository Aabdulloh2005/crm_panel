import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_model.dart';

class UserService {
  final _dio = Dio();

  Future<UserModel> getUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      // await prefs.remove('userData');
      final token = jsonDecode(prefs.getString('userData')!);

      print(token);
      final response = await _dio.get(
        "http://millima.flutterwithakmaljon.uz/api/user",
        options: Options(
          headers: {"Authorization": 'Bearer ${token['token']}'},
        ),
      );
      Map<String, dynamic> data = response.data;

      final user = UserModel.fromJson(data['data']);

      return user;
    } on DioException catch (e) {
      throw e.toString();
    } catch (e) {
      throw e.toString();
    }
  }
}
