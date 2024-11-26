import 'package:flutter/material.dart';
import 'dart:ui'; // For blur effect
import '../utils/design_tokens.dart'; // Import design tokens

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onNavItemTapped;

  const CustomBottomNavBar({
    Key? key,
    required this.currentIndex,
    required this.onNavItemTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: mediumPadding, vertical: smallPadding), // Token padding
      child: ClipRRect(
        borderRadius: BorderRadius.circular(50.0), // Rounded navbar
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0), // Blur effect
          child: Container(
            height: 60.0, // Set height for navbar
            decoration: BoxDecoration(
              color: isDarkMode
                  ? darkBackgroundColor.withOpacity(0.2)
                  : lightBackgroundColor.withOpacity(
                      0.2), // Background color with opacity based on theme
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 5,
                  offset: Offset(0, 3), // Subtle shadow
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceAround, // Evenly space nav items
              children: [
                _buildNavItem(
                  iconOutline: Icons.home_outlined,
                  iconFilled: Icons.home,
                  label: 'Home',
                  index: 0,
                  currentIndex: currentIndex,
                  onTap: onNavItemTapped,
                  isDarkMode: isDarkMode,
                ),
                _buildNavItem(
                  iconOutline: Icons.article_outlined,
                  iconFilled: Icons.article,
                  label: 'Block Deal',
                  index: 1,
                  currentIndex: currentIndex,
                  onTap: onNavItemTapped,
                  isDarkMode: isDarkMode,
                ),
                _buildNavItem(
                  iconOutline: Icons.short_text_outlined,
                  iconFilled: Icons.short_text,
                  label: 'Short News',
                  index: 2,
                  currentIndex: currentIndex,
                  onTap: onNavItemTapped,
                  isDarkMode: isDarkMode,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper function to build each navigation item
  Widget _buildNavItem({
    required IconData iconOutline,
    required IconData iconFilled,
    required String label,
    required int index,
    required int currentIndex,
    required ValueChanged<int> onTap,
    required bool isDarkMode,
  }) {
    final isActive = index == currentIndex;
    final activeColor = primaryRedColor; // Use design token
    final inactiveIconColor =
        isDarkMode ? darkIconTheme.color : lightIconTheme.color;

    return GestureDetector(
      onTap: () => onTap(index), // Handle tap
      child: Semantics(
        selected: isActive, // Accessibility: mark item as selected
        label: label, // Accessibility: add label
        child: Container(
          padding: const EdgeInsets.symmetric(
              horizontal: mediumPadding, vertical: smallPadding),
          decoration: isActive
              ? BoxDecoration(
                  color: activeColor, // Active color from token
                  borderRadius: BorderRadius.circular(30.0),
                )
              : null, // No background for inactive items
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isActive ? iconFilled : iconOutline, // Filled for active
                color: isActive ? Colors.white : inactiveIconColor,
                size: isActive ? 28.0 : 24.0, // Slightly larger active icon
              ),
              if (isActive) ...[
                const SizedBox(width: 8.0), // Space between icon and label
                Text(
                  label,
                  style: isDarkMode
                      ? h6StyleDark.copyWith(color: Colors.white)
                      : h6StyleLight.copyWith(color: Colors.white),
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }
}
