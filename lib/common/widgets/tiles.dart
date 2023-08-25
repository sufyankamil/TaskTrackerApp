import 'package:flutter/material.dart';
import 'dart:math';

import 'package:management/common/utils/constants.dart';
import 'package:management/common/widgets/app_style.dart';
import 'package:management/common/widgets/height_spacer.dart';
import 'package:management/common/widgets/reusable_text.dart';
import 'package:management/common/widgets/width_spacer.dart';

// Function to generate a random color
Color getRandomColor() {
  final random = Random();
  return Color.fromRGBO(
    random.nextInt(256),
    random.nextInt(256),
    random.nextInt(256),
    1.0,
  );
}

class BottomTiles extends StatefulWidget {
  final String text1;
  final String text2;

  const BottomTiles({Key? key, required this.text1, required this.text2});

  @override
  State<BottomTiles> createState() => _BottomTilesState();
}

class _BottomTilesState extends State<BottomTiles> {
  @override
  Widget build(BuildContext context) {
    final Color color = getRandomColor();

    return SizedBox(
      width: AppConst.kWidth,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: 80,
              width: 5,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(AppConst.kRadius),
                ),
                color: color,
              ),
            ),
            const WidthSpacer(width: 15),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ReusableText(
                      text: widget.text1,
                      style: appStyle(18, AppConst.kLight, FontWeight.bold)),
                  const HeightSpacer(height: 5),
                  ReusableText(
                      text: widget.text2,
                      style: appStyle(18, AppConst.kLight, FontWeight.normal)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
