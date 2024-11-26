import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import '../models/article_model.dart';
import '../widgets/banner_ad_widget.dart';
import '../services/ads_service.dart';
import '../services/link_service.dart';
import '../utils/design_tokens.dart';

class ArticleScreen extends StatefulWidget {
  final List<Article> articles;
  final int currentIndex;

  const ArticleScreen({
    Key? key,
    required this.articles,
    required this.currentIndex,
  }) : super(key: key);

  @override
  _ArticleScreenState createState() => _ArticleScreenState();
}

class _ArticleScreenState extends State<ArticleScreen> {
  late PageController _pageController;
  late int _currentIndex;
  final AdsService _adsService = AdsService();

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.currentIndex;
    _pageController = PageController(initialPage: _currentIndex);
    _adsService.loadInterstitialAd();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _adsService.disposeInterstitialAd();
    super.dispose();
  }

  // Updated to share both the title and the link
  void _shareArticle(String title, String id) {
    final link = LinkService.generateArticleUrl(title, id);
    final message = 'Check out this article : "$title": $link';
    Share.share(message, subject: 'Sharing Article');
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryRedColor,
        title: Text(
          widget.articles[_currentIndex].title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share, color: Colors.white),
            onPressed: () {
              final article = widget.articles[_currentIndex];
              _shareArticle(article.title, article.id); // Passing title and id
            },
          ),
        ],
      ),
      body: PageView.builder(
        controller: _pageController,
        itemCount: widget.articles.length,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });

          if (index % 5 == 0 && index != 0) {
            _adsService.showInterstitialAd();
          }
        },
        itemBuilder: (context, index) {
          final article = widget.articles[index];
          final paragraphs = article.content.split('\n\n');

          return SingleChildScrollView(
            padding: const EdgeInsets.all(smallPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (article.imageUrl != null)
                  _buildFeaturedImage(article.imageUrl!),
                const SizedBox(height: smallPadding),
                Text(
                  article.title,
                  style: isDarkMode ? h5StyleDark : h5StyleLight,
                ),
                const SizedBox(height: mediumPadding),
                ..._buildArticleContentWithBannerAds(paragraphs, isDarkMode),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildFeaturedImage(String imageUrl) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.network(
        imageUrl,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
      ),
    );
  }

  List<Widget> _buildArticleContentWithBannerAds(
      List<String> paragraphs, bool isDarkMode) {
    List<Widget> content = [];

    for (int i = 0; i < paragraphs.length; i++) {
      content.add(
        Padding(
          padding: const EdgeInsets.all(smallPadding),
          child: Text(
            paragraphs[i],
            textAlign: TextAlign.justify,
            style: TextStyle(
              fontSize: 16,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
          ),
        ),
      );

      if (i % 4 == 3) {
        content.add(const Center(child: BannerAdWidget()));
      }
    }

    return content;
  }
}
