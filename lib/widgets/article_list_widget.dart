import 'package:bigbreakingwire/widgets/interstitial_ad_widget.dart';
import 'package:flutter/material.dart';
import '../models/article_model.dart';
import 'native_ad_widget.dart';
import 'banner_ad_widget.dart';
import 'article_card_widget.dart';
import '../screens/article_screen.dart';

class ArticleListWidget extends StatelessWidget {
  final List<Article> articles;
  final InterstitialAdWidget interstitialAdHelper;

  const ArticleListWidget({
    Key? key,
    required this.articles,
    required this.interstitialAdHelper,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount:
          articles.length + (articles.length ~/ 7) + (articles.length ~/ 20),
      itemBuilder: (context, index) {
        if (index % 21 == 20) {
          interstitialAdHelper.showAd();
          return const SizedBox.shrink();
        }

        if (index % 8 == 7) {
          return const NativeAdWidget();
        }

        if (index % 6 == 5) {
          return const BannerAdWidget();
        }

        final articleIndex = index - (index ~/ 8) - (index ~/ 21);
        final article = articles[articleIndex];

        return ArticleCardWidget(
          article: article,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ArticleScreen(
                  articles: articles,
                  currentIndex: articleIndex,
                ),
              ),
            );
          },
        );
      },
    );
  }
}
