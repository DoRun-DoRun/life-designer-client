import 'package:dorun_app_flutter/common/component/gap_column.dart';
import 'package:dorun_app_flutter/common/constant/colors.dart';
import 'package:dorun_app_flutter/common/constant/fonts.dart';
import 'package:dorun_app_flutter/common/constant/spacing.dart';
import 'package:flutter/material.dart';

class InputBox extends StatefulWidget {
  final TextEditingController controller;
  final String? hintText;
  final ValueChanged<String>? onSubmitted;

  const InputBox({
    super.key,
    required this.controller,
    this.hintText = '',
    this.onSubmitted,
  });

  @override
  InputBoxState createState() => InputBoxState();
}

class InputBoxState extends State<InputBox> {
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GapColumn(
      gap: AppSpacing.SPACE_8,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _isFocused || widget.controller.text != '' ? widget.hintText! : '',
          style: AppTextStyles.MEDIUM_12,
        ),
        TextField(
          controller: widget.controller,
          focusNode: _focusNode,
          onSubmitted: widget.onSubmitted,
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.BACKGROUND_SUB,
            hintText: _isFocused ? '' : widget.hintText,
            hintStyle: AppTextStyles.REGULAR_20.copyWith(
              color: AppColors.TEXT_SUB,
            ),
            contentPadding: const EdgeInsets.all(
              16,
            ),
            border: const OutlineInputBorder(
              borderRadius: AppRadius.ROUNDED_8,
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }
}
