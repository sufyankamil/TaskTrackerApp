import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:management/common/helpers/notifications_helper.dart';
import 'package:management/common/models/task_model.dart';
import 'package:management/common/widgets/app_style.dart';
import 'package:management/common/widgets/custom_textfield.dart';
import 'package:management/common/widgets/height_spacer.dart';
import 'package:management/common/widgets/reusable_text.dart';
import 'package:management/common/widgets/width_spacer.dart';
import 'package:management/features/todo/widgets/completed_task.dart';
import 'package:management/features/todo/widgets/dat_after_tomorrow.dart';
import 'package:management/features/todo/widgets/tomorrow_list.dart';

import '../../../common/utils/constants.dart';
import '../controller/todo/todo_provider.dart';
import '../pages/add.dart';
import '../widgets/pending_task.dart';
import '../widgets/today_task.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage>
    with TickerProviderStateMixin {
  final TextEditingController search = TextEditingController();

  late final TabController tab = TabController(length: 3, vsync: this);

  late NotificationsHelper notificationsHelper;

  late NotificationsHelper controller;

  String _getFormattedDate() {
    final now = DateTime.now();
    final dayOfWeek = DateFormat('EEEE').format(now);
    final formattedDate = DateFormat('d/MM/yyyy').format(now);
    return '$dayOfWeek, $formattedDate';
  }

  bool tasksCompleted = false;

  late AnimationController _controller;

  @override
  void initState() {
    notificationsHelper = NotificationsHelper(ref: ref);
    Future.delayed(const Duration(seconds: 0), () {
      controller = NotificationsHelper(ref: ref);
    });

    notificationsHelper.initNotifications();
    notificationsHelper.requestIOSPermissions();

    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    if (!tasksCompleted) {
      _controller.forward();
    }

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          tasksCompleted = true;
        });
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(todoStateProvider.notifier).refresh();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(todoStateProvider.notifier).refresh();

    List<Task> todayListData = ref.read(todoStateProvider);

    String today = ref.read(todoStateProvider.notifier).getToday();

    List<Task> filteredTasks = [];

// Function to filter tasks by task name
    void searchTasks(String query) {
      setState(() {
        filteredTasks = todayListData.where((task) {
          final taskName = task.title!.toLowerCase();
          final lowerQuery = query.toLowerCase();
          return task.isCompleted == 0 &&
              task.date!.contains(today) &&
              taskName.contains(lowerQuery);
        }).toList();
      });
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(85.h),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
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
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const AddTask(),
                              ),
                            );
                          },
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
                  onChanged: (value) {
                    searchTasks(value);
                  },
                  prefixIcon: Container(
                    padding: const EdgeInsets.all(14),
                    child: GestureDetector(
                      onTap: () {
                        searchTasks(search.text);
                      },
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
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: ListView(
            children: [
              const HeightSpacer(height: 15),
              Text(
                textAlign: TextAlign.center,
                _getFormattedDate(),
                style: const TextStyle(
                  fontSize: 18,
                  color: AppConst.kLight,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const HeightSpacer(height: 20),
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
                            text: 'All Tasks',
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
                      child: TodayTask(taskList: filteredTasks),
                    ),
                    Container(
                      color: AppConst.kGreyLight,
                      height: AppConst.kHeight * 0.3,
                      child: const PendingTask(),
                    ),
                    Container(
                      color: AppConst.kGreyBk,
                      height: AppConst.kHeight * 0.3,
                      child: const CompletedTask(),
                    ),
                  ]),
                ),
              ),
              const HeightSpacer(height: 20),
              const TomorrowList(),
              const HeightSpacer(height: 20),
              const DayAfterTomorrowList(),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    tab.dispose();
    search.dispose();
    super.dispose();
  }
}
