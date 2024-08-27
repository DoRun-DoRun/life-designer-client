import 'package:dorun_app_flutter/common/component/custom_button.dart';
import 'package:dorun_app_flutter/common/constant/colors.dart';
import 'package:dorun_app_flutter/common/constant/fonts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<Duration?> setAlertTime({
  required BuildContext context,
  Duration? initialTime,
}) async {
  Duration? selectedTime = initialTime;

  await showModalBottomSheet(
    context: context,
    builder: (BuildContext builder) {
      return SizedBox(
        height: 375,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
          child: Column(
            children: [
              const Text('얼마전에 알람 드릴까요?', style: AppTextStyles.BOLD_20),
              Expanded(
                child: CupertinoTimerPicker(
                  mode: CupertinoTimerPickerMode.hm,
                  initialTimerDuration: initialTime != null
                      ? Duration(
                          hours: initialTime.inHours,
                          minutes: initialTime.inMinutes)
                      : const Duration(minutes: 10),
                  minuteInterval: 1,
                  onTimerDurationChanged: (Duration newDuration) {
                    int hours = newDuration.inHours;
                    int minutes = newDuration.inMinutes % 60;

                    selectedTime = Duration(hours: hours, minutes: minutes);
                  },
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      onPressed: () {
                        selectedTime = null; // 알림 없이 선택
                        Navigator.of(context).pop();
                      },
                      title: '알림 없이',
                      backgroundColor: AppColors.BRAND_SUB,
                      foregroundColor: AppColors.TEXT_BRAND,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: CustomButton(
                      onPressed: () {
                        selectedTime ??= const Duration(minutes: 10);
                        Navigator.of(context).pop();
                      },
                      title: '저장',
                      backgroundColor: AppColors.BRAND_SUB,
                      foregroundColor: AppColors.TEXT_BRAND,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );

  return selectedTime;
}

Future<Duration?> setProcessTime({
  required BuildContext context,
  Duration? initialTime,
}) async {
  Duration? selectedTime = initialTime;

  await showModalBottomSheet(
    context: context,
    builder: (BuildContext builder) {
      return SizedBox(
        height: 375,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
          child: Column(
            children: [
              const Text('세부 루틴을 수행하는데 얼마나 걸리나요?',
                  style: AppTextStyles.BOLD_20),
              Expanded(
                child: CupertinoTimerPicker(
                  mode: CupertinoTimerPickerMode.hm,
                  initialTimerDuration: initialTime != null
                      ? Duration(
                          hours: initialTime.inHours,
                          minutes: initialTime.inMinutes)
                      : const Duration(minutes: 10),
                  minuteInterval: 1,
                  onTimerDurationChanged: (Duration newDuration) {
                    int hours = newDuration.inHours;
                    int minutes = newDuration.inMinutes % 60;

                    selectedTime = Duration(hours: hours, minutes: minutes);
                  },
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      onPressed: () {
                        selectedTime = null; // 알림 없이 선택
                        Navigator.of(context).pop();
                      },
                      title: '취소하기',
                      backgroundColor: AppColors.BRAND_SUB,
                      foregroundColor: AppColors.TEXT_BRAND,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: CustomButton(
                      onPressed: () {
                        selectedTime ??= const Duration(minutes: 10);
                        Navigator.of(context).pop();
                      },
                      title: '저장',
                      backgroundColor: AppColors.BRAND_SUB,
                      foregroundColor: AppColors.TEXT_BRAND,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );

  return selectedTime;
}
