import 'package:dorun_app_flutter/common/constant/colors.dart';
import 'package:flutter/material.dart';

class CustomIcon extends StatelessWidget {
  final double size;
  final Color primaryColor;
  final Color secondaryColor;
  final IconData icon;

  const CustomIcon({
    super.key,
    this.size = 24.0,
    this.primaryColor = AppColors.BRAND,
    this.secondaryColor = Colors.white,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: primaryColor,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: secondaryColor,
          size: 16,
        ),
      ),
    );
  }
}
