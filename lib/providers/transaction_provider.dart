import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:foodmarket/commons/state.dart';
import 'package:foodmarket/models/food_model.dart';
import 'package:foodmarket/models/response_model.dart';
import 'package:foodmarket/models/transaction_model.dart';
import 'package:foodmarket/services/transaction_service.dart';

class TransactionProvider extends ChangeNotifier {
  final TransactionService transactionService;

  TransactionProvider({required this.transactionService});

  Future<ResponseModel<TransactionModel>> exec(
      FoodModel food, int quantity, double shippingCost) async {
    return await transactionService.createOrder(food, quantity, shippingCost);
  }

  PageState orderPageState = PageState.Loading;
  String errorPageLoad = '';
  List<TransactionModel> transactions = [];

  PageState tabPageState = PageState.Loading;
  String errorTabPageLoad = '';

  void getOrderData(int indexStatus) async {
    orderPageState = PageState.Loading;
    errorPageLoad = '';
    Future.delayed(const Duration(seconds: 1), () async {
      String status = '';
      if (indexStatus == 0) {
        status = 'pending|paid';
      } else if (indexStatus == 1) {
        status = 'finish';
      } else {
        status = 'expired';
      }
      var response = await transactionService.getListOrder(status);
      if (response.success) {
        orderPageState = PageState.Loaded;
        tabPageState = PageState.Loaded;
        transactions = response.data ?? [];
      } else {
        if (response.statusCode == 401) {
          orderPageState = PageState.ErrorUnautorized;
        } else {
          orderPageState = PageState.Error;
          errorPageLoad = response.message;
        }
      }
      notifyListeners();
    });
    notifyListeners();
  }

  void getOrderTabPage(int indexStatus) async {
    tabPageState = PageState.Loading;
    errorTabPageLoad = '';
    Future.delayed(const Duration(seconds: 1), () async {
      String status = '';
      if (indexStatus == 0) {
        status = 'pending|paid';
      } else if (indexStatus == 1) {
        status = 'finish';
      } else {
        status = 'expired';
      }
      var response = await transactionService.getListOrder(status);
      if (response.success) {
        tabPageState = PageState.Loaded;
        transactions = response.data ?? [];
      } else {
        if (response.statusCode == 401) {
          tabPageState = PageState.ErrorUnautorized;
        } else {
          tabPageState = PageState.Error;
          errorTabPageLoad = response.message;
        }
      }
      notifyListeners();
    });
    notifyListeners();
  }

  Future<ResponseModel<bool>> cancelOrder(TransactionModel transaction) async {
    return await transactionService.cancelOrder(transaction);
  }

  Future<ResponseModel<bool>> uploadPaymentProof(
      TransactionModel transaction, File image) async {
    return await transactionService.uploadPaymentProof(transaction, image);
  }
}
