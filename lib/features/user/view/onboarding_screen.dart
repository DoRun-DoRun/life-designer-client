import 'package:dorun_app_flutter/common/component/custom_button.dart';
import 'package:dorun_app_flutter/common/component/gap_row.dart';
import 'package:dorun_app_flutter/common/constant/colors.dart';
import 'package:dorun_app_flutter/features/user/view/components/chat_bubble.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class OnboardingScreen extends StatefulWidget {
  static String get routeName => 'onboarding';
  final int? id;

  const OnboardingScreen({super.key, this.id});

  @override
  OnboardingScreenState createState() => OnboardingScreenState();
}

class OnboardingScreenState extends State<OnboardingScreen> {
  late int _currentIndex;
  bool _isLoading = false;
  bool _isQuestion = false;

  final List<String> messages = [
    "안녕하세요! 저와 대화하려면 저를 클릭해주세요!",
    "반가워요! 저는 루틴 설계를 도와주는 루틴 디자이너, 루디에요!",
    "앞으로 사용자님이 루틴을 통해 원하시는 일들을 이룰 수 있도록 돕는 업무를 맡고 있어요!",
    "혹시... 루틴에 대해서 알고 계신가요?",
    "루틴은 일정한 규칙과 순서에 따라 반복적으로 수행되는 활동이나 절차를 의미해요.",
    "언뜻 보면 습관과 비슷해보이지만 무의식적으로 행동을 수행하는 습관과 다르게 루틴은 의식적으로 반복하기 위해 세운 계획에 더 가까워요.",
    "좋아요 ~! 이제 저와 함께 루틴을 통해 사용자님의 삶을 설계하러 가봐요!",
  ];

  int _loadingIndex = 0;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.id ?? 0;
    _startLoading();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // MediaQuery, Theme 등 상속된 위젯에 대한 작업은 여기서 처리
    // final mediaQueryData = MediaQuery.of(context);
    // mediaQueryData를 사용한 초기화 작업을 여기서 수행

    precacheImage(const AssetImage('asset/images/hello.gif'), context);
    precacheImage(const AssetImage('asset/images/congrate.gif'), context);
    precacheImage(const AssetImage('asset/images/working.gif'), context);
  }

  void _startLoading() async {
    setState(() {
      _isLoading = true;
    });

    for (int i = 0; i < 3; i++) {
      await Future.delayed(const Duration(milliseconds: 500), () {
        setState(() {
          _loadingIndex = i + 1;
        });
      });
    }

    await Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _isLoading = false;
      });
    });
  }

  Future<void> _nextMessage() async {
    if (_isQuestion) return;

    if (_currentIndex < messages.length - 1) {
      if (_currentIndex == 2) {
        setState(() {
          _currentIndex++;
          _startLoading();
        });
        await Future.delayed(const Duration(milliseconds: 2000), () {
          setState(() {
            _isQuestion = true;
          });
        });
        return;
      }
      setState(() {
        _currentIndex++;
        _startLoading();
      });
    } else {
      setState(() {
        context.go('/onBoarding/userInfo');
        // context.goNamed(UserInfoScreen.routeName);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: _isLoading ? null : _nextMessage,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 32,
                      horizontal: 56,
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        if (_currentIndex < messages.length)
                          ChatBubble(
                            text: _isLoading ? '' : messages[_currentIndex],
                            isLoading: _isLoading,
                            loadingDots: _loadingIndex,
                          ),
                      ],
                    ),
                  ),
                  Center(
                    child: (_currentIndex <= 1)
                        ? Image.asset('asset/images/hello.gif')
                        : _currentIndex == 6
                            ? Image.asset('asset/images/congrate.gif')
                            : Image.asset('asset/images/working.gif'),
                  ),
                  const SizedBox(height: 60),
                ],
              ),
            ),
          ),
          Container(
            height: 103,
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            child: _isQuestion
                ? GapRow(
                    gap: 16,
                    children: [
                      Expanded(
                        child: CustomButton(
                          backgroundColor: AppColors.BRAND_SUB,
                          foregroundColor: AppColors.BRAND,
                          title: '모른다',
                          onPressed: () {
                            setState(() {
                              _currentIndex++;
                              _isQuestion = false;
                              _startLoading();
                            });
                          },
                        ),
                      ),
                      Expanded(
                        child: CustomButton(
                          backgroundColor: AppColors.BRAND,
                          foregroundColor: Colors.white,
                          title: '알고있다',
                          onPressed: () {
                            setState(() {
                              _currentIndex = 6;
                              _isQuestion = false;
                              _startLoading();
                            });
                          },
                        ),
                      ),
                    ],
                  )
                : null,
          )
        ],
      ),
    );
  }
}
