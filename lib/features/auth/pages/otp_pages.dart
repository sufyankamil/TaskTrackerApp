import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:management/common/utils/constants.dart';
import 'package:management/common/widgets/height_spacer.dart';
import 'package:pinput/pinput.dart';

class OTPPage extends StatefulWidget {
  const OTPPage({super.key});

  @override
  State<OTPPage> createState() => _OTPPageState();
}

class _OTPPageState extends State<OTPPage> {
  bool _isAnimationPlaying = true;
  late Timer _animationTimer;

  @override
  void initState() {
    super.initState();
    _playAnimation();
  }

  void _playAnimation() {
    _animationTimer = Timer(const Duration(seconds: 1), () {
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              HeightSpacer(height: AppConst.kHeight * 0.12),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.w),
                child: Lottie.asset(
                  animate: _isAnimationPlaying,
                  'assets/images/confirm_otp.json',
                  width: AppConst.kWidth * 0.5,
                  fit: BoxFit.contain,
                ),
              ),
              const HeightSpacer(height: 20),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Enter the OTP you have recieved on the phone number',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    color: AppConst.kLight,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const HeightSpacer(height: 26),
              Pinput(
                length: 6,
                showCursor: true,
                onCompleted: (value) {
                  if (value.length == 6) {}
                },
                onSubmitted: (value) {
                  if (value.length == 6) {}
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
