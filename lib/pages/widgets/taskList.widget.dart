import 'dart:async';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:welldone/core/theme/theme.dart';
import 'package:welldone/main.dart';
import 'package:welldone/models/task.dart';
import 'package:welldone/models/category.dart';
import 'package:welldone/pages/taskCE.page.dart';
import 'package:welldone/services/notification.service.dart';
import 'package:welldone/services/settings.service.dart';
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
  final bool calendar;
  final bool allTask;
  final bool toggle;
  final Function() set;
  final DateTime? selectedDay;
  final Task? task;
  final Category? category;

  @override
  State<TasksList> createState() => _TasksListState();
}

class _TasksListState extends State<TasksList> {
  final taskService = TaskService();
  final localizationService = LocalizationService();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: StreamBuilder<List<Task>>(
        stream: widget.allTask ? taskService.getTasks(widget.toggle)
            : widget.category != null ? (widget.calendar == false ? taskService.getTasksByCategory(widget.toggle, widget.category!)
                                                                  : taskService.getCalendarTasksByCategory(widget.toggle, widget.selectedDay!, widget.category!))
                                      : (widget.calendar == false ? taskService.getTasks(widget.toggle)
                                                                  : taskService.getCalendarTasks(widget.toggle, widget.selectedDay!)),
        builder: (context, AsyncSnapshot<List<Task>> listData) {
          switch (listData.connectionState) {
            case ConnectionState.done:
            default:
              if (listData.hasData) {
                final tasksList = listData.data!;
                if (tasksList.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          widget.toggle ? 'noCompletedTasks'.tr : 'noTasks'.tr,
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                      ],
                    ),
                  );
                }
                return StatefulBuilder(
                  builder: (context, innerState) {
                    return ListView.separated(
                      physics: const BouncingScrollPhysics(),
                      itemCount: listData.data!.length,
                      itemBuilder: (BuildContext context, int index) {
                        final task = tasksList[index];
                        return Slidable(
                          direction: Axis.horizontal,
                          endActionPane: ActionPane(
                            motion: const ScrollMotion(),
                            children: [
                              SlidableAction(
                                onPressed: (context){
                                  Get.to(() => TaskCEPage(
                                      edit: true,
                                      task: task,
                                      category: task.category.value,
                                      set: (){
                                        widget.set();
                                      }
                                  ));
                                },
                                borderRadius: designSystem.borderRadius[20]!,
                                backgroundColor: AppColors.secondary,
                                foregroundColor: AppColors.accent,
                                icon: Iconsax.edit,
                              ),
                              SlidableAction(
                                  onPressed: (context) async {
                                    return await showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text(
                                            "deleteTask".tr,
                                            style: context.theme.textTheme.headline4,
                                          ),
                                          content: Text("deleteTaskQuery".tr,
                                              style: context.theme.textTheme.headline6
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: (){
                                                taskService.deleteTask(task, () => widget.set());
                                                Get.back(result: true);
                                              },
                                              child: Text("delete".tr,),
                                            ),
                                            TextButton(
                                              onPressed: (){
                                                Get.back(result: false);
                                              },
                                              child: Text("cancel".tr,),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                borderRadius: designSystem.borderRadius[20]!,
                                backgroundColor: AppColors.secondary,
                                foregroundColor: AppColors.red,
                                icon: Iconsax.trush_square,
                              ),
                            ],
                          ),
                          child: Container(
                            padding: const EdgeInsets.only(left: 3, top: 12, right: 12, bottom: 12),
                            decoration: BoxDecoration(
                              boxShadow: designSystem.shadow,
                              color: AppColors.white,
                              borderRadius: designSystem.borderRadius[20],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Checkbox(
                                  checkColor: AppColors.white,
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
                                    Future.delayed(const Duration(milliseconds: 300), () {taskService.updateTaskCheck(task, widget.set);});
                                  },
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        task.title,
                                        style: context.theme.textTheme.headline5,
                                        overflow: TextOverflow.visible,
                                      ),
                                      task.description.isNotEmpty ?
                                      Text(
                                        task.description,
                                        style: context.theme.textTheme.subtitle2?.copyWith(color: AppColors.secondary),
                                        overflow: TextOverflow.visible,
                                      ) : Container(),
                                      task.date != null && widget.calendar == false ? Text(task.date != null ? DateFormat('dd MMM yyyy kk:mm', '${localizationService.locale}',).format(task.date!) : '', style: context.theme.textTheme.subtitle2?.copyWith(color: AppColors.accent),) : Container(),
                                    ],
                                  ),
                                ),
                                Flexible(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        height: 50,
                                        width: 50,
                                        padding: designSystem.padding[8],
                                        child: task.category.value != null ? Icon(IconData(task.category.value!.icon, fontPackage: 'iconsax', fontFamily: 'iconsax'), color: Color(task.category.value!.color),) : null,
                                      ),
                                      Flexible(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              task.date != null && task.category.value != null ? task.category.value!.title : '',
                                              style: task.category.value != null ? context.textTheme.subtitle1?.copyWith(color: Color(task.category.value!.color), overflow: TextOverflow.ellipsis) : null,
                                            ),
                                            Text(
                                              task.date != null ? DateFormat('HH:mm', '${localizationService.locale}',).format(task.date!) : '',
                                              style: task.date != null && DateTime.now().isAfter(task.date!) && task.done == false ? context.theme.textTheme.bodyText1?.copyWith(color: AppColors.red) : context.textTheme.bodyText1,
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return const SizedBox(height: 10);
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