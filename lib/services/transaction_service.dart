import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:foodmarket/commons/constant.dart';
import 'package:foodmarket/models/food_model.dart';
import 'package:foodmarket/models/response_model.dart';
import 'package:foodmarket/models/transaction_model.dart';
import 'package:foodmarket/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class TransactionService {
  Future<ResponseModel<TransactionModel>> createOrder(
      FoodModel food, int quantity, double shippingCost);
  Future<ResponseModel<List<TransactionModel>>> getListOrder(String status);
  Future<ResponseModel<bool>> cancelOrder(TransactionModel transaction);
  Future<ResponseModel<bool>> uploadPaymentProof(
      TransactionModel transaction, File image);
}

class TransactionServiceImpl implements TransactionService {
  final SharedPreferences preferences;
  final Dio dio;

  TransactionServiceImpl({required this.preferences, required this.dio});

  @override
  Future<ResponseModel<TransactionModel>> createOrder(
      FoodModel food, int quantity, double shippingCost) async {
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
        var response = await dio.post(API_URL + "transactions", data: {
          "food_id": food.id,
          "quantity": quantity,
          "shipping_cost": shippingCost,
        }).timeout(durationTimeout, onTimeout: onTimeout);

        if (response.statusCode == 200) {
          TransactionModel transaction =
              TransactionModel.fromJson(response.data['data']);
          return ResponseModel(success: true, data: transaction);
        } else {
          var result = response.data;
          return ResponseModel(
            success: false,
            message: result['message'] ?? FAILED_TO_NETWORK,
            statusCode: response.statusCode ?? 500,
          );
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
  Future<ResponseModel<List<TransactionModel>>> getListOrder(
      String status) async {
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
        var response =
            await dio.get(API_URL + "transactions", queryParameters: {
          "limit": "50",
          "status": status,
        }).timeout(durationTimeout, onTimeout: onTimeout);
        if (response.statusCode == 200) {
          List<TransactionModel> transactions =
              (response.data['data']['rows'] as List)
                  .map((json) => TransactionModel.fromJson(json))
                  .toList();
          return ResponseModel(success: true, data: transactions);
        } else {
          var result = response.data;
          return ResponseModel(
            success: false,
            message: result['message'] ?? FAILED_TO_NETWORK,
            statusCode: response.statusCode ?? 500,
          );
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
  Future<ResponseModel<bool>> cancelOrder(TransactionModel transaction) async {
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
            .put(API_URL + "transactions/${transaction.id}/cancel-transaction")
            .timeout(durationTimeout, onTimeout: onTimeout);
        if (response.statusCode == 200) {
          return ResponseModel(
            success: true,
            message: response.data['message'],
            statusCode: 200,
          );
        } else {
          var result = response.data;
          return ResponseModel(
            success: false,
            message: result['message'] ?? FAILED_TO_NETWORK,
            statusCode: response.statusCode ?? 500,
          );
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
  Future<ResponseModel<bool>> uploadPaymentProof(
      TransactionModel transaction, File image) async {
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
            .put(
                API_URL + "transactions/${transaction.id}/upload-payment-proof",
                data: formData)
            .timeout(durationTimeout, onTimeout: onTimeout);
        if (response.statusCode == 200) {
          return ResponseModel(
            success: true,
            message: response.data['message'],
            statusCode: 200,
          );
        } else {
          var result = response.data;
          return ResponseModel(
            success: false,
            message: result['message'] ?? FAILED_TO_NETWORK,
            statusCode: response.statusCode ?? 500,
          );
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
