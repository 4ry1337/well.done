import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:isar/isar.dart';
import 'package:welldone/core/theme/theme.dart';
import 'package:welldone/main.dart';
import 'package:welldone/models/category.dart';
import 'package:welldone/pages/categoryCE.pager.dart';
import 'package:welldone/pages/taskCE.page.dart';
import 'package:welldone/pages/widgets/taskList.widget.dart';
import 'package:welldone/services/task.service.dart';
import 'package:welldone/services/category.service.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({
    super.key,
    required this.category,
  });
  final Category category;

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  final taskService = TaskService();
  final categoryService = CategoryService();
  Category? selectedCategory;
  @override
  void initState(){
    getCategory();
    super.initState();
  }
  getCategory() async {
    setState(() {
      selectedCategory = widget.category;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(IconData(selectedCategory!.icon, fontFamily: 'iconsax', fontPackage: 'iconsax'), color: Color(selectedCategory!.color)),
        title: Text(selectedCategory!.title),
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
        child: Padding(
          padding: designSystem.padding[18]!,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TasksList(
                category: selectedCategory,
                calendar: false,
                allTask: false,
                toggle: taskService.toggleValue.value,
                set: (){},
              )
            ],
          ),
        ),
      ),
        extendBody: true,
        floatingActionButton: FloatingActionButton(
          onPressed:(){
            Get.to(TaskCEPage(edit: true, category: selectedCategory));
          },
          shape: const CircleBorder(),
          child: Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: colors.gradient
                ),
                boxShadow: designSystem.shadow,
              ),
              height: 60,
              width: 60,
              child: const Icon(Iconsax.add)
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: Container(
          decoration: const BoxDecoration(boxShadow: designSystem.shadow),
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
                topRight: Radius.circular(20),
                topLeft: Radius.circular(20)
            ),
            child: BottomAppBar(
                shape: const CircularNotchedRectangle(),
                notchMargin: 10 ,
                child: SizedBox(
                  height: 90,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      IconButton(
                          onPressed: (){
                            showDialog(
                                context: context,
                                builder: (BuildContext context){
                                  return AlertDialog(
                                    title: Text('delete'.tr),
                                    content: Text('Are you sure you want to delete ${selectedCategory!.title} category?'),
                                    actions: [
                                      TextButton(
                                          onPressed: (){
                                            categoryService.deleteCategory(selectedCategory!, () => null);
                                            Get.close(2);
                                            },
                                          child: Text('delete'.tr)
                                      ),
                                      TextButton(
                                          onPressed: () => Get.back(),
                                          child: Text('cancel'.tr)
                                      )
                                    ],
                                  );
                                }
                            );
                          },
                          icon: const Icon(Iconsax.trash)
                      ),
                      const IconButton(onPressed: null, icon: Icon(null)),
                      IconButton(
                          onPressed: (){
                            Get.to(() => CategoryCEPage(
                                edit: true,
                                category: selectedCategory!,
                                set: (){
                                  getCategory();
                                }
                            ));
                          },
                          icon: const Icon(Iconsax.edit)
                      ),
                    ],
                  ),
                )
            ),
          ),
        )
    );
  }
}
