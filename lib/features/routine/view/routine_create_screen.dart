import 'package:dorun_app_flutter/common/component/custom_bottom_sheet.dart';
import 'package:dorun_app_flutter/common/component/custom_button.dart';
import 'package:dorun_app_flutter/common/component/gap_column.dart';
import 'package:dorun_app_flutter/common/component/gap_row.dart';
import 'package:dorun_app_flutter/common/component/input_box.dart';
import 'package:dorun_app_flutter/common/constant/colors.dart';
import 'package:dorun_app_flutter/common/constant/fonts.dart';
import 'package:dorun_app_flutter/common/layout/default_layout.dart';
import 'package:dorun_app_flutter/common/utils/format.dart';
import 'package:dorun_app_flutter/features/routine/view/components/repeat_button.dart';
import 'package:dorun_app_flutter/features/routine/view/components/set_alert_time.dart';
import 'package:dorun_app_flutter/features/routine/view/routine_create_progress_screen.dart';
import 'package:dorun_app_flutter/features/search/model/search_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../common/constant/data.dart';

class RoutineCreateScreen extends StatefulWidget {
  static String get routeName => 'routineCreate';
  final RoutineTemplate? routineTemplate;

  const RoutineCreateScreen({super.key, this.routineTemplate});

  @override
  State<RoutineCreateScreen> createState() => _RoutineCreateScreenState();
}

class _RoutineCreateScreenState extends State<RoutineCreateScreen> {
  final TextEditingController _textController = TextEditingController();
  String? _routineGoal;
  Duration? _selectedTime;
  RepeatCycle? _repeatCycle;
  final List<bool> _weekDays = List.filled(7, false);
  Duration? _alertTime;
  List<String> guideQuestions = [
    '이루고자 하시는 루틴이 무엇인가요?',
    '몇시에 시작하시나요?',
    '어느 요일에 반복하시나요?',
    '시작 전에 알람 드릴까요?'
  ];

  @override
  void initState() {
    super.initState();

    if (widget.routineTemplate != null) {
      _routineGoal = widget.routineTemplate!.goal;
      _textController.text = _routineGoal!;
    }
  }

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
    Duration? selectedTime = await showTimeSelectionModal(
      context,
      initialTime: _selectedTime,
    );

    setState(() {
      _selectedTime = selectedTime;
    });
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
                        inputText: formattedAlertTime(_alertTime),
                        onTap: () async {
                          _alertTime = await setAlertTime(
                            context: context,
                            initialTime: _alertTime,
                          );
                          setState(() {});
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
                                child: buildRepeatOptionButton(
                                    '매일', _repeatCycle == RepeatCycle.daily,
                                    () {
                                  setState(() {
                                    _repeatCycle = RepeatCycle.daily;
                                  });
                                }),
                              ),
                              Expanded(
                                child: buildRepeatOptionButton(
                                    '평일', _repeatCycle == RepeatCycle.weekdays,
                                    () {
                                  setState(() {
                                    _repeatCycle = RepeatCycle.weekdays;
                                  });
                                }),
                              ),
                            ],
                          ),
                          GapRow(
                            gap: 16,
                            children: [
                              Expanded(
                                child: buildRepeatOptionButton(
                                    '주말', _repeatCycle == RepeatCycle.weekends,
                                    () {
                                  setState(() {
                                    _repeatCycle = RepeatCycle.weekends;
                                  });
                                }),
                              ),
                              Expanded(
                                child: buildRepeatOptionButton(
                                    '직접 선택', _repeatCycle == RepeatCycle.custom,
                                    () {
                                  setState(() {
                                    _repeatCycle = RepeatCycle.custom;
                                  });
                                }),
                              ),
                            ],
                          ),
                          if (_repeatCycle == RepeatCycle.custom)
                            GapRow(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: List.generate(
                                7,
                                (index) {
                                  return buildDayButton(
                                    ['일', '월', '화', '수', '목', '금', '토'][index],
                                    index,
                                    _weekDays[index],
                                    () {
                                      setState(() {
                                        _weekDays[index] = !_weekDays[index];
                                      });
                                    },
                                  );
                                },
                              ),
                            ),
                        ],
                      ),
                    if (_routineGoal != null)
                      ReadOnlyBox(
                        hintText: '시작 시간',
                        inputText: _selectedTime != null
                            ? DateFormat('a hh:mm', 'ko_KR')
                                .format(durationToDateTime(_selectedTime!))
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
                _repeatCycle != null)
              CustomButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RoutineCreateProgressScreen(
                        routineGoal: _routineGoal!,
                        startTime: _selectedTime!,
                        weekDays: createRepeatDays(_repeatCycle!, _weekDays),
                        alertTime: _alertTime,
                        subRoutines: widget.routineTemplate?.subRoutines,
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
