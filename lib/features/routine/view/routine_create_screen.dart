import 'package:dorun_app_flutter/common/component/custom_button.dart';
import 'package:dorun_app_flutter/common/component/gap_column.dart';
import 'package:dorun_app_flutter/common/component/gap_row.dart';
import 'package:dorun_app_flutter/common/component/input_box.dart';
import 'package:dorun_app_flutter/common/constant/colors.dart';
import 'package:dorun_app_flutter/common/constant/fonts.dart';
import 'package:dorun_app_flutter/common/constant/spacing.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum RepeatCycle { daily, weekdays, weekends, custom }

class RoutineCreateScreen extends StatefulWidget {
  const RoutineCreateScreen({super.key});

  @override
  State<RoutineCreateScreen> createState() => _RoutineCreateScreenState();
}

class _RoutineCreateScreenState extends State<RoutineCreateScreen> {
  final TextEditingController _textController = TextEditingController();
  String? _routineGoal;
  TimeOfDay? _selectedTime;
  RepeatCycle? _repeatCycle;
  final List<bool> _weekDays = List.filled(7, false);
  TimeOfDay? _alertTime;

  void _setRoutineGoal(String value) {
    setState(() {
      _routineGoal = value;
    });
    if (_selectedTime == null) {
      _setStartTime(context);
    }
  }

  final List<bool> _buttonStates = [
    false,
    false,
  ]; // Initialize with desired number of buttons

  void _handleButtonPress(int index) {
    setState(() {
      _buttonStates[index] = !_buttonStates[index];
    });
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

  Future<void> _setAlertTime(BuildContext context) async {
    TimeOfDay? tempAlertTime;

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
                  use24hFormat: true,
                  minuteInterval: 1,
                  onDateTimeChanged: (DateTime newTime) {
                    tempAlertTime = TimeOfDay.fromDateTime(newTime);
                  },
                ),
              ),
              CupertinoButton(
                  color: Colors.blue,
                  onPressed: () {
                    if (tempAlertTime != null) {
                      setState(() {
                        _alertTime = tempAlertTime;
                      });
                      Navigator.of(context).pop();
                    }
                  },
                  child: const Text('알림 시간 저장')),
              const SizedBox(height: 20)
            ],
          ),
        );
      },
    );
  }

  Widget _buildRepeatOptionButton(String label, RepeatCycle cycle) {
    bool isSelected = _repeatCycle == cycle;
    return OutlinedButton(
      onPressed: () {
        setState(() {
          _repeatCycle = cycle;
        });
      },
      style: OutlinedButton.styleFrom(
        side:
            BorderSide(width: 2, color: isSelected ? Colors.blue : Colors.grey),
        backgroundColor: isSelected ? Colors.blue : Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: Text(
        label,
        style: TextStyle(color: isSelected ? Colors.white : Colors.black),
      ),
    );
  }

  Widget _buildDayButton(String dayLabel, int index) {
    bool isSelected = _weekDays[index];
    return OutlinedButton(
      onPressed: () {
        setState(() {
          _weekDays[index] = !isSelected;
        });
      },
      style: OutlinedButton.styleFrom(
        side: BorderSide(width: 2, color: isSelected ? Colors.blue : Colors.grey),
        backgroundColor: isSelected ? Colors.blue : Colors.transparent,
        shape: const CircleBorder(),  // 원형 버튼으로 변경
        fixedSize: const Size(40, 40),  // 버튼의 크기를 지정
      ),
      child: Text(
        dayLabel,
        style: TextStyle(color: isSelected ? Colors.white : Colors.black),
      ),
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
          const Text(
            '어느 요일에 반복하시나요?',
            style: AppTextStyles.BOLD_20,
          ),
          if (_routineGoal != null && _selectedTime != null && _repeatCycle != null)
            Column(
              children: <Widget>[
                if (_alertTime != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Text('알림 시간: ${_alertTime!.format(context)}',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                TextButton(
                  onPressed: () => _setAlertTime(context),
                  child: Text(
                    _alertTime != null ? '알림 시간 변경' : '알림 시간 설정',
                    style: const TextStyle(color: Colors.blue),
                  ),
                ),
              ],
            ),
          if (_routineGoal != null && _selectedTime != null)
            Column(
              children: <Widget>[
                const Text(
                  '어느 요일에 반복하시나요?',
                  style: AppTextStyles.BOLD_20,
                ),
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  childAspectRatio: 2,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  padding: const EdgeInsets.all(20),
                  children: [
                    _buildRepeatOptionButton('매일', RepeatCycle.daily),
                    _buildRepeatOptionButton('평일', RepeatCycle.weekdays),
                    _buildRepeatOptionButton('주말', RepeatCycle.weekends),
                    _buildRepeatOptionButton('직접 선택', RepeatCycle.custom),
                  ],
                ),
                if (_repeatCycle == RepeatCycle.custom)
                  Container(
                    height: 50,
                    margin: const EdgeInsets.symmetric(vertical: 20),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: List.generate(7, (index) {
                          return _buildDayButton(['월', '화', '수', '목', '금', '토', '일'][index], index);
                        }),
                      ),
                    ),
                  ),
              ],
            ),
          if (_routineGoal != null)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '몇시에 시작하시나요?',
                  style: AppTextStyles.BOLD_20,
                ),
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
                  const Text(
                    '버튼 테스트 입니다',
                    style: AppTextStyles.BOLD_20,
                  ),
                  GapRow(
                    gap: AppSpacing.SPACE_8,
                    children: List.generate(
                      _buttonStates.length,
                      (i) => Expanded(
                        child: CustomButton(
                          onPressed: () => _handleButtonPress(i),
                          title: 'Button $i',
                          backgroundColor: _buttonStates[i]
                              ? AppColors.BRAND_SUB
                              : AppColors.BACKGROUND_SUB,
                          foregroundColor: _buttonStates[i]
                              ? AppColors.TEXT_BRAND
                              : AppColors.TEXT_PRIMARY,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
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
