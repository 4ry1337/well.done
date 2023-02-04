import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:welldone/core/theme/theme.dart';
import 'package:welldone/models/category.dart';
import 'package:welldone/models/task.dart';
import 'package:welldone/pages/widgets/button.widget.dart';
import 'package:welldone/pages/widgets/colorPicker.widget.dart';
import 'package:welldone/pages/widgets/iconPicker.widget.dart';
import 'package:welldone/services/category.service.dart';

class CategoryCEPage extends StatefulWidget {
  const CategoryCEPage({
    super.key,
    required this.edit,
    required this.set,
    this.category,
  });
  final Category? category;
  final bool edit;
  final Function() set;

  @override
  State<CategoryCEPage> createState() => _CategoryCEPageState();
}

class _CategoryCEPageState extends State<CategoryCEPage> {
  final _forumKey = GlobalKey<FormState>();
  final categoryService = CategoryService();
  final locale = Get.locale;
  Category? selectedCategory;
  List<Task>? task;
  IconData? selectedIcon;
  Color? selectedColor;
  DateTime? selectedDate = DateTime.now();
  final textConroller = TextEditingController();
  @override
  initState() {
    if (widget.edit == true) {
      selectedCategory = widget.category;
      textConroller.text = widget.category!.title;
      selectedIcon = IconData(widget.category!.icon, fontPackage: 'iconsax', fontFamily: 'iconsax');
      selectedColor = Color(widget.category!.color);
      categoryService.titleEdit.value = TextEditingController(text: widget.category!.title);
    }
    super.initState();
  }
  textTrim(value) {
    value.text = value.text.trim();
    while (value.text.contains("  ")) {
      value.text = value.text.replaceAll("  ", " ");
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('newCategory'.tr),
          toolbarHeight: 72,
        elevation: 0,
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(20),
              bottomLeft: Radius.circular(20)),
        ),
        actions: [
          IconButton(
            onPressed: (){
              categoryService.titleEdit.value.clear();
              categoryService.timeEdit.value.clear();
              textConroller.clear();
              Get.back();
            },
            icon: const Icon(Iconsax.close_circle),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Builder(
          builder: (context) => Form(
            key: _forumKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: designSystem.padding[18]!,
                  child: TextFormField(
                    controller: categoryService.titleEdit.value,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Iconsax.edit_2),
                      labelText: 'title'.tr
                    ),
                  ),
                ),
                // CalendarDatePicker(
                //     initialDate: DateTime(2023, 01, 01),
                //     firstDate: DateTime(2023, 01, 01),
                //     lastDate: DateTime(2100, 01, 01),
                //     onDateChanged: ((selected) {
                //       selectedDate = selected;
                //     })
                // ),
                Padding(
                  padding: designSystem.padding[18]!,
                  child: IconPicker(
                      onSelectIcon: (value){
                        setState(() {
                          selectedIcon = value;
                        });
                      },
                      availableIcons: const [
                        Iconsax.briefcase,
                        Iconsax.code,
                        Iconsax.chart_2,
                        Iconsax.building,
                        Iconsax.house,
                        Iconsax.bank,
                        Iconsax.building_3,
                        Iconsax.hospital,
                        Iconsax.game,
                        Iconsax.brush,
                      ],
                      initialIcon: Iconsax.briefcase
                  ),
                ),
                Padding(
                  padding: designSystem.padding[18]!,
                  child: ColorPicker(
                    onSelectColor: (value){
                      setState(() {
                        selectedColor = value;
                      });
                    },
                    availableColors: categoryColor.categoryColors,
                    initialColor: categoryColor.categoryColors.first,
                  ),
                ),
                Padding(
                  padding: designSystem.padding[18]!,
                  child: Button(
                    onPressed: (){
                      widget.set();
                      if(_forumKey.currentState!.validate()){
                        textTrim(categoryService.titleEdit.value);
                        widget.edit == false ?
                        categoryService.addCategory(
                            categoryService.titleEdit.value,
                            selectedIcon!,
                            selectedColor!
                        ).then((value) => Get.back()) : categoryService.updateCategory(
                            widget.category!,
                            categoryService.titleEdit.value,
                            selectedIcon!,
                            selectedColor!
                        ).then((value) => Get.back());
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
    );
  }
}
