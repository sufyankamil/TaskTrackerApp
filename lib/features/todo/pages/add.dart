import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:management/common/models/task_model.dart';
import 'package:management/common/utils/constants.dart';
import 'package:management/common/widgets/app_style.dart';
import 'package:management/common/widgets/custom_button.dart';
import 'package:management/common/widgets/custom_textfield.dart';
import 'package:management/common/widgets/height_spacer.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'
    as picker;
import 'package:management/features/todo/controller/dates/dates_provider.dart';
import 'package:management/features/todo/controller/todo/todo_provider.dart';


class AddTask extends ConsumerStatefulWidget {
  const AddTask({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddTaskState();
}

class _AddTaskState extends ConsumerState<AddTask> {
  final TextEditingController titleController = TextEditingController();

  final TextEditingController descriptionController = TextEditingController();

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var scheduleDate = ref.watch(dateStateProvider);

    var startTime = ref.watch(startTimeStateProvider);

    var endTime = ref.watch(endTimeStateProvider);

    submit() {
      if (titleController.text.isNotEmpty &&
          descriptionController.text.isNotEmpty &&
          scheduleDate.isNotEmpty &&
          startTime.isNotEmpty &&
          endTime.isNotEmpty) {
        Task task = Task(
          title: titleController.text,
          description: descriptionController.text,
          isCompleted: 0,
          date: scheduleDate.substring(0, 10),
          startTime: startTime.substring(11, 16),
          endTime: endTime.substring(11, 16),
          remind: 0,
          repeat: 'yes',
        );
        ref.read(todoStateProvider.notifier).addTask(task);
        ref.read(dateStateProvider.notifier).setDate('');
        ref.read(startTimeStateProvider.notifier).setStart('');
        ref.read(endTimeStateProvider.notifier).setEnd('');
        titleController.clear();
        descriptionController.clear();
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Please fill all the fields',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: AppConst.kRed,
          ),
        );
      }
    }

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            'Add Task',
            style: appStyle(20, AppConst.kLight, FontWeight.w600),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: ListView(
            children: [
              const HeightSpacer(height: 20),
              CustomTextField(
                hintText: 'Add Title',
                textEditingController: titleController,
                hintStyle: appStyle(16, AppConst.kGreyLight, FontWeight.w600),
              ),
              const HeightSpacer(height: 20),
              CustomTextField(
                hintText: 'Add Description',
                textEditingController: descriptionController,
                hintStyle: appStyle(16, AppConst.kGreyLight, FontWeight.w600),
              ),
              const HeightSpacer(height: 20),
              Text(
                'Schedule Your Task',
                style: appStyle(16, AppConst.kGreyLight, FontWeight.w600),
              ),
              const HeightSpacer(height: 20),
              CustomButton(
                  onTap: () {
                    picker.DatePicker.showDatePicker(context,
                        showTitleActions: true,
                        minTime: DateTime(2023, 8, 1),
                        maxTime: DateTime(2025, 12, 31),
                        theme: const picker.DatePickerTheme(
                            headerColor: AppConst.kGreyDk,
                            backgroundColor: Colors.white,
                            itemStyle: TextStyle(
                                color: AppConst.kBkDark,
                                fontWeight: FontWeight.bold,
                                fontSize: 18),
                            doneStyle:
                                TextStyle(color: Colors.white, fontSize: 16)),
                        onChanged: (date) {
                      if (kDebugMode) {
                        print(
                            'change $date in time zone ${date.timeZoneOffset.inHours}');
                      }
                    }, onConfirm: (date) {
                      ref
                          .read(dateStateProvider.notifier)
                          .setDate(date.toString());
                      if (kDebugMode) {
                        print('confirm $date');
                      }
                    },
                        currentTime: DateTime.now(),
                        locale: picker.LocaleType.en);
                  },
                  width: AppConst.kWidth,
                  height: 52.h,
                  color: AppConst.kLight,
                  color2: AppConst.kBlueLight,
                  text: scheduleDate == ''
                      ? 'Set Date'
                      : scheduleDate.substring(0, 10)),
              const HeightSpacer(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  startTime == ''
                      ? Text(
                          'Set Start Time',
                          style: appStyle(
                              16, AppConst.kGreyLight, FontWeight.w600),
                        )
                      : Text(
                          'Start Time',
                          style: appStyle(
                              16, AppConst.kGreyLight, FontWeight.w600),
                        ),
                  endTime == ''
                      ? Text(
                          'Set End Time',
                          style: appStyle(
                              16, AppConst.kGreyLight, FontWeight.w600),
                        )
                      : Text(
                          'End Time',
                          style: appStyle(
                              16, AppConst.kGreyLight, FontWeight.w600),
                        ),
                ],
              ),
              const HeightSpacer(height: 20),
              Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      onTap: () {
                        picker.DatePicker.showDateTimePicker(context,
                            showTitleActions: true,
                            minTime: DateTime(2023, 8, 1),
                            maxTime: DateTime(2025, 12, 31), onConfirm: (date) {
                          ref
                              .read(startTimeStateProvider.notifier)
                              .setStart(date.toString());
                          if (kDebugMode) {
                            print('confirm $date');
                          }
                        }, locale: picker.LocaleType.en);
                      },
                      width: AppConst.kWidth * 0.5,
                      height: 52.h,
                      color: AppConst.kLight,
                      color2: AppConst.kGreen,
                      text: startTime == ''
                          ? 'Start Time'
                          : startTime.substring(11, 16).compareTo('12') > 0
                              ? '${startTime.substring(11, 16)} PM'
                              : '${startTime.substring(11, 16)} AM',
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: CustomButton(
                      onTap: () {
                        picker.DatePicker.showDateTimePicker(context,
                            showTitleActions: true,
                            minTime: DateTime(2023, 8, 1),
                            maxTime: DateTime(2025, 12, 31), onConfirm: (date) {
                          ref
                              .read(endTimeStateProvider.notifier)
                              .setEnd(date.toString());
                          if (kDebugMode) {
                            print('confirm $date');
                          }
                        }, locale: picker.LocaleType.en);
                      },
                      width: AppConst.kWidth * 0.5,
                      height: 52.h,
                      color: AppConst.kLight,
                      color2: AppConst.kRed,
                      text: endTime == ''
                          ? 'End Time'
                          : endTime.substring(11, 16).compareTo('12') > 0
                              ? '${endTime.substring(11, 16)} PM'
                              : '${endTime.substring(11, 16)} AM',
                    ),
                  ),
                ],
              ),
              const HeightSpacer(height: 20),
              CustomButton(
                onTap: () {
                  submit();
                },
                width: AppConst.kWidth,
                height: 52.h,
                color: AppConst.kLight,
                color2: AppConst.kBlueLight,
                text: 'Submit',
              ),
            ],
          ),
        ));
  }
}
