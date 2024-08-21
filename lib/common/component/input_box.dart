import 'package:dorun_app_flutter/common/component/gap_column.dart';
import 'package:dorun_app_flutter/common/constant/colors.dart';
import 'package:dorun_app_flutter/common/constant/fonts.dart';
import 'package:dorun_app_flutter/common/constant/spacing.dart';
import 'package:flutter/material.dart';

class InputBox extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
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
        _isFocused = _focusNode.hasFocus || widget.controller.text.isNotEmpty;
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
      children: [
        AnimatedOpacity(
          opacity: _isFocused ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 200),
          child: Text(
            widget.hintText,
            style: AppTextStyles.MEDIUM_12,
          ),
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
            contentPadding: const EdgeInsets.all(16),
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

class ReadOnlyBox extends StatelessWidget {
  final String hintText;
  final String inputText;
  final VoidCallback onTap;

  const ReadOnlyBox({
    super.key,
    required this.hintText,
    required this.inputText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GapColumn(
      gap: AppSpacing.SPACE_8,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(inputText != '' ? hintText : '', style: AppTextStyles.MEDIUM_12),
        InkWell(
          onTap: onTap,
          child: Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: AppColors.BACKGROUND_SUB,
              borderRadius: AppRadius.ROUNDED_8,
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: inputText == ''
                  ? Text(
                      hintText,
                      style: AppTextStyles.REGULAR_20
                          .copyWith(color: AppColors.TEXT_SUB),
                    )
                  : Text(inputText, style: AppTextStyles.REGULAR_20),
            ),
          ),
        )
      ],
    );
  }
}

class CustomFormField extends FormField<String> {
  final TextEditingController controller;
  final String hintText;
  final ValueChanged<String>? onSubmitted;
  @override
  final FormFieldValidator<String>? validator;

  CustomFormField({
    super.key,
    required this.controller,
    this.hintText = '',
    this.onSubmitted,
    this.validator,
  }) : super(
          initialValue: controller.text,
          validator: validator,
          builder: (FormFieldState<String> state) {
            return _CustomFormFieldContent(
              controller: controller,
              hintText: hintText,
              state: state,
              onSubmitted: onSubmitted,
            );
          },
        );

  @override
  FormFieldState<String> createState() => FormFieldState<String>();
}

class _CustomFormFieldContent extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final FormFieldState<String> state;
  final ValueChanged<String>? onSubmitted;

  const _CustomFormFieldContent({
    required this.controller,
    required this.hintText,
    required this.state,
    this.onSubmitted,
  });

  @override
  State<_CustomFormFieldContent> createState() =>
      _CustomFormFieldContentState();
}

class _CustomFormFieldContentState extends State<_CustomFormFieldContent> {
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus || widget.controller.text.isNotEmpty;
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
      children: [
        AnimatedOpacity(
            opacity: _isFocused ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 200),
            child: Text(widget.hintText, style: AppTextStyles.MEDIUM_12)),
        InputDecorator(
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.BACKGROUND_SUB,
            contentPadding: const EdgeInsets.all(16),
            border: const OutlineInputBorder(
              borderRadius:
                  BorderRadius.all(Radius.circular(8)), // AppRadius.ROUNDED_8
              borderSide: BorderSide.none,
            ),
            errorText: widget.state.hasError ? widget.state.errorText : null,
          ),
          child: TextField(
            controller: widget.controller,
            focusNode: _focusNode,
            onChanged: (value) {
              widget.state.didChange(value);
            },
            onSubmitted: widget.onSubmitted,
            decoration: InputDecoration.collapsed(
              hintText: widget.hintText,
              hintStyle:
                  AppTextStyles.REGULAR_20.copyWith(color: AppColors.TEXT_SUB),
            ),
          ),
        ),
      ],
    );
  }
}
