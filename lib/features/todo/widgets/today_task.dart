import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:management/common/utils/constants.dart';
import 'package:management/common/widgets/app_style.dart';
import 'package:management/common/widgets/height_spacer.dart';
import 'package:management/features/todo/controller/todo/todo_provider.dart';
import 'package:management/features/todo/widgets/todo_tile.dart';

import '../../../common/models/task_model.dart';
import '../../../common/widgets/reusable_text.dart';

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

    if (todayList.isNotEmpty) {
      return ListView.builder(
        itemCount: todayList.length,
        itemBuilder: (context, index) {
          final task = todayList[index];
          bool isCompleted =
              ref.watch(todoStateProvider.notifier).getStatus(task);

          return FutureBuilder<Color>(
            future: ref.read(todoStateProvider.notifier).getRandomColors(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (!snapshot.hasData) {
                // Handle the case where no color data is available.
                return const Text('No color data available');
              } else {
                // Data is ready, build TodoTile with the retrieved color.
                return TodoTile(
                    start: task.startTime!,
                    end: task.endTime!,
                    title: task.title!,
                    description: task.description!,
                    color: snapshot.data, // Use the retrieved color
                    switcher: Switch(
                      value: isCompleted,
                      onChanged: (value) {
                        if (value == true) {
                          ref.read(todoStateProvider.notifier).markAsCompleted(
                              task.id!,
                              task.title!,
                              task.description!,
                              1,
                              task.date!,
                              task.startTime!,
                              task.endTime!,
                              0,
                              'yes');
                        } else {
                          ref.read(todoStateProvider.notifier).markAsCompleted(
                              task.id!,
                              task.title!,
                              task.description!,
                              0,
                              task.date!,
                              task.startTime!,
                              task.endTime!,
                              0,
                              'yes');
                        }
                      },
                    ),
                    delete: () {
                      ref.read(todoStateProvider.notifier).deleteTask(task.id!);
                    },
                    editWidget: GestureDetector(
                      onTap: () {},
                      child: const Icon(
                        FontAwesome.edit,
                        color: AppConst.kLight,
                      ),
                    ));
              }
            },
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
