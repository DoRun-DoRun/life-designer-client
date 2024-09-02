import 'package:dorun_app_flutter/common/component/custom_button.dart';
import 'package:dorun_app_flutter/common/component/custom_icon.dart';
import 'package:dorun_app_flutter/common/constant/colors.dart';
import 'package:flutter/cupertino.dart';

Widget buildRepeatOptionButton(String label, bool isSelected, onTap) {
  return CustomButton(
    onPressed: onTap,
    title: label,
    foregroundColor: isSelected ? AppColors.BRAND : AppColors.TEXT_SECONDARY,
    backgroundColor:
        isSelected ? AppColors.BRAND_SUB : AppColors.BACKGROUND_SUB,
  );
}

Widget buildDayButton(
    String dayLabel, int index, isSelected, Function() onTap) {
  return GestureDetector(
    onTap: onTap,
    child: CustomIcon(
      size: 36,
      text: dayLabel,
      primaryColor: isSelected ? AppColors.BRAND_SUB : AppColors.BACKGROUND_SUB,
      secondaryColor: isSelected ? AppColors.BRAND : AppColors.TEXT_SECONDARY,
    ),
  );
}
