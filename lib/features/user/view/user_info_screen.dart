import 'package:dorun_app_flutter/common/component/custom_bottom_sheet.dart';
import 'package:dorun_app_flutter/common/component/custom_button.dart';
import 'package:dorun_app_flutter/common/component/gap_column.dart';
import 'package:dorun_app_flutter/common/component/input_box.dart';
import 'package:dorun_app_flutter/common/constant/colors.dart';
import 'package:dorun_app_flutter/common/constant/fonts.dart';
import 'package:dorun_app_flutter/common/layout/default_layout.dart';
import 'package:dorun_app_flutter/features/user/provider/user_me_provider.dart';
import 'package:dorun_app_flutter/features/user/repository/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class UserInfoScreen extends ConsumerStatefulWidget {
  static String get routeName => 'userInfo';

  const UserInfoScreen({super.key});

  @override
  ConsumerState<UserInfoScreen> createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends ConsumerState<UserInfoScreen> {
  final TextEditingController _nameController = TextEditingController();
  String? _selectedName;
  String? _selectedAge;
  String? _selectedGender;
  String? _selectedJob;
  List<String> _selectedDifficulties = [];
  List<String> guideQuestions = [
    '그전에 혹시\n사용자님을 어떻게 부르면 될까요?',
    '님께 더 나은 루틴을 제공하기 위해 나이정보가 필요해요.',
    '성별을 알려주세요',
    '하시는 일을 알려주세요',
  ];

  String getCurrentGuideQuestion() {
    if (_selectedName == null) {
      return guideQuestions[0];
    } else if (_selectedAge == null) {
      if (_selectedName != '') return _selectedName! + guideQuestions[1];
      return '사용자${guideQuestions[1]}';
    } else if (_selectedGender == null) {
      return guideQuestions[2];
    } else if (_selectedJob == null) {
      return guideQuestions[3];
    } else {
      return "계획을 지키면서 어려운점이 있으신가요?";
    }
  }

  void _setUserName(String value) {
    setState(() {
      _selectedName = value;
    });
    if (_selectedAge == null) {
      showYearPicker(context, (value) {
        setState(() {
          _selectedAge = (DateTime.now().year - value).toString();
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final userRepository = ref.watch(userRepositoryProvider);

    return DefaultLayout(
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: GapColumn(
                  gap: 16,
                  children: [
                    Text(
                      getCurrentGuideQuestion(),
                      style: AppTextStyles.BOLD_20,
                    ),
                    if (_selectedName != null &&
                        _selectedAge != null &&
                        _selectedGender != null &&
                        _selectedJob != null)
                      Builder(builder: (innerContext) {
                        return ReadOnlyBox(
                          hintText: "계획 중 평소 어려워하는 내용",
                          inputText: _selectedDifficulties.join(', '),
                          onTap: () {
                            showSelectionMulitySheet(innerContext, [
                              "목표 불명확",
                              "꾸준함 부족",
                              "과도한 이상화",
                              "일정 변화",
                              "동기 저하",
                              "시간 부족",
                              "실패 두려움",
                              "완벽주의",
                              "즉각적인 결과 욕구",
                              "자책감"
                            ], (selectedValues) {
                              setState(() {
                                _selectedDifficulties = selectedValues;
                              });
                            }, _selectedDifficulties);
                          },
                        );
                      }),
                    if (_selectedName != null &&
                        _selectedAge != null &&
                        _selectedGender != null)
                      Builder(builder: (innerContext) {
                        return ReadOnlyBox(
                          hintText: "직업",
                          inputText: _selectedJob ?? '',
                          onTap: () {
                            showSelectionSheet(
                              innerContext,
                              ["학생", "직장인", "프리랜서", "자영업자", "취준생", "기타"],
                              (value) {
                                setState(() {
                                  _selectedJob = value;
                                });
                              },
                              "하시는 일이 무엇인가요?",
                              _selectedJob ?? '',
                            );
                          },
                        );
                      }),
                    if (_selectedName != null && _selectedAge != null)
                      Builder(builder: (innerContext) {
                        return ReadOnlyBox(
                          hintText: "성별",
                          inputText: _selectedGender ?? '',
                          onTap: () {
                            showSelectionSheet(
                              innerContext,
                              ["남성", "여성"],
                              (value) {
                                setState(() {
                                  _selectedGender = value;
                                });
                              },
                              "성별을 알려주세요",
                              _selectedGender ?? '',
                            );
                          },
                        );
                      }),
                    if (_selectedName != null)
                      Builder(builder: (innerContext) {
                        return ReadOnlyBox(
                          hintText: "나이",
                          inputText: _selectedAge != null && _selectedAge != ''
                              ? '$_selectedAge살'
                              : '',
                          onTap: () {
                            showYearPicker(
                              innerContext,
                              (value) {
                                setState(() {
                                  _selectedAge =
                                      (DateTime.now().year - value).toString();
                                });
                              },
                            );
                          },
                        );
                      }),
                    InputBox(
                      controller: _nameController,
                      hintText: '이름',
                      onSubmitted: _setUserName,
                    ),
                  ],
                ),
              ),
            ),
            if (_selectedDifficulties.isEmpty)
              Builder(builder: (innerContext) {
                return CustomButton(
                  title: "나중에 입력할래요",
                  onPressed: () {
                    setState(() {
                      _selectedName ??= '';
                      _selectedAge ??= '';
                      _selectedGender ??= '';
                      _selectedJob ??= '';

                      showSelectionMulitySheet(innerContext, [
                        "목표 불명확",
                        "꾸준함 부족",
                        "과도한 이상화",
                        "일정 변화",
                        "동기 저하",
                        "시간 부족",
                        "실패 두려움",
                        "완벽주의",
                        "즉각적인 결과 욕구",
                        "자책감",
                      ], (selectedValues) {
                        setState(() {
                          _selectedDifficulties = selectedValues;
                        });
                      }, _selectedDifficulties);
                    });
                  },
                );
              }),
            if (_selectedAge != null &&
                _selectedDifficulties.isNotEmpty &&
                _selectedGender != null &&
                _selectedName != null &&
                _selectedJob != null)
              CustomButton(
                backgroundColor: AppColors.BRAND,
                foregroundColor: Colors.white,
                title: "완료하기",
                onPressed: () async {
                  await userRepository.updateUser(
                    name: _selectedName,
                    age: _selectedAge,
                    job: _selectedJob,
                    gender: _selectedGender,
                    challenges: _selectedDifficulties,
                    memberStatus: 'Onboarding',
                  );
                  if (context.mounted) context.go('/');
                  ref.invalidate(userMeProvider);
                },
              ),
          ],
        ),
      ),
    );
  }
}
