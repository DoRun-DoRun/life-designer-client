// ignore_for_file: constant_identifier_names

import 'package:dorun_app_flutter/common/constant/colors.dart';
import 'package:flutter/material.dart';

class AppTextStyles {
  static const String fontFamily = 'NotoSansKR';

  // Regular
  static const TextStyle REGULAR_12 = TextStyle(
    fontFamily: fontFamily,
    fontWeight: FontWeight.w400,
    fontSize: 12,
    color: AppColors.TEXT_PRIMARY,
  );

  static const TextStyle REGULAR_14 = TextStyle(
    fontFamily: fontFamily,
    fontWeight: FontWeight.w400,
    fontSize: 14,
    color: AppColors.TEXT_PRIMARY,
  );

  static const TextStyle REGULAR_20 = TextStyle(
    fontFamily: fontFamily,
    fontWeight: FontWeight.w400,
    fontSize: 20,
    color: AppColors.TEXT_PRIMARY,
  );

  // Medium
  static const TextStyle MEDIUM_12 = TextStyle(
    fontFamily: fontFamily,
    fontWeight: FontWeight.w500,
    fontSize: 12,
    color: AppColors.TEXT_PRIMARY,
  );

  static const TextStyle MEDIUM_14 = TextStyle(
    fontFamily: fontFamily,
    fontWeight: FontWeight.w500,
    fontSize: 14,
    color: AppColors.TEXT_PRIMARY,
  );

  static const TextStyle MEDIUM_16 = TextStyle(
    fontFamily: fontFamily,
    fontWeight: FontWeight.w500,
    fontSize: 16,
    color: AppColors.TEXT_PRIMARY,
  );

  // Bold
  static const TextStyle BOLD_16 = TextStyle(
    fontFamily: fontFamily,
    fontWeight: FontWeight.w700,
    fontSize: 16,
    color: AppColors.TEXT_PRIMARY,
  );

  static const TextStyle BOLD_20 = TextStyle(
    fontFamily: fontFamily,
    fontWeight: FontWeight.w700,
    fontSize: 20,
    color: AppColors.TEXT_PRIMARY,
  );

  static const TextStyle EMOJI = TextStyle(
    fontFamily: 'TossFace',
    fontSize: 16,
  );
}
