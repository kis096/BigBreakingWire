import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/article_screen.dart';
import 'screens/home_screen.dart';
import 'screens/block_deal_screen.dart';
import 'screens/live_news_screen.dart';
import 'screens/notification_design_screen.dart';
import 'screens/category_screen.dart'; // Import CategoryScreen
import 'widgets/banner_ad_widget.dart';
import 'widgets/native_ad_widget.dart';
import 'widgets/navbar.dart';
import 'widgets/drawer_menu.dart';
import 'utils/design_tokens.dart';
import 'models/article_model.dart';
import 'services/api_service.dart';

Map<String, WidgetBuilder> appRoutes(
    BuildContext context,
    Future<void> Function(bool) toggleThemeMode,
    int currentIndex,
    void Function(int) onNavItemTapped) {
  return {
    '/home': (context) => Scaffold(
          appBar: AppBar(
            title: const Text('Home'),
            actions: [
              IconButton(
                icon: const Icon(Icons.share),
                onPressed: () {
                  // Shareable link
                  final link = 'https://app.bigbreakingwire.in/';
                  Clipboard.setData(ClipboardData(text: link));
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Link copied to clipboard!')),
                  );
                },
              ),
            ],
            backgroundColor: primaryRedColor,
          ),
          drawer: DrawerMenu(
            toggleThemeMode: toggleThemeMode,
            isDarkMode: Theme.of(context).brightness == Brightness.dark,
          ),
          body: Column(
            children: [
              Expanded(
                child: HomeScreen(toggleThemeMode: toggleThemeMode),
              ),
              const BannerAdWidget(),
            ],
          ),
          bottomNavigationBar: CustomBottomNavBar(
            currentIndex: currentIndex,
            onNavItemTapped: onNavItemTapped,
          ),
        ),

    '/block-deals': (context) => Scaffold(
          appBar: AppBar(
            title: const Text('Block Deals'),
            backgroundColor: primaryRedColor,
          ),
          drawer: DrawerMenu(
            toggleThemeMode: toggleThemeMode,
            isDarkMode: Theme.of(context).brightness == Brightness.dark,
          ),
          body: Column(
            children: [
              Expanded(
                child: BlockDealScreen(toggleThemeMode: toggleThemeMode),
              ),
              const BannerAdWidget(),
            ],
          ),
          bottomNavigationBar: CustomBottomNavBar(
            currentIndex: currentIndex,
            onNavItemTapped: onNavItemTapped,
          ),
        ),

    '/short-news': (context) => Scaffold(
          appBar: AppBar(
            title: const Text('Short News'),
            backgroundColor: primaryRedColor,
          ),
          drawer: DrawerMenu(
            toggleThemeMode: toggleThemeMode,
            isDarkMode: Theme.of(context).brightness == Brightness.dark,
          ),
          body: Column(
            children: [
              Expanded(
                child: LiveNewsScreen(toggleThemeMode: toggleThemeMode),
              ),
              const BannerAdWidget(),
              const NativeAdWidget(),
            ],
          ),
          bottomNavigationBar: CustomBottomNavBar(
            currentIndex: currentIndex,
            onNavItemTapped: onNavItemTapped,
          ),
        ),

    // Route for notifications
    '/notification-design': (context) => const NotificationDesignScreen(),

    // Article route
    '/article': (context) {
      final String articleId =
          ModalRoute.of(context)!.settings.arguments as String;
      return FutureBuilder<Article?>(
        future: ApiService().fetchArticleById(articleId), // Fetch article by ID
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator()); // Loading indicator
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error fetching article'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('Article not found'));
          }
          final article = snapshot.data!;
          return ArticleScreen(
              articles: [article], currentIndex: 0); // Display the article
        },
      );
    },

// Category route
    '/category': (context) {
      final args =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      final String categoryId = args['categoryId'];
      final String categoryName = args['categoryName'];
      return CategoryScreen(
        categoryId: categoryId,
        categoryName: categoryName,
        toggleThemeMode: toggleThemeMode,
      );
    },
  };
}
