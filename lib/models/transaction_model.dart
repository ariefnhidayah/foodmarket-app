import 'package:equatable/equatable.dart';
import 'package:foodmarket/models/food_model.dart';
import 'package:foodmarket/models/user_model.dart';

class TransactionModel extends Equatable {
  final int id;
  final String code;
  final int quantity;
  final double total;
  final double shippingCost;
  final double tax;
  final double grandTotal;
  final String status;
  final String paymentProof;
  final String dateAdded;
  final FoodModel food;
  final UserModel? user;

  const TransactionModel({
    required this.id,
    required this.code,
    required this.quantity,
    required this.total,
    required this.shippingCost,
    required this.tax,
    required this.grandTotal,
    required this.status,
    required this.paymentProof,
    this.dateAdded = '',
    required this.food,
    required this.user,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) =>
      TransactionModel(
        id: json['id'] as int,
        code: json['code'] ?? '',
        quantity: json['quantity'] as int,
        total: double.parse(json['total'].toString()),
        shippingCost: double.parse(json['shipping_cost'].toString()),
        tax: double.parse(json['tax'].toString()),
        grandTotal: double.parse(json['grand_total'].toString()),
        status: json['status'] ?? '',
        paymentProof: json['payment_proof'] ?? '',
        food: FoodModel.fromJson(json['food']),
        user: json['user'] != null ? UserModel.fromJson(json['user']) : null,
        dateAdded: json['date_added'] ?? '',
      );

  @override
  List<Object?> get props => [
        id,
        code,
        quantity,
        total,
        shippingCost,
        tax,
        grandTotal,
        status,
        paymentProof,
        food,
        user,
        dateAdded,
      ];
}
