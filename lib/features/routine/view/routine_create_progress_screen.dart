import 'dart:async';

import 'package:dorun_app_flutter/common/component/gap_column.dart';
import 'package:dorun_app_flutter/common/constant/fonts.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../common/constant/colors.dart';
import '../../../common/constant/data.dart';

class RoutineCreateProgressScreen extends StatefulWidget {
  static String get routeName => 'routineCreateProgress';

  final String routineGoal;
  final TimeOfDay startTime;
  final RepeatCycle repeatCycle;
  final List<bool> weekDays;
  final String alertTime;

  const RoutineCreateProgressScreen({
    super.key,
    required this.routineGoal,
    required this.startTime,
    required this.repeatCycle,
    required this.weekDays,
    required this.alertTime,
  });

  @override
  State<RoutineCreateProgressScreen> createState() =>
      _RoutineCreateProgressScreenState();
}

class _RoutineCreateProgressScreenState
    extends State<RoutineCreateProgressScreen> {
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
          onProgressComplete(context); // 프로그레스 완료 시 처리
        }
      });
    });
  }

  void onProgressComplete(BuildContext context) {
    // print('Progress complete!');
    if (!mounted) return;
    context.pushReplacement('/');
  }

  Future<void> createRoutine() async {
    await Future.delayed(const Duration(seconds: 2));
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
