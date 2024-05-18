import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('통계'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            StatisticsSummary(),
            SizedBox(height: 16),
            Calendar(),
            SizedBox(height: 16),
            FilterButtons(),
            SizedBox(height: 16),
            WeeklyReport(),
            SizedBox(height: 16),
            RecentRoutine(),
          ],
        ),
      ),
    );
  }
}

class StatisticsSummary extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        SummaryCard(
          title: '현재 연속 달성',
          value: '15일',
          icon: Icons.calendar_today,
        ),
        SummaryCard(
          title: '최고 달성',
          value: '15일',
          icon: Icons.star,
        ),
        SummaryCard(
          title: '누적 달성',
          value: '123일',
          icon: Icons.check_circle,
        ),
      ],
    );
  }
}

class SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  SummaryCard({
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Icon(icon, size: 36),
            SizedBox(height: 8),
            Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Text(value, style: TextStyle(fontSize: 20)),
          ],
        ),
      ),
    );
  }
}

class Calendar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {},
            ),
            Text('2024.04', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            IconButton(
              icon: Icon(Icons.arrow_forward),
              onPressed: () {},
            ),
          ],
        ),
        GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            childAspectRatio: 1,
          ),
          itemCount: 30,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(4.0),
              child: CircleAvatar(
                backgroundColor: index % 2 == 0 ? Colors.blue : Colors.grey[300],
                child: Text(
                  '${index + 1}',
                  style: TextStyle(color: index % 2 == 0 ? Colors.white : Colors.black),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class FilterButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        FilterButton(text: '완료', isSelected: true),
        FilterButton(text: '실패', isSelected: false),
        FilterButton(text: '건너뜀', isSelected: false),
      ],
    );
  }
}

class FilterButton extends StatelessWidget {
  final String text;
  final bool isSelected;

  FilterButton({required this.text, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        primary: isSelected ? Colors.blue : Colors.grey[300],
      ),
      child: Text(
        text,
        style: TextStyle(color: isSelected ? Colors.white : Colors.black),
      ),
    );
  }
}

class WeeklyReport extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('주간 리포트 (04.21 - 04.27)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('지난 주에 비해 12% 더 달성했네요!'),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Text('달성 루틴', style: TextStyle(fontWeight: FontWeight.bold)),
                      Text('24개'),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Text('실패 루틴', style: TextStyle(fontWeight: FontWeight.bold)),
                      Text('10개'),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Text('건너뛴 루틴', style: TextStyle(fontWeight: FontWeight.bold)),
                      Text('7개'),
                    ],
                  ),
                ),
                CircularPercentIndicator(
                  radius: 60.0,
                  lineWidth: 5.0,
                  percent: 0.6,
                  center: new Text("60%"),
                  progressColor: Colors.blue,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class RecentRoutine extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('최근 어려웠던 루틴이에요', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        Text('달성률이 낮은 루틴을 모아서 볼 수 있어요.'),
        SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(5, (index) {
            return RoutineAdjustmentButton(day: '일');
          }),
        ),
      ],
    );
  }
}

class RoutineAdjustmentButton extends StatelessWidget {
  final String day;

  RoutineAdjustmentButton({required this.day});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {},
      child: Text(day),
    );
  }
}