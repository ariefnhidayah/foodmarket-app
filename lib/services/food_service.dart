import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:foodmarket/commons/constant.dart';
import 'package:foodmarket/models/food_model.dart';
import 'package:foodmarket/models/response_model.dart';

abstract class FoodService {
  Future<ResponseModel<List<FoodModel>>> getByRating();
  Future<ResponseModel<List<FoodModel>>> getByType(String type);
}

class FoodServiceImpl implements FoodService {
  final Dio dio;

  FoodServiceImpl({required this.dio});

  @override
  Future<ResponseModel<List<FoodModel>>> getByRating() async {
    try {
      var response = await dio.get(API_URL + "foods", queryParameters: {
        "order_by": "rate",
        "is_order_asc": "0",
        "limit": "4",
      }).timeout(durationTimeout, onTimeout: onTimeout);

      if (response.statusCode == 200) {
        List<FoodModel> foods = [];
        for (Map<String, dynamic> item in response.data['data']['rows']) {
          foods.add(FoodModel.fromJson(item));
        }

        return ResponseModel(success: true, data: foods);
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
  Future<ResponseModel<List<FoodModel>>> getByType(String type) async {
    try {
      var response = await dio.get(API_URL + "foods", queryParameters: {
        "order_by": "rate",
        "is_order_asc": "0",
        "types": type,
        "limit": "50",
      }).timeout(durationTimeout, onTimeout: onTimeout);

      if (response.statusCode == 200) {
        List<FoodModel> foods = [];
        for (Map<String, dynamic> item in response.data['data']['rows']) {
          foods.add(FoodModel.fromJson(item));
        }

        return ResponseModel(success: true, data: foods);
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
    throw UnimplementedError();
  }
}
