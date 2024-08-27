import 'dart:async';

import 'package:dorun_app_flutter/common/component/gap_column.dart';
import 'package:dorun_app_flutter/common/constant/fonts.dart';
import 'package:dorun_app_flutter/features/routine/provider/routine_provider.dart';
import 'package:dorun_app_flutter/features/routine/repository/routine_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../common/constant/colors.dart';

class RoutineCreateProgressScreen extends ConsumerStatefulWidget {
  static String get routeName => 'routineCreateProgress';

  final String routineGoal;
  final DateTime startTime;
  final List<bool> weekDays;
  final DateTime? alertTime;

  const RoutineCreateProgressScreen({
    super.key,
    required this.routineGoal,
    required this.startTime,
    required this.weekDays,
    required this.alertTime,
  });

  @override
  ConsumerState<RoutineCreateProgressScreen> createState() =>
      _RoutineCreateProgressScreenState();
}

class _RoutineCreateProgressScreenState
    extends ConsumerState<RoutineCreateProgressScreen> {
  double progress = 0.0;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    createRoutine();
    startProgress(context);
  }

  void startProgress(BuildContext context) {
    timer = Timer.periodic(const Duration(milliseconds: 20), (timer) {
      double stepIncrement = 1.0 / 100; // 총 100번의 업데이트로 1.0에 도달
      setState(() {
        progress += stepIncrement;
        if (progress >= 1) {
          progress = 1.0; // 오버플로 방지
          timer.cancel();
        }
      });
    });
  }

  String convertTimeOfDayToString(TimeOfDay timeOfDay) {
    final formattedTime =
        "${timeOfDay.hour.toString().padLeft(2, '0')}:${timeOfDay.minute.toString().padLeft(2, '0')}";
    return formattedTime;
  }

  String convertRepeatDaysToString(List<bool> repeatDays) {
    List<int> days = [];
    for (int i = 0; i < repeatDays.length; i++) {
      if (repeatDays[i]) {
        days.add(i + 1); // 1부터 시작하는 요일 인덱스
      }
    }
    return days.join(','); // "1,4,7"과 같은 형식
  }

  Future<void> createRoutine() async {
    final routineRepository = ref.read(routineRepositoryProvider);

    try {
      await routineRepository.createRoutine(
        goal: widget.routineGoal,
        startTime: widget.startTime.toString(),
        repeatDays: convertRepeatDaysToString(widget.weekDays),
        notificationTime: widget.alertTime.toString(),
      );
      ref.invalidate(routineListProvider);

      context.pushReplacement('/');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to create routine: $e')),
      );
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GapColumn(
              gap: 72,
              children: [
                const Text(
                  '열심히 최적의\n루틴을 생성하고 있어요',
                  style: AppTextStyles.BOLD_20,
                ),
                LinearProgressIndicator(
                  value: progress,
                  backgroundColor: AppColors.BACKGROUND_SUB,
                  valueColor:
                      const AlwaysStoppedAnimation<Color?>(AppColors.BRAND),
                  minHeight: 5,
                ),
                Center(child: Image.asset('asset/images/create-character.png'))
              ],
            ),
          ],
        ),
      ),
    );
  }
}
