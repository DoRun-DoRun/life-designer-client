import 'package:dorun_app_flutter/common/constant/colors.dart';
import 'package:dorun_app_flutter/common/constant/fonts.dart';
import 'package:dorun_app_flutter/common/utils/data_utils.dart';
import 'package:flutter/material.dart';

class CustomToggle extends StatefulWidget {
  final String title;
  final bool isSwitched;
  final TextStyle textStyle;
  final double padding;
  final Function(bool) onToggle;

  const CustomToggle({
    super.key,
    required this.title,
    required this.isSwitched,
    this.textStyle = AppTextStyles.MEDIUM_16,
    this.padding = 12,
    required this.onToggle,
  });

  @override
  CustomToggleState createState() => CustomToggleState();
}

class CustomToggleState extends State<CustomToggle> {
  late bool isSwitched;
  late Debouncer _debouncer;

  @override
  void initState() {
    super.initState();
    isSwitched = widget.isSwitched;
    _debouncer = Debouncer(milliseconds: 500);
  }

  void _toggleSwitch(bool value) {
    setState(() {
      isSwitched = value;
    });

    _debouncer.run(() {
      widget.onToggle(isSwitched);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: widget.padding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(widget.title, style: widget.textStyle),
          Transform.scale(
            scale: 0.8,
            child: Switch(
              activeColor: Colors.white,
              activeTrackColor: AppColors.BRAND,
              inactiveTrackColor: AppColors.TEXT_INVERT,
              inactiveThumbColor: Colors.white,
              trackOutlineWidth: WidgetStateProperty.all(0),
              value: isSwitched,
              onChanged: _toggleSwitch,
            ),
          ),
        ],
      ),
    );
  }
}
