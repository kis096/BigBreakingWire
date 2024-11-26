import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/article_model.dart';

// ApiService
class ApiService {
  static const String baseUrl =
      'https://bigbreakingwire.in/wp-json/wp/v2/posts?_embed';

  // Specific URL for Block Deals (custom URL for the Block Deals endpoint)
  static const String blockDealsUrl =
      'https://bigbreakingwire.in/wp-json/wp/v2/timeline_post';

  static const Map<String, String> categories = {
    'Business': '31',
    'Finance': '29',
    'Geopolitical': '38',
    'BigBreakingNow': '65',
    'Stock In News': '616',
    'Health': '453',
    'Tech': '1',
    'Brokerage Reports': '618',
    'Short News': '5090',
  };

  Map<String, String> getCategories() {
    return categories;
  }

  // Fetch articles by category with pagination support
  Future<List<Article>> fetchArticlesByCategory(String categoryId, int limit,
      {int page = 1, String? apiUrlOverride}) async {
    String apiUrl = apiUrlOverride ??
        '$baseUrl&categories=$categoryId&per_page=$limit&page=$page';

    print('Fetching articles from: $apiUrl'); // Debug statement

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        return parseArticles(response.body);
      } else {
        print(
            'Failed to load articles for category $categoryId. Status Code: ${response.statusCode}');
        return []; // Return empty list if error occurs
      }
    } catch (e) {
      print('Error fetching articles for category $categoryId: $e');
      return []; // Return empty list if error occurs
    }
  }

  // Fetch articles from custom API URL (used for Block Deals or any other endpoint)
  Future<List<Article>> fetchArticlesFromCustomUrl(String customUrl, int limit,
      {int page = 1}) async {
    String apiUrl = '$customUrl&per_page=$limit&page=$page';

    print('Fetching articles from custom URL: $apiUrl'); // Debug statement

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        return parseArticles(response.body);
      } else {
        print(
            'Failed to load articles from $customUrl. Status Code: ${response.statusCode}');
        return []; // Return empty list if error occurs
      }
    } catch (e) {
      print('Error fetching articles from $customUrl: $e');
      return []; // Return empty list if error occurs
    }
  }

  // Fetch all articles across categories (with duplicate removal by article ID)
  Future<List<Article>> fetchAllArticles(int limit, {int page = 1}) async {
    List<Article> allArticles = [];
    Set<String> uniqueArticleIds = {}; // Set to track unique article IDs

    for (String categoryId in categories.values) {
      List<Article> categoryArticles =
          await fetchArticlesByCategory(categoryId, limit, page: page);

      // Add only unique articles (based on article's ID)
      for (var article in categoryArticles) {
        if (uniqueArticleIds.add(article.id.toString())) {
          allArticles.add(article);
        }
      }
    }

    return allArticles;
  }

  // Fetch the latest post from the "BigBreakingNow" category
  Future<Article?> fetchLatestPostFromBigBreakingNow() async {
    String apiUrl =
        '$baseUrl&categories=${getCategories()['BigBreakingNow']}&per_page=1&page=1';

    print(
        'Fetching latest post from BigBreakingNow: $apiUrl'); // Debug statement

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        List<dynamic> body = json.decode(response.body);
        if (body.isNotEmpty) {
          return Article.fromJson(body.first); // Return the latest article
        } else {
          print('No articles found in BigBreakingNow category.');
          return null;
        }
      } else {
        print(
            'Failed to load the latest post. Status Code: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error fetching the latest post from BigBreakingNow: $e');
      return null;
    }
  }

  // New: Fetch Block Deals using the specific custom URL
  Future<List<Article>> fetchArticlesByBlockDeals(
      {int limit = 20, int page = 1}) async {
    return fetchArticlesFromCustomUrl(blockDealsUrl, limit, page: page);
  }

  // Fetch a specific article by ID
  Future<Article?> fetchArticleById(String articleId) async {
    String apiUrl =
        'https://bigbreakingwire.in/wp-json/wp/v2/posts/$articleId?_embed'; // Corrected URL formatting
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final body = json.decode(response.body);
        return Article.fromJson(body);
      } else {
        print(
            'Failed to load article $articleId. Status Code: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error fetching article $articleId: $e');
      return null;
    }
  }

  // Fetch a specific page by page ID
  Future<Article> fetchPage(String pageId) async {
    String apiUrl = 'https://bigbreakingwire.in/wp-json/wp/v2/pages/$pageId';
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final body = json.decode(response.body);
        return Article.fromJson(body);
      } else {
        throw Exception('Failed to load page $pageId');
      }
    } catch (e) {
      throw Exception('Error fetching page $pageId: $e');
    }
  }

  // Parse JSON response into a list of Article objects
  List<Article> parseArticles(String responseBody) {
    List<dynamic> body = json.decode(responseBody);
    return body.map((dynamic item) => Article.fromJson(item)).toList();
  }
}
