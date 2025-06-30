import 'package:flutter/material.dart';
import 'package:time_manager/theme/color_scheme.dart';
import 'package:time_manager/theme/colors.dart';

class AppTheme extends StatelessWidget {
  const AppTheme({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        primarySwatch: getMaterialColor(AppColors.primary),
        colorScheme: lightColorScheme,
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide: const BorderSide(color: Color(0xffE0E0E0)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide: const BorderSide(color: AppColors.primary),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide: const BorderSide(color: AppColors.primary),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide: const BorderSide(color: AppColors.negative),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide: const BorderSide(color: AppColors.primary),
          ),
          floatingLabelStyle: const TextStyle(color: Colors.black),
          contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
          // contentPadding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
        ),
        cardTheme: CardThemeData(
          color: AppColors.gray,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          elevation: 0,
        ),
        cardColor: AppColors.gray,
        scaffoldBackgroundColor: Colors.white,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.black,
            disabledForegroundColor: Colors.black45,
            backgroundColor: AppColors.primary,
            disabledBackgroundColor: AppColors.gray,
            side: BorderSide.none,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 24),
          ).copyWith(elevation: const WidgetStatePropertyAll(0)),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.black,
            disabledForegroundColor: Colors.black45,
            backgroundColor: Colors.white,
            disabledBackgroundColor: AppColors.gray,
            elevation: 0,
            side: const BorderSide(color: AppColors.primary),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 24),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          ),
        ),
        disabledColor: const Color(0xffE0E0E0),
      ),
      child: child,
    );
  }
}