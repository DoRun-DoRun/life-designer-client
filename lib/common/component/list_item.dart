import 'package:dorun_app_flutter/common/component/gap_row.dart';
import 'package:dorun_app_flutter/common/constant/colors.dart';
import 'package:dorun_app_flutter/common/constant/fonts.dart';
import 'package:dorun_app_flutter/common/constant/spacing.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ListItem extends StatelessWidget {
  final int id;
  final String title;
  final String subTitle;
  final String routinEmoji;
  final IconData? actionIcon;
  final Color actionIconColor;
  final bool isButton;
  final bool isDone;
  final VoidCallback? onTap;

  const ListItem({
    super.key,
    required this.id,
    required this.title,
    this.subTitle = '',
    this.routinEmoji = '',
    this.actionIcon = Icons.chevron_right,
    this.actionIconColor = AppColors.TEXT_INVERT,
    this.isButton = false,
    this.isDone = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 62,
        decoration: const BoxDecoration(
          color: AppColors.BACKGROUND_SUB,
          borderRadius: AppRadius.ROUNDED_16,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.SPACE_16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GapRow(
                gap: AppSpacing.SPACE_8,
                children: [
                  Text(
                    routinEmoji,
                    style: AppTextStyles.EMOJI,
                  ),
                  Text(
                    title,
                    style: AppTextStyles.MEDIUM_16.copyWith(
                      color: isDone
                          ? AppColors.TEXT_INVERT
                          : AppColors.TEXT_PRIMARY,
                    ),
                  ),
                  Text(
                    subTitle,
                    style: AppTextStyles.MEDIUM_14.copyWith(
                      color: isDone
                          ? AppColors.TEXT_INVERT
                          : AppColors.TEXT_SECONDARY,
                    ),
                  ),
                ],
              ),
              if (isButton)
                ElevatedButton(
                  onPressed: () => {context.go('/routine_proceed/$id')},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.BRAND_SUB,
                    shape: const RoundedRectangleBorder(
                      borderRadius: AppRadius.ROUNDED_8,
                    ),
                    shadowColor: null,
                    elevation: 0,
                  ),
                  child: Text(
                    '수행',
                    style: AppTextStyles.MEDIUM_14.copyWith(
                      color: AppColors.BRAND,
                    ),
                  ),
                )
              else
                Icon(
                  actionIcon,
                  size: 32,
                  color: actionIconColor,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
