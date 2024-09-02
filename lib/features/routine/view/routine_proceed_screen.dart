import 'dart:async';

import 'package:dorun_app_flutter/common/component/custom_button.dart';
import 'package:dorun_app_flutter/common/component/gap_column.dart';
import 'package:dorun_app_flutter/common/component/gap_row.dart';
import 'package:dorun_app_flutter/common/component/list_item.dart';
import 'package:dorun_app_flutter/common/component/padding_container.dart';
import 'package:dorun_app_flutter/common/constant/colors.dart';
import 'package:dorun_app_flutter/common/constant/fonts.dart';
import 'package:dorun_app_flutter/common/constant/spacing.dart';
import 'package:dorun_app_flutter/common/layout/default_layout.dart';
import 'package:dorun_app_flutter/common/utils/format.dart';
import 'package:dorun_app_flutter/features/routine/model/routine_model.dart';
import 'package:dorun_app_flutter/features/routine/provider/routine_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

enum TimerState { start, pause, stop }

enum TimerHandleState { rest, passed, complete, pause, start }

class RoutineProceedScreen extends ConsumerStatefulWidget {
  static String get routeName => 'routineProceed';
  final int id;
  const RoutineProceedScreen({super.key, required this.id});

  @override
  ConsumerState<RoutineProceedScreen> createState() =>
      _RoutineProceedScreenState();
}

class _RoutineProceedScreenState extends ConsumerState<RoutineProceedScreen> {
  DetailRoutineModel? routine;
  RoutineHistory? routineHistory;
  int currentIndex = 0;
  Timer? timer;
  int remainingTime = 0;
  TimerState timerState = TimerState.stop;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        ref.read(routineDetailProvider(widget.id).future).then((routineData) {
          if (routineData.subRoutines.isEmpty) {
            context.pushReplacement('/routine_detail/${routineData.id}');
          } else {
            setState(() {
              routine = routineData;
              remainingTime = routine!.subRoutines[currentIndex].duration;
              updateRoutineHistory();
            });
          }
        }).catchError((error) {
          print("오류 발생: $error");
        });
      },
    );
  }

  void updateRoutineHistory() {
    setState(() {
      routineHistory = RoutineHistory(
        routineId: widget.id,
        histories: routine!.subRoutines.map((data) {
          return SubRoutineHistory(
            subRoutine: data,
            duration: data.duration,
            state: RoutineHistoryState.passed,
          );
        }).toList(),
      );
    });
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
      final int originTime = routine!.subRoutines[currentIndex].duration;

      routineHistory!.setDurtaionTime(originTime - remainingTime, currentIndex);
      routineHistory!
          .setRoutineState(RoutineHistoryState.complete, currentIndex);

      if (routineHistory!.histories.length > currentIndex + 1) {
        remainingTime = routineHistory!.histories[currentIndex + 1].duration;
        currentIndex++;
        startTimer();
      } else {
        context.go('/routine_review_edit/${widget.id}', extra: routineHistory);
      }
    });
  }

  void passedTimer() {
    routineHistory!.setDurtaionTime(0, currentIndex);
    setState(() {
      if (routineHistory!.histories.length > currentIndex + 1) {
        remainingTime = routineHistory!.histories[currentIndex + 1].duration;
        currentIndex++;
        startTimer();
      } else {
        context.go('/routine_review_edit/${widget.id}', extra: routineHistory);
      }
    });
  }

  void handleTimerState(TimerHandleState timerHandleState) {
    switch (timerHandleState) {
      case TimerHandleState.complete:
        completeTimer();
        break;
      case TimerHandleState.passed:
        passedTimer();
        break;
      case TimerHandleState.pause:
        pauseTimer();
        break;
      case TimerHandleState.rest:
        context.go('/routine_review_edit/${widget.id}', extra: routineHistory);
        break;
      case TimerHandleState.start:
        startTimer();
        break;
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (routine == null) {
      return const DefaultLayout(child: CircularProgressIndicator());
    }

    return DefaultLayout(
      rightIcon: IconButton(
        icon: const Icon(Icons.close, size: 30),
        onPressed: () {
          context.go('/');
        },
      ),
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
                          routine!.subRoutines[currentIndex].goal,
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
          Expanded(
            child: PaddingContainer(
              child: SingleChildScrollView(
                child: GapColumn(
                  gap: 16,
                  children: routine!.subRoutines.asMap().entries.map((entry) {
                    int index = entry.key;
                    SubRoutineModel data = entry.value;
                    return ListItem(
                      routineId: data.routineId,
                      title: data.goal,
                      routinEmoji: data.emoji,
                      subTitle: '${data.duration ~/ 60}분',
                      isDone: index < currentIndex,
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
