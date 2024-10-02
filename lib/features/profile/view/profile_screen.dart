import 'package:dorun_app_flutter/common/component/custom_toggle.dart';
import 'package:dorun_app_flutter/common/component/gap_column.dart';
import 'package:dorun_app_flutter/common/component/gap_row.dart';
import 'package:dorun_app_flutter/common/component/padding_container.dart';
import 'package:dorun_app_flutter/common/constant/colors.dart';
import 'package:dorun_app_flutter/common/constant/fonts.dart';
import 'package:dorun_app_flutter/common/constant/spacing.dart';
import 'package:dorun_app_flutter/common/layout/default_layout.dart';
import 'package:dorun_app_flutter/common/utils/data_utils.dart';
import 'package:dorun_app_flutter/features/profile/view/edit_profile_screen.dart';
import 'package:dorun_app_flutter/features/user/model/user_model.dart';
import 'package:dorun_app_flutter/features/user/provider/auth_provider.dart';
import 'package:dorun_app_flutter/features/user/provider/user_me_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final user = ref.watch(userMeProvider);

    Future<void> launchURL(url) async {
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        throw 'Could not launch $url';
      }
    }

    if (user is UserModel) {
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
                              Text(user.name == '' ? '익명의 루티너' : user.name!,
                                  style: AppTextStyles.REGULAR_14),
                              Text(
                                processEmail(user.email),
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
              // ProfileListItem(
              //   text: "시스템 설정",
              //   onTap: () {
              //     Navigator.push(
              //       context,
              //       MaterialPageRoute(
              //           builder: (context) => const SystemSettingScreen()),
              //     );
              //   },
              // ),
              Column(
                children: [
                  ProfileListItem(
                    text: "공지 사항",
                    onTap: () => launchURL(
                      Uri.parse('https://life-designer.notion.site/'),
                    ),
                  ),
                  // const ProfileListItem(text: "업데이트 정보"),
                  // const ProfileListItem(text: "FAQ"),
                  // const ProfileListItem(text: "피드백"),
                  ProfileListItem(
                    text: "이용약관",
                    onTap: () => launchURL(
                      Uri.parse(
                          'https://life-designer.notion.site/104ddd0f35ba80d59d94ee77e8bdadd2'),
                    ),
                  ),
                  // const ProfileListItem(
                  //   text: "앱버전 1.0.1",
                  //   isUpdate: false,
                  // ),
                ],
              ),
              Column(
                children: [
                  ProfileListItem(
                    onTap: () => {
                      ref.read(authProvider.notifier).logout(),
                    },
                    text: "로그아웃",
                    color: AppColors.TEXT_SUB,
                  ),
                  ProfileListItem(
                    onTap: () => {
                      ref.read(authProvider.notifier).signOut(),
                    },
                    text: "회원탈퇴",
                    color: const Color(0xFFFF0000),
                  ),
                ],
              )
            ],
          ),
        ),
      );
    } else {
      return const Center(child: Text('User Data is not available'));
    }
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

class SystemSettingScreen extends StatelessWidget {
  const SystemSettingScreen({super.key});

  void updateServerWithToggleValue(bool newValue) {
    print("API 호출 - 알람 상태: $newValue");
  }

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
              child: GapColumn(
                children: [
                  const Text("시스템", style: AppTextStyles.BOLD_16),
                  const SizedBox(height: 16),
                  CustomToggle(
                      title: '전체 푸시 알림',
                      isSwitched: false,
                      onToggle: updateServerWithToggleValue),
                  CustomToggle(
                      title: '습관 관련 마케팅 알림',
                      isSwitched: false,
                      onToggle: updateServerWithToggleValue),
                  CustomToggle(
                      title: '야간 알림 (21:00~08:00)',
                      isSwitched: false,
                      onToggle: updateServerWithToggleValue),
                ],
              ),
            ),
            Container(
              decoration: const BoxDecoration(color: Colors.white),
              padding: const EdgeInsets.only(
                  left: 24, right: 24, top: 16, bottom: 8),
              child: GapColumn(
                children: [
                  const Text("세부 루틴 기본값", style: AppTextStyles.BOLD_16),
                  const SizedBox(height: 16),
                  CustomToggle(
                      title: '타이머 완료 시 자동으로 넘어가기',
                      isSwitched: false,
                      onToggle: updateServerWithToggleValue),
                  CustomToggle(
                      title: '타이머 완료 시 알림으로 알리기',
                      isSwitched: false,
                      onToggle: updateServerWithToggleValue),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
