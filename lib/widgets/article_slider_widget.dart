import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart'; // Import the carousel slider
import '../models/article_model.dart';
import '../screens/article_screen.dart'; // Import the ArticleScreen

class ArticleSliderWidget extends StatelessWidget {
  final List<Article> articles;

  const ArticleSliderWidget({
    Key? key,
    required this.articles,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
        height: 200.0,
        autoPlay: true,
        enableInfiniteScroll: true,
        enlargeCenterPage: true,
        aspectRatio: 16 / 9,
        viewportFraction: 0.8,
      ),
      items: articles.take(10).map((article) {
        return GestureDetector(
          onTap: () {
            // Navigate to the article screen with the selected article
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ArticleScreen(
                  articles: articles,
                  currentIndex: articles.indexOf(article), // Pass the index
                ),
              ),
            );
          },
          child: Stack(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.symmetric(horizontal: 5.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey[200],
                ),
                child: article.imageUrl != null && article.imageUrl!.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          article.imageUrl!,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: 200.0,
                        ),
                      )
                    : Center(
                        child: Text(
                          article.title,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
              ),
              if (article.imageUrl != null && article.imageUrl!.isNotEmpty)
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(8),
                        bottomRight: Radius.circular(8),
                      ),
                      color: Colors.black.withOpacity(0.5),
                    ),
                    padding: const EdgeInsets.symmetric(
                        vertical: 5.0, horizontal: 10.0),
                    child: Text(
                      article.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
