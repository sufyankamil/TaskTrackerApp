import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:management/common/utils/constants.dart';
import 'package:management/common/widgets/app_style.dart';
import 'package:management/common/widgets/reusable_text.dart';
import 'package:management/common/widgets/width_spacer.dart';

import '../../../common/widgets/height_spacer.dart';

class TodoTile extends StatelessWidget {
  final Color? color;

  final String? title;

  final String? description;

  final String? start;

  final String? end;

  final Widget? editWidget;

  final void Function()? delete;

  final Widget? switcher;

  const TodoTile({
    super.key,
    this.color,
    this.title,
    this.description,
    this.start,
    this.end,
    this.editWidget,
    this.delete,
    this.switcher,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Stack(
        children: [
          Container(
            width: AppConst.kWidth,
            padding: EdgeInsets.all(8.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(10.r),
              ),
              // o
              color: const Color.fromRGBO(255, 255, 255, 0.1),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      height: 80,
                      width: 5,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(AppConst.kRadius),
                        ),

                        /// TODO: Add color scheme
                        color: color ?? AppConst.kRed,
                      ),
                    ),
                    const WidthSpacer(width: 15),
                    Padding(
                      padding: EdgeInsets.all(8.h),
                      child: SizedBox(
                        width: AppConst.kWidth * 0.6,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ReusableText(
                              text: title ?? 'Add title for TODO',
                              style: appStyle(
                                  18, AppConst.kLight, FontWeight.bold),
                            ),
                            const HeightSpacer(height: 5),
                            ReusableText(
                              text: description ?? 'Add description for TODO',
                              style: appStyle(
                                  12, AppConst.kLight, FontWeight.bold),
                            ),
                            const HeightSpacer(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  width: AppConst.kWidth * 0.3,
                                  height: 25.h,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: AppConst.kGreyDk, width: 0.3),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(9.r),
                                    ),
                                    color: AppConst.kGreyDk,
                                  ),
                                  child: Center(
                                    child: ReusableText(
                                      textAlign: TextAlign.center,
                                      text: '$start - $end',
                                      style: appStyle(
                                          12, AppConst.kLight, FontWeight.bold),
                                    ),
                                  ),
                                ),
                                const WidthSpacer(width: 20),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 25.w,
                                      height: 25.h,
                                      child: editWidget ??
                                          GestureDetector(
                                            onTap: () {},
                                            child: const Icon(
                                              Icons.edit,
                                              color: AppConst.kGreyDk,
                                            ),
                                          ),
                                    ),
                                    const WidthSpacer(width: 20),
                                    GestureDetector(
                                      onTap: delete,
                                      child: const Icon(
                                        Icons.delete_forever,
                                        color: AppConst.kRed,
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.only(bottom: 0.h),
                  child: switcher,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
