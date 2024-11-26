import 'package:flutter/material.dart';
import 'design_tokens.dart'; // Import the design tokens for colors, typography, etc.

// Light Theme using design tokens
final ThemeData lightTheme = ThemeData(
  primarySwatch: primaryRed, // Use the custom MaterialColor for flexibility
  brightness: Brightness.light,
  primaryColor: primaryRedColor, // Ensure the primary color remains consistent
  scaffoldBackgroundColor:
      lightBackgroundColor, // Background color for light theme

  // AppBar theme for light mode
  appBarTheme: const AppBarTheme(
    backgroundColor:
        lightAppBarColor, // AppBar color for light theme from tokens
    elevation: 0, // Flat AppBar
    titleTextStyle: h6StyleLight, // Heading style for AppBar in light theme
    iconTheme: lightIconTheme, // Icons in light theme
  ),

  // Text themes for light mode, using design tokens
  textTheme: const TextTheme(
    displayLarge: h1StyleLight, // Large heading text style
    displayMedium: h2StyleLight, // Medium heading text style
    displaySmall: h3StyleLight, // Small heading text style
    headlineMedium: h4StyleLight, // Headline text style
    headlineSmall: h5StyleLight, // Sub-headline text style
    titleLarge: h6StyleLight, // Title text style
    bodyLarge: bodyLargeStyleLight, // Body text style for larger text
    bodyMedium: bodyMediumStyleLight, // Body text style for medium text
    titleMedium: pStyleLight, // Paragraph text style
  ),

  // Icon theme for light mode
  iconTheme: lightIconTheme,

  // Button themes for light mode using design tokens
  elevatedButtonTheme: ElevatedButtonThemeData(style: primaryButtonStyle),
  outlinedButtonTheme: OutlinedButtonThemeData(style: secondaryButtonStyle),
);

// Dark Theme using design tokens
final ThemeData darkTheme = ThemeData(
  primarySwatch: primaryRed, // Reuse custom MaterialColor
  brightness: Brightness.dark,
  primaryColor: primaryRedColor, // Primary color for dark mode
  scaffoldBackgroundColor:
      darkBackgroundColor, // Background color for dark theme

  // AppBar theme for dark mode
  appBarTheme: const AppBarTheme(
    backgroundColor: darkAppBarColor, // AppBar color for dark theme from tokens
    elevation: 0, // Flat AppBar
    titleTextStyle: h6StyleDark, // Heading style for AppBar in dark theme
    iconTheme: darkIconTheme, // Icons in dark theme
  ),

  // Text themes for dark mode, using design tokens
  textTheme: const TextTheme(
    displayLarge: h1StyleDark, // Large heading text style
    displayMedium: h2StyleDark, // Medium heading text style
    displaySmall: h3StyleDark, // Small heading text style
    headlineMedium: h4StyleDark, // Headline text style
    headlineSmall: h5StyleDark, // Sub-headline text style
    titleLarge: h6StyleDark, // Title text style
    bodyLarge: bodyLargeStyleDark, // Body text style for larger text
    bodyMedium: bodyMediumStyleDark, // Body text style for medium text
    titleMedium: pStyleDark, // Paragraph text style
  ),

  // Icon theme for dark mode
  iconTheme: darkIconTheme,

  // Button themes for dark mode using design tokens
  elevatedButtonTheme: ElevatedButtonThemeData(style: primaryButtonStyle),
  outlinedButtonTheme: OutlinedButtonThemeData(style: secondaryButtonStyle),
);
