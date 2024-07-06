import 'package:dorun_app_flutter/common/constant/colors.dart';
import 'package:dorun_app_flutter/common/constant/fonts.dart';
import 'package:dorun_app_flutter/common/constant/spacing.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.onPressed,
    this.title = '',
    this.icon,
    this.backgroundColor = AppColors.BACKGROUND_SUB,
    this.foregroundColor = AppColors.TEXT_SECONDARY,
    this.padding = const EdgeInsets.all(16.0),
    this.align = TextAlign.center,
  });

  final VoidCallback onPressed;
  final String title;
  final Color backgroundColor;
  final Color foregroundColor;
  final EdgeInsets padding;
  final TextAlign align;
  final Icon? icon;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onPressed();
      },
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: AppRadius.ROUNDED_16,
        ),
        child: Padding(
          padding: padding,
          child: icon ??
              Text(
                title,
                style: AppTextStyles.MEDIUM_16.copyWith(color: foregroundColor),
                textAlign: align,
              ),
        ),
      ),
    );
  }
}
