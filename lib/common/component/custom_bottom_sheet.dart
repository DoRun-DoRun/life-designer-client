import 'package:dorun_app_flutter/common/component/custom_button.dart';
import 'package:dorun_app_flutter/common/component/gap_column.dart';
import 'package:dorun_app_flutter/common/constant/colors.dart';
import 'package:dorun_app_flutter/common/constant/data.dart';
import 'package:dorun_app_flutter/common/constant/fonts.dart';
import 'package:dorun_app_flutter/common/constant/spacing.dart';
import 'package:dorun_app_flutter/common/utils/format.dart';
import 'package:dorun_app_flutter/features/routine/model/routine_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void showSelectionSheet(BuildContext context, List<String> options,
    ValueChanged<String> onSelected, String text, String selectedOption) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    backgroundColor: Colors.white,
    builder: (context) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 36),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(text, style: AppTextStyles.BOLD_20),
            const SizedBox(height: 36),
            GridView.builder(
              shrinkWrap: true,
              itemCount: options.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16.0,
                crossAxisSpacing: 16.0,
                childAspectRatio: 3.0,
              ),
              itemBuilder: (context, index) {
                final option = options[index];
                final isSelected = option == selectedOption;

                return GestureDetector(
                  onTap: () {
                    onSelected(option);
                    Navigator.pop(context);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.BRAND_SUB
                          : AppColors.BACKGROUND_SUB,
                      borderRadius: AppRadius.ROUNDED_16,
                    ),
                    child: Center(
                      child: Text(
                        option,
                        style: AppTextStyles.MEDIUM_16.copyWith(
                          color: isSelected
                              ? AppColors.BRAND
                              : AppColors.TEXT_SECONDARY,
                        ),
                      ),
                    ),
                  ),
                );
              },
            )
          ],
        ),
      );
    },
  );
}

Future<List<bool>?> showRepeatOptions(
  BuildContext context, {
  required RepeatCycle initialRepeatCycle,
  required List<bool> initialWeekDays,
}) {
  return showModalBottomSheet<List<bool>>(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    backgroundColor: Colors.white,
    builder: (BuildContext context) {
      return _RepeatOptionsModal(
        initialWeekDays: initialWeekDays,
      );
    },
  );
}

class _RepeatOptionsModal extends StatefulWidget {
  final List<bool> initialWeekDays;

  const _RepeatOptionsModal({
    required this.initialWeekDays,
  });

  @override
  _RepeatOptionsModalState createState() => _RepeatOptionsModalState();
}

class _RepeatOptionsModalState extends State<_RepeatOptionsModal> {
  late RepeatCycle _repeatCycle;
  late List<bool> _weekDays;

  @override
  void initState() {
    super.initState();
    _weekDays = widget.initialWeekDays;
    _repeatCycle = formatRoutineType(widget.initialWeekDays);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 36),
      child: GapColumn(
        gap: 16,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('반복요일을 설정해주세요', style: AppTextStyles.BOLD_20),
          Row(
            children: [
              Expanded(
                child: _buildRepeatOptionButton(
                    '매일', _repeatCycle == RepeatCycle.daily, () {
                  setState(() {
                    _weekDays = [true, true, true, true, true, true, true];
                    _repeatCycle = RepeatCycle.daily;
                  });
                  Navigator.pop(context, _weekDays);
                }),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildRepeatOptionButton(
                    '평일', _repeatCycle == RepeatCycle.weekdays, () {
                  setState(() {
                    _weekDays = [false, true, true, true, true, true, false];
                    _repeatCycle = RepeatCycle.weekdays;
                  });
                  Navigator.pop(context, _weekDays);
                }),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: _buildRepeatOptionButton(
                    '주말', _repeatCycle == RepeatCycle.weekends, () {
                  setState(() {
                    _weekDays = [true, false, false, false, false, false, true];
                    _repeatCycle = RepeatCycle.weekends;
                  });
                  Navigator.pop(context, _weekDays);
                }),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildRepeatOptionButton(
                    '직접 선택', _repeatCycle == RepeatCycle.custom, () {
                  setState(() {
                    _repeatCycle = RepeatCycle.custom;
                  });
                }),
              ),
            ],
          ),
          if (_repeatCycle == RepeatCycle.custom)
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(
                  7,
                  (index) {
                    return _buildDayButton(
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
            ),
          if (_repeatCycle == RepeatCycle.custom)
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: CustomButton(
                onPressed: () {
                  Navigator.pop(context, _weekDays);
                },
                backgroundColor: AppColors.BRAND,
                foregroundColor: AppColors.BRAND_SUB,
                title: '선택 완료',
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildRepeatOptionButton(
      String title, bool isSelected, VoidCallback onPressed) {
    return CustomButton(
      onPressed: onPressed,
      backgroundColor:
          isSelected ? AppColors.BRAND_SUB : AppColors.BACKGROUND_SUB,
      foregroundColor: isSelected ? AppColors.BRAND : Colors.black,
      title: title,
    );
  }

  Widget _buildDayButton(
      String label, int index, bool isSelected, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue : Colors.grey[300],
          shape: BoxShape.circle,
        ),
        padding: const EdgeInsets.all(8.0),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }
}

Future<Duration?> showTimeSelectionModal(BuildContext context,
    {Duration? initialTime}) {
  DateTime now = DateTime.now();
  DateTime initialDateTime = DateTime(
    now.year,
    now.month,
    now.day,
    initialTime?.inHours ?? now.hour,
    initialTime?.inMinutes.remainder(60) ?? now.minute,
  );

  DateTime tempSelectedTime = initialDateTime;

  return showModalBottomSheet<Duration>(
    context: context,
    backgroundColor: Colors.white,
    builder: (BuildContext context) {
      return SizedBox(
        height: 375,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              const Text(
                '몇시에 시작하시나요?',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.time,
                  initialDateTime: initialDateTime,
                  onDateTimeChanged: (DateTime newTime) {
                    tempSelectedTime = newTime;
                  },
                ),
              ),
              const SizedBox(height: 24),
              CustomButton(
                onPressed: () {
                  Duration selectedTime = Duration(
                    hours: tempSelectedTime.hour,
                    minutes: tempSelectedTime.minute,
                  );
                  Navigator.of(context).pop(selectedTime);
                },
                backgroundColor: AppColors.BRAND_SUB,
                foregroundColor: AppColors.BRAND,
                title: "저장",
              ),
            ],
          ),
        ),
      );
    },
  );
}

void showYearPicker(
  BuildContext context,
  ValueChanged<int> onYearSelected, {
  int startYear = 1900,
}) {
  final currentYear = DateTime.now().year;
  int selectedYear = currentYear - 20;

  showModalBottomSheet(
    context: context,
    builder: (context) {
      return Container(
        decoration: const BoxDecoration(
            color: Colors.white, borderRadius: AppRadius.ROUNDED_16),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 36),
        height: 420,
        child: GapColumn(
          gap: 32,
          children: [
            const Text("태어난 연도를 알려주세요.", style: AppTextStyles.BOLD_20),
            Expanded(
              child: CupertinoPicker(
                itemExtent: 32.0,
                scrollController: FixedExtentScrollController(
                  initialItem: currentYear - startYear - 20,
                ),
                onSelectedItemChanged: (int index) {
                  selectedYear = startYear + index;
                },
                children: List<Widget>.generate(
                  currentYear - startYear + 1,
                  (int index) {
                    return Center(
                      child: Text('${startYear + index}'),
                    );
                  },
                ),
              ),
            ),
            CustomButton(
                onPressed: () {
                  onYearSelected(selectedYear);
                  Navigator.pop(context);
                },
                title: "선택완료",
                foregroundColor: Colors.white,
                backgroundColor: AppColors.BRAND),
          ],
        ),
      );
    },
  );
}

void showSelectionMulitySheet(
  BuildContext context,
  List<String> options,
  ValueChanged<List<String>> onSelected,
  List<String> selectedDifficulties,
) {
  List<String> tempSelected = selectedDifficulties;

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (context) {
      return Container(
        decoration: const BoxDecoration(
            color: Colors.white, borderRadius: AppRadius.ROUNDED_16),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 36),
        child: StatefulBuilder(
          builder: (context, setState) {
            return GapColumn(
              mainAxisSize: MainAxisSize.min,
              gap: 36,
              children: [
                GapColumn(
                  gap: 12,
                  children: [
                    const Text(
                      "계획을 지키면서 어려운점이 있나요?",
                      style: AppTextStyles.BOLD_20,
                    ),
                    Text(
                      "최대 3개까지 선택해주세요",
                      style: AppTextStyles.MEDIUM_14
                          .copyWith(color: AppColors.TEXT_SECONDARY),
                    ),
                  ],
                ),
                GridView.builder(
                  shrinkWrap: true,
                  itemCount: options.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // 2열로 배치
                    mainAxisSpacing: 16.0,
                    crossAxisSpacing: 16.0,
                    childAspectRatio: 3.0, // 각 항목의 가로 세로 비율
                  ),
                  itemBuilder: (context, index) {
                    final option = options[index];
                    final isSelected = tempSelected.contains(option);

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          if (isSelected) {
                            tempSelected.remove(option);
                          } else {
                            if (tempSelected.length < 3) {
                              tempSelected.add(option);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('최대 3개까지 선택할 수 있습니다.'),
                                ),
                              );
                            }
                          }
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.BRAND_SUB
                              : AppColors.BACKGROUND_SUB,
                          borderRadius: AppRadius.ROUNDED_16,
                        ),
                        child: Center(
                          child: Text(
                            option,
                            style: AppTextStyles.MEDIUM_16.copyWith(
                              color: isSelected
                                  ? AppColors.BRAND
                                  : AppColors.TEXT_SECONDARY,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                CustomButton(
                  onPressed: () {
                    onSelected(tempSelected);
                    Navigator.pop(context);
                  },
                  title: "선택완료",
                  foregroundColor: tempSelected.isNotEmpty
                      ? Colors.white
                      : AppColors.TEXT_INVERT,
                  backgroundColor: tempSelected.isNotEmpty
                      ? AppColors.BRAND
                      : AppColors.BACKGROUND_SUB,
                ),
              ],
            );
          },
        ),
      );
    },
  );
}

Future<SubRoutineHistory> showCombinedBottomSheet(
    BuildContext context, SubRoutineHistory data) async {
  Duration? initialTime = Duration(
    minutes: data.duration ~/ 60,
    seconds: data.duration % 60,
  );

  Duration? tempSelectedTime = initialTime;

  await showModalBottomSheet(
    context: context,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return SizedBox(
            height: 350,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  const Text(
                    '수행된 루틴 기록 수정',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 24),
                  Expanded(
                    child: CupertinoTimerPicker(
                      mode: CupertinoTimerPickerMode.ms,
                      initialTimerDuration: initialTime,
                      minuteInterval: 1,
                      onTimerDurationChanged: (Duration newDuration) {
                        setState(() {
                          tempSelectedTime = newDuration;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 24),
                  CustomButton(
                    onPressed: () {
                      Duration selectedTime =
                          tempSelectedTime ?? const Duration(minutes: 10);
                      Navigator.of(context).pop({
                        'selectedTime': selectedTime,
                        'selectedOption':
                            selectedTime.inSeconds == 0 ? "건너뜀" : "",
                      });
                    },
                    backgroundColor: AppColors.BRAND_SUB,
                    foregroundColor: AppColors.BRAND,
                    title: "저장",
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  ).then((result) {
    if (result != null) {
      Duration selectedTime = result['selectedTime'];
      String selectedOption = result['selectedOption'];

      if (selectedOption == '건너뜀') {
        data.state = RoutineHistoryState.passed;
      } else {
        data.duration = selectedTime.inSeconds;
        data.state = RoutineHistoryState.complete;
      }
    }
  });

  return data;
}
