import 'package:dorun_app_flutter/common/constant/colors.dart';
import 'package:dorun_app_flutter/common/constant/fonts.dart';
import 'package:dorun_app_flutter/common/constant/spacing.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatefulWidget {
  const CustomButton({
    super.key,
    required this.onPressed,
    required this.title,
    this.backgroundColor = AppColors.BACKGROUND_SUB,
    this.foregroundColor = AppColors.TEXT_SECONDARY,
    this.padding = const EdgeInsets.all(16.0),
  });

  final VoidCallback onPressed;
  final String title;
  final Color backgroundColor;
  final Color foregroundColor;
  final EdgeInsets padding;

  @override
  CustomButtonState createState() => CustomButtonState();
}

class CustomButtonState extends State<CustomButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onPressed();
      },
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: widget.backgroundColor,
          borderRadius: AppRadius.ROUNDED_16,
        ),
        child: Padding(
          padding: widget.padding,
          child: Text(
            widget.title,
            style:
                AppTextStyles.MEDIUM_16.copyWith(color: widget.foregroundColor),
          ),
        ),
      ),
    );
  }
}
