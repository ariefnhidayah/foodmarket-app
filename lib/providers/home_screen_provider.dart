import 'package:flutter/foundation.dart';
import 'package:foodmarket/models/food_model.dart';
import 'package:foodmarket/models/response_model.dart';
import 'package:foodmarket/services/food_service.dart';

class HomeScreenProvider extends ChangeNotifier {
  final FoodService foodService;

  HomeScreenProvider({
    required this.foodService,
  });

  Future<ResponseModel<List<FoodModel>>> getFoodBanner() async {
    return await foodService.getByRating();
  }

  Future<ResponseModel<List<FoodModel>>> getFoodsByType(String type) async {
    return await foodService.getByType(type);
  }
}
