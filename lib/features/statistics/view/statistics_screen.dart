import 'dart:convert';

import 'package:dorun_app_flutter/common/component/gap_column.dart';
import 'package:dorun_app_flutter/common/component/list_item.dart';
import 'package:dorun_app_flutter/common/component/padding_container.dart';
import 'package:dorun_app_flutter/common/constant/colors.dart';
import 'package:dorun_app_flutter/common/constant/fonts.dart';
import 'package:dorun_app_flutter/common/layout/default_layout.dart';
import 'package:dorun_app_flutter/features/routine/provider/routine_provider.dart';
import 'package:dorun_app_flutter/features/statistics/model/weekly_model.dart';
import 'package:dorun_app_flutter/features/statistics/provider/statistic_provider.dart';
import 'package:dorun_app_flutter/features/statistics/view/calendar_widget.dart';
import 'package:dorun_app_flutter/features/statistics/view/component.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  @override
  Widget build(BuildContext context, ref) {
    final reportData = ref.watch(reportDataProvider);

    return SingleChildScrollView(
      child: GapColumn(
        gap: 24,
        children: [
          const StreakContainer(),
          const CalendarWidget(),
          reportData.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => Center(child: Text('Error: $error')),
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
    );
  }
}

class StatisticsRoutineScreen extends ConsumerWidget {
  const StatisticsRoutineScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final routineListAsyncValue = ref.watch(routineListProvider);

    return const PaddingContainer(child: Center(child: Text("준비중입니다.")));

    return PaddingContainer(
      child: routineListAsyncValue.when(
        data: (routines) {
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
                            StatisticsRoutineDetail(routineId: routine.id),
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
  final int routineId;

  const StatisticsRoutineDetail({super.key, required this.routineId});

  Future<WeeklyModel> getWeeklyData() async {
    final routeFromJsonFile =
        await rootBundle.loadString('asset/json/weekly_mock.json');

    final jsonData = json.decode(routeFromJsonFile) as Map<String, dynamic>;
    return WeeklyModel.fromJson(jsonData);
  }

  @override
  Widget build(BuildContext context) {
    return const DefaultLayout(
      title: '루틴별 통계',
      child: SingleChildScrollView(
        child: GapColumn(
          gap: 24,
          children: [
            StreakContainer(),
            Column(
              children: [
                CalendarWidget(),
                Divider(height: 0),
                ConductRoutineHistory()
                // DailyRoutineReportContainer(),
              ],
            ),
            RoutineReview(),
          ],
        ),
      ),
    );
  }
}
