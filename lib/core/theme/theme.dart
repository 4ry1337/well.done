import 'package:flutter/material.dart';
import 'package:welldone/core/values/design_system.dart';
export 'package:welldone/core/values/design_system.dart';

final ThemeData lightTheme = ThemeData.light();

class AppTheme {
  static ThemeData get baseTheme {
    return lightTheme.copyWith(
        useMaterial3: true,
        pageTransitionsTheme: const PageTransitionsTheme(),
        appBarTheme: const AppBarTheme(),
        colorScheme: const ColorScheme(
            brightness: Brightness.light,
            primary: AppColors.primary,
            onPrimary: AppColors.white,
            secondary: AppColors.secondary,
            onSecondary: AppColors.white,
            tertiary: AppColors.tertiary,
            error: AppColors.error,
            onError: AppColors.white,
            background: AppColors.background,
            onBackground: AppColors.black,
            surface: AppColors.white,
            onSurface: AppColors.black
        ),
        // canvasColor: canvasColor,
        // cardColor: cardColor,
        // dialogBackgroundColor: dialogBackgroundColor,
        // disabledColor: disabledColor,
        // dividerColor: dividerColor,
        // focusColor: focusColor,
        // highlightColor: highlightColor,
        // hintColor: hintColor,
        // hoverColor: hoverColor,
        // indicatorColor: indicatorColor,
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: AppColors.white,
        // secondaryHeaderColor: secondaryHeaderColor,
        shadowColor: designSystem.shadow.first.color,
        splashColor: AppColors.accent,
        // unselectedWidgetColor: unselectedWidgetColor,
        textTheme: const TextTheme(
            headline1: AppTypography.headline1,
            headline2: AppTypography.headline2,
            headline3: AppTypography.headline3,
            headline4: AppTypography.headline4,
            headline5: AppTypography.headline5,
            headline6: AppTypography.headline6,
            subtitle1: AppTypography.subtitle1,
            subtitle2: AppTypography.subtitle2,
            bodyText1: AppTypography.bodyText1,
            bodyText2: AppTypography.bodyText2,
            button: AppTypography.button,
            caption: AppTypography.caption,
            overline: AppTypography.overline
        ).apply(
          bodyColor: AppColors.primary,
          displayColor: AppColors.primary
        ),
    );
  }
}