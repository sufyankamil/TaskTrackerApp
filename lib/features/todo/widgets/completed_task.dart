import 'dart:io';

import 'package:flutter/cupertino.dart';
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

class CompletedTask extends ConsumerWidget {
  const CompletedTask({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<Task> todayListData = ref.read(todoStateProvider);

    List lastMonth = ref.read(todoStateProvider.notifier).last30Days();

    var completedList = todayListData
        .where(
          (element) =>
              element.isCompleted == 1 ||
              lastMonth.contains(
                element.date!.substring(0, 10),
              ),
        )
        .toList();

    confirmDelete(Task task) {
      if (Platform.isIOS) {
        showDialog(
          context: context,
          builder: (context) => CupertinoAlertDialog(
            title: const Text('Delete Task'),
            content: const Text('Are you sure you want to delete this task?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  ref.read(todoStateProvider.notifier).deleteTask(task.id!);
                  Navigator.pop(context);
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    ref.read(todoStateProvider.notifier).refresh();
                  });
                },
                child: const Text('Delete'),
              ),
            ],
          ),
        );
      } else {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Delete Task'),
            content: const Text('Are you sure you want to delete this task?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  ref.read(todoStateProvider.notifier).deleteTask(task.id!);
                  Navigator.pop(context);
                },
                child: const Text('Delete'),
              ),
            ],
          ),
        );
      }
    }

    if (todayListData.isNotEmpty) {
      return ListView.builder(
        itemCount: completedList.length,
        itemBuilder: (context, index) {
          final task = completedList[index];

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
                    switcher: const Icon(AntDesign.checkcircle,
                        color: AppConst.kGreen),
                    delete: () {
                      confirmDelete(task);
                    },
                    editWidget: const SizedBox.shrink());
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
