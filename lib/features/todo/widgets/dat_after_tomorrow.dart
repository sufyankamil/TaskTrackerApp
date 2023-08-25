import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:management/common/models/task_model.dart';
import 'package:management/features/todo/controller/todo/todo_provider.dart';

import '../../../common/utils/constants.dart';
import '../../../common/widgets/expasion_tile.dart';
import '../controller/expansion_provider.dart';
import 'todo_tile.dart';

class DayAfterTomorrowList extends ConsumerWidget {
  const DayAfterTomorrowList({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todos = ref.watch(todoStateProvider);

    String dayAfter =
        ref.read(todoStateProvider.notifier).getDatAfterTomorrow();

    var dayAfterTomorrowTasks = todos.where((element) {
      return element.date!.contains(dayAfter);
    }).toList();

    return CustomExpansion(
      text1: dayAfterTomorrowTasks.isEmpty
          ? 'No tasks for left'
          : 'Tasks for ${dayAfterTomorrowTasks[0].date}',
      text2: 'Day after tomorrow`s tasks',
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
      children: [
        for (final todo in dayAfterTomorrowTasks) _buildTodoTile(ref, todo),
      ],
    );
  }

  Widget _buildTodoTile(WidgetRef ref, Task todo) {
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
          var color = snapshot.data;
          return TodoTile(
            start: todo.startTime,
            end: todo.endTime,
            title: todo.title,
            description: todo.description,
            color: color,
            switcher: Switch(
              value: todo.isCompleted == 1 ? true : false,
              onChanged: (value) {
                if (value == true) {
                  ref.read(todoStateProvider.notifier).markAsCompleted(
                      todo.id!,
                      todo.title!,
                      todo.description!,
                      1,
                      todo.date!,
                      todo.startTime!,
                      todo.endTime!,
                      0,
                      '');
                } else {}
              },
            ),
            delete: () {
              ref.read(todoStateProvider.notifier).deleteTask(todo.id!);
            },
            editWidget: GestureDetector(
              onTap: () {},
              child: const Icon(
                Icons.edit,
                color: AppConst.kLight,
              ),
            ),
          );
        }
      },
    );
  }
}
