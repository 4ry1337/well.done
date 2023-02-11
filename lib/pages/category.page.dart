import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:welldone/core/theme/theme.dart';
import 'package:welldone/models/category.dart';
import 'package:welldone/pages/categoryCE.page.dart';
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
  int countTotalTask = 0;
  int countDoneTask = 0;

  getCountTaskBycategory() async {
    final countDone = await taskService.getCountDoneTasksByCategory(widget.category);
    final countTotal = await taskService.getCountTotalTasksByCategory(widget.category);
    setState(() {
      countTotalTask = countTotal;
      countDoneTask = countDone;
    });
  }
  @override
  void initState() {
    getCountTaskBycategory();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Category?>(
      future: categoryService.getCategory(widget.category.id),
      builder: (BuildContext context, AsyncSnapshot<Category?> category){
        switch(category.connectionState) {
          case ConnectionState.done:
          default:
            if(category.hasData){
              Category selectedCategory = category.data!;
              return StatefulBuilder(
                builder: (context, innerState){
                  return Scaffold(
                      appBar: AppBar(
                        leading: Icon(IconData(selectedCategory.icon, fontFamily: 'iconsax', fontPackage: 'iconsax'), color: Color(selectedCategory.color)),
                        title: Text(selectedCategory.title),
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
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                      'tasks'.tr,
                                    style: context.textTheme.headline6,
                                  ),
                                  Text(
                                    '$countDoneTask/$countTotalTask',
                                    style: context.textTheme.headline6,
                                  ),
                                  Switch(
                                    // trackColor: taskService.trackColor,
                                    // thumbIcon: taskService.thumbIcon,
                                    value: taskService.toggleValue.value,
                                    onChanged: (value) {
                                      setState(() {
                                        taskService.toggleValue.value = value;
                                      });
                                    },
                                  ),
                                ],
                              ),
                              TasksList(
                                calendar: false,
                                allTask: false,
                                toggle: taskService.toggleValue.value,
                                category: selectedCategory,
                                set: (){
                                  selectedCategory = category.data!;
                                },
                              )
                            ],
                          ),
                        ),
                      ),
                      extendBody: true,
                      floatingActionButton: FloatingActionButton(
                        onPressed:(){
                          Get.to(() => TaskCEPage(
                            category: widget.category,
                              edit: false,
                              set: (){},
                          ));
                        },
                        shape: const CircleBorder(),
                        child: Container(
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: AppColors.gradient
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
                                                  title: Text(
                                                    'deleteCategory'.tr,
                                                    style: context.theme.textTheme.headline4,
                                                  ),
                                                  content: Text(
                                                      'deleteCategoryQuery'.tr,
                                                      style: context.theme.textTheme.headline6
                                                  ),
                                                  actions: [
                                                    TextButton(
                                                        onPressed: (){
                                                          categoryService.deleteCategory(selectedCategory, () => null);
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
                                              category: selectedCategory,
                                              set: (){
                                                setState(() {
                                                  selectedCategory = category.data!;
                                                });
                                                getCountTaskBycategory();
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
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
        }
      }
    );
  }
}
