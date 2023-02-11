import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:isar/isar.dart';

import 'package:welldone/main.dart';
import 'package:welldone/models/category.dart';
import 'package:welldone/models/task.dart';
import 'package:welldone/services/notification.service.dart';

class TaskService {
  final titleEdit = TextEditingController().obs;
  final descEdit = TextEditingController().obs;
  final timeEdit = TextEditingController().obs;
  final toggleValue = false.obs;

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

  Future<int> getCountTotalTaskCalendarByCategory(
      DateTime selectedDay, Category category) async {
    return isar.tasks
        .filter()
        .category((q) => q.idEqualTo(category.id))
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

  Future<int> getCountDoneTaskCalendarByCategory(
      DateTime selectedDay, Category category) async {
    return isar.tasks
        .filter()
        .doneEqualTo(true)
        .dateIsNotNull()
        .dateBetween(
            DateTime(
                selectedDay.year, selectedDay.month, selectedDay.day, 0, 0),
            DateTime(
                selectedDay.year, selectedDay.month, selectedDay.day, 23, 59))
        .category((q) => q.idEqualTo(category.id))
        .count();
  }

  Future<int> getCountTotalTask() async {
    return isar.tasks.count();
  }

  Future<int> getCountDoneTask() async {
    return isar.tasks.filter().doneEqualTo(true).count();
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

  Stream<List<Task>> getTasksByCategory(bool toggle, Category category) async* {
    yield* isar.tasks
        .filter()
        .category((q) => q.idEqualTo(category.id))
        .doneEqualTo(toggle)
        .watch(fireImmediately: true);
  }

  Stream<List<Task>> getTasks(bool toggle) async* {
    yield* isar.tasks.filter().doneEqualTo(toggle).watch(fireImmediately: true);
  }

  Stream<List<Task>> getCalendarTasks(
      bool toggle, DateTime selectedDay) async* {
    yield* isar.tasks
        .filter()
        .doneEqualTo(toggle)
        .dateIsNotNull()
        .dateBetween(
            DateTime(
                selectedDay.year, selectedDay.month, selectedDay.day, 0, 0),
            DateTime(
                selectedDay.year, selectedDay.month, selectedDay.day, 23, 59))
        .sortByDate()
        .watch(fireImmediately: true);
  }

  Stream<List<Task>> getCalendarTasksByCategory(
      bool toggle, DateTime selectedDay, Category category) async* {
    yield* isar.tasks
        .filter()
        .doneEqualTo(toggle)
        .category((q) => q.idEqualTo(category.id))
        .dateIsNotNull()
        .dateBetween(
            DateTime(
                selectedDay.year, selectedDay.month, selectedDay.day, 0, 0),
            DateTime(
                selectedDay.year, selectedDay.month, selectedDay.day, 23, 59))
        .sortByDate()
        .watch(fireImmediately: true);
  }

  Future<void> addTask(
      Category? category,
      TextEditingController titleEdit,
      TextEditingController descEdit,
      TextEditingController timeEdit,
      Function() set) async {
    try {
      final taskCreate = Task(
        title: titleEdit.text,
        description: descEdit.text,
        date: DateTime.tryParse(timeEdit.text),
      )..category.value = category;

      await isar.writeTxn(() async {
        await isar.tasks.put(taskCreate);
        await taskCreate.category.save();
        if (timeEdit.text.isNotEmpty) {
          NotificationShow().showNotification(
            taskCreate.id,
            taskCreate.title,
            taskCreate.description,
            DateTime.tryParse(timeEdit.text),
          );
        }
      });
      EasyLoading.showSuccess('taskCreate'.tr);
      titleEdit.clear();
      descEdit.clear();
      timeEdit.clear();
      set();
    } catch (e) {
      EasyLoading.showError('error'.tr);
    }
  }

  Future<void> updateTaskCheck(Task task, Function() set) async {
    try {
      await isar.writeTxn(() async => isar.tasks.put(task));
      set();
    } catch (e) {
      EasyLoading.showError('error'.tr);
    }
  }

  Future<void> updateTask(
      Task task,
      Category? category,
      TextEditingController titleEdit,
      TextEditingController descEdit,
      TextEditingController timeEdit,
      Function() set) async {
    try {
      await isar.writeTxn(() async {
        task.title = titleEdit.text;
        task.description = descEdit.text;
        task.date = DateTime.tryParse(timeEdit.text);
        task.category.value = category;
        await isar.tasks.put(task);
        await task.category.save();
        if (timeEdit.text.isNotEmpty) {
          await flutterLocalNotificationsPlugin.cancel(task.id);
          NotificationShow().showNotification(
            task.id,
            task.title,
            task.description,
            DateTime.tryParse(timeEdit.text),
          );
        }
      });
      EasyLoading.showSuccess('taskUpdate'.tr);
      set();
    } catch (e) {
      EasyLoading.showError('error'.tr);
    }
  }

  Future<void> deleteTask(Task task, Function() set) async {
    try {
      await isar.writeTxn(() async {
        await isar.tasks.delete(task.id);
        if (task.date != null) {
          await flutterLocalNotificationsPlugin.cancel(task.id);
        }
      });
      EasyLoading.showSuccess('taskDelete'.tr);
      set();
    } catch (e) {
      EasyLoading.showError('error'.tr);
    }
  }
}
