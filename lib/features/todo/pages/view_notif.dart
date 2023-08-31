import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:management/common/utils/constants.dart';
import 'package:management/common/widgets/app_style.dart';
import 'package:management/common/widgets/reusable_text.dart';
import 'package:management/features/todo/pages/homepage.dart';

import '../../../common/widgets/height_spacer.dart';
import '../../../common/widgets/width_spacer.dart';

class NotificationPage extends ConsumerStatefulWidget {
  final String? payload;

  const NotificationPage({super.key, this.payload});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _NotificationPageState();
}

class _NotificationPageState extends ConsumerState<NotificationPage> {
  bool isAnimationPlaying = true;

  late Timer animationTimer;

  void _playAnimation() {
    animationTimer = Timer(const Duration(seconds: 1), () {
      setState(() {
        isAnimationPlaying = false;
      });
      animationTimer.cancel();
    });
  }

  @override
  void initState() {
    super.initState();
    _playAnimation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: const Text(
            'Notification',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            Lottie.asset(
              animate: isAnimationPlaying,
              'assets/images/notif.json',
              width: AppConst.kWidth * 0.2,
              height: AppConst.kHeight * 0.2,
              fit: BoxFit.fitHeight,
            ),
          ],
        ),
        body: SafeArea(
            child: Stack(
          clipBehavior: Clip.none,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 20.h),
              child: Container(
                width: AppConst.kWidth,
                height: AppConst.kHeight * 0.7,
                decoration: BoxDecoration(
                  color: AppConst.kBlueLight,
                  borderRadius: BorderRadius.all(
                    Radius.circular(AppConst.kRadius),
                  ),
                ),
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Notification Reminder',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const HeightSpacer(height: 10),
                      Container(
                        width: AppConst.kWidth,
                        padding: EdgeInsets.only(left: 10.w),
                        decoration: BoxDecoration(
                          color: AppConst.kGreen,
                          borderRadius: BorderRadius.all(
                            Radius.circular(9.h),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Icon(Icons.notifications),
                            ReusableText(
                              text: 'Task ',
                              style: appStyle(
                                  14, AppConst.kBkDark, FontWeight.bold),
                            ),
                            const WidthSpacer(width: 10),
                            ReusableText(
                              text:
                                  'From : ${widget.payload!.split('|')[2]} - ${widget.payload!.split('|')[3]}',
                              style: appStyle(
                                  13, AppConst.kBkDark, FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                      const HeightSpacer(height: 15),
                      ReusableText(
                        text: 'Title : ${widget.payload!.split('|')[0]}',
                        style: appStyle(14, AppConst.kBkDark, FontWeight.bold),
                      ),
                      const HeightSpacer(height: 15),
                      Text(
                        'Description : ${widget.payload!.split('|')[1]}',
                        maxLines: 8,
                        textAlign: TextAlign.justify,
                        style:
                            appStyle(14, AppConst.kBkDark, FontWeight.normal),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: -10,
              right: 10,
              child: IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HomePage(),
                    ),
                  );
                },
                icon: const Icon(Icons.close, color: Colors.white),
              ),
            ),
            Positioned(
              bottom: -AppConst.kHeight * 0.153,
              left: 0,
              right: 0,
              child: Lottie.asset(
                animate: isAnimationPlaying,
                'assets/images/read_n.json',
                width: AppConst.kWidth * 0.8,
                height: AppConst.kHeight * 0.6,
              ),
            ),
          ],
        )));
  }
}
