import 'package:dorun_app_flutter/common/component/custom_bottom_sheet.dart';
import 'package:dorun_app_flutter/common/component/custom_button.dart';
import 'package:dorun_app_flutter/common/component/gap_column.dart';
import 'package:dorun_app_flutter/common/component/input_box.dart';
import 'package:dorun_app_flutter/common/component/padding_container.dart';
import 'package:dorun_app_flutter/common/constant/colors.dart';
import 'package:dorun_app_flutter/common/constant/fonts.dart';
import 'package:dorun_app_flutter/common/layout/default_layout.dart';
import 'package:dorun_app_flutter/common/utils/data_utils.dart';
import 'package:dorun_app_flutter/features/user/model/user_model.dart';
import 'package:dorun_app_flutter/features/user/provider/user_me_provider.dart';
import 'package:dorun_app_flutter/features/user/repository/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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
    selectedAge = user.age ?? '';
    selectedGender = user.gender ?? '';
    selectedJob = user.job ?? '';
    selectedDifficulties = (user.challenges ?? [])
        .map((item) => item.trim())
        .where((item) => item.isNotEmpty)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.read(userMeProvider) as UserModel;
    final userRepository = ref.watch(userRepositoryProvider);

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
                    // Positioned(
                    //   right: 0,
                    //   bottom: 0,
                    //   child: Container(
                    //     width: 30,
                    //     height: 30,
                    //     decoration: const BoxDecoration(
                    //       color: Colors.black,
                    //       shape: BoxShape.circle,
                    //     ),
                    //     child: const Icon(
                    //       Icons.camera_alt,
                    //       size: 20,
                    //       color: Colors.white,
                    //     ),
                    //   ),
                    // )
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
                        processEmail(user.email),
                        style: AppTextStyles.REGULAR_16
                            .copyWith(color: AppColors.TEXT_SUB),
                      ),
                      InputBox(
                        controller: nameController,
                        hintText: '이름',
                        focused: nameController.text != '',
                      ),
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
                        inputText: selectedAge != '' ? '$selectedAge살' : '',
                        onTap: () {
                          showYearPicker(context, (value) {
                            setState(() {
                              selectedAge =
                                  (DateTime.now().year - value).toString();
                            });
                          });
                        },
                      ),
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
                          }, selectedDifficulties);
                        },
                      ),
                    ],
                  ),
                  CustomButton(
                    onPressed: () async {
                      await userRepository.updateUser(
                        name: nameController.text,
                        age: selectedAge,
                        job: selectedJob,
                        gender: selectedGender,
                        challenges: selectedDifficulties,
                      );
                      ref.invalidate(userMeProvider);
                      if (context.mounted) context.pop();
                    },
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
