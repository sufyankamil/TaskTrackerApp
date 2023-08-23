import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:management/common/models/task_model.dart';
import 'package:management/common/widgets/app_style.dart';
import 'package:management/common/widgets/custom_textfield.dart';
import 'package:management/common/widgets/expasion_tile.dart';
import 'package:management/common/widgets/height_spacer.dart';
import 'package:management/common/widgets/reusable_text.dart';
import 'package:management/common/widgets/todo_tile.dart';
import 'package:management/common/widgets/width_spacer.dart';
import 'package:management/features/todo/controller/todo/todo_provider.dart';
import 'package:management/features/todo/pages/add.dart';

import '../../../common/utils/constants.dart';
import '../../../common/widgets/custom_alert.dart';
import '../controller/expansion_provider.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage>
    with TickerProviderStateMixin {
  final TextEditingController search = TextEditingController();

  late final TabController tab = TabController(length: 3, vsync: this);

  String _getFormattedDate() {
    final now = DateTime.now();
    final dayOfWeek = DateFormat('EEEE').format(now); // Get the day of the week
    final formattedDate = DateFormat('d/MM/yyyy')
        .format(now); // Get the date in the desired format
    return '$dayOfWeek, $formattedDate';
  }

  bool tasksCompleted = false;

  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    // Create an animation controller
    _controller = AnimationController(
      duration: const Duration(seconds: 1), // Duration of the animation
      vsync: this,
    );

    // Start the animation when the widget is built
    if (!tasksCompleted) {
      _controller.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(todoStateProvider.notifier).refresh();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(85),
          child: SingleChildScrollView(
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
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: ListView(
            children: [
              const HeightSpacer(height: 15),
              // The sliding message
              SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 1), // Start position (fully hidden)
                  end: const Offset(0, 0), // End position (fully visible)
                ).animate(_controller),
                child: Container(
                  color: Colors.red, // Background color of the message
                  padding: const EdgeInsets.all(16),
                  child: const Text(
                    "You don't have any tasks left for today. Come back tomorrow !",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
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
                        child: const TodayTask()
                        // child: Column(
                        //   mainAxisAlignment: MainAxisAlignment.center,
                        //   children: [
                        //     const Icon(
                        //       FontAwesome.tasks,
                        //       size: 50,
                        //       color: AppConst.kLight,
                        //     ),
                        //     const HeightSpacer(height: 20),
                        //     ReusableText(
                        //       text: 'No Pending Tasks',
                        //       style:
                        //           appStyle(18, AppConst.kLight, FontWeight.bold),
                        //     ),
                        //   ],
                        // ),
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
                text1: '${DateTime.now().day.toString().padLeft(2, '0')}/'
                    '${DateTime.now().month.toString().padLeft(2, '0')}/'
                    '${DateTime.now().year}',
                text2: 'Project Description',
                onExpansionChanged: (bool expanded) {
                  ref.read(expansionStateProvider.notifier).setStart(!expanded);
                },
                trailing: ref.watch(expansionStateProvider) == false
                    ? Padding(
                        padding: EdgeInsets.only(right: 12.0.w),
                        child: const Icon(
                          Icons.keyboard_arrow_down,
                          color: AppConst.kLight,
                        ),
                      )
                    : Padding(
                        padding: EdgeInsets.only(right: 12.0.w),
                        child: const Icon(
                          Icons.keyboard_arrow_up,
                          color: AppConst.kLight,
                        ),
                      ),
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
              const HeightSpacer(height: 20),
              CustomExpansion(
                text1:
                    '${DateTime.now().add(const Duration(days: 1)).day.toString().padLeft(2, '0')}/${DateTime.now().add(const Duration(days: 1)).month.toString().padLeft(2, '0')}/${DateTime.now().add(const Duration(days: 1)).year}',
                text2: 'Project Description',
                onExpansionChanged: (bool expanded) {
                  ref
                      .read(expansionState0Provider.notifier)
                      .setStart(!expanded);
                },
                trailing: ref.watch(expansionState0Provider) == false
                    ? Padding(
                        padding: EdgeInsets.only(right: 12.0.w),
                        child: const Icon(
                          Icons.keyboard_arrow_down,
                          color: AppConst.kLight,
                        ),
                      )
                    : Padding(
                        padding: EdgeInsets.only(right: 12.0.w),
                        child: const Icon(
                          Icons.keyboard_arrow_up,
                          color: AppConst.kLight,
                        ),
                      ),
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
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose(); // Dispose the animation controller
    super.dispose();
  }
}

class TodayTask extends ConsumerWidget {
  const TodayTask({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<Task> todayListData = ref.read(todoStateProvider);

    String today = ref.read(todoStateProvider.notifier).getToday();

    var todayList = todayListData
        .where((element) =>
            element.isCompleted == 0 && element.date!.contains(today))
        .toList();

    // print(todayList);

    // print(todayListData[0].description);

    if (todayList.isNotEmpty) {
      return ListView.builder(
        itemCount: todayList.length,
        itemBuilder: (context, index) {
          final task = todayList[index];
          return TodoTile(
            start: task.startTime!,
            end: task.endTime!,
            title: task.title!,
            description: task.description!,
            color: AppConst.kRed,
          );
        },
      );
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            FontAwesome.tasks,
            size: 50,
            color: AppConst.kLight,
          ),
          const HeightSpacer(height: 20),
          ReusableText(
            text: 'No Pending Tasks',
            style: appStyle(18, AppConst.kLight, FontWeight.bold),
          ),
        ],
      );
    }
  }
}
