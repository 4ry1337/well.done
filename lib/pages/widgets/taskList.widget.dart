import 'dart:async';
import 'package:iconsax/iconsax.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:welldone/core/values/colors.dart';
import 'package:welldone/main.dart';
import 'package:welldone/models/task.dart';
import 'package:welldone/models/category.dart';
import 'package:welldone/services/notification.service.dart';
import 'package:welldone/services/task.service.dart';

class TasksList extends StatefulWidget {
  const TasksList({
    super.key,
    required this.calendar,
    required this.allTask,
    required this.toggle,
    required this.set,
    this.task,
    this.category,
    this.selectedDay,
  });
  final DateTime? selectedDay;
  final bool calendar;
  final bool allTask;
  final Task? task;
  final Category? category;
  final int toggle;
  final Function() set;

  @override
  State<TasksList> createState() => _TasksListState();
}

class _TasksListState extends State<TasksList> {
  final taskService = TaskService();
  final locale = Get.locale;

  @override
  Widget build(BuildContext context) {

    return Expanded(
      child: StreamBuilder<List<Task>>(
        stream: widget.allTask == true ?
        taskService.getTasks(widget.toggle) :
        widget.calendar == true ?
        taskService.getCalendarTasks(widget.toggle, widget.selectedDay!) :
        taskService.getTasks(widget.toggle),
        builder: (BuildContext context, AsyncSnapshot<List<Task>> listData) {
          switch (listData.connectionState) {
            case ConnectionState.done:
            default:
              if (listData.hasData) {
                final tasksList = listData.data!;
                if (tasksList.isEmpty) {
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        // Image.asset(
                        //   'assets/images/AddTasks.png',
                        //   scale: 5,
                        // ),
                        Text(
                          widget.toggle == 1 ? 'Completed Task': 'No Tasks',
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                      ],
                    ),
                  );
                }
                return StatefulBuilder(
                  builder: (context, innerState) {
                    return ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: listData.data?.length,
                      itemBuilder: (BuildContext context, int index) {
                        final task = tasksList[index];
                        return Dismissible(
                          key: ObjectKey(task),
                          direction: DismissDirection.endToStart,
                          confirmDismiss: (DismissDirection direction) async {
                            return await showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  backgroundColor: context.theme.primaryColor,
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(15))),
                                  title: Text(
                                    "deletedTask".tr,
                                    style: context.theme.textTheme.headline4,
                                  ),
                                  content: Text("deletedTaskQuery".tr,
                                      style: context.theme.textTheme.headline6),
                                  actions: [
                                    TextButton(
                                        onPressed: () => Get.back(result: false),
                                        child: Text("cancel".tr,
                                            style: context
                                                .theme.textTheme.headline6
                                                ?.copyWith(
                                                color: Colors.blueAccent))),
                                    TextButton(
                                        onPressed: () => Get.back(result: true),
                                        child: Text("delete".tr,
                                            style: context
                                                .theme.textTheme.headline6
                                                ?.copyWith(color: Colors.red))),
                                  ],
                                );
                              },
                            );
                          },
                          onDismissed: (DismissDirection direction) {
                            taskService.deleteTask(task, widget.set);
                          },
                          background: Container(
                            alignment: Alignment.centerRight,
                            child: const Padding(
                              padding: EdgeInsets.only(
                                right: 15,
                              ),
                              child: Icon(
                                Iconsax.trush_square,
                                color: Colors.red,
                              ),
                            ),
                          ),
                          child: Container(
                            margin: const EdgeInsets.only(right: 20, left: 20, bottom: 15),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              // color: Colors.white,
                            ),
                            child: Row(
                              children: [
                                Flexible(
                                  child: Row(
                                    children: [
                                      Checkbox(
                                        checkColor: Colors.white,
                                        value: task.done,
                                        shape: const CircleBorder(),
                                        onChanged: (val) {
                                          innerState(() {task.done = val!;});
                                          task.done == true ? flutterLocalNotificationsPlugin.cancel(task.id) : task.date != null ? NotificationShow().showNotification(
                                            task.id,
                                            task.title,
                                            task.description,
                                            task.date,
                                          ) : null;
                                          Future.delayed(
                                            const Duration(milliseconds: 300),
                                                () {taskService.updateTaskCheck(task, widget.set);},
                                          );
                                        },
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              right: 10),
                                          child: Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                task.title,
                                                style: task.date != null
                                                    && DateTime.now().isAfter(task.date!)
                                                    && task.done == false ?
                                                context.theme.textTheme.headline4?.copyWith(color: colors.accent,) :
                                                context.theme.textTheme.headline4?.copyWith(color: colors.black), overflow: TextOverflow.visible,
                                              ),
                                              task.description.isNotEmpty ?
                                              Text(task.description, style: context.theme.textTheme.subtitle2, overflow: TextOverflow.visible,) :
                                              Container(),

                                              task.date != null && widget.calendar == false ?
                                              Text(task.date != null ?
                                              DateFormat('dd MMM yyyy kk:mm', '${locale?.languageCode}',).format(task.date!) : '', style: context.theme.textTheme.subtitle2?.copyWith(color: Colors.deepPurple),) :
                                              Container(),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                widget.allTask == true ?
                                Text(task.title.length > 10 ? task.title.substring(0, 10) : task.title,
                                  style: context.theme.textTheme.subtitle2,
                                ) : widget.calendar == true ? Text(
                                  '${task.title.length > 10 ? task.title.substring(0, 10) : task.title}\n${DateFormat('kk:mm', '${locale?.languageCode}',).format(task.date!)}',
                                  style: context.theme.textTheme.subtitle2,
                                ) : Container(),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
          }
        },
      ),
    );
  }
}