import 'package:flutter/material.dart';
import 'package:foodmarket/commons/constant.dart';
import 'package:foodmarket/models/food_model.dart';
import 'package:foodmarket/screens/food_detail/food_detail_screen.dart';
import 'package:foodmarket/widgets/image_network_widget.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class FoodBannerWidget extends StatelessWidget {
  final FoodModel food;
  final int index;
  const FoodBannerWidget({
    Key? key,
    required this.food,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int ratingActive = food.rate.floor();
    int rating = 5 - ratingActive;
    return ZoomTapAnimation(
      onTap: () {
        Navigator.pushNamed(context, FoodDetailScreen.ROUTE_NAME, arguments: {
          "food": food,
          "imageHeroTag": "banner-image-${food.id}",
        });
      },
      child: Container(
        width: 200,
        margin: EdgeInsets.only(
          left: index == 0 ? 24 : 0,
          right: 24,
          top: 24,
          bottom: 24,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(.150),
              blurRadius: 4,
              offset: const Offset(0, 0), // Shadow position
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Column(
            children: [
              Hero(
                tag: "banner-image-${food.id}",
                child: ImageNetworkWidget(
                  imageUrl: food.picturePath,
                  width: 200,
                  height: 140,
                  boxFit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      food.name,
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            for (int index = 0; index < ratingActive; index++)
                              const Icon(
                                Icons.star,
                                size: 16,
                                color: ratingActiveColor,
                              ),
                            for (int index = 0; index < rating; index++)
                              const Icon(
                                Icons.star,
                                size: 16,
                                color: ratingColor,
                              ),
                          ],
                        ),
                        const SizedBox(
                          width: 4,
                        ),
                        Text(
                          "${food.rate}",
                          style: const TextStyle(
                            fontSize: 12,
                            color: secondaryColor,
                          ),
                        )
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
