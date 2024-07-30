import 'package:dorun_app_flutter/common/component/custom_button.dart';
import 'package:dorun_app_flutter/common/component/gap_column.dart';
import 'package:dorun_app_flutter/common/component/gap_row.dart';
import 'package:dorun_app_flutter/common/component/input_box.dart';
import 'package:dorun_app_flutter/common/component/list_item.dart';
import 'package:dorun_app_flutter/common/component/padding_container.dart';
import 'package:dorun_app_flutter/common/constant/colors.dart';
import 'package:dorun_app_flutter/common/constant/data.dart';
import 'package:dorun_app_flutter/common/constant/fonts.dart';
import 'package:dorun_app_flutter/common/constant/spacing.dart';
import 'package:dorun_app_flutter/common/layout/default_layout.dart';
import 'package:dorun_app_flutter/features/routine/model/routine_model.dart';
import 'package:emoji_selector/emoji_selector.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RoutineDetailScreen extends StatefulWidget {
  static String get routeName => 'routineDetail';
  final int id;
  const RoutineDetailScreen({super.key, required this.id});

  @override
  State<RoutineDetailScreen> createState() => _RoutineDetailScreenState();
}

class _RoutineDetailScreenState extends State<RoutineDetailScreen> {
  String _alertTime = '';
  String _emoji = '✅';

  Routine? getRoutineById(int id) {
    try {
      return routineMockData.firstWhere((routine) => routine.id == id);
    } catch (e) {
      return routineMockData[0];
    }
  }

  void _showAddRoutineModal(BuildContext context) {
    final TextEditingController titleController = TextEditingController();

    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext bc) {
          return StatefulBuilder(builder: (context, setState) {
            return Padding(
              padding: MediaQuery.of(context).viewInsets, // 키보드 높이에 따라 패딩 조정
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: const BoxDecoration(
                    color: Colors.white, borderRadius: AppRadius.ROUNDED_16),
                child: GapColumn(
                  gap: 16,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text("루틴을 어떻게 수행하고 있는지 작성해주세요",
                        style: AppTextStyles.MEDIUM_16),
                    GestureDetector(
                      onTap: () {
                        setEmoji(bc, setState);
                      },
                      child: Row(
                        children: [
                          Container(
                            width: 46,
                            height: 46,
                            decoration: const BoxDecoration(
                              borderRadius: AppRadius.FULL,
                              color: AppColors.BACKGROUND_SUB,
                            ),
                            child: Center(
                              child: Text(
                                _emoji,
                                style:
                                    AppTextStyles.EMOJI.copyWith(fontSize: 30),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            "아이콘 변경하기",
                            style: AppTextStyles.MEDIUM_12
                                .copyWith(color: AppColors.TEXT_SUB),
                          )
                        ],
                      ),
                    ),
                    InputBox(controller: titleController, hintText: '세부 루틴'),
                    ReadOnlyBox(
                      hintText: '수행 시간',
                      inputText: _alertTime,
                      onTap: () {
                        _setAlertTime(bc, setState);
                      },
                    ),
                    const SizedBox(height: 16),
                    CustomButton(
                      onPressed: () {
                        _alertTime = '';
                        Navigator.of(bc).pop();
                      },
                      title: '추가하기',
                      backgroundColor: AppColors.BRAND_SUB,
                      foregroundColor: AppColors.TEXT_BRAND,
                    ),
                  ],
                ),
              ),
            );
          });
        });
  }

  void _setAlertTime(BuildContext context, StateSetter setState) {
    String formattedTime = '10분';

    showModalBottomSheet(
      context: context,
      builder: (BuildContext builder) {
        return SizedBox(
          height: 375,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
            child: GapColumn(
              children: [
                const Text('소요시간을 알려주세요', style: AppTextStyles.BOLD_20),
                Expanded(
                  child: CupertinoTimerPicker(
                    mode: CupertinoTimerPickerMode.hm,
                    initialTimerDuration: const Duration(minutes: 10),
                    minuteInterval: 1,
                    onTimerDurationChanged: (Duration newDuration) {
                      int hours = newDuration.inHours;
                      int minutes = newDuration.inMinutes % 60;
                      setState(() {
                        if (hours > 0) {
                          formattedTime = '$hours시간 $minutes분';
                        } else {
                          formattedTime = '$minutes분';
                        }
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
                            _alertTime = '알람 X';
                          });
                          Navigator.of(builder).pop();
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
                            _alertTime = formattedTime;
                          });
                          Navigator.of(builder).pop();
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

  void setEmoji(BuildContext context, StateSetter setState) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext subcontext) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: EmojiSelector(
                onSelected: (emoji) {
                  setState(() {
                    _emoji = emoji.char;
                  });
                  Navigator.of(subcontext).pop(emoji);
                },
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: GapColumn(
                gap: 16,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PaddingContainer(
                    width: double.infinity,
                    child: GapColumn(
                      gap: 24,
                      children: [
                        Text(getRoutineById(widget.id)!.name,
                            style: AppTextStyles.BOLD_20),
                        GapColumn(
                          gap: 8,
                          children: [
                            Text(
                              "총 소요시간",
                              style: AppTextStyles.MEDIUM_14
                                  .copyWith(color: AppColors.TEXT_SUB),
                            ),
                            Text(
                                "${getRoutineById(widget.id)!.totalDuration.toString()} 분",
                                style: AppTextStyles.MEDIUM_20),
                          ],
                        ),
                      ],
                    ),
                  ),
                  PaddingContainer(
                    child: GapColumn(
                      gap: 16,
                      children:
                          getRoutineById(widget.id)!.subRoutines.map((data) {
                        return ListItem(
                          id: data.id,
                          title: data.name,
                          routinEmoji: data.emoji,
                          subTitle:
                              '${(data.durationSecond ~/ 60).toString()}분',
                        );
                      }).toList(),
                    ),
                  ),
                  PaddingContainer(
                      child: Column(
                    children: [
                      GapColumn(
                        gap: 16,
                        children: [
                          const Text(
                            "루틴을 수행하고 있는지 작성해주세요",
                            style: AppTextStyles.MEDIUM_16,
                          ),
                          CustomButton(
                            onPressed: () => {_showAddRoutineModal(context)},
                            icon: const Icon(
                              Icons.add_circle,
                              size: 25,
                              color: AppColors.TEXT_BRAND,
                            ),
                          )
                        ],
                      ),
                    ],
                  ))
                ],
              ),
            ),
          ),
          PaddingContainer(
            child: CustomButton(
              title: '수행하기',
              backgroundColor: AppColors.BRAND,
              foregroundColor: AppColors.BRAND_SUB,
              onPressed: () {
                context.go('/routine_proceed/${getRoutineById(widget.id)!.id}');
              },
            ),
          ),
        ],
      ),
    );
  }
}
