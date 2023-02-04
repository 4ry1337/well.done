import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:welldone/core/theme/theme.dart';
import 'package:welldone/pages/categoryCE.pager.dart';
import 'package:welldone/pages/taskCE.page.dart';
import 'package:welldone/pages/widgets/categoryList.widget.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({
    super.key,
  });
  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
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
                  'Category'.tr,
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
                )
              ],
            ),
          ),
          const CategoryList()
        ],
      ),
    );
  }
}
