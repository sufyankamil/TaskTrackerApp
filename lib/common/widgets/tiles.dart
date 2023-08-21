import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:management/common/utils/constants.dart';
import 'package:management/common/widgets/app_style.dart';
import 'package:management/common/widgets/reusable_text.dart';
import 'package:management/common/widgets/width_spacer.dart';

import 'height_spacer.dart';

class BottomTiles extends StatefulWidget {
  final String text1;

  final String text2;

  final Color? clr;

  const BottomTiles(
      {super.key, required this.text1, required this.text2, this.clr});

  @override
  State<BottomTiles> createState() => _BottomTilesState();
}

class _BottomTilesState extends State<BottomTiles> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: AppConst.kWidth,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Consumer(
              builder: (context, ref, child) {
                return Container(
                  height: 80,
                  width: 5,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(AppConst.kRadius),
                    ),

                    /// TODO: Add color scheme
                    color: AppConst.kGreen,
                  ),
                );
              },
            ),
            const WidthSpacer(width: 15),
            Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ReusableText(
                        text: widget.text1,
                        style: appStyle(20, AppConst.kLight, FontWeight.bold)),
                    const HeightSpacer(height: 5),
                    ReusableText(
                        text: widget.text2,
                        style:
                            appStyle(20, AppConst.kLight, FontWeight.normal)),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
