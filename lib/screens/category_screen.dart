import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../services/api_service.dart';
import '../models/article_model.dart';
import 'article_screen.dart';
import 'search_screen.dart';
import '../widgets/navbar.dart';
import '../widgets/banner_ad_widget.dart'; // Reusable BannerAd Widget
import '../widgets/drawer_menu.dart'; // Drawer Menu
import '../utils/design_tokens.dart'; // Import design tokens
import '../widgets/article_card_widget.dart'; // Import ArticleCardWidget
import 'home_screen.dart'; // Import HomeScreen
import 'block_deal_screen.dart'; // Import BlockDealScreen

class CategoryScreen extends StatefulWidget {
  final String categoryId;
  final String categoryName;
  final Future<void> Function(bool) toggleThemeMode;

  const CategoryScreen({
    Key? key,
    required this.categoryId,
    required this.categoryName,
    required this.toggleThemeMode,
  }) : super(key: key);

  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final ApiService _apiService = ApiService();
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  List<Article> _articles = [];
  int _currentPage = 1;
  bool _isLoading = false;
  bool _hasMore = true;
  int _currentIndex = 0; // Track the current index of the bottom nav

  @override
  void initState() {
    super.initState();
    _loadCategoryArticles();
  }

  Future<void> _loadCategoryArticles({bool refresh = false}) async {
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
          widget.categoryId,
          20,
          page: _currentPage,
        );

        setState(() {
          _articles.addAll(articles);
          _currentPage++;
          if (articles.length < 20) {
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

  // Handle Bottom Navigation
  void _onNavItemTapped(int index) {
    if (index == _currentIndex) return; // Prevent reloading the same screen

    setState(() {
      _currentIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>
                HomeScreen(toggleThemeMode: widget.toggleThemeMode),
          ),
        );
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>
                BlockDealScreen(toggleThemeMode: widget.toggleThemeMode),
          ),
        );
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => CategoryScreen(
              categoryId: 'Live News',
              categoryName: 'Live News',
              toggleThemeMode: widget.toggleThemeMode,
            ),
          ),
        );
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.categoryName, // Use category name
          style: h5StyleLight.copyWith(
              color: Colors.white), // Consistent AppBar style
        ),
        backgroundColor: primaryRedColor, // Consistent color for AppBar
        iconTheme: const IconThemeData(
          color: Colors.white, // Set Drawer menu icon color to white
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search,
                color: Colors.white), // Set Search icon color to white
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SearchScreen(
                    articles: _articles,
                    posts: [],
                  ),
                ),
              );
            },
          ),
        ],
      ),
      drawer: DrawerMenu(
        toggleThemeMode: widget.toggleThemeMode,
        isDarkMode: Theme.of(context).brightness == Brightness.dark,
      ),
      body: _isLoading && _articles.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : _articles.isEmpty
              ? const Center(
                  child: Text(
                    'No articles available in this category.',
                    style: TextStyle(fontSize: 16),
                  ),
                )
              : SmartRefresher(
                  controller: _refreshController,
                  enablePullDown: true,
                  enablePullUp: true,
                  onRefresh: () => _loadCategoryArticles(refresh: true),
                  onLoading: _loadCategoryArticles,
                  child: ListView.builder(
                    itemCount: _articles.length + (_hasMore ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == _articles.length && _hasMore) {
                        return const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }

                      // Display ad after every 5 articles
                      if (index % 6 == 5) {
                        return const BannerAdWidget();
                      }

                      final articleIndex = index - (index ~/ 6);
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
                  ),
                ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onNavItemTapped: _onNavItemTapped,
      ),
    );
  }
}
