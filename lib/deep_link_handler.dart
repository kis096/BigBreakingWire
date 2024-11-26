
import 'package:flutter/material.dart';
import 'package:bigbreakingwire/services/api_service.dart';
import 'package:bigbreakingwire/services/link_service.dart';
import 'package:bigbreakingwire/models/article_model.dart';

class DeepLinkHandler {
  final BuildContext context;
  final ApiService _apiService = ApiService();

  DeepLinkHandler(this.context);

  /// Handles the incoming deep link path.
  void handleDeepLink(String path) {
    if (path.startsWith('https://app.bigbreakingwire.in/articles/')) {
      String id = LinkService.parseArticleId(path);
      _fetchAndNavigate(id, 'article');
    } else if (path.startsWith('https://app.bigbreakingwire.in/block-deals/')) {
      String id = LinkService.parseBlockDealId(path);
      _fetchAndNavigate(id, 'block-deal');
    } else {
      _showErrorDialog("Invalid deep link path: $path");
    }
  }

  /// Refactored method to fetch data and navigate based on type.
  Future<void> _fetchAndNavigate(String id, String type) async {
    try {
      Article? article = await _apiService.fetchArticleById(id);
      if (article != null) {
        final routeName = type == 'article' ? '/article' : '/block-deal';
        Navigator.pushNamed(context, routeName, arguments: article);
      } else {
        _showErrorDialog("$type not found.");
      }
    } catch (error) {
      _showErrorDialog("Error loading $type. Please try again later.");
    }
  }

  /// Displays an error dialog for invalid paths or data fetch failures.
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Error"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }
}
