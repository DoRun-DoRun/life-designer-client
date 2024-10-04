import 'package:dorun_app_flutter/common/component/gap_column.dart';
import 'package:dorun_app_flutter/common/component/padding_container.dart';
import 'package:dorun_app_flutter/common/constant/fonts.dart';
import 'package:dorun_app_flutter/common/layout/default_layout.dart';
import 'package:dorun_app_flutter/features/statistics/provider/statistic_provider.dart';
import 'package:dorun_app_flutter/features/statistics/view/component.dart';
import 'package:dorun_app_flutter/features/user/model/user_model.dart';
import 'package:dorun_app_flutter/features/user/provider/user_me_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StatisticsWeeklyDetail extends ConsumerWidget {
  const StatisticsWeeklyDetail({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final reportDetailsAsync = ref.watch(reportDetailsProvider);
    final user = ref.watch(userMeProvider);
    String userName = '익명의 루티너';

    if (user is UserModel && user.name != '') userName = user.name!;

    return DefaultLayout(
      title: "주간기록",
      leftIcon: IconButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        icon: const Icon(
          Icons.chevron_left,
          size: 30,
        ),
      ),
      child: SingleChildScrollView(
        child: PaddingContainer(
          child: reportDetailsAsync.when(
            data: (reportDetails) {
              return GapColumn(
                gap: 8,
                children: [
                  Text("$userName님의\n일주일 루틴이에요", style: AppTextStyles.BOLD_20),
                  const SizedBox(height: 24),
                  ...reportDetails.map(
                    (reportDetail) {
                      return WeeklyRoutine(
                        maxFailedRoutineLastWeek: reportDetail,
                        routineWeeklyReport: reportDetail.status,
                      );
                    },
                  ),
                ],
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => Center(child: Text('Error: $error')),
          ),
        ),
      ),
    );
  }
}
