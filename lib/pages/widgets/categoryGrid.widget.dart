import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:welldone/core/theme/theme.dart';
import 'package:welldone/models/category.dart';
import 'package:welldone/pages/category.page.dart';
import 'package:welldone/services/category.service.dart';

class CategoryGrid extends StatefulWidget {
  const CategoryGrid({
    super.key,
  });

  @override
  State<CategoryGrid> createState() => _CategoryGridState();
}

class _CategoryGridState extends State<CategoryGrid> {
  final categoryService = CategoryService();
  final locale = Get.locale;

  @override
  Widget build(BuildContext context) {

    return Expanded(
      child: StreamBuilder<List<Category>>(
        stream: categoryService.getCategories(),
        builder: (BuildContext context, AsyncSnapshot<List<Category>> listData) {
          switch (listData.connectionState) {
            case ConnectionState.done:
            default:
              if (listData.hasData) {
                final categoryList = listData.data!;
                if (categoryList.isEmpty) {
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        Text(
                            'noCategories'.tr,
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                      ],
                    ),
                  );
                }
                return StatefulBuilder(
                  builder: (context, innerState) {
                    final double itemHeight = (Get.height - kToolbarHeight) / 2;
                    final double itemWidth = Get.width * 2;
                    return GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                        childAspectRatio: (itemWidth/itemHeight),
                      ),
                      physics: const BouncingScrollPhysics(),
                      itemCount: listData.data?.length,
                      itemBuilder: (BuildContext context, int index) {
                        final category = categoryList[index];
                        return Container(
                          decoration: BoxDecoration(
                            boxShadow: designSystem.shadow,
                            borderRadius: designSystem.borderRadius[16]
                          ),
                          child: Material(
                            borderRadius: designSystem.borderRadius[16],
                            color: AppColors.white,
                            // shape: ShapeBorder.,
                            child: InkWell(
                              borderRadius: designSystem.borderRadius[12],
                              onTap: (){
                                Get.to(() => CategoryPage(category: category));
                              },
                              child: Padding(
                                padding: designSystem.padding[12]!,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: 40,
                                      width: 40,
                                      decoration: BoxDecoration(
                                        borderRadius: designSystem.borderRadius[8]!,
                                        //color: colors.white,
                                        boxShadow: designSystem.shadow,
                                      ),
                                      child: Icon(IconData(category.icon, fontFamily: 'iconsax', fontPackage: 'iconsax'), color: Color(category.color), size: 30,),
                                    ),
                                    Flexible(
                                      child: Container(
                                        padding: designSystem.padding[12],
                                        decoration: const BoxDecoration(),
                                        child: Text(
                                            category.title,
                                          style: Theme.of(context).textTheme.headline6,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
          }
        },
      ),
    );
  }
}