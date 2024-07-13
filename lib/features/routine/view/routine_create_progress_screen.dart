import 'dart:async';

import 'package:dorun_app_flutter/common/layout/default_layout.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../common/constant/colors.dart';
import '../../../common/constant/data.dart';
import '../../../common/view/root_tab.dart';

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
    startProgress();
  }

  void startProgress() {
    timer = Timer.periodic(const Duration(milliseconds: 20), (timer) {
      double stepIncrement = 1.0 / 100; // 총 100번의 업데이트로 1.0에 도달
      setState(() {
        progress += stepIncrement;
        if (progress >= 1) {
          progress = 1.0; // 오버플로 방지
          timer.cancel();
          onProgressComplete(); // 프로그레스 완료 시 처리
        }
      });
    });
  }

  void onProgressComplete() {
    print('Progress complete!');
    if (!mounted) return;
    context.goNamed(RootTab.routeName);
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
    return DefaultLayout(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              '열심히 최적의 루틴을 생성하고 있어요',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.BRAND,
              ),
            ),
            const SizedBox(height: 20),
            LinearProgressIndicator(
              value: progress, // 직접적으로 progress 값을 사용
              backgroundColor: AppColors.BACKGROUND_SUB,
              valueColor: const AlwaysStoppedAnimation<Color?>(AppColors.BRAND),
              minHeight: 5,
            ),
            const SizedBox(height: 40),
            Image.asset(
              'asset/images/character/bear-example.png',
              width: MediaQuery.of(context).size.width * 0.8,
            )
          ],
        ),
      ),
    );
  }
}
