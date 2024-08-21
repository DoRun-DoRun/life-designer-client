import 'package:dorun_app_flutter/common/component/custom_button.dart';
import 'package:dorun_app_flutter/common/component/gap_column.dart';
import 'package:dorun_app_flutter/common/component/gap_row.dart';
import 'package:dorun_app_flutter/common/component/input_box.dart';
import 'package:dorun_app_flutter/common/component/padding_container.dart';
import 'package:dorun_app_flutter/common/constant/colors.dart';
import 'package:dorun_app_flutter/common/constant/fonts.dart';
import 'package:dorun_app_flutter/common/constant/spacing.dart';
import 'package:dorun_app_flutter/common/layout/default_layout.dart';
import 'package:dorun_app_flutter/features/user/model/user_model.dart';
import 'package:dorun_app_flutter/features/user/provider/auth_provider.dart';
import 'package:dorun_app_flutter/features/user/provider/user_me_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// TODO
// 나이, 직업, 어려운일 선택하게 만들기
// UserEdit - 서버 API만들기

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final user = ref.read(userMeProvider) as UserModel;

    return DefaultLayout(
      title: 'MY',
      child: SingleChildScrollView(
        child: GapColumn(
          gap: 16,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const EditProfileScreen()),
                );
              },
              child: PaddingContainer(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GapRow(
                      gap: 16,
                      children: [
                        Container(
                          width: 64,
                          height: 64,
                          decoration: const BoxDecoration(
                            color: AppColors.TEXT_INVERT,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.person_outline,
                            size: 42,
                            color: Colors.white,
                          ),
                        ),
                        GapColumn(
                          children: [
                            Text(user.name ?? '이름없는 루티너',
                                style: AppTextStyles.REGULAR_14),
                            Text(
                              user.email,
                              style: AppTextStyles.REGULAR_12.copyWith(
                                color: AppColors.TEXT_SUB,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                    const Icon(
                      Icons.chevron_right,
                      size: 30,
                      color: AppColors.TEXT_INVERT,
                    )
                  ],
                ),
              ),
            ),
            ProfileListItem(
              text: "시스템 설정",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SystemSettingScreen()),
                );
              },
            ),
            const Column(
              children: [
                ProfileListItem(text: "공지 사항"),
                ProfileListItem(text: "업데이트 정보"),
                ProfileListItem(text: "FAQ"),
                ProfileListItem(text: "피드백"),
                ProfileListItem(text: "이용약관"),
                ProfileListItem(
                  text: "앱버전 1.0.1",
                  isUpdate: true,
                ),
              ],
            ),
            Column(
              children: [
                ProfileListItem(
                  onTap: () => {ref.read(authProvider.notifier).logout()},
                  text: "로그아웃",
                  color: AppColors.TEXT_SUB,
                ),
                ProfileListItem(
                  onTap: () => {ref.read(authProvider.notifier).logout()},
                  text: "회원탈퇴",
                  color: const Color(0xFFFF0000),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class ProfileListItem extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;
  final bool? isUpdate;
  final Color color;

  const ProfileListItem({
    super.key,
    required this.text,
    this.onTap,
    this.isUpdate,
    this.color = AppColors.TEXT_PRIMARY,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: PaddingContainer(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(text, style: AppTextStyles.MEDIUM_14.copyWith(color: color)),
            isUpdate != null
                ? Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                    decoration: BoxDecoration(
                      color: isUpdate!
                          ? AppColors.BRAND
                          : AppColors.BACKGROUND_SUB,
                      borderRadius: AppRadius.FULL,
                    ),
                    child: Text(
                      isUpdate! ? "업데이트" : "최신버전",
                      style: AppTextStyles.REGULAR_12.copyWith(
                        color:
                            isUpdate! ? Colors.white : AppColors.TEXT_SECONDARY,
                      ),
                    ),
                  )
                : const Icon(
                    Icons.chevron_right,
                    size: 30,
                    color: AppColors.TEXT_INVERT,
                  )
          ],
        ),
      ),
    );
  }
}

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  EditProfileScreenState createState() => EditProfileScreenState();
}

class EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  String selectedGender = '';
  String selectedAge = '';
  String selectedJob = '';
  List<String> selectedDifficulties = [];
  final TextEditingController nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final user = ref.read(userMeProvider) as UserModel;

    nameController.text = user.name ?? '';
    selectedAge = (user.age ?? '').toString();
    selectedGender = user.gender ?? '';
    selectedJob = user.job ?? '';
    selectedDifficulties = (user.challenges ?? '')
        .split(',')
        .map((item) => item.trim())
        .where((item) => item.isNotEmpty)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.read(userMeProvider) as UserModel;

    void showYearPicker(
      BuildContext context,
      ValueChanged<int> onYearSelected, {
      int startYear = 1900,
    }) {
      final currentYear = DateTime.now().year;
      int selectedYear = currentYear;

      showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            decoration: const BoxDecoration(
                color: Colors.white, borderRadius: AppRadius.ROUNDED_16),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 36),
            height: 420,
            child: GapColumn(
              gap: 32,
              children: [
                const Text("태어난 연도를 알려주세요.", style: AppTextStyles.BOLD_20),
                Expanded(
                  child: CupertinoPicker(
                    itemExtent: 32.0,
                    scrollController: FixedExtentScrollController(
                      initialItem: currentYear - startYear - 20,
                    ),
                    onSelectedItemChanged: (int index) {
                      selectedYear = startYear + index;
                    },
                    children: List<Widget>.generate(
                      currentYear - startYear + 1,
                      (int index) {
                        return Center(
                          child: Text('${startYear + index}'),
                        );
                      },
                    ),
                  ),
                ),
                CustomButton(
                    onPressed: () {
                      onYearSelected(selectedYear);
                      Navigator.pop(context);
                    },
                    title: "선택완료",
                    foregroundColor: Colors.white,
                    backgroundColor: AppColors.BRAND),
              ],
            ),
          );
        },
      );
    }

    void showSelectionSheet(BuildContext context, List<String> options,
        ValueChanged<String> onSelected, String text, String selectedOption) {
      showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            decoration: const BoxDecoration(
                color: Colors.white, borderRadius: AppRadius.ROUNDED_16),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 36),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(text, style: AppTextStyles.BOLD_20),
                const SizedBox(height: 36),
                GridView.builder(
                  shrinkWrap: true,
                  itemCount: options.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // 2열로 배치
                    mainAxisSpacing: 16.0,
                    crossAxisSpacing: 16.0,
                    childAspectRatio: 3.0, // 각 항목의 가로 세로 비율
                  ),
                  itemBuilder: (context, index) {
                    final option = options[index];
                    final isSelected = option == selectedOption;

                    return GestureDetector(
                      onTap: () {
                        onSelected(option);
                        Navigator.pop(context);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.BRAND_SUB
                              : AppColors.BACKGROUND_SUB,
                          borderRadius: AppRadius.ROUNDED_16,
                        ),
                        child: Center(
                          child: Text(
                            option,
                            style: AppTextStyles.MEDIUM_16.copyWith(
                              color: isSelected
                                  ? AppColors.BRAND
                                  : AppColors.TEXT_SECONDARY,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                )
              ],
            ),
          );
        },
      );
    }

    void showSelectionMulitySheet(
      BuildContext context,
      List<String> options,
      ValueChanged<List<String>> onSelected,
    ) {
      List<String> tempSelected = selectedDifficulties;

      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return Container(
            decoration: const BoxDecoration(
                color: Colors.white, borderRadius: AppRadius.ROUNDED_16),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 36),
            child: StatefulBuilder(
              builder: (context, setState) {
                return GapColumn(
                  mainAxisSize: MainAxisSize.min,
                  gap: 36,
                  children: [
                    const Text("평소 계획을 지키면서 어려운점이 있나요?",
                        style: AppTextStyles.BOLD_20),
                    GridView.builder(
                      shrinkWrap: true,
                      itemCount: options.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, // 2열로 배치
                        mainAxisSpacing: 16.0,
                        crossAxisSpacing: 16.0,
                        childAspectRatio: 3.0, // 각 항목의 가로 세로 비율
                      ),
                      itemBuilder: (context, index) {
                        final option = options[index];
                        final isSelected = tempSelected.contains(option);

                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              if (isSelected) {
                                tempSelected.remove(option);
                              } else {
                                if (tempSelected.length < 3) {
                                  tempSelected.add(option);
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('최대 3개까지 선택할 수 있습니다.'),
                                    ),
                                  );
                                }
                              }
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.BRAND_SUB
                                  : AppColors.BACKGROUND_SUB,
                              borderRadius: AppRadius.ROUNDED_16,
                            ),
                            child: Center(
                              child: Text(
                                option,
                                style: AppTextStyles.MEDIUM_16.copyWith(
                                  color: isSelected
                                      ? AppColors.BRAND
                                      : AppColors.TEXT_SECONDARY,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    CustomButton(
                      onPressed: () {
                        onSelected(tempSelected);
                        Navigator.pop(context);
                      },
                      title: "선택완료",
                      foregroundColor: tempSelected.isNotEmpty
                          ? Colors.white
                          : AppColors.TEXT_INVERT,
                      backgroundColor: tempSelected.isNotEmpty
                          ? AppColors.BRAND
                          : AppColors.BACKGROUND_SUB,
                    ),
                  ],
                );
              },
            ),
          );
        },
      );
    }

    return DefaultLayout(
      title: "프로필 수정",
      child: SingleChildScrollView(
        child: GapColumn(
          gap: 24,
          children: [
            PaddingContainer(
              width: double.infinity,
              child: Center(
                child: Stack(
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      decoration: const BoxDecoration(
                        color: AppColors.TEXT_INVERT,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.person_outline,
                        size: 90,
                        color: Colors.white,
                      ),
                    ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: const BoxDecoration(
                          color: Colors.black,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.camera_alt,
                          size: 20,
                          color: Colors.white,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            PaddingContainer(
              child: GapColumn(
                gap: 36,
                children: [
                  GapColumn(
                    gap: 24,
                    children: [
                      Text(
                        "이메일",
                        style: AppTextStyles.MEDIUM_12
                            .copyWith(color: AppColors.TEXT_SUB),
                      ),
                      Text(
                        user.email,
                        style: AppTextStyles.REGULAR_16
                            .copyWith(color: AppColors.TEXT_SUB),
                      ),
                      InputBox(controller: nameController, hintText: '이름'),
                      ReadOnlyBox(
                        hintText: "성별",
                        inputText: selectedGender,
                        onTap: () {
                          showSelectionSheet(context, ["남성", "여성"], (value) {
                            setState(() {
                              selectedGender = value;
                            });
                          }, "성별을 알려주세요", selectedGender);
                        },
                      ),
                      ReadOnlyBox(
                          hintText: "나이",
                          inputText: "$selectedAge살",
                          onTap: () {
                            showYearPicker(context, (value) {
                              setState(() {
                                selectedAge =
                                    (DateTime.now().year - value).toString();
                              });
                            });
                          }),
                      ReadOnlyBox(
                        hintText: "직업",
                        inputText: selectedJob,
                        onTap: () {
                          showSelectionSheet(context, [
                            "학생",
                            "직장인",
                            "프리랜서",
                            "자영업자",
                            "취준생",
                            "기타"
                          ], (value) {
                            setState(() {
                              selectedJob = value;
                            });
                          }, "하시는 일이 무엇인가요?", selectedJob);
                        },
                      ),
                      ReadOnlyBox(
                        hintText: "계획 중 평소 어려워하는 내용",
                        inputText: selectedDifficulties.join(', '),
                        onTap: () {
                          showSelectionMulitySheet(context, [
                            "의욕 떨어짐",
                            "목표가 너무 큼",
                            "시간 부족",
                            "갑작스런 일",
                            "지속하기 어려움",
                            "우선순위 정하기",
                            "주변의 도움 부족",
                            "유혹에 약함",
                            "결과가 안 보임",
                            "스트레스 받음",
                            "자원 부족",
                            "계획이 애매함",
                          ], (selectedValues) {
                            setState(() {
                              selectedDifficulties = selectedValues;
                            });
                          });
                        },
                      ),
                    ],
                  ),
                  CustomButton(
                    onPressed: () {},
                    title: "수정하기",
                    backgroundColor: AppColors.BRAND,
                    foregroundColor: Colors.white,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class SystemSettingScreen extends StatelessWidget {
  const SystemSettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: "시스템 설정",
      child: SingleChildScrollView(
        child: GapColumn(
          gap: 16,
          children: [
            Container(
              decoration: const BoxDecoration(color: Colors.white),
              padding: const EdgeInsets.only(
                  left: 24, right: 24, top: 16, bottom: 8),
              child: const GapColumn(
                children: [
                  Text("시스템", style: AppTextStyles.BOLD_16),
                  SizedBox(height: 16),
                  SystemSettingListItem(title: '전체 푸시 알림'),
                  SystemSettingListItem(title: '습관 관련 마케팅 알림'),
                  SystemSettingListItem(title: '야간 알림 (21:00~08:00)'),
                ],
              ),
            ),
            Container(
              decoration: const BoxDecoration(color: Colors.white),
              padding: const EdgeInsets.only(
                  left: 24, right: 24, top: 16, bottom: 8),
              child: const GapColumn(
                children: [
                  Text("세부 루틴 기본값", style: AppTextStyles.BOLD_16),
                  SizedBox(height: 16),
                  SystemSettingListItem(title: '타이머 완료 시 자동으로 넘어가기'),
                  SystemSettingListItem(title: '타이머 완료 시 알림으로 알리기'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SystemSettingListItem extends StatefulWidget {
  final String title;

  const SystemSettingListItem({
    super.key,
    required this.title,
  });

  @override
  SystemSettingListItemState createState() => SystemSettingListItemState();
}

class SystemSettingListItemState extends State<SystemSettingListItem> {
  bool isSwitched = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 19.5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(widget.title, style: const TextStyle(fontSize: 16)),
          Transform.scale(
            scale: 0.8,
            child: Switch(
              activeColor: Colors.white,
              activeTrackColor: AppColors.BRAND,
              inactiveTrackColor: AppColors.TEXT_INVERT,
              inactiveThumbColor: Colors.white,
              trackOutlineWidth: WidgetStateProperty.all(0),
              value: isSwitched,
              onChanged: (bool value) {
                setState(() {
                  isSwitched = value;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
