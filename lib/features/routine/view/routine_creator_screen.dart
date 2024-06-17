import 'package:dorun_app_flutter/common/component/gap_column.dart';
import 'package:dorun_app_flutter/common/component/input_box.dart';
import 'package:dorun_app_flutter/common/constant/fonts.dart';
import 'package:dorun_app_flutter/common/constant/spacing.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RoutineCreatorScreen extends StatefulWidget {
  const RoutineCreatorScreen({super.key});

  @override
  State<RoutineCreatorScreen> createState() => _RoutineCreatorScreenState();
}

class _RoutineCreatorScreenState extends State<RoutineCreatorScreen> {
  final TextEditingController _textController = TextEditingController();
  String? _routineGoal;
  TimeOfDay? _selectedTime;

  void _setRoutineGoal(String value) {
    setState(() {
      _routineGoal = value;
    });
    if (_selectedTime == null) {
      _setStartTime(context);
    }
  }

  Future<void> _setStartTime(BuildContext context) async {
    TimeOfDay? tempSelectedTime;

    await showModalBottomSheet(
      context: context,
      builder: (BuildContext builder) {
        return Container(
          height: 250,
          padding: const EdgeInsets.only(top: 15),
          child: Column(
            children: [
              Expanded(
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.time,
                  initialDateTime: DateTime.now(),
                  onDateTimeChanged: (DateTime newTime) {
                    tempSelectedTime = TimeOfDay.fromDateTime(newTime);
                  },
                ),
              ),
              CupertinoButton(
                  color: Colors.blue,
                  onPressed: () {
                    if (tempSelectedTime != null) {
                      setState(() {
                        _selectedTime = tempSelectedTime;
                      });
                      Navigator.of(context).pop();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ConfirmationScreen(
                                routineGoal: _routineGoal!,
                                startTime: _selectedTime!)),
                      );
                    }
                  },
                  child: const Text('저장')),
              const SizedBox(height: 20)
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '생성하기',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Column(
        children: <Widget>[
          if (_routineGoal != null && _selectedTime == null)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Text('시작 시간',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: InkWell(
                    onTap: () => _setStartTime(context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.blue[200],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _selectedTime != null
                                ? '시간: ${_selectedTime!.format(context)}'
                                : '시작 시간 설정',
                            style: const TextStyle(
                                fontSize: 16, color: Colors.white),
                          ),
                          const Icon(Icons.access_time,
                              size: 16, color: Colors.white),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          if (_routineGoal != null)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Text('루틴 목표',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
                Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: TextField(
                    controller: TextEditingController(text: _routineGoal),
                    readOnly: true,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[200],
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 10),
                    ),
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
              ],
            ),
          if (_routineGoal == null)
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.SPACE_24,
                vertical: AppSpacing.SPACE_32,
              ),
              child: GapColumn(
                gap: AppSpacing.SPACE_16,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '이루고자 하시는 루틴이 무엇인가요?',
                    style: AppTextStyles.BOLD_20,
                  ),
                  InputBox(
                    controller: _textController,
                    hintText: '루틴 목표',
                    onSubmitted: _setRoutineGoal,
                  ),
                ],
              ),
            ),
          // Column(
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     children: [
          //       const Padding(
          //         padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          //         child: Text('이루고자 하시는 루틴이 무엇인가요?',
          //             style:
          //                 TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          //       ),
          //       Padding(
          //         padding:
          //             const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          //         child: TextField(
          //           controller: _textController,
          //           decoration: InputDecoration(
          //             filled: true,
          //             fillColor: Colors.grey[200],
          //             labelStyle: const TextStyle(color: Colors.black),
          //             enabledBorder: OutlineInputBorder(
          //               borderSide: const BorderSide(color: Colors.white),
          //               borderRadius: BorderRadius.circular(8),
          //             ),
          //             focusedBorder: OutlineInputBorder(
          //               borderSide:
          //                   const BorderSide(color: Colors.white, width: 2),
          //               borderRadius: BorderRadius.circular(8),
          //             ),
          //           ),
          //           cursorColor: Colors.blue,
          //           onSubmitted: _setRoutineGoal,
          //         ),
          //       ),
          //     ],
          //   ),
          if (_routineGoal != null && _selectedTime != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ConfirmationScreen(
                            routineGoal: _routineGoal!,
                            startTime: _selectedTime!)),
                  );
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.blue[700],
                  textStyle: const TextStyle(fontSize: 16),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0,
                ),
                child: const Text('저장하기'),
              ),
            ),
        ],
      ),
    );
  }
}

class ConfirmationScreen extends StatelessWidget {
  final String routineGoal;
  final TimeOfDay startTime;

  const ConfirmationScreen(
      {super.key, required this.routineGoal, required this.startTime});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('루틴 확인')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('루틴 목표: $routineGoal'),
            Text('시작 시간: ${startTime.format(context)}'),
          ],
        ),
      ),
    );
  }
}
