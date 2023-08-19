import 'package:flutter/material.dart';
import 'package:management/common/widgets/app_style.dart';
import 'package:management/common/widgets/reusable_text.dart';

class CustomButton extends StatelessWidget {
  final void Function()? onTap;

  final double width;

  final double height;

  final Color color;

  final Color? color2;

  final String text;

  const CustomButton({
    super.key,
    this.onTap,
    required this.width,
    required this.height,
    this.color2,
    required this.color,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: color2,
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          border: Border.all(width: 1, color: color),
        ),
        child: Center(
          child: ReusableText(
            text: text,
            style: appStyle(18, color, FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
