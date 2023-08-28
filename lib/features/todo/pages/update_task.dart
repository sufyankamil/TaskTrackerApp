import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
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

class UpdateTask extends ConsumerStatefulWidget {
  final int id;

  const UpdateTask({super.key, required this.id});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _UpdateTaskState();
}

class _UpdateTaskState extends ConsumerState<UpdateTask> {
  final TextEditingController titleController = TextEditingController(
    text: titles,
  );

  final TextEditingController descriptionController = TextEditingController(
    text: descriptions,
  );

  // @override
  // void dispose() {
  //   titleController.dispose();
  //   descriptionController.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    var scheduleDate = ref.watch(dateStateProvider);

    var startTime = ref.watch(startTimeStateProvider);

    var endTime = ref.watch(endTimeStateProvider);

    DateTime? lastUpdateTime;

    print(lastUpdateTime);

    submit(BuildContext context) {
      if (titleController.text.isNotEmpty &&
          descriptionController.text.isNotEmpty &&
          scheduleDate.isNotEmpty &&
          startTime.isNotEmpty &&
          endTime.isNotEmpty) {
        ref.read(todoStateProvider.notifier).updateTask(
            widget.id,
            titleController.text,
            descriptionController.text,
            0,
            0,
            scheduleDate.substring(0, 10),
            startTime.substring(11, 16),
            endTime.substring(11, 16),
            0,
            'yes');

        // Task successfully updated, update last update time
        lastUpdateTime = DateTime.now();

        ref.read(dateStateProvider.notifier).setDate('');
        ref.read(startTimeStateProvider.notifier).setStart('');
        ref.read(endTimeStateProvider.notifier).setEnd('');

        titleController.clear();
        descriptionController.clear();

        Navigator.pop(context);

        // Display a toast message with the last update time
        Fluttertoast.showToast(
          msg:
              'Task updated successfully on ${lastUpdateTime.toString().substring(0, 10)}',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 10,
          backgroundColor: AppConst.kBlueLight, // You can choose a color
          textColor: Colors.white,
          fontSize: 16.0,
        );
      } else {
        Fluttertoast.showToast(
          msg: 'Please fill all the fields',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 3,
          backgroundColor: AppConst.kRed,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    }

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            'Update Task',
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
                'Previous selected date was ${dates.substring(0, 10)}',
                style: appStyle(16, AppConst.kGreyLight, FontWeight.w600),
              ),
              const HeightSpacer(height: 20),
              ExpansionTile(
                title: Text(
                  'If you want to change the date then expand this below or else you can leave it as it is',
                  style: appStyle(16, AppConst.kGreyLight, FontWeight.w600),
                ),
                children: [
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
                                doneStyle: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16)), onChanged: (date) {
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
                          ? dates
                          : scheduleDate.substring(0, 10)),
                  const HeightSpacer(height: 20),
                ],
              ),
              // const HeightSpacer(height: 20),
              // CustomButton(
              //     onTap: () {
              //       picker.DatePicker.showDatePicker(context,
              //           showTitleActions: true,
              //           minTime: DateTime(2023, 8, 1),
              //           maxTime: DateTime(2025, 12, 31),
              //           theme: const picker.DatePickerTheme(
              //               headerColor: AppConst.kGreyDk,
              //               backgroundColor: Colors.white,
              //               itemStyle: TextStyle(
              //                   color: AppConst.kBkDark,
              //                   fontWeight: FontWeight.bold,
              //                   fontSize: 18),
              //               doneStyle:
              //                   TextStyle(color: Colors.white, fontSize: 16)),
              //           onChanged: (date) {
              //         if (kDebugMode) {
              //           print(
              //               'change $date in time zone ${date.timeZoneOffset.inHours}');
              //         }
              //       }, onConfirm: (date) {
              //         ref
              //             .read(dateStateProvider.notifier)
              //             .setDate(date.toString());
              //         if (kDebugMode) {
              //           print('confirm $date');
              //         }
              //       },
              //           currentTime: DateTime.now(),
              //           locale: picker.LocaleType.en);
              //     },
              //     width: AppConst.kWidth,
              //     height: 52.h,
              //     color: AppConst.kLight,
              //     color2: AppConst.kBlueLight,
              //     text: scheduleDate == ''
              //         ? 'Set Date'
              //         : scheduleDate.substring(0, 10)),
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
                  submit(context);
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
