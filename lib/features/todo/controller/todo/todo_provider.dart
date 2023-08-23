import 'package:management/common/models/task_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../common/helpers/db_helpers.dart';

part 'todo_provider.g.dart';

@riverpod
class TodoState extends _$TodoState {
  @override
  List<Task> build() {
    return [];
  }

  void refresh() async {
    final data = await DBHelper.getItems();
    state = data.map((e) => Task.fromJson(e)).toList();
  }

  void addTask(Task task) async {
    final result = await DBHelper.createItem(task);
    if (result != 0) {
      refresh();
    }
  }

  void updateTask(
      int id,
      String title,
      String description,
      int isCompleted,
      String date,
      String startTime,
      String endTime,
      int remind,
      String repeat) async {
    await DBHelper.updateTask(id, title, description, isCompleted, date,
        startTime, endTime, remind, repeat);
    refresh();
  }

  void deleteTask(int id) async {
    final result = await DBHelper.deleteItem(id);
    if (result != 0) {
      refresh();
    }
  }

  void markAsCompleted(
      int id,
      String title,
      String description,
      int isCompleted,
      String date,
      String startTime,
      String endTime,
      int remind,
      String repeat) async {
    await DBHelper.updateTask(
        id, title, description, 1, date, startTime, endTime, remind, repeat);
        refresh();
  }

  String getToday() {
    DateTime today = DateTime.now();
    return today.toString().substring(0, 10);
  }

  String getTomorrow() {
    DateTime tomorrow = DateTime.now().add(const Duration(days: 1));
    return tomorrow.toString().substring(0, 10);
  }

  String getYesterday() {
    final now = DateTime.now();
    final yesterday = DateTime(now.year, now.month, now.day - 1);
    return yesterday.toString();
  }

  List<String> last30Days() {
    final now = DateTime.now();
    DateTime oneMonth = now.subtract(const Duration(days: 30));

    List<String> dates = [];
    for (int i = 0; i < 30; i++) {
      DateTime date = oneMonth.add(Duration(days: i));
      dates.add(date.toString().substring(0, 10));
    }
    return dates;
  }

  bool getStatus(Task task) {
    bool? isCompleted;
    if (task.isCompleted == 0) {
      isCompleted = false;
    } else {
      isCompleted = true;
    }
    return isCompleted;
  }
}
