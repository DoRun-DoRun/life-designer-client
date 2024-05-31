import 'package:flutter/material.dart';

class RoutineDetailScreen extends StatelessWidget {
  static String get routeName => 'routine_detail';

  void _showAddRoutineModal(BuildContext context) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,  // 모달을 전체 화면으로 확장
        builder: (BuildContext bc) {
          return Padding(
            padding: MediaQuery.of(context).viewInsets,  // 키보드 높이에 따라 패딩 조정
            child: Container(
              padding: EdgeInsets.all(20),
              child: Wrap(
                children: <Widget>[
                  Text('세부 루틴 추가', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  SizedBox(height: 10),
                  DropdownButton<IconData>(
                    isExpanded: true,
                    items: <IconData>[Icons.fitness_center, Icons.directions_run, Icons.pool].map((IconData value) {
                      return DropdownMenuItem<IconData>(
                        value: value,
                        child: Icon(value),
                      );
                    }).toList(),
                    onChanged: (_) {},
                    hint: Text('아이콘 선택'),
                  ),
                  TextField(
                    decoration: InputDecoration(
                      hintText: '세부 루틴 설명',
                    ),
                  ),
                  TextField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: '세부 루틴 소요 시간(분)',
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context); // 모달 창 닫기
                    },
                    child: Text('추가하기'),
                  )
                ],
              ),
            ),
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Text(
              '운동하기',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              '지금까지 소요시간',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('42분', style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Text('08시 31분 이 마지막 시도', style: TextStyle(fontSize: 16)),
            SizedBox(height: 24),
            TextField(
              decoration: InputDecoration(
                hintText: '루틴을 어떻게 수행하고 있는지 작성해주세요',
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () => _showAddRoutineModal(context),
                ),
              ),
            ),
            SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                child: Text('수행하기', style: TextStyle(fontSize: 20)),
                onPressed: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
