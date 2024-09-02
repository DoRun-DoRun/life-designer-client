import 'dart:convert';

import 'package:dorun_app_flutter/common/component/custom_button.dart';
import 'package:dorun_app_flutter/common/component/custom_icon.dart';
import 'package:dorun_app_flutter/common/component/gap_column.dart';
import 'package:dorun_app_flutter/common/component/padding_container.dart';
import 'package:dorun_app_flutter/common/constant/colors.dart';
import 'package:dorun_app_flutter/common/constant/fonts.dart';
import 'package:dorun_app_flutter/common/constant/spacing.dart';
import 'package:dorun_app_flutter/features/statistics/model/calendar_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class CalendarWidget extends StatefulWidget {
  const CalendarWidget({super.key});

  @override
  CalendarWidgetState createState() => CalendarWidgetState();
}

class CalendarWidgetState extends State<CalendarWidget> {
  DateTime _selectedDate =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  DateTime _focusedDate = DateTime.now();
  DateTime _tempSelectedDate = DateTime.now();
  late Future<List<CalendarModel>> calendarDataFuture;

  @override
  void initState() {
    super.initState();
    calendarDataFuture = getCalendarData();
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
      calendarDataFuture = getCalendarData();
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
                            _tempSelectedDate.year, _tempSelectedDate.month, 1);
                        calendarDataFuture = getCalendarData();
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

  Future<List<CalendarModel>> getCalendarData() async {
    final routeFromJsonFile =
        await rootBundle.loadString('asset/json/calendar_mock.json');

    final List<dynamic> parsedJson = json.decode(routeFromJsonFile);
    return parsedJson
        .map((json) => CalendarModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return PaddingContainer(
      child: Column(
        children: [
          _buildHeader(),
          // _buildDaysOfWeek(),
          FutureBuilder<List<CalendarModel>>(
            future: calendarDataFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return _buildCalendar(null);
              }
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }

              if (snapshot.hasData) {
                return _buildCalendar(snapshot.data!);
              } else {
                return const Center(child: Text('noData'));
              }
            },
          ),
        ],
      ),
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

  Widget _buildCalendar(List<CalendarModel>? calendarData) {
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

        final calendarModel = calendarData.firstWhere(
          (item) =>
              item.date.year == date.year &&
              item.date.month == date.month &&
              item.date.day == date.day,
          orElse: () => CalendarModel(date, 0.0, 0, 0),
        );

        final isComplete = calendarModel.dailyProgress == 1;

        return GestureDetector(
          onTap: () => _onDaySelected(date),
          child: Container(
            decoration: BoxDecoration(
              color: isSelected ? AppColors.BRAND_SUB : Colors.transparent,
              shape: BoxShape.circle,
            ),
            child: (date.isAfter(
              DateTime(
                DateTime.now().year,
                DateTime.now().month,
                DateTime.now().day - 1,
              ),
            ))
                ? CustomIcon(
                    size: 32,
                    text: day.toString(),
                    primaryColor: Colors.transparent,
                    secondaryColor: Colors.black,
                  )
                : calendarModel.dailyProgress > 0
                    ? CustomIcon(
                        size: 32,
                        progress: isComplete ? 0 : calendarModel.dailyProgress,
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
                        secondaryColor:
                            isComplete ? Colors.black : AppColors.TEXT_SUB,
                      ),
          ),
        );
      },
    );
  }
}
