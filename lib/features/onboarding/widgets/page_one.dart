import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:management/common/utils/constants.dart';
import 'package:management/common/widgets/app_style.dart';
import 'package:management/common/widgets/height_spacer.dart';
import 'package:management/common/widgets/reusable_text.dart';

class PageOne extends StatefulWidget {
  const PageOne({super.key});

  @override
  State<PageOne> createState() => _PageOneState();
}

class _PageOneState extends State<PageOne> {
  bool _isAnimationPlaying = true;
  late Timer _animationTimer;

  @override
  void initState() {
    super.initState();
    _playAnimation();
  }

  void _playAnimation() {
    _animationTimer = Timer(const Duration(seconds: 2), () {
      setState(() {
        _isAnimationPlaying = false;
      });
      _animationTimer.cancel();
    });
  }

  @override
  void dispose() {
    _animationTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppConst.kHeight,
      width: AppConst.kWidth,
      color: AppConst.kBkDark,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(
            animate: _isAnimationPlaying,
            'assets/images/animation_1.json',
            width: 300,
            height: 300,
            fit: BoxFit.contain,
          ),
          const HeightSpacer(height: 100),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ReusableText(
                text: 'Unlock Your Productivity',
                style: appStyle(25, AppConst.kLight, FontWeight.w600),
              ),
              const HeightSpacer(height: 20),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.w),
                child: Text(
                  'Effortlessly Manage Your Tasks and Achieve More',
                  textAlign: TextAlign.center,
                  style: appStyle(18, AppConst.kGreyLight, FontWeight.normal),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
