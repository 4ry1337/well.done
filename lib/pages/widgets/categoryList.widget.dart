import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:welldone/core/theme/theme.dart';
import 'package:welldone/models/category.dart';
import 'package:welldone/services/category.service.dart';


class CategoryList extends StatefulWidget {
  const CategoryList({
    super.key,
    required this.set,
    required this.onSelected,
    this.backgroundColor,
    this.foregroundColor,
    this.initialCategory,
  });
  final Function() set;
  final Function(Category? selectedCategory) onSelected;
  final Color? foregroundColor;
  final Color? backgroundColor;
  final Category? initialCategory;

  @override
  State<CategoryList> createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  final categoryService = CategoryService();
  final locale = Get.locale;
  int? selectedCategoryIndex;
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    Color foregroundColor = widget.foregroundColor ?? AppColors.white;
    Color backgroundColor = widget.backgroundColor ?? AppColors.transparent;
    return SizedBox(
      height: 60.0,
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
                        Text('noCategories'.tr),
                      ],
                    ),
                  );
                }
                return StatefulBuilder(
                  builder: (context, innerState) {
                    return ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: listData.data!.length,
                      itemBuilder: (BuildContext context, int index) {
                        final category = categoryList[index];
                        return GestureDetector(
                          onTap: (){
                            setState(() {
                              if(index == selectedCategoryIndex){
                                selectedCategoryIndex = null;
                                widget.onSelected.call(null);
                              } else {
                                selectedCategoryIndex = index;
                                widget.onSelected.call(category);
                              }
                            });
                          },
                          child: Container(
                            padding: designSystem.padding[8],
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(Radius.circular(30)),
                                color: backgroundColor,
                                border: selectedCategoryIndex == index ? Border.all(color: foregroundColor, width: 4) : Border.all(color: foregroundColor.withOpacity(0.2), width: 4),
                              ),
                              child: Row(
                                children: [
                                  Icon(IconData(category.icon, fontFamily: 'iconsax', fontPackage: 'iconsax'), color: foregroundColor, size: 30,),
                                  const SizedBox(width: 8),
                                  Text(
                                    category.title,
                                    style: context.textTheme.headline6?.copyWith(color: foregroundColor),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              )
                          ),
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return const SizedBox(width: 10);
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