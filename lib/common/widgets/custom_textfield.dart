import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:management/common/utils/constants.dart';
import 'package:management/common/widgets/app_style.dart';

class CustomTextField extends StatefulWidget {
  final TextInputType? keyboardType;

  final String hintText;

  final Widget? suffixIcon;

  final Widget? prefixIcon;

  final TextStyle? hintStyle;

  final TextEditingController textEditingController;

  final void Function(String)? onChanged;

  const CustomTextField({
    super.key,
    this.keyboardType,
    required this.hintText,
    this.suffixIcon,
    this.prefixIcon,
    this.hintStyle,
    required this.textEditingController,
    this.onChanged,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  final List<TextInputFormatter> _inputFormatters = [];

  @override
  void initState() {
    super.initState();
    if (widget.keyboardType == TextInputType.number) {
      _inputFormatters.add(FilteringTextInputFormatter.allow(RegExp(r'[0-9]')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppConst.kWidth * 0.9,
      decoration: BoxDecoration(
        color: AppConst.kLight,
        borderRadius: BorderRadius.all(
          Radius.circular(AppConst.kRadius),
        ),
      ),
      child: TextFormField(
        cursorHeight: 25,
        onChanged: widget.onChanged,
        style: appStyle(18, AppConst.kBkDark, FontWeight.w700),
        controller: widget.textEditingController,
        keyboardType: widget.keyboardType,
        inputFormatters: _inputFormatters,
        decoration: InputDecoration(
          hintText: widget.hintText,
          suffixIcon: widget.suffixIcon,
          prefixIcon: widget.prefixIcon,
          suffixIconColor: AppConst.kBkDark,
          hintStyle: widget.hintStyle,
          errorBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.zero,
            borderSide: BorderSide(
              color: AppConst.kRed,
              width: 0.5,
            ),
          ),
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.zero,
            borderSide: BorderSide(
              color: Colors.transparent,
              width: 0.5,
            ),
          ),
          focusedErrorBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.zero,
            borderSide: BorderSide(
              color: AppConst.kRed,
              width: 0.5,
            ),
          ),
          disabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.zero,
            borderSide: BorderSide(
              color: AppConst.kGreyDk,
              width: 0.5,
            ),
          ),
          enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.zero,
            borderSide: BorderSide(
              color: AppConst.kBkDark,
              width: 0.5,
            ),
          ),
        ),
      ),
    );
  }
}
