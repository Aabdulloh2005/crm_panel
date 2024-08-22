import 'dart:io';
import 'package:dio/dio.dart';
import 'package:lesson_101/core/dio_client.dart';
import '../models/user_model.dart';

class UserService {
  final DioClient _dioClient =
      DioClient(baseUrl: "http://millima.flutterwithakmaljon.uz/api/");

  Future<UserModel> getUser() async {
    try {
      final response = await _dioClient.dio.get("user");
      Map<String, dynamic> data = response.data;

      final user = UserModel.fromJson(data['data']);

      return user;
    } on DioException catch (e) {
      throw e.toString();
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> updateUser(
      String email, String name, String phone, String photoUrl) async {
    try {
      FormData formData = FormData.fromMap({
        "name": name,
        "phone": phone,
        "email": email,
        // Only add the photo if a valid path is provided
        if (photoUrl.isNotEmpty)
          "photo": await MultipartFile.fromFile(photoUrl,
              filename: photoUrl.split('/').last),
      });

      final response = await _dioClient.dio.post(
        "profile/update",
        data: formData,
      );

      print(response.data);
    } on DioException catch (e) {
      print(e.message);
      throw e.toString();
    } catch (e) {
      throw e.toString();
    }
  }
}
