import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:management/common/utils/constants.dart';
import 'package:management/common/widgets/app_style.dart';
import 'package:management/common/widgets/height_spacer.dart';
import 'package:management/common/widgets/reusable_text.dart';
import 'package:management/common/widgets/width_spacer.dart';

import '../../features/todo/controller/todo/todo_provider.dart';

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

class BottomTiles extends ConsumerWidget {
  final String text1;
  final String text2;

  const BottomTiles({Key? key, required this.text1, required this.text2});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder<dynamic>(
      future: ref
          .read(todoStateProvider.notifier)
          .getRandomColors(), // Replace with your actual async operation
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Return a loading indicator while the future is still executing
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          // Return an error message if the future throws an error
          return Text('Error: ${snapshot.error}');
        } else {
          // Return your widget with the dynamic data received from the future
          final Color color = snapshot.data as Color;

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
                          text: text1,
                          style: appStyle(18, AppConst.kLight, FontWeight.bold),
                        ),
                        const HeightSpacer(height: 5),
                        ReusableText(
                          text: text2,
                          style:
                              appStyle(18, AppConst.kLight, FontWeight.normal),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
