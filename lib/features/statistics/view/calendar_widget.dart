import 'package:dorun_app_flutter/common/component/custom_button.dart';
import 'package:dorun_app_flutter/common/component/custom_icon.dart';
import 'package:dorun_app_flutter/common/component/gap_column.dart';
import 'package:dorun_app_flutter/common/component/padding_container.dart';
import 'package:dorun_app_flutter/common/constant/colors.dart';
import 'package:dorun_app_flutter/common/constant/fonts.dart';
import 'package:dorun_app_flutter/common/constant/spacing.dart';
import 'package:dorun_app_flutter/features/routine/model/routine_model.dart';
import 'package:dorun_app_flutter/features/statistics/model/calendar_model.dart';
import 'package:dorun_app_flutter/features/statistics/repository/statistics_repository.dart';
import 'package:dorun_app_flutter/features/statistics/view/component.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class CalendarWidget extends ConsumerStatefulWidget {
  final RoutineModel? routine;

  const CalendarWidget({super.key, this.routine});

  @override
  CalendarWidgetState createState() => CalendarWidgetState();
}

class CalendarWidgetState extends ConsumerState<CalendarWidget> {
  DateTime _selectedDate =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  DateTime _focusedDate = DateTime.now();
  late Future<List<CalendarModel>> calendarDataFuture;
  DateTime _tempSelectedDate = DateTime.now();
  late Future<Map<String, CalendarModel>>? _calendarDataFuture;
  late Future<Map<String, RoutineCalendarModel>>? _routineCalendarDataFuture;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (widget.routine != null) {
      _routineCalendarDataFuture = _getRoutineCalendarData();
    } else {
      _calendarDataFuture = _getCalendarData();
    }
  }

  Future<Map<String, CalendarModel>> _getCalendarData() {
    final statisticsRepository = ref.watch(statisticsRepositoryProvider);

    return statisticsRepository.getCalendarData(
      _focusedDate.month,
      _focusedDate.year,
    );
  }

  Future<Map<String, RoutineCalendarModel>> _getRoutineCalendarData() {
    final statisticsRepository = ref.watch(statisticsRepositoryProvider);

    return statisticsRepository.getRoutineCalendarData(
      widget.routine!.id,
      _focusedDate.month,
      _focusedDate.year,
    );
  }

  void _onDaySelected(DateTime selectedDay) {
    setState(() {
      _selectedDate = selectedDay;
    });
  }

  void _onMonthChanged(int increment) {
    setState(() {
      _focusedDate =
          DateTime(_focusedDate.year, _focusedDate.month + increment, 1);
      if (widget.routine != null) {
        _routineCalendarDataFuture = _getRoutineCalendarData();
      } else {
        _calendarDataFuture = _getCalendarData();
      }
    });
  }

  void _showDatePicker(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext builder) {
          return Container(
            height: 350,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: AppRadius.ROUNDED_16,
            ),
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
                        const Text("날짜를 선택해주세요", style: AppTextStyles.BOLD_20),
                        IconButton(
                          icon: const Icon(Icons.close, size: 30),
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
                    onPressed: () {
                      setState(() {
                        _selectedDate = _tempSelectedDate;
                        _focusedDate = DateTime(
                          _tempSelectedDate.year,
                          _tempSelectedDate.month,
                          1,
                        );
                        if (widget.routine != null) {
                          _routineCalendarDataFuture =
                              _getRoutineCalendarData();
                        } else {
                          _calendarDataFuture = _getCalendarData();
                        }
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
    return FutureBuilder(
      future: widget.routine == null
          ? _calendarDataFuture
          : _routineCalendarDataFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Column(
            children: [
              PaddingContainer(
                child: Column(
                  children: [
                    _buildHeader(),
                    _buildCalendar(null),
                  ],
                ),
              ),
              const Divider(height: 0),
              DailyRoutineReportContainer(
                selectedDate: _selectedDate,
                calendarData: CalendarModel(
                  completed: [],
                  failed: [],
                  passed: [],
                ),
              ),
            ],
          );
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (snapshot.hasData) {
          Map<String, CalendarModel> calendarData;
          late Map<String, RoutineCalendarModel> routineCalendarData;

          if (widget.routine != null) {
            calendarData = parseCalendarData(
                snapshot.data! as Map<String, RoutineCalendarModel>);
            routineCalendarData =
                snapshot.data! as Map<String, RoutineCalendarModel>;
          } else {
            calendarData = snapshot.data! as Map<String, CalendarModel>;
          }

          return Column(
            children: [
              PaddingContainer(
                child: Column(
                  children: [
                    _buildHeader(),
                    // _buildDaysOfWeek(),
                    _buildCalendar(calendarData),
                  ],
                ),
              ),
              const Divider(height: 0),
              widget.routine == null
                  ? DailyRoutineReportContainer(
                      selectedDate: _selectedDate,
                      calendarData:
                          calendarData[_selectedDate.day.toString()] ??
                              CalendarModel(
                                completed: [],
                                failed: [],
                                passed: [],
                              ),
                    )
                  : ConductRoutineHistory(
                      routineData:
                          routineCalendarData[_selectedDate.day.toString()]!,
                    ),
              const SizedBox(height: 24),
              if (widget.routine != null)
                RoutineReview(
                  routineReview:
                      routineCalendarData[_selectedDate.day.toString()]!
                          .routineReview,
                ),
            ],
          );
        } else {
          return const Center(child: Text("No Data"));
        }
      },
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(Icons.chevron_left, size: 30),
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
          icon: const Icon(Icons.chevron_right, size: 30),
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

  Widget _buildCalendar(Map<String, CalendarModel>? calendarData) {
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
        }

        final day = daysInMonth[index - daysBefore];
        final date = DateTime(_focusedDate.year, _focusedDate.month, day);
        final isSelected = date == _selectedDate;

        // calendarData가 null인 경우 기본 UI 제공
        if (calendarData == null) {
          return date.isAfter(
            DateTime(
              DateTime.now().year,
              DateTime.now().month,
              DateTime.now().day,
            ),
          )
              ? CustomIcon(
                  size: 32,
                  text: day.toString(),
                  primaryColor: Colors.transparent,
                  secondaryColor: Colors.black,
                )
              : CustomIcon(
                  size: 32,
                  text: day.toString(),
                  primaryColor: Colors.transparent,
                  secondaryColor: AppColors.TEXT_SUB,
                );
        }

        // 날짜에 해당하는 CalendarModel을 가져옴
        final calendarModel = calendarData[day.toString()] ??
            CalendarModel(completed: [], failed: [], passed: []);

        // 완료 여부 확인
        final completeProgress =
            (calendarModel.completed.length + calendarModel.passed.length) /
                (calendarModel.completed.length +
                    calendarModel.failed.length +
                    calendarModel.passed.length);
        final isComplete = completeProgress == 1;

        return GestureDetector(
          onTap: () => _onDaySelected(date),
          child: Container(
            decoration: BoxDecoration(
              color: isSelected ? AppColors.BRAND_SUB : Colors.transparent,
              shape: BoxShape.circle,
            ),
            child: date.isAfter(
              DateTime(
                DateTime.now().year,
                DateTime.now().month,
                DateTime.now().day - 1,
              ),
            )
                ? CustomIcon(
                    size: 32,
                    text: day.toString(),
                    primaryColor: Colors.transparent,
                    secondaryColor: Colors.black,
                  )
                : calendarModel.completed.isNotEmpty ||
                        calendarModel.passed.isNotEmpty
                    ? CustomIcon(
                        size: 32,
                        progress: completeProgress,
                        primaryColor:
                            isComplete ? AppColors.BRAND : Colors.transparent,
                        secondaryColor:
                            isComplete ? Colors.white : AppColors.BRAND,
                        icon: Icons.check,
                      )
                    : CustomIcon(
                        size: 32,
                        text: day.toString(),
                        primaryColor: Colors.transparent,
                        secondaryColor: AppColors.TEXT_SUB,
                      ),
          ),
        );
      },
    );
  }
}

Map<String, CalendarModel> parseCalendarData(
    Map<String, RoutineCalendarModel> inputData) {
  Map<String, CalendarModel> calendarData = {};

  // 입력 데이터를 순회하면서 상태를 확인
  inputData.forEach((key, value) {
    String status = value.status;

    // 새로운 CalendarModel 객체 생성
    CalendarModel calendarModel = CalendarModel(
      completed: [],
      failed: [],
      passed: [],
    );

    // 상태에 따라 값을 리스트에 추가
    switch (status) {
      case "완료됨":
        calendarModel.completed.add(key);
        break;
      case "실패함" || "생성되지않음":
        calendarModel.failed.add(key);
        break;
      case "일정없음":
        calendarModel.passed.add(key);
        break;
      default:
        calendarModel.passed.add(key);
        // 상태가 다른 값인 경우, 필요에 따라 처리하거나 생략할 수 있음
        break;
    }

    // calendarData에 해당 일자의 CalendarModel 저장
    calendarData[key] = calendarModel;
  });

  return calendarData;
}
