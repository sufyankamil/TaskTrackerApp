import 'package:flutter/material.dart';
import 'package:management/common/widgets/app_style.dart';
import 'package:management/common/widgets/reusable_text.dart';

import '../../../common/utils/constants.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ReusableText(
            text: 'Home Page State - Home Page',
            style: appStyle(20, AppConst.kBlueLight, FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
