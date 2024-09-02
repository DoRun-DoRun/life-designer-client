import 'dart:convert';

import 'package:dorun_app_flutter/common/component/gap_column.dart';
import 'package:dorun_app_flutter/common/component/list_item.dart';
import 'package:dorun_app_flutter/common/component/padding_container.dart';
import 'package:dorun_app_flutter/common/constant/colors.dart';
import 'package:dorun_app_flutter/common/constant/fonts.dart';
import 'package:dorun_app_flutter/common/layout/default_layout.dart';
import 'package:dorun_app_flutter/features/statistics/model/weekly_model.dart';
import 'package:dorun_app_flutter/features/statistics/view/calendar_widget.dart';
import 'package:dorun_app_flutter/features/statistics/view/component.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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

class StatisticsPeriodScreen extends StatelessWidget {
  const StatisticsPeriodScreen({super.key});

  Future<WeeklyModel> getPeriodStatData() async {
    final routeFromJsonFile =
        await rootBundle.loadString('asset/json/weekly_mock.json');

    final jsonData = json.decode(routeFromJsonFile) as Map<String, dynamic>;
    return WeeklyModel.fromJson(jsonData);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<WeeklyModel>(
      future: getPeriodStatData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (snapshot.hasData) {
          return SingleChildScrollView(
            child: GapColumn(
              gap: 24,
              children: [
                StreakContainer(periodStatData: snapshot.data!),
                const Column(
                  children: [
                    CalendarWidget(),
                    Divider(height: 0),
                    DailyRoutineReportContainer(),
                  ],
                ),
                WeeklyRoutineReportContainer(periodStatData: snapshot.data!),
                RoutineFeedbackContainer(periodStatData: snapshot.data!)
              ],
            ),
          );
        } else {
          return const Center(child: Text('noData'));
        }
      },
    );
  }
}

class StatisticsRoutineScreen extends StatelessWidget {
  const StatisticsRoutineScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PaddingContainer(
        child: GapColumn(
      gap: 24,
      children: [
        ListItem(
          routineId: 0,
          title: "아침 조깅하기",
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const StatisticsRoutineDetail()),
            );
          },
        ),
        const ListItem(routineId: 0, title: "아침 조깅하기"),
        const ListItem(routineId: 0, title: "아침 조깅하기"),
        const ListItem(routineId: 0, title: "아침 조깅하기"),
        const ListItem(routineId: 0, title: "아침 조깅하기"),
      ],
    ));
  }
}

class StatisticsRoutineDetail extends StatelessWidget {
  const StatisticsRoutineDetail({super.key});

  Future<WeeklyModel> getWeeklyData() async {
    final routeFromJsonFile =
        await rootBundle.loadString('asset/json/weekly_mock.json');

    final jsonData = json.decode(routeFromJsonFile) as Map<String, dynamic>;
    return WeeklyModel.fromJson(jsonData);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<WeeklyModel>(
        future: getWeeklyData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (snapshot.hasData) {
            return DefaultLayout(
                title: '루틴별 통계',
                child: SingleChildScrollView(
                  child: GapColumn(
                    gap: 24,
                    children: [
                      StreakContainer(
                        periodStatData: snapshot.data!,
                      ),
                      const Column(
                        children: [
                          CalendarWidget(),
                          Divider(height: 0),
                          ConductRoutineHistory()
                          // DailyRoutineReportContainer(),
                        ],
                      ),
                      const RoutineReview(),
                    ],
                  ),
                ));
          } else {
            return const Center(child: Text('nodata'));
          }
        });
  }
}

class StatisticsWeeklyDetail extends StatelessWidget {
  const StatisticsWeeklyDetail({super.key});

  @override
  Widget build(BuildContext context) {
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
      child: const PaddingContainer(
        child: GapColumn(
          gap: 32,
          children: [
            GapColumn(
              gap: 8,
              children: [
                Text("홍길동 님의\n일주일 루틴이에요", style: AppTextStyles.BOLD_20),
                Text("04.21 ~ 04.27", style: AppTextStyles.REGULAR_14),
              ],
            ),
            WeeklyRoutine(routineId: "0"),
            WeeklyRoutine(routineId: "0"),
            WeeklyRoutine(routineId: "0"),
          ],
        ),
      ),
    );
  }
}
