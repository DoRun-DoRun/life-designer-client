import 'package:dorun_app_flutter/common/component/gap_column.dart';
import 'package:dorun_app_flutter/common/component/list_item.dart';
import 'package:dorun_app_flutter/common/component/padding_container.dart';
import 'package:dorun_app_flutter/common/constant/colors.dart';
import 'package:dorun_app_flutter/common/constant/fonts.dart';
import 'package:dorun_app_flutter/common/layout/default_layout.dart';
import 'package:dorun_app_flutter/features/routine/model/routine_model.dart';
import 'package:dorun_app_flutter/features/routine/provider/routine_provider.dart';
import 'package:dorun_app_flutter/features/statistics/provider/statistic_provider.dart';
import 'package:dorun_app_flutter/features/statistics/view/calendar_widget.dart';
import 'package:dorun_app_flutter/features/statistics/view/component.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: DefaultLayout(
        customAppBar: AppBar(
          title: const Text('통계', style: AppTextStyles.MEDIUM_16),
          backgroundColor: Colors.white,
          bottom: const TabBar(
              indicator: UnderlineTabIndicator(
                borderSide: BorderSide(width: 4, color: AppColors.BRAND),
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              labelColor: AppColors.TEXT_BRAND,
              unselectedLabelColor: AppColors.TEXT_SUB,
              labelStyle: AppTextStyles.BOLD_14,
              tabs: [
                Tab(text: "기간별"),
                Tab(text: "루틴별"),
              ]),
        ),
        child: const TabBarView(
          children: [
            StatisticsPeriodScreen(),
            StatisticsRoutineScreen(),
          ],
        ),
      ),
    );
  }
}

class StatisticsPeriodScreen extends ConsumerWidget {
  const StatisticsPeriodScreen({super.key});

  Future<void> _refreshStatistics(WidgetRef ref) async {
    ref.invalidate(reportDataProvider);
    ref.invalidate(statisticsProvider);

    await ref.read(reportDataProvider.future);
    await ref.read(statisticsProvider.future);
  }

  @override
  Widget build(BuildContext context, ref) {
    final reportData = ref.watch(reportDataProvider);

    return RefreshIndicator(
      backgroundColor: Colors.white,
      color: AppColors.BRAND,
      onRefresh: () => _refreshStatistics(ref),
      child: SingleChildScrollView(
        child: GapColumn(
          gap: 24,
          children: [
            const StreakContainer(),
            const CalendarWidget(),
            reportData.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => const Center(
                child: PaddingContainer(
                  verticalSize: 48,
                  child: Center(
                    child: Text(
                      "현재 사용자님의 데이터를 수집하고 있어요.\n루틴 수행 2주 이후에 보고서를 제공해드릴 수 있어요.",
                      style: AppTextStyles.MEDIUM_16,
                    ),
                  ),
                ),
              ),
              data: (report) {
                return GapColumn(
                  gap: 24,
                  children: [
                    WeeklyRoutineReportContainer(
                      current: report.current,
                      progress: report.progress,
                    ),
                    RoutineFeedbackContainer(
                      maxFailedRoutineLastWeek: report.maxFailedRoutineLastWeek,
                      routineWeeklyReport: report.routineWeeklyReport,
                    ),
                  ],
                );
              },
            )
          ],
        ),
      ),
    );
  }
}

class StatisticsRoutineScreen extends ConsumerWidget {
  const StatisticsRoutineScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final routineListAsyncValue = ref.watch(routineListProvider);

    return PaddingContainer(
      child: routineListAsyncValue.when(
        data: (routines) {
          if (routines.isEmpty) {
            return const Center(child: Text("루틴이 없습니다."));
          }

          return SingleChildScrollView(
            child: GapColumn(
              gap: 24,
              children: routines.map((routine) {
                return ListItem(
                  routineId: routine.id,
                  title: routine.name,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            StatisticsRoutineDetail(routine: routine),
                      ),
                    );
                  },
                );
              }).toList(),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) =>
            const Center(child: Text('Failed to load routines')),
      ),
    );
  }
}

class StatisticsRoutineDetail extends StatelessWidget {
  final RoutineModel routine;

  const StatisticsRoutineDetail({super.key, required this.routine});

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: '루틴별 통계',
      child: SingleChildScrollView(
        child: GapColumn(
          gap: 24,
          children: [
            StreakContainer(routine: routine),
            CalendarWidget(routine: routine),
          ],
        ),
      ),
    );
  }
}
