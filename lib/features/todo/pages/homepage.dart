import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:management/common/widgets/app_style.dart';
import 'package:management/common/widgets/custom_textfield.dart';
import 'package:management/common/widgets/height_spacer.dart';
import 'package:management/common/widgets/reusable_text.dart';
import 'package:management/common/widgets/width_spacer.dart';

import '../../../common/utils/constants.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final TextEditingController search = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(85),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ReusableText(
                        text: 'Dashboard',
                        style: appStyle(18, AppConst.kLight, FontWeight.bold),
                      ),
                      Container(
                        width: 25.w,
                        height: 25.h,
                        decoration: const BoxDecoration(
                          color: AppConst.kLight,
                          borderRadius: BorderRadius.all(
                            Radius.circular(9),
                          ),
                        ),
                        child: GestureDetector(
                          onTap: () {},
                          child: const Icon(
                            Icons.add,
                            color: AppConst.kBkDark,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                const HeightSpacer(height: 20),
                CustomTextField(
                  keyboardType: TextInputType.text,
                  hintText: 'Search',
                  textEditingController: search,
                  prefixIcon: Container(
                    padding: const EdgeInsets.all(14),
                    child: GestureDetector(
                      onTap: () {},
                      child: const Icon(
                        AntDesign.search1,
                        color: AppConst.kGreyLight,
                      ),
                    ),
                  ),
                  suffixIcon: const Icon(
                    FontAwesome.sliders,
                    color: AppConst.kGreyLight,
                  ),
                ),
                const HeightSpacer(height: 15),
              ],
            ),
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: ListView(
              children: [
                const HeightSpacer(height: 25),
                Row(
                  children: [
                    const Icon(
                      FontAwesome.tasks,
                      size: 20,
                      color: AppConst.kLight,
                    ),
                    const WidthSpacer(width: 10),
                    ReusableText(
                        text: 'Today`s Task',
                        style: appStyle(18, AppConst.kLight, FontWeight.bold))
                  ],
                ),
                const HeightSpacer(height: 25),
                Container()
              ],
            ),
          ),
        ));
  }
}
