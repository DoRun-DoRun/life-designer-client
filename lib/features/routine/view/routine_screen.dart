import 'package:dorun_app_flutter/common/component/gap_column.dart';
import 'package:dorun_app_flutter/common/component/list_item.dart';
import 'package:dorun_app_flutter/common/constant/colors.dart';
import 'package:dorun_app_flutter/common/constant/spacing.dart';
import 'package:dorun_app_flutter/common/layout/default_layout.dart';
import 'package:dorun_app_flutter/features/routine/view/routine_creator_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

class RoutineScreen extends StatelessWidget {
  static String get routeName => 'routine';

  const RoutineScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      rightIcon: IconButton(
        icon: const Icon(
          Icons.notifications,
          size: 30,
          color: AppColors.TEXT_SUB,
        ),
        onPressed: () {
          // 알림 버튼 클릭 이벤트 처리
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const RoutineCreatorScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
      child: GapColumn(
        gap: 16,
        children: [
          Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.only(left: 24, bottom: 24, right: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const DateSelector(),
                  const SizedBox(height: 16),
                  const Text(
                    '오늘의 루틴입니다',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '이제 시작이네요!',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  LinearProgressIndicator(
                    value: 0.1, // 진행 상태 값
                    backgroundColor: Colors.grey[300],
                    valueColor:
                        const AlwaysStoppedAnimation<Color>(Colors.blue),
                  ),
                ],
              ),
            ),
          ),
          Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: GapColumn(
                gap: AppSpacing.SPACE_16,
                children: [
                  ListItem(
                    id: 0,
                    title: "운동하기",
                    subTitle: '09:00',
                    routinEmoji: '😛',
                    isButton: true,
                    onTap: () {
                      context.push('/routine_edit/0');
                    },
                  ),
                  ListItem(
                    id: 1,
                    title: "운동하기",
                    subTitle: '09:00',
                    onTap: () {
                      context.push('/routine_edit/1');
                    },
                  ),
                ],
              ),
            ),
          ),
          // RoutineCard(
          //   title: '운동하기',
          //   time: '09:00 시작',
          //   onPressed: () {
          //     // 수행 버튼 클릭 이벤트 처리
          //   },
          // ),
        ],
      ),
    );
  }
}

class DateSelector extends StatelessWidget {
  const DateSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Text(
          '4월 13일',
          style: TextStyle(fontSize: 20),
        ),
        Icon(Icons.arrow_drop_down),
      ],
    );
  }
}

class RoutineCard extends StatelessWidget {
  final String title;
  final String time;
  final VoidCallback onPressed;

  const RoutineCard({
    super.key,
    required this.title,
    required this.time,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(time),
              ],
            ),
            ElevatedButton(
              onPressed: onPressed,
              child: const Text('수행'),
            ),
          ],
        ),
      ),
    );
  }
}
