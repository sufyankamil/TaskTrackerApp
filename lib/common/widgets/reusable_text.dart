import 'package:flutter/material.dart';

class ReusableText extends StatelessWidget {
  final String text;
  final TextStyle style;
  final TextAlign? textAlign;

  const ReusableText(
      {super.key,
      required this.text,
      required this.style,
      this.textAlign = TextAlign.left});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: 1,
      textAlign: textAlign,
      softWrap: true,
      overflow: TextOverflow.fade,
      style: style,
    );
  }
}
