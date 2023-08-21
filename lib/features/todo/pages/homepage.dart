import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:management/common/widgets/app_style.dart';
import 'package:management/common/widgets/custom_textfield.dart';
import 'package:management/common/widgets/expasion_tile.dart';
import 'package:management/common/widgets/height_spacer.dart';
import 'package:management/common/widgets/reusable_text.dart';
import 'package:management/common/widgets/todo_tile.dart';
import 'package:management/common/widgets/width_spacer.dart';

import '../../../common/utils/constants.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage>
    with TickerProviderStateMixin {
  final TextEditingController search = TextEditingController();

  late final TabController tab = TabController(length: 3, vsync: this);

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
                    style: appStyle(18, AppConst.kLight, FontWeight.bold),
                  ),
                ],
              ),
              const HeightSpacer(height: 25),
              Container(
                decoration: BoxDecoration(
                  color: AppConst.kLight,
                  borderRadius: BorderRadius.all(
                    Radius.circular(AppConst.kRadius),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.all(
                    Radius.circular(AppConst.kRadius),
                  ),
                  child: TabBar(
                    indicatorSize: TabBarIndicatorSize.label,
                    indicator: BoxDecoration(
                      color: AppConst.kGreyLight,
                      borderRadius: BorderRadius.all(
                        Radius.circular(AppConst.kRadius),
                      ),
                    ),
                    controller: tab,
                    labelPadding: EdgeInsets.zero,
                    labelColor: AppConst.kBlueLight,
                    labelStyle:
                        appStyle(23, AppConst.kBlueLight, FontWeight.w700),
                    unselectedLabelColor: AppConst.kLight,
                    tabs: [
                      Tab(
                        child: SizedBox(
                          width: AppConst.kWidth * 0.5,
                          child: ReusableText(
                            textAlign: TextAlign.center,
                            text: 'Pending',
                            style: appStyle(16, AppConst.kRed, FontWeight.bold),
                          ),
                        ),
                      ),
                      Tab(
                        child: SizedBox(
                          width: AppConst.kWidth * 0.5,
                          child: ReusableText(
                            textAlign: TextAlign.center,
                            text: 'InProgress',
                            style:
                                appStyle(16, AppConst.kBkDark, FontWeight.bold),
                          ),
                        ),
                      ),
                      Tab(
                        child: SizedBox(
                          width: AppConst.kWidth * 0.5,
                          child: ReusableText(
                            textAlign: TextAlign.center,
                            text: 'Completed',
                            style:
                                appStyle(16, AppConst.kGreen, FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const HeightSpacer(height: 20),
              SizedBox(
                height: AppConst.kHeight * 0.3,
                width: AppConst.kWidth,
                child: ClipRRect(
                  borderRadius: BorderRadius.all(
                    Radius.circular(AppConst.kRadius),
                  ),
                  child: TabBarView(controller: tab, children: [
                    Container(
                      color: AppConst.kBkLight,
                      height: AppConst.kHeight * 0.3,
                      child: ListView(
                        children: const [
                          TodoTile(
                            start: '10:00 AM',
                            end: '11:00 AM',
                            title: 'Meeting with client',
                            description: 'Discuss about the project',
                            color: AppConst.kRed,
                            switcher: Switch(
                              value: true,
                              onChanged: null,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      color: AppConst.kGreyLight,
                      height: AppConst.kHeight * 0.3,
                    ),
                    Container(
                      color: AppConst.kGreen,
                      height: AppConst.kHeight * 0.3,
                    ),
                  ]),
                ),
              ),
              const HeightSpacer(height: 20),
              CustomExpansion(
                text1: 'Project Name',
                text2: 'Project Description',
                children: [
                  Container(
                    height: 100,
                    color: AppConst.kBkLight,
                  )
                ],
              ),
              const HeightSpacer(height: 20),
              CustomExpansion(
                text1:
                    '${DateTime.now().add(const Duration(days: 1)).day.toString().padLeft(2, '0')}/${DateTime.now().add(const Duration(days: 1)).month.toString().padLeft(2, '0')}/${DateTime.now().add(const Duration(days: 1)).year}',
                text2: 'Project Description',
                children: [
                  Container(
                    height: 100,
                    color: AppConst.kBkLight,
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
