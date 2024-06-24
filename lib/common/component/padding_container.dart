import 'package:flutter/material.dart';

class PaddingContainer extends StatelessWidget {
  final Widget child;
  final double size;
  final Color color;
  final double? height;

  const PaddingContainer({
    super.key,
    required this.child,
    this.size = 24.0,
    this.color = Colors.white,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: color,
      ),
      child: Padding(
        padding: EdgeInsets.all(size),
        child: child,
      ),
    );
  }
}
