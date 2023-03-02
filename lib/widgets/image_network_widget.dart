import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:foodmarket/commons/constant.dart';
import 'package:foodmarket/widgets/lazy_load_widget.dart';

class ImageNetworkWidget extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit? boxFit;
  final BorderRadius? borderRadius;
  const ImageNetworkWidget(
      {Key? key,
      required this.imageUrl,
      this.width,
      this.height,
      this.boxFit,
      this.borderRadius})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: boxFit,
      imageBuilder: (context, imageProvider) => Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
            image: DecorationImage(
              image: imageProvider,
              fit: boxFit,
            ),
            borderRadius: borderRadius),
      ),
      placeholder: (context, _) {
        return LazyLoadWidget(
          child: Container(
            decoration: BoxDecoration(
              color: baseColorLazyLoad,
              borderRadius:
                  borderRadius ?? const BorderRadius.all(Radius.circular(0)),
            ),
          ),
        );
      },
      errorWidget: (context, err, _) {
        return LazyLoadWidget(
          child: Container(
            decoration: BoxDecoration(
              color: baseColorLazyLoad,
              borderRadius:
                  borderRadius ?? const BorderRadius.all(Radius.circular(0)),
            ),
          ),
        );
      },
    );
  }
}
