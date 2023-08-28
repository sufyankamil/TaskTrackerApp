import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:management/common/models/task_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../common/helpers/db_helpers.dart';
import '../../../../common/utils/constants.dart';
import '../../../../common/widgets/loading_state_notifier.dart';

part 'todo_provider.g.dart';

final shouldReloadProvider = StateNotifierProvider<ShouldReloadNotifier, bool>(
    (ref) => ShouldReloadNotifier());

class ShouldReloadNotifier extends StateNotifier<bool> {
  ShouldReloadNotifier() : super(false);

  void toggleReload() {
    state = !state;
  }
}

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

  void addTask(Task task, BuildContext context) async {
    final result = await DBHelper.createItem(task, context);
    if (result != 0) {
      refresh();
    }
  }

  final loadingProvider = Provider<bool>((ref) => false);

  final loadingNotifierProvider =
      StateNotifierProvider<LoadingStateNotifier, bool>((ref) {
    return LoadingStateNotifier();
  });

  // Future<Color> getRandomColors() async {
  //   Random random = Random();
  //   int randomNumber = random.nextInt(colors.length);
  //   return colors[randomNumber];
  // }

  Future<Color> getRandomColors() async {
    if (colors.isEmpty) {
      throw Exception('No colors available');
    }

    Random random = Random();
    int randomNumber;

    // Keep track of used color indices
    Set<int> usedIndices = <int>{};

    // Check if all colors have been used
    if (usedIndices.length == colors.length) {
      throw Exception('All colors have been used');
    }

    // Generate a random color that hasn't been used before
    do {
      randomNumber = random.nextInt(colors.length);
    } while (usedIndices.contains(randomNumber));

    // Add the used index to the set
    usedIndices.add(randomNumber);

    return colors[randomNumber];
  }

  void updateTask(
      int id,
      String title,
      String description,
      int isCompleted,
      int isPending,
      String date,
      String startTime,
      String endTime,
      int remind,
      String repeat) async {
    await DBHelper.updateTask(
        id, title, description, 0, 0, date, startTime, endTime, remind, repeat);
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
      int isPending,
      String date,
      String startTime,
      String endTime,
      int remind,
      String repeat) async {
    await DBHelper.updateTask(
        id, title, description, 1, 0, date, startTime, endTime, remind, repeat);
    refresh();
  }

  void markAsPending(
      int id,
      String title,
      String description,
      int isCompleted,
      int isPending,
      String date,
      String startTime,
      String endTime,
      int remind,
      String repeat) async {
    await DBHelper.updateTask(
        id, title, description, 0, 1, date, startTime, endTime, remind, repeat);
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

  String getDatAfterTomorrow() {
    DateTime tomorrow = DateTime.now().add(const Duration(days: 2));
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

  bool getPendingStatus(Task task) {
    bool? isPending;
    if (task.isPending == 0) {
      isPending = false;
    } else {
      isPending = true;
    }
    return isPending;
  }
}
