import 'package:dorun_app_flutter/common/component/gap_column.dart';
import 'package:dorun_app_flutter/common/component/padding_container.dart';
import 'package:dorun_app_flutter/common/constant/fonts.dart';
import 'package:dorun_app_flutter/common/constant/spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

import '../../../common/layout/default_layout.dart';

class LoginScreen extends ConsumerStatefulWidget {
  static String get routeName => 'login';

  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  String username = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    // final state = ref.watch(userMeProvider);
    const List<String> scopes = <String>[
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ];

    GoogleSignIn googleSignIn = GoogleSignIn(
      // Optional clientId
      // clientId: 'your-client_id.apps.googleusercontent.com',
      scopes: scopes,
    );

    Future<void> handleSignIn() async {
      try {
        await googleSignIn.signIn();
        print(googleSignIn.currentUser);
      } catch (error) {
        print(error);
      }
    }

    return DefaultLayout(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const PaddingContainer(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text('당신의 삶을 설계하는\n맞춤형 라이프 디자이너,\n라디에 오신걸 환영합니다!',
                      style: AppTextStyles.BOLD_20),
                  SizedBox(height: 16.0),
                  Text('5초 가입으로 좋은 습관들을 만들어보세요',
                      style: AppTextStyles.MEDIUM_14),
                  SizedBox(height: 32.0),
                  // ElevatedButton(
                  //   onPressed: state is UserModelLoading
                  //       ? null
                  //       : () async {
                  //           //TODO: Must Remove after Testing
                  //           if (username == 'test@test.com' &&
                  //               password == 't12345') {
                  //             context.goNamed(RootTab.routeName);
                  //           } else {
                  //             // 실제 로그인 로직 실행
                  //             ref.read(userMeProvider.notifier).login(
                  //                   username: username,
                  //                   password: password,
                  //                 );
                  //           }
                  //         },
                  //   style: ElevatedButton.styleFrom(
                  //     backgroundColor: AppColors.BACKGROUND_SUB,
                  //   ),
                  //   child: const Text(
                  //     '로그인',
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
            child: GapColumn(
              gap: 24,
              children: [
                GestureDetector(
                    onTap: () async {
                      if (await isKakaoTalkInstalled()) {
                        try {
                          OAuthToken token =
                              await UserApi.instance.loginWithKakaoTalk();
                          print('카카오톡으로 로그인 성공 ${token.accessToken}');
                        } catch (error) {
                          print('카카오톡으로 로그인 실패 $error');
                        }
                      } else {
                        try {
                          OAuthToken token =
                              await UserApi.instance.loginWithKakaoAccount();
                          print('카카오계정으로 로그인 성공 ${token.accessToken}');
                        } catch (error) {
                          print('카카오계정으로 로그인 실패 $error');
                        }
                      }
                    },
                    child: const LoginButton(socialType: SocialType.kakao)),
                GestureDetector(
                    onTap: handleSignIn,
                    child: const LoginButton(socialType: SocialType.google)),
                const LoginButton(socialType: SocialType.apple),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

enum SocialType {
  kakao,
  google,
  apple,
}

class LoginButton extends StatelessWidget {
  final SocialType socialType;

  const LoginButton({
    super.key,
    required this.socialType,
  });

  @override
  Widget build(BuildContext context) {
    String text, image;
    // Image image;
    Color color;

    switch (socialType) {
      case SocialType.kakao:
        text = 'Kakao로 계속하기';
        image = 'kakao';
        color = const Color(0xFFFEE500);
        break;
      case SocialType.google:
        text = 'Google로 계속하기';
        image = 'google';
        color = const Color(0xFFFFFFFF);
        break;
      case SocialType.apple:
        text = 'Apple로 계속하기';
        image = 'apple';
        color = const Color(0xFF0A0A0A);
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 16,
      ),
      decoration:
          BoxDecoration(color: color, borderRadius: AppRadius.ROUNDED_4),
      child: Row(
        children: [
          Image.asset('asset/images/$image.png', width: 24, height: 24),
          Expanded(
            child: Center(
              child: Text(
                text,
                style: AppTextStyles.MEDIUM_14.copyWith(
                    color: socialType == SocialType.apple
                        ? Colors.white
                        : const Color.fromRGBO(0, 0, 0, .85)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
