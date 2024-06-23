import 'package:dorun_app_flutter/common/component/gap_column.dart';
import 'package:dorun_app_flutter/common/component/list_item.dart';
import 'package:dorun_app_flutter/common/component/padding_container.dart';
import 'package:dorun_app_flutter/common/constant/colors.dart';
import 'package:dorun_app_flutter/common/constant/fonts.dart';
import 'package:dorun_app_flutter/common/layout/default_layout.dart';
import 'package:dorun_app_flutter/features/statistics/view/calendar_widget.dart';
import 'package:dorun_app_flutter/features/statistics/view/component.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ko', ''),
        Locale('en', ''),
      ],
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 2,
        child: DefaultLayout(
          customAppBar: AppBar(
            title: const Text('통계', style: AppTextStyles.MEDIUM_16),
            bottom: const TabBar(
                indicator: UnderlineTabIndicator(
                  borderSide: BorderSide(width: 4, color: AppColors.BRAND),
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                labelColor: AppColors.TEXT_BRAND,
                unselectedLabelColor: AppColors.TEXT_SUB,
                tabs: [
                  Tab(
                    child: Text("기간별", style: AppTextStyles.BOLD_14),
                  ),
                  Tab(
                    child: Text("루틴별", style: AppTextStyles.BOLD_14),
                  ),
                ]),
          ),
          child: const TabBarView(
            children: [
              StatisticsPeriodScreen(),
              StatisticsRoutineScreen(),
            ],
          ),
        ),
      ),
    );
  }
}

class StatisticsPeriodScreen extends StatelessWidget {
  const StatisticsPeriodScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: GapColumn(
        gap: 24,
        children: [
          StreakContainer(),
          Column(
            children: [
              CalendarWidget(),
              Divider(height: 0),
              DailyRoutineReportContainer(),
            ],
          ),
          WeeklyRoutineReportContainer(),
          RoutineFeedbackContainer()
        ],
      ),
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
          id: 0,
          title: "아침 조깅하기",
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const StatisticsRoutineDetail()),
            );
          },
        ),
        const ListItem(id: 0, title: "아침 조깅하기"),
        const ListItem(id: 0, title: "아침 조깅하기"),
        const ListItem(id: 0, title: "아침 조깅하기"),
        const ListItem(id: 0, title: "아침 조깅하기"),
      ],
    ));
  }
}

class StatisticsRoutineDetail extends StatelessWidget {
  const StatisticsRoutineDetail({super.key});

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
        ));
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
            WeeklyRoutine(),
            WeeklyRoutine(),
            WeeklyRoutine()
          ],
        ),
      ),
    );
  }
}
