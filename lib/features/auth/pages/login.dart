import 'dart:async';

import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:management/common/utils/constants.dart';
import 'package:management/common/widgets/app_style.dart';
import 'package:management/common/widgets/custom_button.dart';
import 'package:management/common/widgets/height_spacer.dart';
import 'package:management/common/widgets/reusable_text.dart';

import '../../../common/widgets/custom_textfield.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  bool _isAnimationPlaying = true;

  late Timer _animationTimer;

  final TextEditingController _controller = TextEditingController();

  Country country = Country(
      phoneCode: '91',
      countryCode: 'IND',
      e164Sc: 0,
      geographic: true,
      level: 1,
      name: 'INDIA',
      example: "India",
      displayName: 'INDIA',
      displayNameNoCountryCode: '+91',
      e164Key: '');

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
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.w),
          child: ListView(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.w),
                child: Lottie.asset(
                  animate: _isAnimationPlaying,
                  'assets/images/phone_auth.json',
                  width: 300,
                  height: 300,
                  fit: BoxFit.contain,
                ),
              ),
              const HeightSpacer(height: 20),
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.only(left: 16),
                child: ReusableText(
                    text: 'Please enter your phone number',
                    style: appStyle(17, AppConst.kLight, FontWeight.w500)),
              ),
              const HeightSpacer(height: 20),
              Center(
                child: CustomTextField(
                  textEditingController: _controller,
                  keyboardType: TextInputType.number,
                  hintText: 'Enter phone number',
                  hintStyle: appStyle(16, AppConst.kBkDark, FontWeight.w600),
                  prefixIcon: Container(
                    padding: const EdgeInsets.all(14),
                    child: GestureDetector(
                      onTap: () {
                        showCountryPicker(
                            countryListTheme: CountryListThemeData(
                                bottomSheetHeight: AppConst.kHeight * 0.6,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(AppConst.kRadius),
                                  topRight: Radius.circular(AppConst.kRadius),
                                )),
                            context: context,
                            onSelect: (code) {
                              setState(() {});
                            });
                      },
                      child: ReusableText(
                        text: '${country.flagEmoji} + ${country.phoneCode}',
                        style: appStyle(19, AppConst.kBkDark, FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ),
              const HeightSpacer(height: 20),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: CustomButton(
                  // onTap: () {

                  // },
                  width: AppConst.kWidth * 0.9,
                  height: AppConst.kHeight * 0.07,
                  color: AppConst.kBkDark,
                  color2: AppConst.kLight,
                  text: 'Send Code',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
