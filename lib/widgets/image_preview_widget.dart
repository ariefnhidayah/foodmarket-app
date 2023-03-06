import 'dart:io';

import 'package:flutter/material.dart';
import 'package:foodmarket/widgets/image_network_widget.dart';

class ImagePreviewWidget extends StatefulWidget {
  final String imagePath;
  final String from;
  const ImagePreviewWidget(
      {Key? key, required this.imagePath, this.from = 'url'})
      : super(key: key);

  static const String ROUTE_NAME = '/image-preview';

  @override
  // ignore: no_logic_in_create_state
  State<ImagePreviewWidget> createState() => _ImagePreviewWidgetState(
        imagePath: imagePath,
        from: from,
      );
}

class _ImagePreviewWidgetState extends State<ImagePreviewWidget> {
  final String imagePath;
  final String from;

  _ImagePreviewWidgetState({required this.imagePath, required this.from});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: Container(),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.close,
              color: Colors.white,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
      backgroundColor: Colors.black,
      body: Center(
        child: InteractiveViewer(
          child: Hero(
            tag: "image-preview-$imagePath",
            child: from == 'url'
                ? ImageNetworkWidget(
                    imageUrl: imagePath,
                    width: MediaQuery.of(context).size.width,
                  )
                : Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: FileImage(File(imagePath)),
                      ),
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
