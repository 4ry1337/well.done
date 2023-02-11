import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:path_provider/path_provider.dart';
import 'package:get/get.dart';
import 'package:isar/isar.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
//app
import 'package:welldone/pages/main.page.dart';
import 'package:welldone/services/settings.service.dart';
import 'package:welldone/core/theme/theme.dart';
import 'package:welldone/core/utils/translation.dart';
//data
import 'package:welldone/models/category.dart';
import 'package:welldone/models/settings.dart';
import 'package:welldone/models/task.dart';
// ignore: depend_on_referenced_packages
import 'package:timezone/data/latest_all.dart' as tz;
// ignore: depend_on_referenced_packages
import 'package:timezone/timezone.dart' as tz;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
late Isar isar;
late Settings settings;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final String timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
  const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
  const InitializationSettings initializationSettings = InitializationSettings(android: initializationSettingsAndroid);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  tz.initializeTimeZones();
  tz.setLocalLocation(tz.getLocation(timeZoneName));
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(systemNavigationBarColor: AppColors.black));
  await isarInit();
  runApp(const App());
  configLoading();
}

void configLoading() {
  EasyLoading.instance
    ..indicatorType = EasyLoadingIndicatorType.threeBounce
    ..radius = 10.0
    ..dismissOnTap = false
    ..animationStyle = EasyLoadingAnimationStyle.scale;
}

Future<void> isarInit() async {
  isar = await Isar.open([
    TaskSchema,
    CategorySchema,
    SettingsSchema,
  ], directory: (await getApplicationSupportDirectory()).path);

  settings = await isar.settings.where().findFirst() ?? Settings();
}

class App extends StatelessWidget {
  const App({super.key});
  @override
  Widget build(BuildContext context) {
    final localizationService = LocalizationService();
    return ScreenUtilInit(
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          translations: Translation(),
          locale: Locale(Translation.languages[settings.language].languageCode, Translation.languages[settings.language].countryCode),
          fallbackLocale: localizationService.fallbackLocale,
          debugShowCheckedModeBanner: false,
          theme: AppTheme.baseTheme,
          home: const MainPage(),
          builder: EasyLoading.init(),
        );
      },
    );
  }
}
