import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:isar/isar.dart';
import 'package:welldone/core/utils/utils.dart';
import 'package:welldone/main.dart';
import 'package:welldone/core/theme/theme.dart';
import 'package:welldone/models/category.dart';
import 'package:welldone/models/task.dart';
import 'package:welldone/pages/widgets/button.widget.dart';
import 'package:welldone/pages/widgets/categoryList.widget.dart';
import 'package:welldone/services/task.service.dart';

class TaskCEPage extends StatefulWidget {
  const TaskCEPage({
    super.key,
    required this.edit,
    required this.set,
    this.category,
    this.task,
  });
  final Task? task;
  final bool edit;
  final Function() set;
  final Category? category;

  @override
  State<TaskCEPage> createState() => _TaskCEPageState();
}

class _TaskCEPageState extends State<TaskCEPage> {
  final _formKey = GlobalKey<FormState>();
  final taskService = TaskService();
  final locale = Get.locale;
  DateTime? initialDate;
  Task? selectedTask;
  Category? selectedCategory;

  @override
  initState() {
    if (widget.edit == true) {
      selectedTask = widget.task;
      selectedCategory = widget.task?.category.value;
      taskService.titleEdit.value = TextEditingController(text: widget.task!.title);
      taskService.descEdit.value = TextEditingController(text: widget.task?.description);
      taskService.timeEdit.value = TextEditingController(text: widget.task!.date != null ? widget.task!.date.toString() : '');
    }
    initialDate = widget.task?.date != null ? widget.task!.date : DateTime.now();
    if(widget.category != null){
      selectedCategory = widget.category;
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
        title: Text('task'.tr),
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
      extendBody: true,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Builder(
          builder: (context) => Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'title'.tr,
                          style: Theme.of(context).textTheme.subtitle2,
                        ),
                        TextFormField(
                          controller: taskService.titleEdit.value,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            border: const UnderlineInputBorder(),
                            hintText: 'hintTaskTitle'.tr,
                            hintStyle: Theme.of(context).textTheme.bodyText1,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'validateTitle'.tr;
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'description'.tr,
                          style: Theme.of(context).textTheme.subtitle2,
                        ),
                        TextFormField(
                          controller: taskService.descEdit.value,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            border: const UnderlineInputBorder(),
                            hintText: 'hintTaskDescription'.tr,
                            hintStyle: Theme.of(context).textTheme.bodyText1,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'category'.tr,
                            style: Theme.of(context).textTheme.subtitle2,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: CategoryList(
                              set: (){},
                              initialCategory: widget.category,
                              onSelected: (selected){
                                selectedCategory = selected;
                              },
                              foregroundColor: AppColors.primary,),
                          ),
                        ],
                      )
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                        child: CupertinoDatePicker(
                            initialDateTime: initialDate,
                            mode: CupertinoDatePickerMode.dateAndTime,
                            onDateTimeChanged: (DateTime selected){
                              taskService.timeEdit.value.text = selected.toString();
                            },
                        )
                    ),
                  ),
                  Container(
                    height: 100,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    child: Button(
                      onPressed: (){
                        if (_formKey.currentState!.validate()) {
                          textTrim(taskService.titleEdit.value);
                          textTrim(taskService.descEdit.value);
                          widget.edit == false ? taskService.addTask(
                            selectedCategory,
                            taskService.titleEdit.value,
                            taskService.descEdit.value,
                            taskService.timeEdit.value,
                            widget.set,
                          ) : taskService.updateTask(
                            selectedTask!,
                            selectedCategory,
                            taskService.titleEdit.value,
                            taskService.descEdit.value,
                            taskService.timeEdit.value,
                            widget.set,
                          );
                          Get.back();
                        }
                      },
                      buttonName: widget.edit == false ? "create".tr.toUpperCase() : "edit".tr.toUpperCase(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}