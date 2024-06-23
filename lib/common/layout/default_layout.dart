import 'package:dorun_app_flutter/common/constant/colors.dart';
import 'package:dorun_app_flutter/common/constant/fonts.dart';
import 'package:flutter/material.dart';

class DefaultLayout extends StatelessWidget {
  final IconButton? leftIcon;
  final IconButton? rightIcon;
  final String? title;
  final PreferredSizeWidget? customAppBar;
  final Color backgroundColor;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;
  final Widget child;

  const DefaultLayout({
    super.key,
    this.leftIcon,
    this.rightIcon,
    this.title,
    this.customAppBar,
    this.backgroundColor = AppColors.BACKGROUND_SUB,
    this.bottomNavigationBar,
    this.floatingActionButton,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar ??
          AppBar(
            leading: leftIcon,
            backgroundColor: Colors.white,
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 24.0),
                child: rightIcon,
              )
            ],
            elevation: 0,
            title: Text(
              title ?? '',
              style: AppTextStyles.MEDIUM_16.copyWith(
                color: Colors.black,
              ),
            ),
          ),
      backgroundColor: backgroundColor,
      bottomNavigationBar: bottomNavigationBar,
      floatingActionButton: floatingActionButton,
      body: child,
    );
  }
}

// class DefaultLayout extends StatelessWidget {
//   final Color? backgroundColor;
//   final Widget child;
//   final String? title;
//   final Widget? bottomNavigationBar;
//   final Widget? floatingActionButton;

//   const DefaultLayout({
//     required this.child,
//     this.backgroundColor,
//     this.title,
//     this.bottomNavigationBar,
//     this.floatingActionButton,
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: backgroundColor ?? AppColors.BACKGROUND_SUB,
//       appBar: renderAppBar(),
//       body: child,
//       bottomNavigationBar: bottomNavigationBar,
//       floatingActionButton: floatingActionButton,
//     );
//   }

//   AppBar? renderAppBar() {
//     if (title == null) {
//       return null;
//     } else {
//       return AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         title: Text(
//           title!,
//           style: AppTextStyles.MEDIUM_16,
//         ),
//         // foregroundColor: Colors.black,
//       );
//     }
//   }
// }
