import 'dart:async';

import 'package:dorun_app_flutter/common/component/custom_button.dart';
import 'package:dorun_app_flutter/common/component/gap_column.dart';
import 'package:dorun_app_flutter/common/component/gap_row.dart';
import 'package:dorun_app_flutter/common/component/list_item.dart';
import 'package:dorun_app_flutter/common/component/padding_container.dart';
import 'package:dorun_app_flutter/common/constant/colors.dart';
import 'package:dorun_app_flutter/common/constant/data.dart';
import 'package:dorun_app_flutter/common/constant/fonts.dart';
import 'package:dorun_app_flutter/common/constant/spacing.dart';
import 'package:dorun_app_flutter/common/layout/default_layout.dart';
import 'package:dorun_app_flutter/features/routine/model/routine_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

enum TimerState { start, pause, stop }

enum TimerHandleState { rest, passed, complete, pause, start }

class RoutineProceedScreen extends StatefulWidget {
  static String get routeName => 'routineProceed';
  final int id;
  const RoutineProceedScreen({super.key, required this.id});

  @override
  State<RoutineProceedScreen> createState() => _RoutineProceedScreenState();
}

class _RoutineProceedScreenState extends State<RoutineProceedScreen> {
  Routine? routine;
  RoutineHistory? routineHistory;
  int currentSubRoutineIndex = 0;
  Timer? timer;
  int remainingTime = 0;
  TimerState timerState = TimerState.stop;

  @override
  void initState() {
    super.initState();
    updateRoutineHistory();
    remainingTime = getRoutineById(widget.id)!
        .subRoutines[currentSubRoutineIndex]
        .durationSecond;
  }

  void updateRoutineHistory() {
    setState(() {
      routineHistory = RoutineHistory(
        id: widget.id,
        histories: getRoutineById(widget.id)!
            .subRoutines
            .map((data) => SubRoutineHistory(
                  id: data.id,
                  durationSecond: data.durationSecond,
                  state: RoutineHistoyState.passed,
                ))
            .toList(),
      );
    });
  }

  Routine? getRoutineById(int id) {
    try {
      return routineMockData.firstWhere((routine) => routine.id == id);
    } catch (e) {
      return routineMockData[0];
    }
  }

  void startTimer() {
    setState(() {
      timerState = TimerState.start;
    });
    timer?.cancel();
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        remainingTime--;
      });
    });
  }

  void pauseTimer() {
    setState(() {
      timerState = TimerState.pause;
    });
    timer?.cancel();
  }

  void completeTimer() {
    setState(() {
      routineHistory!.histories[currentSubRoutineIndex]
          .setDurtaionTime(remainingTime);

      if (routineHistory!.histories.length > currentSubRoutineIndex + 1) {
        remainingTime = routineHistory!
            .histories[currentSubRoutineIndex + 1].durationSecond;
        currentSubRoutineIndex++;
        startTimer();
      } else {
        context.go('/routine_review_edit/${widget.id}');
      }
    });
  }

  void passedTimer() {
    setState(() {
      if (routineHistory!.histories.length > currentSubRoutineIndex + 1) {
        remainingTime = routineHistory!
            .histories[currentSubRoutineIndex + 1].durationSecond;
        currentSubRoutineIndex++;
        startTimer();
      } else {
        context.go('/routine_review_edit/${widget.id}');
      }
    });
  }

  void handleTimerState(TimerHandleState timerHandleState) {
    switch (timerHandleState) {
      case TimerHandleState.complete:
        // 완료하기
        completeTimer();
        break;
      case TimerHandleState.passed:
        // 건너뛰기
        passedTimer();
        break;
      case TimerHandleState.pause:
        //일시정지
        pauseTimer();
        break;
      case TimerHandleState.rest:
        //쉬어가기
        context.go('/routine_review_edit/${widget.id}');
        break;
      case TimerHandleState.start:
        //다시시작
        startTimer();
        break;
    }
  }

  String formatTime(int seconds) {
    bool isNegative = seconds < 0;
    Duration duration = Duration(seconds: seconds.abs());
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    String formattedTime = "$twoDigitMinutes:$twoDigitSeconds";

    return isNegative ? "-$formattedTime" : " $formattedTime";
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      rightIcon: IconButton(
        icon: const Icon(Icons.close, size: 30),
        onPressed: () {
          context.go('/');
        },
      ),
      // TODO 리팩토링해서 3개 위젯으로 분리하기
      child: GapColumn(
        gap: 16,
        children: [
          PaddingContainer(
            width: double.infinity,
            child: GapColumn(
              gap: 24,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: const BoxDecoration(
                    color: AppColors.BACKGROUND_SUB,
                    borderRadius: AppRadius.ROUNDED_16,
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: Text(
                          getRoutineById(widget.id)!
                              .subRoutines[currentSubRoutineIndex]
                              .name,
                          style: AppTextStyles.BOLD_16,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 32.0),
                        child: Text(
                          formatTime(remainingTime),
                          style: AppTextStyles.BOLD_16.copyWith(
                            fontSize: 50,
                            color: remainingTime > 0
                                ? Colors.black
                                : AppColors.Red,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24.0),
                  child: GapColumn(
                    gap: 24,
                    children: [
                      GapRow(
                        gap: 10,
                        children: [
                          Expanded(
                            child: CustomButton(
                              onPressed: () {
                                handleTimerState(
                                  timerState == TimerState.stop
                                      ? TimerHandleState.rest
                                      : timerState == TimerState.start
                                          ? TimerHandleState.pause
                                          : TimerHandleState.start,
                                );
                              },
                              title: timerState == TimerState.stop
                                  ? '쉬어가기'
                                  : timerState == TimerState.start
                                      ? '일시정지'
                                      : '다시시작',
                              backgroundColor: AppColors.BRAND_SUB,
                              foregroundColor: AppColors.TEXT_BRAND,
                            ),
                          ),
                          if (timerState != TimerState.pause)
                            Expanded(
                              child: CustomButton(
                                onPressed: () {
                                  handleTimerState(
                                    timerState == TimerState.stop
                                        ? TimerHandleState.start
                                        : TimerHandleState.passed,
                                  );
                                },
                                title: timerState == TimerState.stop
                                    ? '수행하기'
                                    : '건너뛰기',
                                backgroundColor: timerState == TimerState.stop
                                    ? AppColors.BRAND
                                    : AppColors.BRAND_SUB,
                                foregroundColor: timerState == TimerState.stop
                                    ? Colors.white
                                    : AppColors.TEXT_BRAND,
                              ),
                            )
                        ],
                      ),
                      if (timerState == TimerState.start)
                        CustomButton(
                          onPressed: () {
                            handleTimerState(TimerHandleState.complete);
                          },
                          title: '완료하기',
                          backgroundColor: AppColors.BRAND,
                          foregroundColor: Colors.white,
                        )
                    ],
                  ),
                )
              ],
            ),
          ),
          PaddingContainer(
            child: GapColumn(
              gap: 16,
              children: getRoutineById(widget.id)!
                  .subRoutines
                  .asMap()
                  .entries
                  .map((entry) {
                int index = entry.key;
                SubRoutine data = entry.value;
                return ListItem(
                  id: data.id,
                  title: data.name,
                  routinEmoji: data.emoji,
                  subTitle: '${(data.durationSecond ~/ 60).toString()}분',
                  isDone: index < currentSubRoutineIndex,
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
