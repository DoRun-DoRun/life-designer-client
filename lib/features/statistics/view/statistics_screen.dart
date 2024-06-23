import 'package:dorun_app_flutter/common/component/custom_button.dart';
import 'package:dorun_app_flutter/common/component/custom_icon.dart';
import 'package:dorun_app_flutter/common/component/gap_column.dart';
import 'package:dorun_app_flutter/common/component/gap_row.dart';
import 'package:dorun_app_flutter/common/component/padding_container.dart';
import 'package:dorun_app_flutter/common/constant/colors.dart';
import 'package:dorun_app_flutter/common/constant/fonts.dart';
import 'package:dorun_app_flutter/common/constant/spacing.dart';
import 'package:dorun_app_flutter/common/layout/default_layout.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';

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
            title: const Text(
              '통계',
              style: AppTextStyles.MEDIUM_16,
            ),
            bottom: const TabBar(
                indicator: UnderlineTabIndicator(
                  borderSide: BorderSide(
                    width: 4,
                    color: AppColors.BRAND,
                  ),
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                labelColor: AppColors.TEXT_BRAND,
                unselectedLabelColor: AppColors.TEXT_SUB,
                tabs: [
                  Tab(
                    child: Text(
                      "기간별",
                      style: AppTextStyles.BOLD_14,
                    ),
                  ),
                  Tab(
                    child: Text(
                      "루틴별",
                      style: AppTextStyles.BOLD_14,
                    ),
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
    return SingleChildScrollView(
      child: GapColumn(
        gap: 24,
        children: [
          PaddingContainer(
            child: GapColumn(
              gap: 24,
              children: [
                RichText(
                  text: TextSpan(
                    text: '지금까지 ',
                    style: AppTextStyles.BOLD_20,
                    children: <TextSpan>[
                      TextSpan(
                        text: '연속 15일 ',
                        style: AppTextStyles.BOLD_20.copyWith(
                          color: AppColors.TEXT_BRAND,
                        ),
                      ),
                      const TextSpan(
                        text: '동안 \n루틴을 100% 달성했어요',
                      ),
                    ],
                  ),
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '최고 연속 달성',
                      style: AppTextStyles.REGULAR_14,
                    ),
                    Text(
                      '24일',
                      style: AppTextStyles.BOLD_16,
                    ),
                  ],
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '누적 연속 달성',
                      style: AppTextStyles.REGULAR_14,
                    ),
                    Text(
                      '24일',
                      style: AppTextStyles.BOLD_16,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Column(
            children: [
              const PaddingContainer(
                child: GapColumn(
                  children: [
                    CalendarWidget(),
                  ],
                ),
              ),
              const Divider(
                height: 0,
              ),
              PaddingContainer(
                child: GapColumn(
                  gap: 24,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        RichText(
                          text: const TextSpan(
                              style: AppTextStyles.REGULAR_16,
                              children: [
                                TextSpan(
                                  text: "완료1   ",
                                  style: TextStyle(
                                    color: AppColors.TEXT_BRAND,
                                  ),
                                ),
                                TextSpan(
                                  text: "실패2   ",
                                ),
                                TextSpan(
                                  text: "건너뜀1",
                                  style: TextStyle(
                                    color: AppColors.TEXT_SUB,
                                  ),
                                )
                              ]),
                        ),
                        const Icon(
                          size: 30,
                          Icons.keyboard_arrow_up_outlined,
                        )
                      ],
                    ),
                    const IconListView(
                      text: '아침 조깅하기',
                      icon: Icons.check,
                    ),
                    const IconListView(
                      text: '아침 조깅하기',
                      icon: Icons.close,
                      color: AppColors.BRAND_SUB,
                    ),
                  ],
                ),
              ),
            ],
          ),
          PaddingContainer(
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
                          text: const TextSpan(
                            text: "지난 주에 비해\n",
                            style: AppTextStyles.BOLD_20,
                            children: <TextSpan>[
                              TextSpan(
                                text: '12% 더\n달성했네요',
                                style: TextStyle(
                                  color: AppColors.TEXT_BRAND,
                                ),
                              )
                            ],
                          ),
                        ),
                        const Text(
                          "04.21 ~ 04.27",
                          style: AppTextStyles.REGULAR_14,
                        )
                      ],
                    ),
                    const CircularProgress(
                      progressNow: 0.6,
                      progressBefore: 0.48,
                    )
                  ],
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconListView(
                      text: '아침 조깅하기',
                      icon: Icons.close,
                      color: AppColors.BRAND_SUB,
                    ),
                    Text(
                      '24개',
                      style: AppTextStyles.BOLD_16,
                    )
                  ],
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconListView(
                      text: '아침 조깅하기',
                      icon: Icons.close,
                      color: AppColors.BRAND_SUB,
                    ),
                    Text(
                      '24개',
                      style: AppTextStyles.BOLD_16,
                    )
                  ],
                ),
                CustomButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const WeeklyDetail()),
                    );
                  },
                  title: '자세히 보기',
                  align: TextAlign.center,
                  backgroundColor: AppColors.BRAND_SUB,
                  foregroundColor: AppColors.TEXT_BRAND,
                )
              ],
            ),
          ),
          PaddingContainer(
            child: GapColumn(
              gap: 24,
              children: [
                GapColumn(
                  gap: 8,
                  children: [
                    const Text(
                      "최근 어려워한 루틴이에요",
                      style: AppTextStyles.BOLD_20,
                    ),
                    Text(
                      "단순한 루틴의 달성률이 68% 더 높게 나타나요.\n조금 더 간단하게 해보는 건 어떨까요?",
                      style: AppTextStyles.REGULAR_14.copyWith(
                        color: AppColors.TEXT_SUB,
                      ),
                    ),
                  ],
                ),
                const WeeklyRoutine()
              ],
            ),
          )
        ],
      ),
    );
  }
}

class WeeklyRoutine extends StatelessWidget {
  const WeeklyRoutine({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.BACKGROUND_SUB,
        borderRadius: AppRadius.ROUNDED_16,
      ),
      child: const Padding(
        padding: EdgeInsets.all(16.0),
        child: GapColumn(
          gap: 16,
          children: [
            Text(
              "아침 조깅하기",
              style: AppTextStyles.BOLD_14,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GapColumn(
                  gap: 4,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CustomIcon(
                      text: "07",
                      primaryColor: AppColors.TEXT_INVERT,
                      size: 28,
                    ),
                    Text(
                      "월",
                      style: AppTextStyles.REGULAR_12,
                    )
                  ],
                ),
                GapColumn(
                  gap: 4,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CustomIcon(
                      text: "07",
                      primaryColor: AppColors.TEXT_INVERT,
                      size: 28,
                    ),
                    Text(
                      "월",
                      style: AppTextStyles.REGULAR_12,
                    )
                  ],
                ),
                GapColumn(
                  gap: 4,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CustomIcon(
                      text: "07",
                      primaryColor: AppColors.TEXT_INVERT,
                      size: 28,
                    ),
                    Text(
                      "월",
                      style: AppTextStyles.REGULAR_12,
                    )
                  ],
                ),
                GapColumn(
                  gap: 4,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CustomIcon(
                      text: "07",
                      primaryColor: AppColors.TEXT_INVERT,
                      size: 28,
                    ),
                    Text(
                      "월",
                      style: AppTextStyles.REGULAR_12,
                    )
                  ],
                ),
                GapColumn(
                  gap: 4,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CustomIcon(
                      text: "07",
                      primaryColor: AppColors.TEXT_INVERT,
                      size: 28,
                    ),
                    Text(
                      "월",
                      style: AppTextStyles.REGULAR_12,
                    )
                  ],
                ),
                GapColumn(
                  gap: 4,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CustomIcon(
                      text: "07",
                      primaryColor: AppColors.TEXT_INVERT,
                      size: 28,
                    ),
                    Text(
                      "월",
                      style: AppTextStyles.REGULAR_12,
                    )
                  ],
                ),
                GapColumn(
                  gap: 4,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CustomIcon(
                      text: "07",
                      primaryColor: AppColors.TEXT_INVERT,
                      size: 28,
                    ),
                    Text(
                      "월",
                      style: AppTextStyles.REGULAR_12,
                    )
                  ],
                )
              ],
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

class StatisticsRoutineScreen extends StatelessWidget {
  const StatisticsRoutineScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
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

class CalendarWidget extends StatefulWidget {
  const CalendarWidget({super.key});

  @override
  CalendarWidgetState createState() => CalendarWidgetState();
}

class CalendarWidgetState extends State<CalendarWidget> {
  DateTime _selectedDate = DateTime.now();
  DateTime _focusedDate = DateTime.now();
  DateTime _tempSelectedDate = DateTime.now();

  void _onDaySelected(DateTime selectedDay) {
    setState(() {
      _selectedDate = selectedDay;
    });
  }

  void _onMonthChanged(int increment) {
    setState(() {
      _focusedDate =
          DateTime(_focusedDate.year, _focusedDate.month + increment, 1);
    });
  }

  void _showDatePicker(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext builder) {
          return Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: AppRadius.ROUNDED_16,
            ),
            // height: MediaQuery.of(context).copyWith().size.height / 3,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: GapColumn(
                gap: 24,
                children: [
                  SizedBox(
                    height: 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "날짜를 선택해주세요",
                          style: AppTextStyles.BOLD_20,
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.close,
                            size: 30,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: CupertinoDatePicker(
                      mode: CupertinoDatePickerMode.date,
                      initialDateTime: _selectedDate,
                      onDateTimeChanged: (DateTime newDate) {
                        setState(() {
                          _tempSelectedDate = newDate;
                        });
                      },
                    ),
                  ),
                  CustomButton(
                    title: "선택",
                    backgroundColor: AppColors.BRAND_SUB,
                    foregroundColor: AppColors.TEXT_BRAND,
                    align: TextAlign.center,
                    onPressed: () {
                      setState(() {
                        _selectedDate = _tempSelectedDate;
                        _focusedDate = DateTime(
                            _tempSelectedDate.year, _tempSelectedDate.month, 1);
                      });
                      Navigator.pop(context);
                    },
                  )
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildHeader(),
        // _buildDaysOfWeek(),
        _buildCalendar(),
      ],
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(
            Icons.chevron_left,
            size: 30,
          ),
          onPressed: () => _onMonthChanged(-1),
        ),
        Row(
          children: [
            Text(
              DateFormat('yyyy.MM').format(_focusedDate),
              style: AppTextStyles.REGULAR_14,
            ),
            IconButton(
              icon: const Icon(
                Icons.calendar_today,
                size: 24,
                color: AppColors.TEXT_INVERT,
              ),
              onPressed: () {
                _showDatePicker(context);
              },
            ),
          ],
        ),
        IconButton(
          icon: const Icon(
            Icons.chevron_right,
            size: 30,
          ),
          onPressed: () => _onMonthChanged(1),
        ),
      ],
    );
  }

  // Widget _buildDaysOfWeek() {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(vertical: 8.0),
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceAround,
  //       children: List.generate(7, (index) {
  //         return Text(
  //           DateFormat.E().format(DateTime(2022, 1, index + 3)),
  //           style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
  //         );
  //       }),
  //     ),
  //   );
  // }
  Widget _buildCalendar() {
    final firstDayOfMonth = DateTime(_focusedDate.year, _focusedDate.month, 1);
    final lastDayOfMonth =
        DateTime(_focusedDate.year, _focusedDate.month + 1, 0);
    final daysBefore = firstDayOfMonth.weekday - 1;
    final daysAfter = 7 - lastDayOfMonth.weekday;
    final daysInMonth = List.generate(lastDayOfMonth.day, (index) => index + 1);

    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(), // GridView가 스크롤을 막음
      shrinkWrap: true, // GridView가 Column 내에서 정상적으로 작동하도록 설정
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
      ),
      itemCount: daysBefore + daysInMonth.length + daysAfter,
      itemBuilder: (context, index) {
        if (index < daysBefore || index >= daysBefore + daysInMonth.length) {
          return Container();
        } else {
          final day = daysInMonth[index - daysBefore];
          final date = DateTime(_focusedDate.year, _focusedDate.month, day);
          final isSelected = date == _selectedDate;
          return GestureDetector(
            onTap: () => _onDaySelected(date),
            child: Container(
              decoration: BoxDecoration(
                color: isSelected ? AppColors.BRAND_SUB : Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: const BoxDecoration(
                    // color: AppColors.TEXT_INVERT,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      day.toString(),
                      style: AppTextStyles.REGULAR_12,
                    ),
                  ),
                ),
              ),
            ),
          );
        }
      },
    );
  }
}

class WeeklyDetail extends StatelessWidget {
  const WeeklyDetail({super.key});

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
                Text(
                  "홍길동 님의\n일주일 루틴이에요",
                  style: AppTextStyles.BOLD_20,
                ),
                Text(
                  "04.21 ~ 04.27",
                  style: AppTextStyles.REGULAR_14,
                ),
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
