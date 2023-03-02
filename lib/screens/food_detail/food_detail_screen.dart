import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:foodmarket/commons/constant.dart';
import 'package:foodmarket/commons/helper.dart';
import 'package:foodmarket/commons/theme.dart';
import 'package:foodmarket/models/food_model.dart';
import 'package:foodmarket/screens/payment/payment_screen.dart';
import 'package:foodmarket/widgets/button_widget.dart';
import 'package:foodmarket/widgets/image_network_widget.dart';

class FoodDetailScreen extends StatefulWidget {
  final FoodModel food;
  const FoodDetailScreen({Key? key, required this.food}) : super(key: key);

  static const String ROUTE_NAME = '/food/detail';

  @override
  // ignore: no_logic_in_create_state
  State<FoodDetailScreen> createState() => _FoodDetailScreenState(food);
}

class _FoodDetailScreenState extends State<FoodDetailScreen> {
  final FoodModel food;

  _FoodDetailScreenState(this.food);

  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.text = '1';
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int ratingActive = food.rate.floor();
    int rating = 5 - ratingActive;
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        titleSpacing: 24,
        leading: Container(
          width: 24,
          color: Colors.transparent,
          margin: const EdgeInsets.only(
            left: 24,
            top: 24,
            bottom: 0,
          ),
          child: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
            onPressed: () => Navigator.of(context).pop(),
            iconSize: 24,
          ),
        ),
      ),
      body: Stack(
        children: [
          ListView(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    transform: Matrix4.translationValues(0.0, -50, 0.0),
                    child: ImageNetworkWidget(
                      imageUrl: food.picturePath,
                      width: MediaQuery.of(context).size.width,
                      height: 330,
                      boxFit: BoxFit.cover,
                    ),
                  ),
                  Container(
                    transform: Matrix4.translationValues(0.0, -70, 0.0),
                    padding: const EdgeInsets.symmetric(
                      vertical: 26,
                      horizontal: 16,
                    ),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                      color: Colors.white,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: MediaQuery.of(context).size.width -
                                      140 -
                                      16 -
                                      16,
                                  child: Text(
                                    food.name,
                                    style: textStyleTheme().copyWith(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        for (int index = 0;
                                            index < ratingActive;
                                            index++)
                                          const Icon(
                                            Icons.star,
                                            size: 16,
                                            color: ratingActiveColor,
                                          ),
                                        for (int index = 0;
                                            index < rating;
                                            index++)
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
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      if (int.parse(_controller.text) > 1) {
                                        _controller.text =
                                            (int.parse(_controller.text) - 1)
                                                .toString();
                                      }
                                    });
                                  },
                                  child: Container(
                                    width: 26,
                                    height: 26,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                        color: textColor,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Icon(
                                      Icons.remove,
                                      size: 16,
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 5,
                                  ),
                                  width: 30,
                                  height: 26,
                                  child: TextField(
                                    controller: _controller,
                                    keyboardType: TextInputType.number,
                                    textAlign: TextAlign.center,
                                    scrollPadding: EdgeInsets.zero,
                                    style: textStyleTheme().copyWith(
                                      fontSize: 16,
                                    ),
                                    onSubmitted: (value) {
                                      setState(() {
                                        _controller.text =
                                            value.isNotEmpty ? value : '0';
                                      });
                                    },
                                    decoration: InputDecoration(
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              vertical: 2),
                                      border: outlineInputBorder.copyWith(
                                        borderSide: BorderSide.none,
                                      ),
                                      focusedBorder:
                                          outlineInputBorder.copyWith(
                                        borderSide: BorderSide.none,
                                      ),
                                      enabledBorder:
                                          outlineInputBorder.copyWith(
                                        borderSide: BorderSide.none,
                                      ),
                                      errorBorder: outlineInputBorder.copyWith(
                                        borderSide: BorderSide.none,
                                      ),
                                      disabledBorder:
                                          outlineInputBorder.copyWith(
                                        borderSide: BorderSide.none,
                                      ),
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      _controller.text =
                                          (int.parse(_controller.text) + 1)
                                              .toString();
                                    });
                                  },
                                  child: Container(
                                    width: 26,
                                    height: 26,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: textColor,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Icon(
                                      Icons.add,
                                      size: 16,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Text(
                          food.description,
                          style: textStyleTheme().copyWith(
                            color: secondaryColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Ingredients:",
                              style: textStyleTheme().copyWith(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Text(
                              food.ingredients,
                              style: textStyleTheme().copyWith(
                                fontSize: 14,
                                color: secondaryColor,
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 95,
                  )
                ],
              ),
            ],
          ),
          Positioned(
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 26, horizontal: 16),
              width: MediaQuery.of(context).size.width,
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Total Price:",
                        style: textStyleTheme().copyWith(
                          color: secondaryColor,
                          fontSize: 13,
                        ),
                      ),
                      Text(
                        formatRupiah((int.parse(_controller.text != ''
                                ? _controller.text
                                : '0') *
                            food.price)),
                        style: textStyleTheme().copyWith(
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                  ButtonWidget(
                    onPress: int.parse(
                              _controller.text != '' ? _controller.text : '0',
                            ) ==
                            0
                        ? null
                        : () {
                            Navigator.pushNamed(
                                context, PaymentScreen.ROUTE_NAME,
                                arguments: {
                                  "quantity": int.parse(_controller.text),
                                  "food": food,
                                });
                          },
                    child: Text(
                      "Order Now",
                      style: textStyleTheme(),
                    ),
                    width: 150,
                    elevation: 0,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
