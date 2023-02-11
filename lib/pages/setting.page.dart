import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import 'package:welldone/core/theme/theme.dart';
import 'package:welldone/core/utils/translation.dart';
import 'package:welldone/models/language.model.dart';
import 'package:welldone/services/settings.service.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  final localizationService = LocalizationService();
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Container(
        padding: designSystem.padding[18]!,
        child: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: designSystem.padding[8]!,
                  child: Text(
                      'common'.tr,
                    style: context.textTheme.headline6?.copyWith(color: AppColors.accent),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    boxShadow: designSystem.shadow,
                    borderRadius: designSystem.borderRadius[8]
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      DropdownButtonHideUnderline(
                        child: DropdownButton2(
                          itemHeight: 80,
                          isExpanded: true,
                          dropdownDecoration: BoxDecoration(
                              color: AppColors.white,
                              boxShadow: designSystem.shadow,
                              borderRadius: designSystem.borderRadius[8]
                          ),
                          value: localizationService.selectedIndex,
                          onChanged: (index){
                            localizationService.updateLanguage(index!);
                          },
                          items: Translation.languages.map((LanguageModel language) {
                              return DropdownMenuItem(
                                value: language.index,
                                child: Text(
                                  language.languageName,
                                  style: context.textTheme.bodyText1,
                                ),
                              );
                            }).toList(),
                          selectedItemBuilder: (BuildContext context) {
                            return Translation.languages.map((LanguageModel language) {
                              return Row(
                                children: [
                                  Container(
                                    padding: designSystem.padding[8]!,
                                    decoration: BoxDecoration(
                                      color: AppColors.inactive,
                                      borderRadius: designSystem.borderRadius[12]!,
                                    ),
                                    child: const Icon(Iconsax.global, size: 40),
                                  ),
                                  const SizedBox(width: 8),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'language'.tr,
                                        style: context.textTheme.bodyText2?.copyWith(color: context.textTheme.bodyText2?.color?.withOpacity(0.5)),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        language.languageName,
                                        style: context.textTheme.bodyText1,
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            }).toList();
                          },
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
