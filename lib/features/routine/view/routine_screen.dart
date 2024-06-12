import 'package:dorun_app_flutter/features/routine/view/routine_creator_screen.dart';
import 'package:flutter/material.dart';

class RoutineScreen extends StatelessWidget {
  static String get routeName => 'routine';

  const RoutineScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // 알림 버튼 클릭 이벤트 처리
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
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
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
            ),
            const SizedBox(height: 32),
            RoutineCard(
              title: '운동하기',
              time: '09:00 시작',
              onPressed: () {
                // 수행 버튼 클릭 이벤트 처리
              },
            ),
          ],
        ),
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
