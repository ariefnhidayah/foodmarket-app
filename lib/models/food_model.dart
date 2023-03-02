import 'package:equatable/equatable.dart';

class FoodModel extends Equatable {
  final int id;
  final String name;
  final String description;
  final String ingredients;
  final double price;
  final double rate;
  final String picturePath;

  const FoodModel({
    required this.id,
    required this.name,
    required this.description,
    required this.ingredients,
    required this.price,
    required this.rate,
    required this.picturePath,
  });

  factory FoodModel.fromJson(Map<String, dynamic> json) => FoodModel(
        id: json['id'] as int,
        name: json['name'] ?? "",
        description: json['description'] ?? "",
        ingredients: json['ingredients'] ?? "",
        price: double.parse(json['price'].toString()),
        rate: double.parse(json['rate'].toString()),
        picturePath: json['picture_path'] ?? "",
      );

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        ingredients,
        price,
        rate,
        picturePath,
      ];
}
