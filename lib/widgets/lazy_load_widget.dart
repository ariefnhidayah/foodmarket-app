import 'package:flutter/material.dart';
import 'package:foodmarket/commons/constant.dart';
import 'package:shimmer/shimmer.dart';

class LazyLoadWidget extends StatelessWidget {
  final Widget child;
  final bool enable;

  const LazyLoadWidget({Key? key, required this.child, this.enable = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      child: child,
      baseColor: baseColorLazyLoad,
      highlightColor: highlightColorLazyLoad,
      enabled: true,
    );
  }
}
