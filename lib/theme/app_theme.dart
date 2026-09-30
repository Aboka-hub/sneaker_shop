import 'package:flutter/material.dart';
import 'package:sneaker_shop/theme/button_theme.dart';
import 'package:sneaker_shop/theme/input_decoration_theme.dart';

import '../constants.dart';
import 'checkbox_themedata.dart';
import 'theme_data.dart';

class AppTheme {
  static ThemeData lightTheme(BuildContext context) {
    return ThemeData(
      brightness: Brightness.light,
      fontFamily: "Plus Jakarta",
      primarySwatch: primaryMaterialColor,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: Colors.white,
      iconTheme: const IconThemeData(color: blackColor),
      textTheme: const TextTheme(
        bodyMedium: TextStyle(color: blackColor40),
      ),
      elevatedButtonTheme: elevatedButtonThemeData,
      textButtonTheme: textButtonThemeData,
      outlinedButtonTheme: outlinedButtonTheme(),
      inputDecorationTheme: lightInputDecorationTheme,
      checkboxTheme: checkboxThemeData.copyWith(
        side: const BorderSide(color: blackColor40),
      ),
      appBarTheme: appBarLightTheme,
      scrollbarTheme: scrollbarThemeData,
      dataTableTheme: dataTableLightThemeData,
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: FadeUpPageTransitionsBuilder(),
          TargetPlatform.iOS: FadeUpPageTransitionsBuilder(),
          TargetPlatform.macOS: FadeUpPageTransitionsBuilder(),
          TargetPlatform.windows: FadeUpPageTransitionsBuilder(),
          TargetPlatform.linux: FadeUpPageTransitionsBuilder(),
          TargetPlatform.fuchsia: FadeUpPageTransitionsBuilder(),
        },
      ),
    );
  }
}

class FadeUpPageTransitionsBuilder extends PageTransitionsBuilder {
  const FadeUpPageTransitionsBuilder();

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    final curved = CurvedAnimation(
      parent: animation,
      curve: Curves.easeOutCubic,
      reverseCurve: Curves.easeInCubic,
    );
    return FadeTransition(
      opacity: curved,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.05),
          end: Offset.zero,
        ).animate(curved),
        child: child,
      ),
    );
  }
}
