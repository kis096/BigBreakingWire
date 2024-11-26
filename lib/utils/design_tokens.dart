import 'package:flutter/material.dart';

// Define primary color palette
const MaterialColor primaryRed = MaterialColor(
  0xFFBA2026,
  <int, Color>{
    50: Color(0xFFFFEBEE),
    100: Color(0xFFFFCDD2),
    200: Color(0xFFEF9A9A),
    300: Color(0xFFE57373),
    400: Color(0xFFEF5350),
    500: Color(0xFFF44336),
    600: Color(0xFFE53935),
    700: Color(0xFFD32F2F),
    800: Color(0xFFC62828),
    900: Color(0xFFBA2026), // Your primary color
  },
);
const Color darkCardColor = Color(0xFF1E1E1E); // Example dark card color
const Color lightCardColor = Color(0xFFFFFFFF); // Example light card color

// Colors
const Color primaryRedColor = Color(0xFFBA2026);
const Color secondaryRedColor = Color(0xFFD32F2F);
const Color lightBackgroundColor = Colors.white;
const Color darkBackgroundColor =
    Color(0xFF121212); // Updated dark theme background
const Color lightTextColor = Colors.black;
const Color darkTextColor = Colors.white;
const Color greyTextColor = Colors.grey;
const Color lightAppBarColor = Color(0xFFBA2026); // AppBar color in light theme
const Color darkAppBarColor = Color(0xFF170200); // AppBar color in dark theme

// Secondary Text Colors
const Color lightSecondaryTextColor =
    Colors.grey; // Added secondary text color for light theme
Color darkSecondaryTextColor =
    Colors.grey[400]!; // Added secondary text color for dark theme

// Typography for light theme
const TextStyle h1StyleLight = TextStyle(
  fontFamily: 'Poppins',
  fontWeight: FontWeight.bold,
  fontSize: 32,
  color: lightTextColor,
);

const TextStyle h2StyleLight = TextStyle(
  fontFamily: 'Poppins',
  fontWeight: FontWeight.bold,
  fontSize: 28,
  color: lightTextColor,
);

const TextStyle h3StyleLight = TextStyle(
  fontFamily: 'Poppins',
  fontWeight: FontWeight.bold,
  fontSize: 24,
  color: lightTextColor,
);

const TextStyle h4StyleLight = TextStyle(
  fontFamily: 'Poppins',
  fontWeight: FontWeight.bold,
  fontSize: 20,
  color: lightTextColor,
);

const TextStyle h5StyleLight = TextStyle(
  fontFamily: 'Poppins',
  fontWeight: FontWeight.bold,
  fontSize: 18,
  color: lightTextColor,
);

const TextStyle h6StyleLight = TextStyle(
  fontFamily: 'Poppins',
  fontWeight: FontWeight.bold,
  fontSize: 16,
  color: lightTextColor,
);

const TextStyle bodyLargeStyleLight = TextStyle(
  fontFamily: 'Poppins',
  fontSize: 18,
  color: lightTextColor,
);

const TextStyle bodyMediumStyleLight = TextStyle(
  fontFamily: 'Poppins',
  fontSize: 16,
  color: greyTextColor,
);

const TextStyle pStyleLight = TextStyle(
  fontFamily: 'Poppins',
  fontSize: 16,
  color: lightTextColor,
);

// Typography for dark theme
const TextStyle h1StyleDark = TextStyle(
  fontFamily: 'Poppins',
  fontWeight: FontWeight.bold,
  fontSize: 32,
  color: darkTextColor,
);

const TextStyle h2StyleDark = TextStyle(
  fontFamily: 'Poppins',
  fontWeight: FontWeight.bold,
  fontSize: 28,
  color: darkTextColor,
);

const TextStyle h3StyleDark = TextStyle(
  fontFamily: 'Poppins',
  fontWeight: FontWeight.bold,
  fontSize: 24,
  color: darkTextColor,
);

const TextStyle h4StyleDark = TextStyle(
  fontFamily: 'Poppins',
  fontWeight: FontWeight.bold,
  fontSize: 20,
  color: darkTextColor,
);

const TextStyle h5StyleDark = TextStyle(
  fontFamily: 'Poppins',
  fontWeight: FontWeight.bold,
  fontSize: 18,
  color: darkTextColor,
);

const TextStyle h6StyleDark = TextStyle(
  fontFamily: 'Poppins',
  fontWeight: FontWeight.bold,
  fontSize: 16,
  color: darkTextColor,
);

const TextStyle bodyLargeStyleDark = TextStyle(
  fontFamily: 'Poppins',
  fontSize: 18,
  color: darkTextColor,
);

const TextStyle bodyMediumStyleDark = TextStyle(
  fontFamily: 'Poppins',
  fontSize: 16,
  color: greyTextColor,
);

const TextStyle pStyleDark = TextStyle(
  fontFamily: 'Poppins',
  fontSize: 16,
  color: darkTextColor,
);

// Button Styles
final ButtonStyle primaryButtonStyle = ElevatedButton.styleFrom(
  backgroundColor: primaryRedColor,
  foregroundColor: Colors.white,
  padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(12),
  ),
  textStyle: const TextStyle(
    fontFamily: 'Poppins',
    fontWeight: FontWeight.bold,
    fontSize: 16,
  ),
);

final ButtonStyle secondaryButtonStyle = OutlinedButton.styleFrom(
  foregroundColor: primaryRedColor,
  side: BorderSide(color: primaryRedColor),
  padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(12),
  ),
  textStyle: const TextStyle(
    fontFamily: 'Poppins',
    fontWeight: FontWeight.bold,
    fontSize: 16,
  ),
);

// Icon Colors
const IconThemeData lightIconTheme = IconThemeData(color: Colors.black);
const IconThemeData darkIconTheme = IconThemeData(color: Colors.white);

// Padding & Spacing
const double smallPadding = 8.0;
const double mediumPadding = 16.0;
const double largePadding = 24.0;
