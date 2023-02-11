import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:isar/isar.dart';
import 'package:welldone/main.dart';
import 'package:welldone/models/category.dart';
import 'package:welldone/models/task.dart';

class CategoryService {
  final titleEdit = TextEditingController().obs;
  final timeEdit = TextEditingController().obs;
  final toggle = 0.obs;

  Future<Category?> getCategory(int id) async {
    return await isar.categorys.get(id);
  }

  Stream<List<Category>> getCategories() async* {
    yield* isar.categorys.where().watch(fireImmediately: true);
  }

  Future<void> addCategory(TextEditingController titleEdit, IconData icon, Color selectedColor, Function() set) async {
    final categoryCreate = Category(
      title: titleEdit.text,
      icon: icon.codePoint,
      color: selectedColor.value,
    );
    List<Category> searchCategory;
    final categoryCollection = isar.categorys;

    searchCategory = await categoryCollection.filter().titleEqualTo(titleEdit.text).findAll();
    if (searchCategory.isEmpty) {
      await isar.writeTxn(() async {
        await isar.categorys.put(categoryCreate);
      });
      EasyLoading.showSuccess('createCategory'.tr);
    } else {
      EasyLoading.showError('duplicateCategory'.tr);
    }

    titleEdit.clear();
    set();
  }

  Future<void> updateCategory(Category category, TextEditingController titleEdit, IconData icon, Color selectedColor, Function() set) async {
    await isar.writeTxn(() async {
      category.title = titleEdit.text;
      category.icon = icon.codePoint;
      category.color = selectedColor.value;
      await isar.categorys.put(category);
    });
    EasyLoading.showSuccess('editCategory'.tr);
    set();
  }

  Future<void> deleteCategory(Category category, Function() set) async {
    // Delete Notification
    List<Task> getTasks;
    final tasksCollection = isar.tasks;
    getTasks = await tasksCollection
        .filter()
        .category((q) => q.idEqualTo(category.id))
        .findAll();

    for (var element in getTasks) {
      if (element.date != null) {
        await flutterLocalNotificationsPlugin.cancel(element.id);
      }
    }
    // Delete Tasks
    await isar.writeTxn(() async {
      await isar.tasks.filter().category((q) => q.idEqualTo(category.id)).deleteAll();
    });
    // Delete Category
    await isar.writeTxn(() async {
      await isar.categorys.delete(category.id);
    });
    EasyLoading.showSuccess('categoryDelete'.tr);
    set();
  }
}