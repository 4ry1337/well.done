import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:welldone/core/theme/theme.dart';
import 'package:welldone/pages/categories.page.dart';
import 'package:welldone/pages/profile.page.dart';
import 'package:welldone/pages/task.page.dart';
import 'package:welldone/pages/taskCE.page.dart';

class MainPage extends StatefulWidget{
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final List<Widget> pages = [
    const CategoriesPage(),
    const TaskPage(),
    const ProfilePage(),
  ];
  final PageStorageBucket bucket = PageStorageBucket();
  Widget currentPage = const TaskPage();
  bool _showFAB = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: PageStorage(
            bucket: bucket,
            child: currentPage,
          ),
        ),
        extendBody: true,
        floatingActionButton: _showFAB ? FloatingActionButton(
          onPressed:(){
            Get.to(const TaskCEPage(edit: false));
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
                              currentPage = const CategoriesPage();
                              _showFAB = false;
                            });
                          },
                          icon: const Icon(Iconsax.task)
                      ),
                      !_showFAB ? IconButton(
                          onPressed: (){
                            setState(() {
                              currentPage = const TaskPage();
                              _showFAB = true;
                            });
                          },
                          icon: const Icon(Iconsax.home,)
                      ) : const IconButton(onPressed: null, icon: Icon(null)),
                      IconButton(
                          onPressed: (){
                            setState(() {
                              currentPage = const ProfilePage();
                              _showFAB = false;
                            });
                          },
                          icon: const Icon(Iconsax.profile_circle)
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