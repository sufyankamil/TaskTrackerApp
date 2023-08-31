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

class PendingTask extends ConsumerWidget {
  const PendingTask({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<Task> todayListData = ref.read(todoStateProvider);

    List lastMonth = ref.read(todoStateProvider.notifier).last30Days();


    var pendingList = todayListData
        .where(
          (element) =>
              element.isPending == 1 ||
              lastMonth.contains(
                element.date!.substring(0, 10),
              ),
        )
        .toList();

    if (todayListData.isNotEmpty) {
      return ListView.builder(
        itemCount: pendingList.length,
        itemBuilder: (context, index) {
          final task = pendingList[index];

          bool isPending =
              ref.watch(todoStateProvider.notifier).getPendingStatus(task);

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
                return isPending
                    ? TodoTile(
                        start: task.startTime!,
                        end: task.endTime!,
                        title: task.title!,
                        description: task.description!,
                        color: snapshot.data, // Use the retrieved color
                        switcher: PopupMenuButton(
                          itemBuilder: (context) => [
                            const PopupMenuItem(
                              value: 1,
                              child: Text('Mark as Completed'),
                            ),
                            const PopupMenuItem(
                              value: 2,
                              child: Text('Mark as Pending'),
                            ),
                          ],
                          onSelected: (value) {
                            if (value == 1) {
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
                                      '');
                            } else {
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
                                      '');
                            }
                          },
                          icon: const Icon(
                            Icons.more_vert,
                            color: AppConst.kLight,
                          ),
                        ),
                        delete: () {
                          ref
                              .read(todoStateProvider.notifier)
                              .deleteTask(task.id!);
                        },
                      )
                    : const SizedBox.shrink();
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
