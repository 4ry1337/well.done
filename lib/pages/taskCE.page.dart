import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:isar/isar.dart';
import 'package:welldone/main.dart';
import 'package:welldone/core/theme/theme.dart';
import 'package:welldone/models/category.dart';
import 'package:welldone/models/task.dart';
import 'package:welldone/services/category.service.dart';
import 'package:welldone/services/task.service.dart';

class TaskCEPage extends StatefulWidget {
  const TaskCEPage({
    super.key,
    required this.edit,
    this.category,
    this.task,
  });
  final Category? category;
  final Task? task;
  final bool edit;
  //final Function() set;

  @override
  State<TaskCEPage> createState() => _TaskCEPageState();
}

class _TaskCEPageState extends State<TaskCEPage> {
  final formKey = GlobalKey<FormState>();
  final taskService = TaskService();
  final categoryService = CategoryService();
  final locale = Get.locale;
  Category? selectedCategory;
  List<Category>? category;
  final textConroller = TextEditingController();

  @override
  initState() {
    if (widget.edit == true) {
      selectedCategory = widget.task!.category.value;
      textConroller.text = widget.task!.category.value!.title;
      taskService.titleEdit.value = TextEditingController(text: widget.task!.title);
      taskService.descEdit.value = TextEditingController(text: widget.task!.description);
      taskService.timeEdit.value = TextEditingController(text: widget.task!.date != null ? widget.task!.date.toString() : '');
    }
    super.initState();
  }

  Future<List<Task>> getTasksAll(String pattern) async {
    final tasksCollection = isar.tasks;
    List<Task> getTask;
    getTask = await tasksCollection.where().findAll();
    return getTask.where((element) {
      final title = element.title.toLowerCase();
      final query = pattern.toLowerCase();
      return title.contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('newTask'.tr),
        toolbarHeight: 72,
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(20),
              bottomLeft: Radius.circular(20)),
        ),
        actions: [
          IconButton(
            onPressed: (){
              Get.back();
            },
            icon: const Icon(Icons.close),
          )
        ],
      ),
      body: SafeArea(
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Padding(
              padding: designSystem.padding[18]!,
              child: Column(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          'taskTitle'.tr,
                          style: Theme.of(context).textTheme.subtitle2,
                      ),
                      TextField(
                        decoration: InputDecoration(
                          border: const UnderlineInputBorder(),
                          hintText: 'hintText'.tr,
                          hintStyle: Theme.of(context).textTheme.bodyText1,
                        ),
                      ),
                    ],
                  ),
                ]
              ),
            ),
          ),
        ),
      ),
    );
  }
}