import 'package:dorun_app_flutter/common/constant/colors.dart';
import 'package:dorun_app_flutter/features/profile/view/profile_screen.dart';
import 'package:dorun_app_flutter/features/routine/view/routine_screen.dart';
import 'package:dorun_app_flutter/features/search/view/search_screen.dart';
import 'package:dorun_app_flutter/features/statistics/view/statistics_screen.dart';
import 'package:flutter/material.dart';

import '../layout/default_layout.dart';

class RootTab extends StatefulWidget {
  static String get routeName => 'home';

  const RootTab({Key? key}) : super(key: key);

  @override
  State<RootTab> createState() => _RootTabState();
}

class _RootTabState extends State<RootTab> with SingleTickerProviderStateMixin {
  late TabController controller;
  int index = 0;

  @override
  void initState() {
    super.initState();

    controller = TabController(length: 4, vsync: this);

    controller.addListener(tabListener);
  }

  @override
  void dispose() {
    controller.removeListener(tabListener);

    super.dispose();
  }

  void tabListener() {
    setState(() {
      index = controller.index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: PRIMARY_COLOR,
        unselectedItemColor: BODY_TEXT_COLOR,
        selectedFontSize: 10,
        unselectedFontSize: 10,
        type: BottomNavigationBarType.fixed,
        onTap: (int index) {
          controller.animateTo(index);
        },
        currentIndex: index,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search_outlined),
            label: '둘러보기',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long_outlined),
            label: '통계',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outlined),
            label: 'MY',
          ),
        ],
      ),
      child: TabBarView(
        physics: NeverScrollableScrollPhysics(),
        controller: controller,
        children: [
          RoutineScreen(),
          SearchScreen(),
          StatisticsScreen(),
          ProfileScreen()
        ],
      ),
    );
  }
}
