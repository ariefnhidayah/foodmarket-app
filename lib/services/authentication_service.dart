import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:foodmarket/commons/constant.dart';
import 'package:foodmarket/models/response_model.dart';
import 'package:foodmarket/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:slugify/slugify.dart';

abstract class AuthenticationService {
  Future<ResponseModel<UserModel>> getUser();
  Future<ResponseModel<bool>> isLoggedIn();
  Future<ResponseModel<bool>> logout();
  Future<ResponseModel<bool>> login(String email, String password);
  Future<ResponseModel<bool>> register({
    String fullName = '',
    String email = '',
    String password = '',
    String phoneNumber = '',
    String address = '',
    String houseNumber = '',
    String city = '',
    File? avatar,
  });
  Future<ResponseModel<bool>> checkEmail(String email);
}

class AuthenticationServiceImpl implements AuthenticationService {
  final SharedPreferences preferences;
  final Dio dio;

  AuthenticationServiceImpl({
    required this.preferences,
    required this.dio,
  });

  @override
  Future<ResponseModel<UserModel>> getUser() async {
    try {
      String user = preferences.getString(PREFERENCE_USER) ?? "";
      UserModel userModel = UserModel.fromJson(json.decode(user));
      return ResponseModel<UserModel>(success: true, data: userModel);
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
  Future<ResponseModel<bool>> isLoggedIn() async {
    try {
      String user = preferences.getString(PREFERENCE_USER) ?? "";
      if (user.isNotEmpty) {
        return const ResponseModel(success: true, data: true);
      } else {
        return const ResponseModel(success: false, data: false);
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
  Future<ResponseModel<bool>> logout() async {
    try {
      await preferences.remove(TOKEN_TYPE);
      await preferences.remove(TOKEN_USER);
      bool isRemoved = await preferences.remove(PREFERENCE_USER);
      return ResponseModel<bool>(
          success: isRemoved, data: isRemoved, message: EXEPTION_ERROR);
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
  Future<ResponseModel<bool>> login(String email, String password) async {
    try {
      var response = await dio.post(API_URL + 'users/login', data: {
        "email": email,
        "password": password,
      }).timeout(durationTimeout, onTimeout: onTimeout);
      if (response.statusCode == 200) {
        String token = response.data['data']['access_token'];
        String tokenType = response.data['data']['token_type'];
        UserModel user = UserModel.fromJson(response.data['data']['data']);
        await preferences.setString(PREFERENCE_USER, user.toString());
        await preferences.setString(TOKEN_USER, token);
        await preferences.setString(TOKEN_TYPE, tokenType);
        return const ResponseModel(success: true, data: true);
      } else {
        return ResponseModel(
            success: false,
            message: response.data['message'] ?? FAILED_TO_NETWORK);
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
  Future<ResponseModel<bool>> register({
    String fullName = '',
    String email = '',
    String password = '',
    String phoneNumber = '',
    String address = '',
    String houseNumber = '',
    String city = '',
    File? avatar,
  }) async {
    String fileName =
        "${slugify(fullName)}-${DateTime.now().millisecondsSinceEpoch}.jpg";
    FormData formData = FormData.fromMap({
      "name": fullName,
      "email": email,
      "password": password,
      "phone_number": phoneNumber,
      "address": address,
      "house_number": houseNumber,
      "city": city,
      "image": avatar != null
          ? await MultipartFile.fromFile(avatar.path, filename: fileName)
          : null,
    });

    try {
      var response = await dio
          .post(API_URL + "users/register", data: formData)
          .timeout(durationTimeout, onTimeout: onTimeout);

      if (response.statusCode == 200) {
        String token = response.data['data']['access_token'];
        String tokenType = response.data['data']['token_type'];
        UserModel user = UserModel.fromJson(response.data['data']['data']);
        await preferences.setString(PREFERENCE_USER, user.toString());
        await preferences.setString(TOKEN_USER, token);
        await preferences.setString(TOKEN_TYPE, tokenType);
        return const ResponseModel(success: true, data: true);
      } else {
        return ResponseModel(
            success: false,
            message: response.data['message'] ?? FAILED_TO_NETWORK);
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
  Future<ResponseModel<bool>> checkEmail(String email) async {
    try {
      var response = await dio.post(API_URL + "users/check-email", data: {
        "email": email
      }).timeout(durationTimeout, onTimeout: onTimeout);
      if (response.statusCode == 200) {
        return ResponseModel(success: true, statusCode: response.statusCode!);
      } else {
        return const ResponseModel(success: false, message: FAILED_TO_NETWORK);
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
