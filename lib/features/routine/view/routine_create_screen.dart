import 'package:dorun_app_flutter/common/component/custom_button.dart';
import 'package:dorun_app_flutter/common/component/custom_icon.dart';
import 'package:dorun_app_flutter/common/component/gap_column.dart';
import 'package:dorun_app_flutter/common/component/gap_row.dart';
import 'package:dorun_app_flutter/common/component/input_box.dart';
import 'package:dorun_app_flutter/common/constant/colors.dart';
import 'package:dorun_app_flutter/common/constant/fonts.dart';
import 'package:dorun_app_flutter/common/layout/default_layout.dart';
import 'package:dorun_app_flutter/features/routine/view/routine_create_progress_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../common/constant/data.dart';

String _formattedTime(DateTime? time) {
  String formattedTime = '알림 없음';
  if (time == null) return formattedTime;

  if (time.hour > 0) {
    formattedTime = '${time.hour}시간 ${time.minute}분 전';
  } else {
    formattedTime = '${time.minute}분 전';
  }
  return formattedTime;
}

class RoutineCreateScreen extends StatefulWidget {
  static String get routeName => 'routineCreate';
  const RoutineCreateScreen({super.key});

  @override
  State<RoutineCreateScreen> createState() => _RoutineCreateScreenState();
}

class _RoutineCreateScreenState extends State<RoutineCreateScreen> {
  final TextEditingController _textController = TextEditingController();
  String? _routineGoal;
  DateTime? _selectedTime;
  RepeatCycle? _repeatCycle;
  final List<bool> _weekDays = List.filled(7, false);
  DateTime? _alertTime;
  List<String> guideQuestions = [
    '이루고자 하시는 루틴이 무엇인가요?',
    '몇시에 시작하시나요?',
    '어느 요일에 반복하시나요?',
    '시작 전에 알람 드릴까요?'
  ];

  String getCurrentGuideQuestion() {
    if (_routineGoal == null) {
      return guideQuestions[0];
    } else if (_selectedTime == null) {
      return guideQuestions[1];
    } else if (_repeatCycle == null) {
      return guideQuestions[2];
    } else if (_alertTime == null) {
      return guideQuestions[3];
    } else {
      return "시간이 되면 알려드릴까요?";
    }
  }

  void _setRoutineGoal(String value) {
    setState(() {
      _routineGoal = value;
    });
    if (_selectedTime == null) {
      _setStartTime(context);
    }
  }

  Future<void> _setStartTime(BuildContext context) async {
    DateTime tempSelectedTime = DateTime.now();
    DateTime initialDateTime = DateTime.now();

    if (_selectedTime != null) {
      initialDateTime = DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
        _selectedTime!.hour,
        _selectedTime!.minute,
      );
    }

    await showModalBottomSheet(
      context: context,
      builder: (BuildContext builder) {
        return SizedBox(
          height: 375,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: GapColumn(
              gap: 24,
              children: [
                const Text('몇시에 시작하시나요?', style: AppTextStyles.BOLD_20),
                Expanded(
                  child: CupertinoDatePicker(
                    mode: CupertinoDatePickerMode.time,
                    initialDateTime: initialDateTime,
                    onDateTimeChanged: (DateTime newTime) {
                      tempSelectedTime = newTime;
                    },
                  ),
                ),
                CustomButton(
                  onPressed: () {
                    setState(() {
                      _selectedTime = tempSelectedTime;
                    });
                    Navigator.of(context).pop();
                  },
                  title: "저장",
                  backgroundColor: AppColors.BRAND_SUB,
                  foregroundColor: AppColors.TEXT_BRAND,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _setAlertTime(BuildContext context) async {
    await showModalBottomSheet(
      context: context,
      builder: (BuildContext builder) {
        return SizedBox(
          height: 375,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
            child: GapColumn(
              children: [
                const Text('얼마전에 알람 드릴까요?', style: AppTextStyles.BOLD_20),
                Expanded(
                  child: CupertinoTimerPicker(
                    mode: CupertinoTimerPickerMode.hm,
                    initialTimerDuration: const Duration(minutes: 10),
                    minuteInterval: 1,
                    onTimerDurationChanged: (Duration newDuration) {
                      int hours = newDuration.inHours;
                      int minutes = newDuration.inMinutes % 60;
                      setState(() {
                        final now = DateTime.now();
                        _alertTime = DateTime(
                            now.year, now.month, now.day, hours, minutes);
                      });
                    },
                  ),
                ),
                GapRow(
                  gap: 16,
                  children: [
                    Expanded(
                      child: CustomButton(
                        onPressed: () {
                          setState(() {
                            _alertTime = null;
                          });
                          Navigator.of(context).pop();
                        },
                        title: '알림 없이',
                        backgroundColor: AppColors.BRAND_SUB,
                        foregroundColor: AppColors.TEXT_BRAND,
                      ),
                    ),
                    Expanded(
                      child: CustomButton(
                        onPressed: () {
                          setState(() {
                            final now = DateTime.now();
                            _alertTime ??=
                                DateTime(now.year, now.month, now.day, 0, 10);
                          });

                          Navigator.of(context).pop();
                        },
                        title: '저장',
                        backgroundColor: AppColors.BRAND_SUB,
                        foregroundColor: AppColors.TEXT_BRAND,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildRepeatOptionButton(String label, RepeatCycle cycle) {
    bool isSelected = _repeatCycle == cycle;
    return CustomButton(
      onPressed: () {
        setState(() {
          _repeatCycle = cycle;
        });
      },
      title: label,
      foregroundColor: isSelected ? AppColors.BRAND : AppColors.TEXT_SECONDARY,
      backgroundColor:
          isSelected ? AppColors.BRAND_SUB : AppColors.BACKGROUND_SUB,
    );
  }

  Widget _buildDayButton(String dayLabel, int index) {
    bool isSelected = _weekDays[index];
    return GestureDetector(
      onTap: () {
        setState(() {
          _weekDays[index] = !isSelected;
        });
      },
      child: CustomIcon(
        size: 36,
        text: dayLabel,
        primaryColor:
            isSelected ? AppColors.BRAND_SUB : AppColors.BACKGROUND_SUB,
        secondaryColor: isSelected ? AppColors.BRAND : AppColors.TEXT_SECONDARY,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: "생성하기",
      backgroundColor: Colors.white,
      child: Container(
        height: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: GapColumn(
                  gap: 16,
                  children: <Widget>[
                    Text(getCurrentGuideQuestion(),
                        style: AppTextStyles.BOLD_20),
                    if (_routineGoal != null &&
                        _selectedTime != null &&
                        _repeatCycle != null)
                      ReadOnlyBox(
                        hintText: '알림 시간',
                        inputText: _formattedTime(_alertTime),
                        onTap: () {
                          _setAlertTime(context);
                        },
                      ),
                    if (_routineGoal != null && _selectedTime != null)
                      GapColumn(
                        gap: 16,
                        children: [
                          const Text(
                            "반복 요일",
                            style: AppTextStyles.MEDIUM_12,
                          ),
                          GapRow(
                            gap: 16,
                            children: [
                              Expanded(
                                child: _buildRepeatOptionButton(
                                    '매일', RepeatCycle.daily),
                              ),
                              Expanded(
                                child: _buildRepeatOptionButton(
                                    '평일', RepeatCycle.weekdays),
                              ),
                            ],
                          ),
                          GapRow(
                            gap: 16,
                            children: [
                              Expanded(
                                child: _buildRepeatOptionButton(
                                    '주말', RepeatCycle.weekends),
                              ),
                              Expanded(
                                child: _buildRepeatOptionButton(
                                    '직접 선택', RepeatCycle.custom),
                              ),
                            ],
                          ),
                          if (_repeatCycle == RepeatCycle.custom)
                            GapRow(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: List.generate(7, (index) {
                                return _buildDayButton(
                                  ['월', '화', '수', '목', '금', '토', '일'][index],
                                  index,
                                );
                              }),
                            ),
                        ],
                      ),
                    if (_routineGoal != null)
                      ReadOnlyBox(
                        hintText: '시작 시간',
                        inputText: _selectedTime != null
                            ? DateFormat('a hh:mm', 'ko_KR')
                                .format(_selectedTime!)
                            : '',
                        onTap: () {
                          _setStartTime(context);
                        },
                      ),
                    InputBox(
                      controller: _textController,
                      hintText: '루틴 목표',
                      onSubmitted: _setRoutineGoal,
                    ),
                  ],
                ),
              ),
            ),
            if (_routineGoal != null &&
                _selectedTime != null &&
                _repeatCycle != null &&
                _alertTime != null)
              CustomButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RoutineCreateProgressScreen(
                        routineGoal: _routineGoal!,
                        startTime: _selectedTime!,
                        weekDays: createRepeatDays(_repeatCycle!, _weekDays),
                        alertTime: _alertTime!,
                      ),
                    ),
                  );
                },
                title: "완료하기",
                backgroundColor: AppColors.BRAND_SUB,
                foregroundColor: AppColors.TEXT_BRAND,
              ),
          ],
        ),
      ),
    );
  }
}

List<bool> createRepeatDays(RepeatCycle repeatCycle, List<bool> weekDays) {
  switch (repeatCycle) {
    case RepeatCycle.daily:
      return List<bool>.filled(7, true);
    case RepeatCycle.weekdays:
      return [true, true, true, true, true, false, false];
    case RepeatCycle.weekends:
      return [false, false, false, false, false, true, true];
    case RepeatCycle.custom:
      return weekDays;
    default:
      return List<bool>.filled(7, false);
  }
}
