import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:foodmarket/commons/constant.dart';
import 'package:foodmarket/models/response_model.dart';
import 'package:foodmarket/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class UserService {
  Future<ResponseModel<bool>> uploadPhotoProfile(File image);
  Future<ResponseModel<bool>> updateProfile(Map<String, dynamic> data);
}

class UserServiceImpl implements UserService {
  final SharedPreferences preferences;
  final Dio dio;

  UserServiceImpl({
    required this.preferences,
    required this.dio,
  });

  @override
  Future<ResponseModel<bool>> uploadPhotoProfile(File image) async {
    try {
      String tokenType = preferences.getString(TOKEN_TYPE) ?? "";
      String token = preferences.getString(TOKEN_USER) ?? "";
      if (tokenType == '' || token == '') {
        return const ResponseModel(
          success: false,
          message: "Unauthorized!",
          statusCode: 401,
        );
      } else {
        FormData formData = FormData.fromMap(
            {"image": await MultipartFile.fromFile(image.path)});
        dio.options.headers['Authorization'] = '$tokenType $token';
        var response = await dio
            .put(API_URL + 'users/upload-photo', data: formData)
            .timeout(durationTimeout, onTimeout: onTimeout);
        if (response.statusCode == 200) {
          await preferences.remove(TOKEN_TYPE);
          await preferences.remove(TOKEN_USER);
          await preferences.remove(PREFERENCE_USER);
          String token = response.data['data']['access_token'];
          String tokenType = response.data['data']['token_type'];
          UserModel user = UserModel.fromJson(response.data['data']['data']);
          await preferences.setString(PREFERENCE_USER, user.toString());
          await preferences.setString(TOKEN_USER, token);
          await preferences.setString(TOKEN_TYPE, tokenType);
          return ResponseModel(
              success: true, data: true, message: response.data['message']);
        } else {
          return ResponseModel(
              success: false,
              message: response.data['message'] ?? FAILED_TO_NETWORK);
        }
      }
    } on SocketException {
      return const ResponseModel(success: false, message: FAILED_TO_NETWORK);
    } on DioError catch (e) {
      String message = EXEPTION_ERROR;
      int statusCode = 500;
      if (e.response != null) {
        message = e.response!.data['message'];
        statusCode = e.response!.statusCode ?? 500;
      }
      return ResponseModel(
          success: false, message: message, statusCode: statusCode);
    } on TimeoutException catch (e) {
      return ResponseModel(
          success: false, message: e.message ?? FAILED_TO_NETWORK);
    } catch (e) {
      return const ResponseModel(success: false, message: EXEPTION_ERROR);
    }
  }

  @override
  Future<ResponseModel<bool>> updateProfile(Map<String, dynamic> data) async {
    try {
      String tokenType = preferences.getString(TOKEN_TYPE) ?? "";
      String token = preferences.getString(TOKEN_USER) ?? "";
      if (tokenType == '' || token == '') {
        return const ResponseModel(
          success: false,
          message: "Unauthorized!",
          statusCode: 401,
        );
      } else {
        dio.options.headers['Authorization'] = '$tokenType $token';
        var response = await dio
            .put(API_URL + "users", data: data)
            .timeout(durationTimeout, onTimeout: onTimeout);
        if (response.statusCode == 200) {
          await preferences.remove(TOKEN_TYPE);
          await preferences.remove(TOKEN_USER);
          await preferences.remove(PREFERENCE_USER);
          String token = response.data['data']['access_token'];
          String tokenType = response.data['data']['token_type'];
          UserModel user = UserModel.fromJson(response.data['data']['data']);
          await preferences.setString(PREFERENCE_USER, user.toString());
          await preferences.setString(TOKEN_USER, token);
          await preferences.setString(TOKEN_TYPE, tokenType);
          return ResponseModel(
              success: true, data: true, message: response.data['message']);
        } else {
          return ResponseModel(
              success: false,
              message: response.data['message'] ?? FAILED_TO_NETWORK);
        }
      }
    } on SocketException {
      return const ResponseModel(success: false, message: FAILED_TO_NETWORK);
    } on DioError catch (e) {
      String message = EXEPTION_ERROR;
      int statusCode = 500;
      if (e.response != null) {
        message = e.response!.data['message'];
        statusCode = e.response!.statusCode ?? 500;
      }
      return ResponseModel(
          success: false, message: message, statusCode: statusCode);
    } on TimeoutException catch (e) {
      return ResponseModel(
          success: false, message: e.message ?? FAILED_TO_NETWORK);
    } catch (e) {
      return const ResponseModel(success: false, message: EXEPTION_ERROR);
    }
  }
}
