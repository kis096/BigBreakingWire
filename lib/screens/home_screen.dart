import 'package:bigbreakingwire/screens/article_screen.dart';
import 'package:bigbreakingwire/screens/block_deal_screen.dart';
import 'package:bigbreakingwire/screens/live_news_screen.dart';
import 'package:bigbreakingwire/screens/search_screen.dart';
import 'package:bigbreakingwire/widgets/article_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../services/api_service.dart';
import '../models/article_model.dart';
import '../widgets/custom_button.dart';
import '../widgets/interstitial_ad_widget.dart';
// Import widgets and use alias to avoid conflicts
import '../widgets/live_ticker_widget.dart' as liveTicker;
import '../widgets/article_slider_widget.dart' as articleSlider;
import '../widgets/drawer_menu.dart'; // Import Drawer widget
import '../widgets/navbar.dart'; // Import Custom Bottom Navigation Bar
import '../utils/design_tokens.dart'; // Import design tokens for consistent styling
import '../widgets/banner_ad_widget.dart'; // Import Banner Ad Widget

class HomeScreen extends StatefulWidget {
  final Future<void> Function(bool) toggleThemeMode;

  const HomeScreen({super.key, required this.toggleThemeMode});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService _apiService = ApiService();
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  List<Article> _articles = [];
  int _currentPage = 1;
  bool _isLoading = false;
  bool _hasMore = true;
  final InterstitialAdWidget _interstitialAdHelper = InterstitialAdWidget();

  @override
  void initState() {
    super.initState();
    _loadArticles();
    _interstitialAdHelper.loadAd();
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
        final articles = await _apiService.fetchArticlesByCategory('65', 15,
            page: _currentPage); // Using category ID for "BigBreakingNow"

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'BigBreakingWire',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
        ),
        backgroundColor: primaryRedColor,
        iconTheme: const IconThemeData(
            color: Colors.white), // Drawer icon color set to white
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
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
      body: SmartRefresher(
        controller: _refreshController,
        enablePullDown: true,
        enablePullUp: true,
        onRefresh: () => _loadArticles(refresh: true),
        onLoading: () async {
          await _loadArticles();
          if (_articles.length % 15 == 0) {
            _interstitialAdHelper.showAd();
          }
        },
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                children: [
                  if (_articles.isNotEmpty)
                    liveTicker.LiveTickerWidget(articles: _articles),
                  articleSlider.ArticleSliderWidget(articles: _articles),
                  const SizedBox(height: 10),
                  _buildArticleList(), // Build the article list with ads
                  if (_hasMore)
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: CustomButton(
                        text: 'Load More',
                        isLoading: _isLoading,
                        width: 150,
                        height: 50,
                        onPressed: () async {
                          await _loadArticles();
                          if (_articles.length % 15 == 0) {
                            _interstitialAdHelper.showAd();
                          }
                        },
                      ),
                    ),
                  if (_isLoading)
                    const Padding(
                      padding: EdgeInsets.all(10),
                      child: CircularProgressIndicator(),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 0,
        onNavItemTapped: (index) {
          if (index != 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => _getScreenForIndex(index),
              ),
            );
          } else {
            setState(() {
              _loadArticles(refresh: true);
            });
          }
        },
      ),
    );
  }

  Widget _getScreenForIndex(int index) {
    switch (index) {
      case 1:
        return BlockDealScreen(toggleThemeMode: widget.toggleThemeMode);
      case 2:
        return LiveNewsScreen(toggleThemeMode: widget.toggleThemeMode);
      default:
        return HomeScreen(toggleThemeMode: widget.toggleThemeMode);
    }
  }
}
