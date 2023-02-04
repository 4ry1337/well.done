import 'package:flutter/material.dart';
import 'package:welldone/core/values/design_system.dart';
export 'package:welldone/core/values/design_system.dart';

final ThemeData lightTheme = ThemeData.light();

class apptheme {
  static ThemeData get baseTheme {
    return lightTheme.copyWith(
        useMaterial3: true,
        pageTransitionsTheme: const PageTransitionsTheme(),
        appBarTheme: const AppBarTheme(),
        colorScheme: const ColorScheme(
            brightness: Brightness.light,
            primary: colors.primary,
            onPrimary: colors.white,
            secondary: colors.secondary,
            onSecondary: colors.white,
            tertiary: colors.tertiary,
            error: colors.error,
            onError: colors.white,
            background: colors.background,
            onBackground: colors.black,
            surface: colors.white,
            onSurface: colors.black
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
        primaryColor: colors.primary,
        // scaffoldBackgroundColor: scaffoldBackgroundColor,
        // secondaryHeaderColor: secondaryHeaderColor,
        // shadowColor: shadowColor,
        splashColor: colors.accent,
        // unselectedWidgetColor: unselectedWidgetColor,
        textTheme: const TextTheme(
            headline1: typography.headline1,
            headline2: typography.headline2,
            headline3: typography.headline3,
            headline4: typography.headline4,
            headline5: typography.headline5,
            headline6: typography.headline6,
            subtitle1: typography.subtitle1,
            subtitle2: typography.subtitle2,
            bodyText1: typography.bodyText1,
            bodyText2: typography.bodyText2,
            button: typography.button,
            caption: typography.caption,
            overline: typography.overline
        ).apply(
          bodyColor: colors.primary,
          displayColor: colors.primary
        )
    );
  }
}