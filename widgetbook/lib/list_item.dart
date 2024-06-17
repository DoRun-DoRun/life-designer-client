import 'package:dorun_app_flutter/common/constant/colors.dart';
import 'package:dorun_app_flutter/common/constant/spacing.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'package:dorun_app_flutter/common/component/list_item.dart';
import 'package:dorun_app_flutter/common/component/gap_column.dart';

@widgetbook.UseCase(name: 'Default', type: List)
Widget buildListUseCase(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(24.0),
    child: SingleChildScrollView(
      child: GapColumn(
        gap: AppSpacing.SPACE_16,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("기본 값"),
          const ListItem(
            id: 0,
            title: '루틴 삭제하기',
            actionIcon: null,
          ),
          const Text("루틴"),
          const ListItem(
            id: 1,
            title: '운동하기',
            subTitle: '09:00 시작',
            isButton: true,
          ),
          const Text("세부 루틴"),
          const ListItem(
            id: 2,
            routinEmoji: '🧐',
            title: '어깨하기',
            subTitle: '10분',
          ),
          const Text("세부 루틴 완료"),
          const ListItem(
            id: 3,
            routinEmoji: '🧐',
            title: '어깨하기',
            subTitle: '10분',
            isDone: true,
          ),
          const Text("클릭 시 토스트"),
          ListItem(
            id: 3,
            routinEmoji: '🧐',
            title: '어깨하기',
            subTitle: '10분',
            onTap: () {
              _showAlertDialog(context);
            },
          ),
          const Text("우측 아이콘 커스텀"),
          const ListItem(
            id: 3,
            routinEmoji: '🧐',
            title: '어깨하기',
            subTitle: '10분',
            actionIcon: Icons.check,
            actionIconColor: AppColors.TEXT_BRAND,
          ),
        ],
      ),
    ),
  );
}

void _showAlertDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Alert'),
        content: const Text('This is an alert dialog.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // 대화상자 닫기
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // 원하는 동작 수행
              Navigator.of(context).pop(); // 대화상자 닫기
            },
            child: const Text('OK'),
          ),
        ],
      );
    },
  );
}
