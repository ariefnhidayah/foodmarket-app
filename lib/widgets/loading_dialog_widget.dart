import 'package:flutter/material.dart';
import 'package:foodmarket/commons/constant.dart';
import 'package:loading_indicator/loading_indicator.dart';

void showLoaderDialog(BuildContext context) {
  WidgetsBinding.instance!.addPostFrameCallback((_) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Center(
            child: Container(
              width: 85,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(15)),
              padding: const EdgeInsets.all(15),
              child: const LoadingIndicator(
                indicatorType: Indicator.ballPulse,
                colors: [primaryColor],
              ),
            ),
          ),
        );
      },
    );
  });
}
