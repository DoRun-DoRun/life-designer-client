import 'package:dorun_app_flutter/common/component/gap_column.dart';
import 'package:dorun_app_flutter/common/component/gap_row.dart';
import 'package:dorun_app_flutter/common/component/input_box.dart';
import 'package:dorun_app_flutter/common/component/padding_container.dart';
import 'package:dorun_app_flutter/common/constant/colors.dart';
import 'package:dorun_app_flutter/common/constant/fonts.dart';
import 'package:dorun_app_flutter/common/constant/spacing.dart';
import 'package:dorun_app_flutter/common/layout/default_layout.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                            const Text("홍길동", style: AppTextStyles.REGULAR_14),
                            Text(
                              "hongglidong@naver.com",
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
            const Column(
              children: [
                ProfileListItem(text: "로그인", color: AppColors.TEXT_BRAND),
                ProfileListItem(
                  text: "회원탈퇴",
                  color: Color(0xFFFF0000),
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

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                gap: 24,
                children: [
                  GapColumn(
                    gap: 24,
                    children: [
                      Text(
                        "이메일",
                        style: AppTextStyles.MEDIUM_12.copyWith(
                          color: AppColors.TEXT_SUB,
                        ),
                      ),
                      Text(
                        "honggildong@naver.com",
                        style: AppTextStyles.MEDIUM_12.copyWith(
                          color: AppColors.TEXT_SUB,
                        ),
                      ),
                    ],
                  ),
                  ReadOnlyBox(hintText: "이름", inputText: "홍길동", onTap: () {}),
                  ReadOnlyBox(
                    hintText: "자기소개",
                    inputText: "안녕하세요~",
                    onTap: () {},
                  ),
                  ReadOnlyBox(hintText: "나이", inputText: "23", onTap: () {}),
                  ReadOnlyBox(hintText: "직업", inputText: "학생", onTap: () {}),
                  ReadOnlyBox(
                    hintText: "계획 중 평소 어려워하는 내용",
                    inputText: "계획을 세우는 것은 쉬운데 꾸준히 실천하는 것이 어려운 것 같아요.",
                    onTap: () {},
                  ),
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
  bool _isSwitched = false;

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
              trackOutlineWidth: MaterialStateProperty.all(0),
              value: _isSwitched,
              onChanged: (bool value) {
                setState(() {
                  _isSwitched = value;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
