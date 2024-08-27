import 'package:dorun_app_flutter/common/component/custom_button.dart';
import 'package:dorun_app_flutter/common/component/gap_column.dart';
import 'package:dorun_app_flutter/common/component/list_item.dart';
// import 'package:dorun_app_flutter/common/component/list_item.dart';
import 'package:dorun_app_flutter/common/component/padding_container.dart';
import 'package:dorun_app_flutter/common/constant/colors.dart';
import 'package:dorun_app_flutter/common/constant/fonts.dart';
import 'package:dorun_app_flutter/common/layout/default_layout.dart';
import 'package:dorun_app_flutter/common/utils/data_utils.dart';
import 'package:dorun_app_flutter/features/routine/model/routine_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RoutineReviewEditScreen extends StatelessWidget {
  static String get routeName => 'routinReviewEditScreen';
  final int id;
  final RoutineHistory routineHistory;

  const RoutineReviewEditScreen(
      {super.key, required this.id, required this.routineHistory});

  @override
  Widget build(BuildContext context) {
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
            child: GapColumn(
              gap: 24,
              children: [
                RichText(
                  text: TextSpan(
                    text: '수행시간: ',
                    style: AppTextStyles.REGULAR_16,
                    children: <TextSpan>[
                      TextSpan(
                        text: calculateTotalDuration(routineHistory),
                        style: AppTextStyles.BOLD_16
                            .copyWith(color: AppColors.TEXT_BRAND),
                      ),
                    ],
                  ),
                ),
                GapColumn(
                  gap: 16,
                  children: routineHistory.histories.map((data) {
                    SubRoutineModel subRoutine = data.subRoutine;

                    return ListItem(
                      id: subRoutine.id,
                      title: subRoutine.goal,
                      routinEmoji: subRoutine.emoji,
                      subTitle: data.state == RoutineHistoyState.passed
                          ? "건너뜀"
                          : '${data.duration ~/ 60}분 ${data.duration % 60}초',
                      actionIcon: Icons.edit,
                      isDone: data.state == RoutineHistoyState.passed,
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          PaddingContainer(
            child: CustomButton(
              title: '확인',
              onPressed: () {
                context.push('/routine_review/$id', extra: routineHistory);
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
