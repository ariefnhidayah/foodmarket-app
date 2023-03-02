import 'package:flutter/material.dart';
import '/commons/constant.dart';

class ErrorPageWidget extends StatelessWidget {
  final String message;
  final Function press;
  const ErrorPageWidget({
    Key? key,
    required this.message,
    required this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.warning,
            color: dangerColor,
            size: 100,
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              message.isEmpty ? "Oopps, Terjadi suatu kesalahan!" : message,
              style: const TextStyle(
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          TextButton(
            onPressed: () {
              press();
            },
            child: const Text(
              "Coba Lagi",
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
          )
        ],
      ),
    );
  }
}
