import 'package:flutter/material.dart';
import 'package:foodmarket/commons/constant.dart';
import 'package:foodmarket/commons/helper.dart';
import 'package:foodmarket/commons/theme.dart';
import 'package:foodmarket/models/food_model.dart';
import 'package:foodmarket/screens/food_detail/food_detail_screen.dart';
import 'package:foodmarket/widgets/image_network_widget.dart';

class FoodWidget extends StatelessWidget {
  final FoodModel food;
  const FoodWidget({Key? key, required this.food}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, FoodDetailScreen.ROUTE_NAME, arguments: {
          "food": food,
          "imageHeroTag": "image-${food.id}",
        });
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.only(
          bottom: 16,
          left: 24,
          right: 24,
        ),
        child: Row(
          children: [
            ImageNetworkWidget(
              imageUrl: food.picturePath,
              width: 60,
              height: 60,
              boxFit: BoxFit.cover,
              borderRadius: BorderRadius.circular(8),
            ),
            const SizedBox(
              width: 12,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width - 24 - 24 - 60 - 12,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    food.name,
                    style: textStyleTheme().copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    formatRupiah(food.price),
                    style: textStyleTheme().copyWith(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: secondaryColor,
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
