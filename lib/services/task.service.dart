import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:isar/isar.dart';

import 'package:welldone/main.dart';
import 'package:welldone/models/category.dart';
import 'package:welldone/models/task.dart';

class TaskService {
  final titleEdit = TextEditingController().obs;
  final descEdit = TextEditingController().obs;
  final timeEdit = TextEditingController().obs;
  final toggleValue = 0.obs;

  Future<int> getCountTotalTaskCalendar(DateTime selectedDay) async {
    return isar.tasks
        .filter()
        .dateIsNotNull()
        .dateBetween(
        DateTime(
            selectedDay.year, selectedDay.month, selectedDay.day, 0, 0),
        DateTime(
            selectedDay.year, selectedDay.month, selectedDay.day, 23, 59))
        .count();
  }
  Future<int> getCountDoneTaskCalendar(DateTime selectedDay) async {
    return isar.tasks
        .filter()
        .doneEqualTo(true)
        .dateIsNotNull()
        .dateBetween(
        DateTime(
            selectedDay.year, selectedDay.month, selectedDay.day, 0, 0),
        DateTime(
            selectedDay.year, selectedDay.month, selectedDay.day, 23, 59))
        .count();
  }
  Future<int> getCountTotalTask() async {
    return isar.tasks.count();
  }

  Future<int> getCountDoneTask() async {
    return isar.tasks
        .filter()
        .doneEqualTo(true)
        .count();
  }

  Future<int> getCountTotalTasksByCategory(Category category) async {
    return isar.tasks
        .filter()
        .category((q) => q.idEqualTo(category.id))
        .count();
  }

  Future<int> getCountDoneTasksByCategory(Category category) async {
    return isar.tasks
        .filter()
        .doneEqualTo(true)
        .category((q) => q.idEqualTo(category.id))
        .count();
  }
  Stream<List<Task>> getTasksByCategory(int toggle, Category category) async* {
    yield* toggle == 0
        ? isar.tasks
        .filter()
        .category((q) => q.idEqualTo(category.id))
        .doneEqualTo(false)
        .watch(fireImmediately: true)
        : isar.tasks
        .filter()
        .category((q) => q.idEqualTo(category.id))
        .doneEqualTo(true)
        .watch(fireImmediately: true);
  }

  Stream<List<Task>> getTasks(int toggle) async* {
    yield* toggle == 0
        ? isar.tasks
        .filter()
        .doneEqualTo(false)
        .watch(fireImmediately: true)
        : isar.tasks
        .filter()
        .doneEqualTo(true)
        .watch(fireImmediately: true);
  }
  Stream<List<Task>> getCalendarTasks(int toggle, DateTime selectedDay) async* {
    yield* toggle == 0
        ? isar.tasks
        .filter()
        .doneEqualTo(false)
        .dateIsNotNull()
        .dateBetween(
        DateTime(
            selectedDay.year, selectedDay.month, selectedDay.day, 0, 0),
        DateTime(selectedDay.year, selectedDay.month, selectedDay.day,
            23, 59))
        .sortByDate()
        .watch(fireImmediately: true)
        : isar.tasks
        .filter()
        .doneEqualTo(true)
        .dateIsNotNull()
        .dateBetween(
        DateTime(
            selectedDay.year, selectedDay.month, selectedDay.day, 0, 0),
        DateTime(selectedDay.year, selectedDay.month, selectedDay.day,
            23, 59))
        .sortByDate()
        .watch(fireImmediately: true);
  }

  Future<void> addTask(
      Category category,
      TextEditingController titleEdit,
      TextEditingController descEdit,
      TextEditingController timeEdit,
      Function() set) async {
    final taskCreate = Task(
      title: titleEdit.text,
      description: descEdit.text,
      date: DateTime.tryParse(timeEdit.text),
    );

    final tasksCollection = isar.tasks;
    List<Task> getTasks;

    getTasks = await tasksCollection
        .filter()
        .titleEqualTo(titleEdit.text)
        .category((q) => q.idEqualTo(category.id))
        .findAll();

    if (getTasks.isEmpty) {
      await isar.writeTxn(() async {
        await isar.tasks.put(taskCreate);
        await taskCreate.category.save();
        // if (timeEdit.text.isNotEmpty) {
        //   NotificationShow().showNotification(
        //     taskCreate.id,
        //     taskCreate.title,
        //     taskCreate.description,
        //     DateTime.tryParse(timeEdit.text),
        //   );
        // }
      });
      EasyLoading.showSuccess('taskCreate'.tr,
          duration: const Duration(milliseconds: 500));
    } else {
      EasyLoading.showError('duplicateTask'.tr,
          duration: const Duration(milliseconds: 500));
    }
    titleEdit.clear();
    descEdit.clear();
    timeEdit.clear();
    set();
  }

  Future<void> updateTaskCheck(Task task, Function() set) async {
    await isar.writeTxn(() async => isar.tasks.put(task));
    set();
  }

  Future<void> updateTask(
      Task task,
      Category category,
      TextEditingController titleEdit,
      TextEditingController descEdit,
      TextEditingController timeEdit,
      Function() set) async {
    await isar.writeTxn(() async {
      task.title = titleEdit.text;
      task.description = descEdit.text;
      task.date = DateTime.tryParse(timeEdit.text);
      task.category.value = category;
      await isar.tasks.put(task);
      await task.category.save();
      // if (timeEdit.text.isNotEmpty) {
      //   await flutterLocalNotificationsPlugin.cancel(task.id);
      //   NotificationShow().showNotification(
      //     task.id,
      //     task.name,
      //     task.description,
      //     DateTime.tryParse(timeEdit.text),
      //   );
      // }
    });
    EasyLoading.showSuccess('update'.tr,
        duration: const Duration(milliseconds: 500));
    set();
  }

  Future<void> deleteTask(Task task, Function() set) async {
    await isar.writeTxn(() async {
      await isar.tasks.delete(task.id);
      if (task.date != null) {
        await flutterLocalNotificationsPlugin.cancel(task.id);
      }
    });
    EasyLoading.showSuccess('taskDelete'.tr,
        duration: const Duration(milliseconds: 500));
    set();
  }
}