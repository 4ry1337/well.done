import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:welldone/core/utils/translation.dart';
import 'package:welldone/main.dart';
import 'package:welldone/models/language.model.dart';
import 'package:welldone/models/settings.dart';


class SettingsService {

}

class LocalizationService{
  Locale _locale = Locale(Translation.languages[0].languageCode, Translation.languages[0].countryCode);
  final Locale fallbackLocale = Locale(Translation.languages[0].languageCode, Translation.languages[0].countryCode);
  Locale get locale => _locale;
  int _selectedIndex = 0;
  int get selectedIndex => _selectedIndex;
  final List<LanguageModel> _languages = [];
  List<LanguageModel> get languages => _languages;

  Future<void> updateLanguage(int l) async {
    try {
      _locale = Locale(Translation.languages[l].languageCode, Translation.languages[l].countryCode);
      Get.updateLocale(_locale);
      settings.language = l;
      _selectedIndex = l;
      await isar.writeTxn(() async {
        await isar.settings.put(settings);
      });
      EasyLoading.showSuccess('languageChanged'.tr);
    } catch (e){
      EasyLoading.showError('error'.tr);
    }
  }
}