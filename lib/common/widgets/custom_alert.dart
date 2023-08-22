import 'package:flutter/material.dart';
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
}
