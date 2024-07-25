import 'package:dorun_app_flutter/common/component/custom_button.dart';
import 'package:dorun_app_flutter/common/component/gap_column.dart';
import 'package:dorun_app_flutter/common/component/list_item.dart';
import 'package:dorun_app_flutter/common/component/padding_container.dart';
import 'package:dorun_app_flutter/common/constant/colors.dart';
import 'package:dorun_app_flutter/common/constant/data.dart';
import 'package:dorun_app_flutter/common/constant/fonts.dart';
import 'package:dorun_app_flutter/common/layout/default_layout.dart';
import 'package:dorun_app_flutter/features/routine/model/routine_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RoutineReviewEditScreen extends StatelessWidget {
  static String get routeName => 'routinReviewEditScreen';
  final int id;
  const RoutineReviewEditScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    Routine? getRoutineById(int id) {
      try {
        return routineMockData.firstWhere((routine) => routine.id == id);
      } catch (e) {
        return routineMockData[0];
      }
    }

    return DefaultLayout(
      rightIcon: IconButton(
        icon: const Icon(Icons.close, size: 30),
        onPressed: () {
          context.go('/');
        },
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          PaddingContainer(
            child: GapColumn(gap: 24, children: [
              RichText(
                text: TextSpan(
                  text: '수행시간: ',
                  style: AppTextStyles.REGULAR_16,
                  children: <TextSpan>[
                    TextSpan(
                      text: '82분 41초',
                      style: AppTextStyles.BOLD_16
                          .copyWith(color: AppColors.TEXT_BRAND),
                    ),
                  ],
                ),
              ),
              ...getRoutineById(id)!.subRoutines.map((data) {
                return ListItem(
                  id: data.id,
                  title: data.name,
                  routinEmoji: data.emoji,
                  subTitle: '${(data.durationSecond ~/ 60).toString()}분',
                  actionIcon: Icons.edit,
                );
              }),
            ]),
          ),
          PaddingContainer(
            child: CustomButton(
              title: '확인',
              onPressed: () {
                context.push('/routine_review/$id');
              },
              backgroundColor: AppColors.BRAND_SUB,
              foregroundColor: AppColors.TEXT_BRAND,
            ),
          )
        ],
      ),
    );
  }
}
