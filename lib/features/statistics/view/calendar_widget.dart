import 'package:dorun_app_flutter/common/component/custom_button.dart';
import 'package:dorun_app_flutter/common/component/gap_column.dart';
import 'package:dorun_app_flutter/common/component/padding_container.dart';
import 'package:dorun_app_flutter/common/constant/colors.dart';
import 'package:dorun_app_flutter/common/constant/fonts.dart';
import 'package:dorun_app_flutter/common/constant/spacing.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
    return PaddingContainer(
      child: Column(
        children: [
          _buildHeader(),
          // _buildDaysOfWeek(),
          _buildCalendar(),
        ],
      ),
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
