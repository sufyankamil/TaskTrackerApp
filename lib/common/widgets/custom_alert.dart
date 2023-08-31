import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:management/common/utils/constants.dart';
import 'package:management/common/widgets/app_style.dart';

class CustomCupertinoAlertDialog {
  static show(BuildContext context, String title, String content) {
    showAdaptiveDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog.adaptive(
          title: Text(
            title,
            style: appStyle(15, AppConst.kBkDark, FontWeight.w800),
          ),
          content: Text(
            content,
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  static showAlertDialog({
    required BuildContext context,
    required String title,
    required String content,
    String? buttonText,
  }) {
    showAdaptiveDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            title,
            style: appStyle(15, AppConst.kLight, FontWeight.w800),
          ),
          contentPadding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 0.h),
          content: Text(
            content,
          ),
          actions: <Widget>[
            TextButton(
              child: Text(buttonText ?? 'OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
