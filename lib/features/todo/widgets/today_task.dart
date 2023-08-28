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
import '../pages/update_task.dart';

class TodayTask extends ConsumerWidget {
  final List<Task> taskList;

  const TodayTask({Key? key, required this.taskList}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<Task> todayListData = ref.read(todoStateProvider);

    String today = ref.read(todoStateProvider.notifier).getToday();

    var todayList = todayListData
        .where((element) =>
            element.isCompleted == 0 && element.date!.contains(today))
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

    return Consumer(
      builder: (context, watch, child) {
        final shouldReload = ref.watch(shouldReloadProvider.notifier);

        // Check if a reload is needed
        // ignore: invalid_use_of_protected_member
        if (shouldReload.state == true) {
          // Toggle the reload state to false to avoid triggering reload repeatedly
          shouldReload.toggleReload();
          ref.read(todoStateProvider.notifier).refresh();
        }

        return todayList.isEmpty
            ? Column(
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
              )
            : ListView.builder(
                itemCount: todayList.length,
                itemBuilder: (context, index) {
                  final task = todayList[index];

                  return FutureBuilder<Color>(
                    future: ref
                        .read(todoStateProvider.notifier)
                        .getRandomColors(), // Replace with your actual async operation
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        // Return a loading indicator while the future is still executing
                        if (Platform.isIOS) {
                          return const CupertinoActivityIndicator();
                        } else {
                          return const CircularProgressIndicator();
                        }
                      } else if (snapshot.hasError) {
                        // Return an error message if the future throws an error
                        return Text('Error: ${snapshot.error}');
                      } else {
                        // Return your widget with the dynamic data received from the future
                        final Color color = snapshot.data as Color;

                        return TodoTile(
                          start: task.startTime!,
                          end: task.endTime!,
                          title: task.title!,
                          description: task.description!,
                          color: color, // Use the retrieved color
                          switcher: PopupMenuButton<String>(
                            onSelected: (value) {
                              if (value == 'In Progress') {
                                ref
                                    .read(todoStateProvider.notifier)
                                    .markAsPending(
                                        task.id!,
                                        task.title!,
                                        task.description!,
                                        0,
                                        1,
                                        task.date!,
                                        task.startTime!,
                                        task.endTime!,
                                        0,
                                        'yes');
                              } else {
                                ref
                                    .read(todoStateProvider.notifier)
                                    .markAsCompleted(
                                        task.id!,
                                        task.title!,
                                        task.description!,
                                        1,
                                        0,
                                        task.date!,
                                        task.startTime!,
                                        task.endTime!,
                                        0,
                                        'yes');
                              }
                            },
                            itemBuilder: (BuildContext context) => [
                              const PopupMenuItem<String>(
                                value: 'In Progress',
                                child: Text('In Progress'),
                              ),
                              const PopupMenuItem<String>(
                                value: 'Completed',
                                child: Text('Completed'),
                              ),
                            ],
                          ),
                          delete: () {
                            confirmDelete(task);
                          },
                          editWidget: GestureDetector(
                            onTap: () {
                              titles = task.title.toString();
                              descriptions = task.description.toString();
                              dates = task.date.toString();
                              startTimes = task.startTime.toString();
                              endTimes = task.endTime.toString();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => UpdateTask(
                                    id: task.id!,
                                  ),
                                ),
                              );
                            },
                            child: const Icon(
                              FontAwesome.edit,
                              color: AppConst.kLight,
                            ),
                          ),
                        );
                      }
                    },
                  );
                },
              );
      },
    );
  }
}
