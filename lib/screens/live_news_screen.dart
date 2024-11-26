import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../services/api_service.dart';
import '../models/article_model.dart';
import '../widgets/custom_button.dart'; // Custom Button Widget
import '../widgets/article_card_widget.dart'; // Reusable Article Widget
import '../widgets/banner_ad_widget.dart'; // Banner Ad Widget
import '../widgets/interstitial_ad_widget.dart'; // Interstitial Ad Widget
import '../utils/design_tokens.dart'; // Design tokens for consistent styling
import '../widgets/navbar.dart'; // Navigation Bar
import '../widgets/drawer_menu.dart'; // Drawer Menu
import 'article_screen.dart'; // Article details screen
import 'search_screen.dart'; // Search functionality
import 'block_deal_screen.dart'; // Block Deal Screen
import 'home_screen.dart'; // Home Screen

class LiveNewsScreen extends StatefulWidget {
  final Future<void> Function(bool) toggleThemeMode;

  const LiveNewsScreen({super.key, required this.toggleThemeMode});

  @override
  _LiveNewsScreenState createState() => _LiveNewsScreenState();
}

class _LiveNewsScreenState extends State<LiveNewsScreen> {
  final ApiService _apiService = ApiService();
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  List<Article> _articles = [];
  int _currentPage = 1;
  bool _isLoading = false;
  bool _hasMore = true;

  @override
  void initState() {
    super.initState();
    _loadArticles();
  }

  Future<void> _loadArticles({bool refresh = false}) async {
    if (refresh) {
      _currentPage = 1;
      _articles.clear();
      _hasMore = true;
    }

    if (!_isLoading && _hasMore) {
      setState(() {
        _isLoading = true;
      });

      try {
        final articles = await _apiService.fetchArticlesByCategory(
          '5090', // Fetching from the "Short News" category ID
          15,
          page: _currentPage,
        );

        setState(() {
          _articles.addAll(articles);
          _currentPage++;
          if (articles.length < 15) {
            _hasMore = false;
          }
          _isLoading = false;
        });

        if (refresh) {
          _refreshController.refreshCompleted();
        }
      } catch (e) {
        print('Error loading articles: $e');
        setState(() {
          _isLoading = false;
        });
        if (refresh) {
          _refreshController.refreshFailed();
        }
      }
    }
  }

  // Build list of articles with ads
  Widget _buildArticleList() {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: _articles.length + (_articles.length ~/ 5),
      itemBuilder: (context, index) {
        if (index % 6 == 5) {
          return const BannerAdWidget(); // Display a banner ad
        }

        final articleIndex = index - (index ~/ 6); // Adjust for ads
        final article = _articles[articleIndex];

        return ArticleCardWidget(
          article: article,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ArticleScreen(
                  articles: _articles,
                  currentIndex: articleIndex,
                ),
              ),
            );
          },
        );
      },
    );
  }

  // Handle Bottom Navigation
  void _onNavItemTapped(int index) {
    if (index != 2) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => _getScreenForIndex(index),
        ),
      );
    }
  }

  // Helper to navigate between different screens
  Widget _getScreenForIndex(int index) {
    switch (index) {
      case 0:
        return HomeScreen(
            toggleThemeMode: widget.toggleThemeMode); // Navigate to HomeScreen
      case 1:
        return BlockDealScreen(
            toggleThemeMode:
                widget.toggleThemeMode); // Navigate to BlockDealScreen
      case 2:
        return LiveNewsScreen(
            toggleThemeMode: widget.toggleThemeMode); // Stay on LiveNewsScreen
      default:
        return HomeScreen(
            toggleThemeMode: widget.toggleThemeMode); // Default to HomeScreen
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryRedColor,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Short News',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SearchScreen(
                    articles: _articles,
                    posts: [], // Pass posts if available
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: SmartRefresher(
        controller: _refreshController,
        enablePullDown: true,
        enablePullUp: true,
        onRefresh: () => _loadArticles(refresh: true),
        onLoading: () async {
          await _loadArticles();
          await InterstitialAdWidget(); // Show interstitial ad on load more
        },
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                children: [
                  const SizedBox(height: smallPadding),
                  _buildArticleList(), // Build the article list without live ticker and slider
                  if (_hasMore)
                    Padding(
                      padding: const EdgeInsets.all(smallPadding),
                      child: CustomButton(
                        text: 'Load More',
                        isLoading: _isLoading,
                        width: 150,
                        height: 150, // Adjust button width for consistency
                        onPressed: _loadArticles,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
      drawer: DrawerMenu(
        toggleThemeMode: widget.toggleThemeMode,
        isDarkMode: Theme.of(context).brightness == Brightness.dark,
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 2, // Index for Short News (Live News Screen)
        onNavItemTapped: _onNavItemTapped,
      ),
    );
  }
}
