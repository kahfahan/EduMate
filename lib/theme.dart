import 'package:flutter/material.dart';

class AppTheme {
  // Main color palette
  static const Color primaryBlue = Color(0xFF3949AB);  // Deeper blue for primary actions
  static const Color lightBlue = Color(0xFFE3F2FD);    // Light blue for backgrounds
  static const Color accentBlue = Color(0xFF2196F3);   // Brighter blue for highlights
  static const Color darkBlue = Color(0xFF283593);     // Dark blue for text and headers
  static const Color lightGrey = Color(0xFFF5F5F5);    // Light grey for inactive elements
  
  // Secondary colors
  static const Color white = Colors.white;
  static const Color black = Colors.black;
  static const Color grey = Color(0xFF757575);
  static const Color errorRed = Color(0xFFD32F2F);
  
  // Text styles
  static const TextStyle headingStyle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: darkBlue,
  );
  
  static const Color primaryColor = primaryBlue;
  static const Color darkGrey = Color(0xFF424242);

  static const TextStyle subheadingStyle = TextStyle(
    fontSize: 18, 
    fontWeight: FontWeight.w500,
    color: darkBlue,
  );
  
  static const TextStyle bodyStyle = TextStyle(
    fontSize: 16,
    color: grey,
  );
  
  static const TextStyle buttonTextStyle = TextStyle(
    color: white,
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );
  
  // Input decoration theme
  static InputDecorationTheme inputDecorationTheme() {
    return InputDecorationTheme(
      filled: true,
      fillColor: white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: primaryBlue, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: errorRed, width: 1.5),
      ),
      labelStyle: TextStyle(color: grey, fontSize: 14),
      hintStyle: TextStyle(color: grey.withOpacity(0.5)),
    );
  }
  
  // Button theme
  static ElevatedButtonThemeData elevatedButtonTheme() {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryBlue,
        foregroundColor: white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        elevation: 0,
      ),
    );
  }
  
  // Overall theme data
  static ThemeData themeData() {
    return ThemeData(
      primaryColor: primaryBlue,
      scaffoldBackgroundColor: lightBlue,
      colorScheme: ColorScheme.light(
        primary: primaryBlue,
        secondary: accentBlue,
        error: errorRed,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: lightBlue,
        elevation: 0,
        iconTheme: IconThemeData(color: darkBlue),
        titleTextStyle: TextStyle(
          color: darkBlue,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      inputDecorationTheme: inputDecorationTheme(),
      elevatedButtonTheme: elevatedButtonTheme(),
      textTheme: TextTheme(
        displayLarge: headingStyle,
        headlineMedium: subheadingStyle,
        bodyLarge: bodyStyle,
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: MaterialStateProperty.resolveWith<Color>((states) {
          if (states.contains(MaterialState.selected)) {
            return primaryBlue;
          }
          return grey;
        }),
      ),
    );
  }
}