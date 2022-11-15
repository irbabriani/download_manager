import 'package:flutter/material.dart';
class AppSizes {
  static const int splashScreenHeadline6FontSize = 48;
  static const int headline6FontSize = 34;
  static const double sidePadding = 15;
  static const double widgetSidePadding = 20;
  static const double buttonRadius = 25;
  static const double imageRadius = 8;
  static const double linePadding = 4;
  static const double widgetBorderRadius = 34;
  static const double textFieldRadius = 4.0;
  static const EdgeInsets bottomSheetPadding =
  EdgeInsets.symmetric(horizontal: 16, vertical: 10);
  static const app_bar_size = 56.0;
  static const app_bar_expanded_size = 180.0;
  static const tile_width = 148.0;
  static const tile_height = 276.0;
}

class AppColors {
  static const primaryColor = Color(0xFF014cff);
  static const primaryLightColor = Color(0xFF7288ff);
  static const primaryDarkColor = Color(0xFF0009cc);
  static const secondaryColor = Color(0xFF368ffc);
  static const secondaryLightColor = Color(0xFF4cacff);
  static const secondaryDarkColor = Color(0xFF2e4bb6);
  static const primaryTextColor = Color(0xFF80cbc4);
  static const secondaryTextColor = Color(0xFFffffff);

  static const red = Colors.red;
  static const redAccent = Colors.redAccent;
  static const blueGrey = Colors.blueGrey;
  static const pink = Colors.pink;
  static const pinkAccent = Colors.pinkAccent;

  static const black = Color(0xFF212121);
  static const darkGray = Color(0xFF979797);
  static const white = Color(0xFFFFFFFF);
  static const orange = Color(0xFFFFBA49);
  static const background = Color(0xFFE5E5E5);
  static const backgroundLight = Color(0xFFF9F9F9);
  static const transparent = Color(0x00000000);
  static const success = Color(0xFF2AA952);

  static const Color darkPurple = Color(0xff240046);
  static const Color purple = Color(0xff5A189A);
  static const Color green = Color(0xff118AB2);
  static const Color lightGreen = Color(0xffB7DCE8);
  static const Color lightGray = Color(0xffE5E5E5);
  static const Color gray = Color(0xffB1A7A6);


  static const Color darkBlue = Color(0xff0054A5);
  static const Color blue = Color(0xff0077b6);
  static const Color darkYellow = Color(0xffF7941D);
  static const Color lightYellow = Color(0xffFBC98D);
}

class AppConstants {
  static const pageSize = 20;
}

class AppTheme {
  static ThemeData of(context) {
    var theme = Theme.of(context);
    return theme.copyWith(
      visualDensity: VisualDensity.adaptivePlatformDensity,
      primaryColor: AppColors.primaryColor,
      primaryColorLight: AppColors.primaryLightColor,
      primaryColorDark: AppColors.primaryDarkColor,
      secondaryHeaderColor: AppColors.red,
      bottomAppBarColor: AppColors.lightGray,
      backgroundColor: AppColors.background,
      dialogBackgroundColor: AppColors.backgroundLight,
      errorColor: AppColors.red,
      dividerColor: AppColors.transparent,
      hintColor: AppColors.blueGrey,
      inputDecorationTheme: const InputDecorationTheme(
        labelStyle: TextStyle(color: AppColors.primaryLightColor),
      ),
      appBarTheme: theme.appBarTheme.copyWith(
          color: AppColors.primaryColor,
          iconTheme: const IconThemeData(color: AppColors.white), toolbarTextStyle: theme.textTheme.copyWith(
              caption: const TextStyle(
                  color: AppColors.white,
                  fontSize: 18,
                  fontFamily: 'irSans',
                  fontWeight: FontWeight.w400)).bodyText2, titleTextStyle: theme.textTheme.copyWith(
              caption: const TextStyle(
                  color: AppColors.white,
                  fontSize: 18,
                  fontFamily: 'irSans',
                  fontWeight: FontWeight.w400)).headline6),
      textTheme: theme.textTheme
          .copyWith(
        //over image white text
        headline5: theme.textTheme.headline5?.copyWith(
            fontSize: 48,
            color: AppColors.white,
            fontFamily: 'irSans',
            fontWeight: FontWeight.w900),
        headline6: theme.textTheme.headline6?.copyWith(
            fontSize: 24,
            color: AppColors.black,
            fontWeight: FontWeight.w900,
            fontFamily: 'irSans'),
        //

        //product headline6
        headline4: theme.textTheme.headline4?.copyWith(
            color: AppColors.black,
            fontSize: 16,
            fontWeight: FontWeight.w400,
            fontFamily: 'irSans'),

        headline3: theme.textTheme.headline3
            ?.copyWith(fontFamily: 'irSans', fontWeight: FontWeight.w400),
        //product price
        headline2: theme.textTheme.headline2?.copyWith(
            color: AppColors.lightGray,
            fontSize: 14,
            fontFamily: 'irSans',
            fontWeight: FontWeight.w400),
        headline1: theme.textTheme.headline1
            ?.copyWith(fontFamily: 'irSans', fontWeight: FontWeight.w500),

        subtitle2: theme.textTheme.headline5?.copyWith(
            fontSize: 18,
            color: AppColors.black,
            fontFamily: 'irSans',
            fontWeight: FontWeight.w400),
        subtitle1: theme.textTheme.headline5?.copyWith(
            fontSize: 12.3,
            color: AppColors.black,
            fontFamily: 'irSans',
            fontWeight: FontWeight.w500),
        //pink button with white text
        button: theme.textTheme.button?.copyWith(
            fontSize: 14,
            color: AppColors.white,
            fontFamily: 'irSans',
            fontWeight: FontWeight.w500),
        //black caption headline6
        caption: theme.textTheme.caption?.copyWith(
            fontSize: 10,
            color: AppColors.black,
            fontFamily: 'irSans',
            fontWeight: FontWeight.w700),
        //light gray small text
        bodyText2: theme.textTheme.bodyText2?.copyWith(
            color: AppColors.black,
            fontSize: 11,
            fontFamily: 'irSans',
            fontWeight: FontWeight.w400),
        //view all link
        bodyText1: theme.textTheme.bodyText1?.copyWith(
            color: AppColors.black,
            fontSize: 11,
            fontFamily: 'irSans',
            fontWeight: FontWeight.w400),

      )
          .apply(fontFamily: 'irSans'), colorScheme: ColorScheme.fromSwatch().copyWith(secondary: AppColors.primaryColor),
    );
  }
}
