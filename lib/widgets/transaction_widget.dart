import 'package:flutter/material.dart';
import 'package:foodmarket/commons/constant.dart';
import 'package:foodmarket/commons/helper.dart';
import 'package:foodmarket/commons/theme.dart';
import 'package:foodmarket/models/transaction_model.dart';
import 'package:foodmarket/screens/order/order_detail_screen.dart';
import 'package:foodmarket/widgets/image_network_widget.dart';

class TransactionWidget extends StatelessWidget {
  final TransactionModel transactionModel;

  const TransactionWidget({Key? key, required this.transactionModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, OrderDetailScreen.ROUTE_NAME,
            arguments: transactionModel);
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
              imageUrl: transactionModel.food.picturePath,
              width: 60,
              height: 60,
              boxFit: BoxFit.cover,
              borderRadius: BorderRadius.circular(8),
            ),
            const SizedBox(
              width: 12,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width - 24 - 24 - 12 - 60,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width -
                            24 -
                            24 -
                            12 -
                            60,
                        child: Text(
                          transactionModel.food.name,
                          style: textStyleTheme().copyWith(
                            fontSize: 16,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            "${transactionModel.quantity} items | ",
                            style: textStyleTheme().copyWith(
                              fontSize: 13,
                              color: secondaryColor,
                            ),
                          ),
                          Text(
                            formatRupiah(transactionModel.total),
                            style: textStyleTheme().copyWith(
                              fontSize: 13,
                              color: secondaryColor,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
