import 'package:dorun_app_flutter/common/component/custom_button.dart';
import 'package:dorun_app_flutter/common/component/custom_icon.dart';
import 'package:dorun_app_flutter/common/component/gap_column.dart';
import 'package:dorun_app_flutter/common/component/gap_row.dart';
import 'package:dorun_app_flutter/common/component/list_item.dart';
import 'package:dorun_app_flutter/common/component/padding_container.dart';
import 'package:dorun_app_flutter/common/constant/colors.dart';
import 'package:dorun_app_flutter/common/constant/fonts.dart';
import 'package:dorun_app_flutter/common/constant/spacing.dart';
import 'package:dorun_app_flutter/features/statistics/model/calendar_model.dart';
import 'package:dorun_app_flutter/features/statistics/model/header_model.dart';
import 'package:dorun_app_flutter/features/statistics/model/report_model.dart';
import 'package:dorun_app_flutter/features/statistics/repository/statistics_repository.dart';
import 'package:dorun_app_flutter/features/statistics/view/statistics_weekly_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class WeeklyRoutine extends StatelessWidget {
  final MaxFailedRoutine maxFailedRoutineLastWeek;
  final Map<String, String> routineWeeklyReport;

  const WeeklyRoutine({
    super.key,
    required this.maxFailedRoutineLastWeek,
    required this.routineWeeklyReport,
  });

  IconData _getIconForStatus(String status) {
    switch (status) {
      case "실패함":
        return Icons.close;
      case "완료됨":
        return Icons.check;
      case "건너뜀":
        return Icons.keyboard_double_arrow_right;
      case "삭제됨":
        return Icons.delete;
      default:
        return Icons.circle; // 기본적으로 아무것도 표시하지 않을 때 (생성되지 않음)
    }
  }

  Color _getColorForStatus(String status) {
    switch (status) {
      case "실패함":
        return AppColors.BRAND_SUB;
      case "완료됨":
        return AppColors.BRAND;
      case "건너뜀":
        return AppColors.TEXT_INVERT;
      case "삭제됨":
        return AppColors.TEXT_SECONDARY;
      default:
        return AppColors.TEXT_INVERT;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.BACKGROUND_SUB,
        borderRadius: AppRadius.ROUNDED_16,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GapColumn(
          gap: 16,
          children: [
            Text(
              maxFailedRoutineLastWeek.goal, // 목표 표시
              style: AppTextStyles.BOLD_14,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: routineWeeklyReport.entries.map((entry) {
                // 날짜 파싱
                DateTime date = DateTime.parse(entry.key);
                String dayOfWeek =
                    DateFormat.E('ko_KR').format(date); // 요일 가져오기
                String dayOfMonth = DateFormat.d().format(date); // 날짜 가져오기

                // 상태에 따른 아이콘
                IconData icon = _getIconForStatus(entry.value);

                // 상태가 "생성되지않음"인 경우에는 아이콘 대신 날짜 텍스트만 표시
                return GapColumn(
                  gap: 4,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    entry.value == "생성되지않음" || entry.value == "일정없음"
                        ? CustomIcon(
                            text: dayOfMonth, // 아이콘 대신 날짜 표시
                            primaryColor: AppColors.TEXT_INVERT,
                            size: 28,
                          )
                        : CustomIcon(
                            icon: icon,
                            primaryColor: _getColorForStatus(entry.value),
                            size: 28,
                          ),
                    Text(
                      dayOfWeek, // 요일 표시
                      style: AppTextStyles.REGULAR_12,
                    ),
                  ],
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class IconListView extends StatelessWidget {
  final String text;
  final IconData icon;
  final Color color;

  const IconListView({
    super.key,
    required this.text,
    required this.icon,
    this.color = AppColors.BRAND,
  });

  @override
  Widget build(BuildContext context) {
    return GapRow(
      gap: 8,
      children: [
        CustomIcon(
          icon: icon,
          primaryColor: color,
        ),
        Text(
          text,
          style: AppTextStyles.REGULAR_14,
        )
      ],
    );
  }
}

class CircularProgress extends StatelessWidget {
  final double outerThickness;
  final double innerThickness;
  final double progressNow;
  final double progressBefore;
  final double size;

  const CircularProgress({
    super.key,
    this.outerThickness = 10,
    this.innerThickness = 10,
    required this.progressNow,
    required this.progressBefore,
    this.size = 154.0,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: Size(size, size),
            painter: CirclePainter(
              progress: progressNow,
              thickness: outerThickness,
              color: AppColors.BRAND,
            ),
          ),
          SizedBox(
            width: size - outerThickness * 2,
            height: size - outerThickness * 2,
            child: CustomPaint(
              size: Size(size - outerThickness * 2, size - outerThickness * 2),
              painter: CirclePainter(
                progress: progressBefore,
                thickness: innerThickness,
                color: AppColors.TEXT_INVERT,
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${(progressNow * 100).toInt()}%',
                  style: AppTextStyles.BOLD_20.copyWith(
                    fontSize: 32,
                    color: AppColors.TEXT_BRAND,
                  ),
                ),
                Text(
                  '지난 주 ${(progressBefore * 100).toInt()}%',
                  style: AppTextStyles.REGULAR_12.copyWith(
                    color: AppColors.TEXT_SUB,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CirclePainter extends CustomPainter {
  final double progress;
  final double thickness;
  final Color color;

  CirclePainter({
    required this.progress,
    required this.thickness,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    double radius = (size.width / 2) - thickness / 2;
    Offset center = Offset(size.width / 2, size.height / 2);

    Paint baseCircle = Paint()
      ..color = color.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = thickness;

    Paint progressCircle = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = thickness
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, baseCircle);

    double sweepAngle = 2 * 3.141592653589793 * progress;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -3.141592653589793 / 2,
      sweepAngle,
      false,
      progressCircle,
    );
  }

  @override
  bool shouldRepaint(CirclePainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

class RoutineFeedbackContainer extends StatelessWidget {
  final MaxFailedRoutine maxFailedRoutineLastWeek;
  final Map<String, String> routineWeeklyReport;

  const RoutineFeedbackContainer({
    super.key,
    required this.maxFailedRoutineLastWeek,
    required this.routineWeeklyReport,
  });

  @override
  Widget build(BuildContext context) {
    return PaddingContainer(
      child: GapColumn(
        gap: 24,
        children: [
          GapColumn(
            gap: 8,
            children: [
              const Text("가장 어려워한 루틴", style: AppTextStyles.BOLD_20),
              Text(
                "단순한 루틴의 달성률이 통계적으로 더 높게 나타나요. 조금 더 간단하게 해보는 건 어떨까요?",
                style: AppTextStyles.REGULAR_14
                    .copyWith(color: AppColors.TEXT_SUB),
              ),
            ],
          ),
          WeeklyRoutine(
            maxFailedRoutineLastWeek: maxFailedRoutineLastWeek,
            routineWeeklyReport: routineWeeklyReport,
          )
        ],
      ),
    );
  }
}

class WeeklyRoutineReportContainer extends StatelessWidget {
  final Current current;
  final Progress progress;

  const WeeklyRoutineReportContainer({
    super.key,
    required this.current,
    required this.progress,
  });

  String getWeekRange() {
    DateTime now = DateTime.now();
    int currentWeekday = now.weekday;
    DateTime startOfWeek = now.subtract(Duration(days: currentWeekday - 1));
    DateTime endOfWeek =
        now.add(Duration(days: DateTime.daysPerWeek - currentWeekday));

    DateFormat formatter = DateFormat('MM.dd');
    String formattedStartOfWeek = formatter.format(startOfWeek);
    String formattedEndOfWeek = formatter.format(endOfWeek);

    return '$formattedStartOfWeek ~ $formattedEndOfWeek';
  }

  @override
  Widget build(BuildContext context) {
    return PaddingContainer(
      child: GapColumn(
        gap: 24,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GapColumn(
                gap: 8,
                children: [
                  RichText(
                    text: TextSpan(
                      text: "지난 주에 비해\n",
                      style: AppTextStyles.BOLD_20,
                      children: <TextSpan>[
                        TextSpan(
                          text: double.parse(progress.differentInWeeks) < 0
                              ? '${(double.parse(progress.differentInWeeks) * 100).toInt().abs()}% 조금\n부족했어요'
                              : '${(double.parse(progress.differentInWeeks) * 100).toInt()}% 더\n달성했어요',
                          style: const TextStyle(color: AppColors.TEXT_BRAND),
                        ),
                      ],
                    ),
                  ),
                  Text(getWeekRange(), style: AppTextStyles.REGULAR_14)
                ],
              ),
              CircularProgress(
                progressNow: double.parse(progress.lastWeekProgresds),
                progressBefore: double.parse(progress.twoWeeksAgoProgress),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const IconListView(
                text: '달성 루틴',
                icon: Icons.check,
                color: AppColors.BRAND,
              ),
              Text('${current.completed}개', style: AppTextStyles.BOLD_16)
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const IconListView(
                text: '실패 루틴',
                icon: Icons.close,
                color: AppColors.BRAND_SUB,
              ),
              Text('${current.failed}개', style: AppTextStyles.BOLD_16)
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const IconListView(
                text: '건너뛴 루틴',
                icon: Icons.keyboard_double_arrow_right,
                color: AppColors.TEXT_INVERT,
              ),
              Text('${current.passed}개', style: AppTextStyles.BOLD_16)
            ],
          ),
          CustomButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const StatisticsWeeklyDetail()),
              );
            },
            title: '자세히 보기',
            backgroundColor: AppColors.BRAND_SUB,
            foregroundColor: AppColors.TEXT_BRAND,
          )
        ],
      ),
    );
  }
}

class DailyRoutineReportContainer extends StatefulWidget {
  final DateTime selectedDate;
  final CalendarModel calendarData;

  const DailyRoutineReportContainer({
    super.key,
    required this.selectedDate,
    required this.calendarData,
  });

  @override
  DailyRoutineReportContainerState createState() =>
      DailyRoutineReportContainerState();
}

class DailyRoutineReportContainerState
    extends State<DailyRoutineReportContainer> {
  bool _isExpanded = false;

  void _toggleExpand() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate =
        DateFormat('MM월 dd일 EEEE', 'ko_KR').format(widget.selectedDate);

    return PaddingContainer(
      child: GapColumn(
        gap: 24,
        children: [
          GestureDetector(
            onTap: _toggleExpand,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GapRow(
                  gap: 16,
                  children: [
                    Text(formattedDate, style: AppTextStyles.REGULAR_14),
                    Row(
                      children: [
                        Text(
                          '성공 ${widget.calendarData.completed.length}',
                          style: AppTextStyles.BOLD_16
                              .copyWith(color: AppColors.TEXT_BRAND),
                        ),
                        const SizedBox(width: 8),
                        Text("실패 ${widget.calendarData.failed.length}",
                            style: AppTextStyles.MEDIUM_16),
                        const SizedBox(width: 8),
                        Text("넘김 ${widget.calendarData.passed.length}",
                            style: AppTextStyles.MEDIUM_16
                                .copyWith(color: AppColors.TEXT_INVERT)),
                      ],
                    ),
                  ],
                ),
                Icon(
                  _isExpanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  size: 30,
                ),
              ],
            ),
          ),
          if (_isExpanded)
            GapColumn(
              gap: 24,
              children: [
                ...widget.calendarData.completed.map(
                  (item) => IconListView(
                    text: item,
                    icon: Icons.check,
                    color: AppColors.BRAND,
                  ),
                ),
                ...widget.calendarData.failed.map(
                  (item) => IconListView(
                    text: item,
                    icon: Icons.close,
                    color: AppColors.TEXT_INVERT,
                  ),
                ),
                ...widget.calendarData.passed.map(
                  (item) => IconListView(
                    text: item,
                    icon: Icons.keyboard_double_arrow_right,
                    color: AppColors.BRAND_SUB,
                  ),
                ),
              ],
            )
        ],
      ),
    );
  }
}

class StreakContainer extends ConsumerWidget {
  const StreakContainer({
    super.key,
  });

  @override
  Widget build(BuildContext context, ref) {
    final statisticsRepository = ref.watch(statisticsRepositoryProvider);

    return FutureBuilder<HeaderModel>(
      future: statisticsRepository.getStatistics(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasData) {
          final statistics = snapshot.data!;

          return PaddingContainer(
            child: GapColumn(
              gap: 24,
              children: [
                RichText(
                  text: TextSpan(
                    text: '지금까지 ',
                    style: AppTextStyles.BOLD_20,
                    children: <TextSpan>[
                      TextSpan(
                        text: '연속 ${statistics.recentStreak}일 ',
                        style: AppTextStyles.BOLD_20
                            .copyWith(color: AppColors.TEXT_BRAND),
                      ),
                      TextSpan(
                        text:
                            '동안 \n루틴을 ${(statistics.recentPerformanceRate).toInt()}% 달성했어요',
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('최고 연속 달성', style: AppTextStyles.REGULAR_14),
                    Text('${statistics.maxStreak}일',
                        style: AppTextStyles.BOLD_16),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('누적 달성', style: AppTextStyles.REGULAR_14),
                    Text(
                      '${statistics.totalProcessDays}일',
                      style: AppTextStyles.BOLD_16,
                    ),
                  ],
                ),
              ],
            ),
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        }

        return const Center(child: Text("No data"));
      },
    );
  }
}

class ConductRoutineHistory extends StatefulWidget {
  const ConductRoutineHistory({super.key});

  @override
  ConductRoutineHistoryState createState() => ConductRoutineHistoryState();
}

class ConductRoutineHistoryState extends State<ConductRoutineHistory> {
  bool _isExpanded = false;

  void _toggleExpand() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return PaddingContainer(
      child: GapColumn(
        gap: 24,
        children: [
          GestureDetector(
            onTap: _toggleExpand,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Text(
                      "수행시간: ",
                      style: AppTextStyles.REGULAR_16,
                    ),
                    Text(
                      "82분 41초",
                      style: AppTextStyles.BOLD_16.copyWith(
                        color: AppColors.TEXT_BRAND,
                      ),
                    ),
                  ],
                ),
                Icon(_isExpanded
                    ? Icons.keyboard_arrow_up
                    : Icons.keyboard_arrow_down),
              ],
            ),
          ),
          if (_isExpanded)
            const GapColumn(
              gap: 24,
              children: [
                ListItem(routineId: 0, title: "창문열기"),
                ListItem(routineId: 0, title: "창문열기"),
                ListItem(routineId: 0, title: "창문열기"),
                ListItem(routineId: 0, title: "창문열기"),
              ],
            ),
        ],
      ),
    );
  }
}

class RoutineReview extends StatelessWidget {
  const RoutineReview({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const PaddingContainer(
      child: GapColumn(
        gap: 16,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GapColumn(
                gap: 2,
                children: [
                  Text("루틴 회고", style: AppTextStyles.BOLD_20),
                  Text("2024. 04. 22", style: AppTextStyles.REGULAR_12),
                ],
              ),
              SizedBox(
                height: 80,
              )
            ],
          ),
          Text(
            "루틴 회고 텍스트가 들어가는 공간입니다. 루틴 회고 텍스트가 들어가는 공간입니다. 루틴 회고 텍스트가 들어가는 공간입니다. 루틴 회고 텍스트가 들어가는 공간입니다. 루틴 회고 텍스트가 들어가는 공간입니다. 루틴 회고 텍스트가 들어가는 공간입니다. 루틴 회고 텍스트가 들어가는 공간입니다. 루틴 회고 텍스트가 들어가는 공간입니다. ",
            style: AppTextStyles.REGULAR_12,
          )
        ],
      ),
    );
  }
}
