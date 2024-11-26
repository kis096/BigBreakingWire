import 'package:flutter/material.dart';
import '../models/article_model.dart';
import 'article_screen.dart';
import '../utils/design_tokens.dart'; // Import design tokens

class SearchScreen extends StatefulWidget {
  final List<Article> articles;

  const SearchScreen({super.key, required this.articles, required List posts});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<Article> _filteredArticles = [];
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _filteredArticles = widget.articles; // Initially show all articles
  }

  void _filterArticles(String query) {
    setState(() {
      _searchQuery = query;
      _filteredArticles = widget.articles
          .where((article) =>
              article.title.toLowerCase().contains(query.toLowerCase()) ||
              article.content.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void _clearSearch() {
    setState(() {
      _searchQuery = '';
      _filteredArticles = widget.articles;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryRedColor, // Use your custom design color
        leading: IconButton(
          icon: const Icon(Icons.arrow_back,
              color: Colors.white), // Use themed icons
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: TextField(
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Search articles...',
            hintStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.white, // Ensure text style follows theme
                ),
            border: InputBorder.none,
            suffixIcon: _searchQuery.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear, color: Colors.white),
                    onPressed: _clearSearch,
                  )
                : null,
          ),
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.white, // Ensure search text follows theme
              ),
          onChanged: _filterArticles,
        ),
      ),
      body: _filteredArticles.isEmpty
          ? Center(
              child: Text(
                'No articles found',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: isDarkMode
                          ? Colors.white
                          : Colors.black, // Theme-based styling
                    ),
              ),
            )
          : ListView.builder(
              itemCount: _filteredArticles.length,
              itemBuilder: (context, index) {
                final article = _filteredArticles[index];

                return Card(
                  margin: const EdgeInsets.symmetric(
                    vertical:
                        smallPadding, // Design token for consistent spacing
                    horizontal: smallPadding,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(8), // Consistent card shape
                  ),
                  elevation: 2,
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(smallPadding),
                    title: Text(
                      article.title,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: isDarkMode
                                ? Colors.white
                                : Colors.black, // Adjust based on theme
                          ),
                    ),
                    subtitle: Text(
                      article.content,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: isDarkMode
                                ? Colors.grey[400]
                                : Colors.grey[800], // Consistent subtitle color
                          ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ArticleScreen(
                            articles: widget.articles,
                            currentIndex: widget.articles.indexOf(article),
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
