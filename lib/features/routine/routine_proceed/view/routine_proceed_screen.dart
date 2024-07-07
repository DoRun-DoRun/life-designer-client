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
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RoutineProceedScreen extends StatefulWidget {
  static String get routeName => 'routineProceed';
  final int id;
  const RoutineProceedScreen({super.key, required this.id});

  @override
  State<RoutineProceedScreen> createState() => _RoutineProceedScreenState();
}

class _RoutineProceedScreenState extends State<RoutineProceedScreen> {
  Routine? routine;
  int currentSubRoutineIndex = 0;
  Timer? timer;
  int remainingTime = 0;

  @override
  void initState() {
    super.initState();
  }

  Routine? getRoutineById(int id) {
    try {
      return routineMockData.firstWhere((routine) => routine.id == id);
    } catch (e) {
      return routineMockData[0];
    }
  }

  void startSubRoutine(SubRoutine subRoutine) {
    setState(() {
      remainingTime = subRoutine.duration;
    });

    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (remainingTime > 0) {
          remainingTime--;
        } else {
          timer.cancel();
          if (currentSubRoutineIndex < routine!.subRoutines.length - 1) {
            setState(() {
              currentSubRoutineIndex++;
            });
            startSubRoutine(routine!.subRoutines[currentSubRoutineIndex]);
          }
        }
      });
    });
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
                            style: AppTextStyles.BOLD_16),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 32.0),
                        child: Text(remainingTime.toString(),
                            style:
                                AppTextStyles.BOLD_16.copyWith(fontSize: 50)),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24.0),
                  child: GapRow(
                    gap: 10,
                    children: [
                      Expanded(
                          child: CustomButton(
                        onPressed: () {},
                        title: '쉬어가기',
                        backgroundColor: AppColors.BRAND_SUB,
                        foregroundColor: AppColors.TEXT_BRAND,
                      )),
                      Expanded(
                          child: CustomButton(
                        onPressed: () {
                          startSubRoutine(getRoutineById(widget.id)!
                              .subRoutines[currentSubRoutineIndex]);
                        },
                        title: '수행하기',
                        backgroundColor: AppColors.BRAND,
                        foregroundColor: Colors.white,
                      )),
                    ],
                  ),
                )
              ],
            ),
          ),
          PaddingContainer(
            child: GapColumn(
              gap: 16,
              children: getRoutineById(widget.id)!.subRoutines.map((data) {
                return ListItem(
                  id: data.id,
                  title: data.name,
                  routinEmoji: data.emoji,
                  subTitle: '${data.duration.toString()}분',
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
