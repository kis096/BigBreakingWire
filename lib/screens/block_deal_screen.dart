import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_html/flutter_html.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../widgets/drawer_menu.dart';
import '../widgets/navbar.dart';
import '../utils/design_tokens.dart';
import '../widgets/banner_ad_widget.dart';
import '../widgets/native_ad_widget.dart';
import '../widgets/interstitial_ad_widget.dart';
import 'live_news_screen.dart';
import 'home_screen.dart';
import 'package:intl/intl.dart';
import '../widgets/custom_button.dart';
import '../utils/utils.dart';

class BlockDealScreen extends StatefulWidget {
  final Future<void> Function(bool) toggleThemeMode;

  const BlockDealScreen({Key? key, required this.toggleThemeMode})
      : super(key: key);

  @override
  _BlockDealScreenState createState() => _BlockDealScreenState();
}

class _BlockDealScreenState extends State<BlockDealScreen> {
  List<dynamic> posts = [];
  int _currentPage = 1;
  bool _isLoading = false;
  bool _hasMore = true;
  int _currentIndex = 1;
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  final InterstitialAdWidget _interstitialAdHelper = InterstitialAdWidget();

  @override
  void initState() {
    super.initState();
    _loadBlockDealPosts();
    _interstitialAdHelper.loadAd();
  }

  Future<void> _loadBlockDealPosts({bool refresh = false}) async {
    if (refresh) {
      _currentPage = 1;
      posts.clear();
      _hasMore = true;
    }

    if (!_isLoading && _hasMore) {
      setState(() {
        _isLoading = true;
      });

      try {
        final response = await http.get(Uri.parse(
            'https://bigbreakingwire.in/wp-json/wp/v2/timeline_post?per_page=15&page=$_currentPage'));

        if (response.statusCode == 200) {
          final newPosts = json.decode(response.body);

          setState(() {
            posts.addAll(newPosts);
            _currentPage++;
            _hasMore = newPosts.isNotEmpty && newPosts.length == 15;
            _isLoading = false;
          });

          if (refresh) {
            _refreshController.refreshCompleted();
          }
        } else {
          setState(() {
            _isLoading = false;
          });

          if (refresh) {
            _refreshController.refreshFailed();
          }

          throw Exception('Failed to load posts');
        }
      } catch (e) {
        setState(() {
          _isLoading = false;
        });

        if (refresh) {
          _refreshController.refreshFailed();
        }

        print('Error loading posts: $e');
      }
    }
  }

  String formatDate(String dateStr) {
    try {
      final DateTime parsedDate = DateTime.parse(dateStr);
      return DateFormat('dd MMM yyyy, hh:mm a').format(parsedDate);
    } catch (e) {
      return 'Invalid date';
    }
  }

  void _onNavItemTapped(int index) {
    if (index == _currentIndex) return;

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
        break; // Already on BlockDealScreen
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>
                LiveNewsScreen(toggleThemeMode: widget.toggleThemeMode),
          ),
        );
        break;
    }
  }

  Widget _buildPostItem(BuildContext context, int index, bool isDarkMode) {
    final post = posts[index];

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Post title
            Text(
              decodeHtmlEntities(post['title']['rendered'] ?? 'Untitled'),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            // Post date
            Text(
              formatDate(post['date']),
              style: TextStyle(
                color: isDarkMode ? Colors.white : Colors.black,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            // Post content
            Html(
              data: decodeHtmlEntities(
                  post['content']['rendered'] ?? 'No content available'),
              style: {
                "body": Style(
                  fontSize: FontSize(14.0),
                  color: isDarkMode ? darkTextColor : lightTextColor,
                ),
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Block Deals',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: primaryRedColor,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      drawer: DrawerMenu(
        toggleThemeMode: widget.toggleThemeMode,
        isDarkMode: isDarkMode,
      ),
      body: _isLoading && posts.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : posts.isEmpty
              ? const Center(
                  child: Text(
                    'No posts available.',
                    style: TextStyle(fontSize: 16),
                  ),
                )
              : SmartRefresher(
                  controller: _refreshController,
                  enablePullDown: true,
                  enablePullUp: true,
                  onRefresh: () => _loadBlockDealPosts(refresh: true),
                  onLoading: _loadBlockDealPosts,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16.0),
                    itemCount: posts.length + (_hasMore ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index < posts.length) {
                        // Show ads conditionally
                        if (index % 7 == 6) _interstitialAdHelper.showAd();
                        if (index % 10 == 9) return const NativeAdWidget();
                        if (index % 4 == 3) return const BannerAdWidget();

                        return _buildPostItem(context, index, isDarkMode);
                      } else if (_hasMore) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: CustomButton(
                              text: 'Load More',
                              isLoading: _isLoading,
                              onPressed: _loadBlockDealPosts,
                              width: 150,
                              height: 150,
                            ),
                          ),
                        );
                      } else {
                        return const BannerAdWidget();
                      }
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
