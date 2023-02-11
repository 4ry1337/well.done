import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:welldone/core/theme/theme.dart';
import 'package:welldone/pages/categoryCE.page.dart';
import 'package:welldone/pages/widgets/categoryGrid.widget.dart';
import 'package:welldone/services/task.service.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({
    super.key,
  });
  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  final taskService = TaskService();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: designSystem.padding[18]!,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'categories'.tr,
                  style: Theme.of(context).textTheme.headline4,
                ),
                IconButton(
                    onPressed: (){
                      Get.to(() => CategoryCEPage(
                        set: (){},
                        edit: false,
                      ));
                    },
                    icon: const Icon(Iconsax.add)
                ),
              ],
            ),
          ),
          const CategoryGrid()
        ],
      ),
    );
  }
}
