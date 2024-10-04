import 'package:dorun_app_flutter/common/component/custom_bottom_sheet.dart';
import 'package:dorun_app_flutter/common/component/custom_button.dart';
import 'package:dorun_app_flutter/common/component/gap_column.dart';
import 'package:dorun_app_flutter/common/component/gap_row.dart';
import 'package:dorun_app_flutter/common/component/input_box.dart';
import 'package:dorun_app_flutter/common/component/list_item.dart';
import 'package:dorun_app_flutter/common/component/padding_container.dart';
import 'package:dorun_app_flutter/common/constant/colors.dart';
import 'package:dorun_app_flutter/common/constant/fonts.dart';
import 'package:dorun_app_flutter/common/layout/default_layout.dart';
import 'package:dorun_app_flutter/common/utils/format.dart';
import 'package:dorun_app_flutter/features/routine/model/routine_model.dart';
import 'package:dorun_app_flutter/features/routine/provider/routine_provider.dart';
import 'package:dorun_app_flutter/features/routine/repository/routine_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

Future<RoutineHistory?> _fetchRoutineReview(WidgetRef ref, int id) async {
  final routineRepository = ref.read(routineRepositoryProvider);

  try {
    final routine = await routineRepository.getRoutineDetail(id);

    final histories = routine.subRoutines.map((data) {
      return SubRoutineHistory(
        subRoutine: data,
        duration: 0,
        state: RoutineHistoryState.passed,
      );
    }).toList();

    if (histories.isEmpty) {
      return null;
    }

    return RoutineHistory(
      histories: histories,
      routineId: id,
    );
  } catch (e) {
    print('Failed to fetch routine detail: $e');
    rethrow; // 예외를 다시 던져서 호출자에게 전달
  }
}

class RoutineEditScreen extends ConsumerStatefulWidget {
  static String get routeName => 'routineEdit';
  final DetailRoutineModel routine;
  const RoutineEditScreen({super.key, required this.routine});

  @override
  ConsumerState<RoutineEditScreen> createState() => _RoutineEditScreenState();
}

class _RoutineEditScreenState extends ConsumerState<RoutineEditScreen> {
  late Duration? alertTime;
  late Duration? startTime;
  late List<bool> selectedDays;
  late bool isSwitched = widget.routine.notificationTime != null;

  @override
  void initState() {
    super.initState();
    startTime = Duration(seconds: widget.routine.startTime);
    alertTime = widget.routine.notificationTime != null
        ? Duration(seconds: widget.routine.notificationTime!)
        : const Duration(seconds: -1);
    selectedDays = widget.routine.repeatDays;
  }

  @override
  Widget build(BuildContext context) {
    final routineRepository = ref.read(routineRepositoryProvider);
    TextEditingController textEditingController =
        TextEditingController(text: widget.routine.name);

    void updateServerWithToggleValue(bool newValue) {
      print("API 호출 - 알람 상태: $newValue");
    }

    Future<void> setStartTime(BuildContext context) async {
      Duration? selectedTime = await showTimeSelectionModal(
        context,
        initialTime: startTime,
      );

      setState(
        () {
          startTime = selectedTime;
        },
      );
    }

    return DefaultLayout(
      title: '수정하기',
      child: SingleChildScrollView(
        child: GapColumn(
          gap: 16,
          children: [
            PaddingContainer(
              width: double.infinity,
              child: InputBox(
                controller: textEditingController,
                hintText: '루틴 이름',
              ),
            ),
            PaddingContainer(
              child: GapColumn(
                gap: 32,
                children: [
                  const Text('루틴 수행', style: AppTextStyles.BOLD_20),
                  ListItem(
                    onTap: () {
                      setStartTime(context);
                    },
                    routineId: 0,
                    title: '시작 시간',
                    subTitle: formatTimeRange(
                      startTime?.inSeconds ?? 0,
                      widget.routine.totalDuration,
                    ),
                  ),
                  ListItem(
                    onTap: () async {
                      List<bool>? selectedDaysData = await showRepeatOptions(
                          context,
                          initialRepeatCycle: formatRoutineType(selectedDays),
                          initialWeekDays: selectedDays);

                      setState(() {
                        selectedDays = selectedDaysData ?? [];
                      });
                    },
                    routineId: 0,
                    title: '주기',
                    subTitle: formatRoutineDays(selectedDays),
                  )
                ],
              ),
            ),
            // TODO 알람 추가하기
            // PaddingContainer(
            //   child: GapColumn(
            //     gap: 16,
            //     children: [
            //       const Text(
            //         '알림',
            //         style: AppTextStyles.BOLD_20,
            //       ),
            //       const SizedBox(height: 16),
            //       // CustomToggle(
            //       //   title: '알림',
            //       //   textStyle: AppTextStyles.BOLD_20,
            //       //   padding: 0,
            //       //   isSwitched: widget.routine.notificationTime != null,
            //       //   onToggle: updateServerWithToggleValue,
            //       // ),
            //       ListItem(
            //         onTap: () async {
            //           alertTime = await setAlertTime(
            //             context: context,
            //             initialTime: alertTime,
            //           );
            //           setState(() {});
            //         },
            //         routineId: 0,
            //         title: '시간',
            //         subTitle: alertTime?.inSeconds == -1
            //             ? '알림 없음'
            //             : formattedAlertTime(alertTime),
            //       ),
            //     ],
            //   ),
            // ),
            PaddingContainer(
              child: GapRow(
                gap: 24,
                children: [
                  Expanded(
                    child: CustomButton(
                      foregroundColor: Colors.red,
                      onPressed: () {
                        try {
                          routineRepository.deleteRoutine(widget.routine.id);
                          context.go('/');
                          ref.invalidate(routineListProvider);
                        } catch (e) {
                          print('Failed to create routine: $e');
                        }
                      },
                      title: '루틴 삭제하기',
                    ),
                  ),
                  Expanded(
                    child: CustomButton(
                      onPressed: () async {
                        final routineHistory =
                            await _fetchRoutineReview(ref, widget.routine.id);

                        if (routineHistory == null) {
                          context.pop();
                          // TODO 루틴 생성이 필요하다고 사용자에게 알려주기.

                          return;
                        }
                        context.push(
                          '/routine_review/${widget.routine.id}',
                          extra: routineHistory,
                        );
                      },
                      title: '루틴 쉬어가기',
                    ),
                  ),
                ],
              ),
            ),
            PaddingContainer(
              child: CustomButton(
                backgroundColor: AppColors.BRAND_SUB,
                foregroundColor: AppColors.BRAND,
                onPressed: () {
                  try {
                    routineRepository.editRoutines(
                      EditRoutineModel(
                        routineId: widget.routine.id,
                        goal: textEditingController.text,
                        startTime: startTime?.inSeconds ?? 0,
                        repeatDays: selectedDays,
                      ),
                    );
                    context.go('/');
                    ref.invalidate(routineListProvider);
                    ref.invalidate(routineDetailProvider(widget.routine.id));
                  } catch (e) {
                    print('Failed to create routine: $e');
                  }
                },
                title: '루틴 수정하기',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
