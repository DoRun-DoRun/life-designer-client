import 'package:flutter/material.dart';

class PaddingContainer extends StatelessWidget {
  final Widget child;
  final double verticalSize;
  final double horizontalSize;
  final Color color;
  final double? height;
  final double? width;

  const PaddingContainer({
    super.key,
    required this.child,
    this.verticalSize = 24.0,
    this.horizontalSize = 24.0,
    this.color = Colors.white,
    this.height,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: color,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: verticalSize,
          horizontal: horizontalSize,
        ),
        child: child,
      ),
    );
  }
}
