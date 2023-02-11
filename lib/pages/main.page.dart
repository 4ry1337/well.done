import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:welldone/core/theme/theme.dart';
import 'package:welldone/pages/categories.page.dart';
import 'package:welldone/pages/setting.page.dart';
import 'package:welldone/pages/task.page.dart';
import 'package:welldone/pages/taskCE.page.dart';

class MainPage extends StatefulWidget{
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage>{
  final PageStorageBucket bucket = PageStorageBucket();
  late List<Widget> pages;
  late int currentPageIndex;
  late bool _showFAB;
  @override
  void initState() {
    pages = [
      const CategoriesPage(key: PageStorageKey(1)),
      const TaskPage(key: PageStorageKey(2)),
      const SettingPage(key: PageStorageKey(3)),
    ];
    _showFAB = true;
    currentPageIndex = 1;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: PageStorage(
            bucket: bucket,
            child: pages[currentPageIndex],
          ),
        ),
        extendBody: true,
        floatingActionButton: _showFAB ? FloatingActionButton(
          onPressed:(){
            Get.to(()=>
                TaskCEPage(
                  edit: false,
                  set: (){},
                )
            );
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
        ) : null,
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
                            setState(() {
                              _showFAB = false;
                              currentPageIndex = 0;
                            });
                          },
                          icon: Icon(Iconsax.task, color: currentPageIndex == 0 ? AppColors.accent : AppColors.primary, size: 28)
                      ),
                      !_showFAB ? IconButton(
                          onPressed: (){
                            setState(() {
                              _showFAB = true;
                              currentPageIndex = 1;
                            });
                          },
                          icon: Icon(Iconsax.home, color: currentPageIndex == 1 ? AppColors.accent : AppColors.primary, size: 28)
                      ) : const IconButton(onPressed: null, icon: Icon(null)),
                      IconButton(
                          onPressed: (){
                            setState(() {
                              _showFAB = false;
                              currentPageIndex = 2;
                            });
                          },
                          icon: Icon(Iconsax.profile_circle, color: currentPageIndex == 2 ? AppColors.accent : AppColors.primary, size: 28)
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