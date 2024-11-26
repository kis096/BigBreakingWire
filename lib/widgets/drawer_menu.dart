import 'package:flutter/material.dart';
import '../utils/design_tokens.dart';
import '../services/api_service.dart';
import '../screens/about_screen.dart';
import '../screens/disclaimer_screen.dart';
import '../screens/privacy_policy_screen.dart';
import '../widgets/banner_ad_widget.dart'; // Import banner ad widget

class DrawerMenu extends StatelessWidget {
  final Function(bool) toggleThemeMode;
  final bool isDarkMode;

  const DrawerMenu({
    super.key,
    required this.toggleThemeMode,
    required this.isDarkMode,
  });

  static const Map<String, IconData> _icons = {
    'Business': Icons.business,
    'Finance': Icons.attach_money,
    'Geopolitical': Icons.public,
    'BigBreakingNow': Icons.newspaper,
    'Stock In News': Icons.show_chart,
    'Health': Icons.health_and_safety,
    'Brokerage Reports': Icons.report,
    'Short News': Icons.short_text,
    'Tech': Icons.computer,
  };

  @override
  Widget build(BuildContext context) {
    final apiService = ApiService();
    final categories = apiService.getCategories();

    final Color backgroundColor =
        isDarkMode ? darkBackgroundColor : lightBackgroundColor;
    final Color textColor = isDarkMode ? darkTextColor : lightTextColor;
    final Color iconColor =
        isDarkMode ? darkIconTheme.color! : lightIconTheme.color!;

    return Drawer(
      backgroundColor: backgroundColor,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Color(0xFFFFEBEE), // Background color behind the logo
            ),
            child: Center(
              child: Image.asset(
                'assets/images/logo.png',
                fit: BoxFit.contain,
              ),
            ),
          ),
          for (var i = 0; i < categories.length; i++) ...[
            ListTile(
              leading: Icon(
                  _icons[categories.entries.elementAt(i).key] ?? Icons.category,
                  color: iconColor),
              title: Text(
                categories.entries.elementAt(i).key,
                style: isDarkMode ? bodyLargeStyleDark : bodyLargeStyleLight,
              ),
              onTap: () {
                final categoryId = categories.entries.elementAt(i).value;
                final categoryName = categories.entries.elementAt(i).key;

                Navigator.pushNamed(
                  context,
                  '/category',
                  arguments: {
                    'categoryId': categoryId,
                    'categoryName': categoryName,
                  },
                );
              },
            ),
            if (i % 10 == 9)
              const BannerAdWidget(), // Insert ad after every 10 items
          ],
          const Divider(thickness: 1, color: Colors.grey),
          _buildStaticMenuItem(
            icon: Icons.info_outline,
            label: 'About',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AboutScreen()),
              );
            },
            textColor: textColor,
            iconColor: iconColor,
          ),
          _buildStaticMenuItem(
            icon: Icons.privacy_tip_outlined,
            label: 'Privacy Policy',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const PrivacyPolicyScreen()),
              );
            },
            textColor: textColor,
            iconColor: iconColor,
          ),
          _buildStaticMenuItem(
            icon: Icons.warning_amber_outlined,
            label: 'Disclaimer',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const DisclaimerScreen()),
              );
            },
            textColor: textColor,
            iconColor: iconColor,
          ),
          const Divider(thickness: 1, color: Colors.grey),
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 10.0), // Padding for dark mode switcher
            child: SwitchListTile(
              contentPadding: const EdgeInsets.all(0),
              title: Row(
                children: [
                  Icon(
                    Icons.dark_mode,
                    color: iconColor,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Dark Mode',
                    style:
                        isDarkMode ? bodyLargeStyleDark : bodyLargeStyleLight,
                  ),
                ],
              ),
              value: isDarkMode,
              onChanged: (value) {
                toggleThemeMode(value);
              },
            ),
          ),
        ],
      ),
    );
  }

  ListTile _buildStaticMenuItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required Color textColor,
    required Color iconColor,
  }) {
    return ListTile(
      leading: Icon(icon, color: iconColor),
      title: Text(
        label,
        style: TextStyle(color: textColor),
      ),
      onTap: onTap,
    );
  }
}
