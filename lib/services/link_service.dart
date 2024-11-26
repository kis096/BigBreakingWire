class LinkService {
  // Method to generate article URL
  static String generateArticleUrl(String title, String id) {
    // Replace spaces with hyphens and convert to lowercase
    String formattedTitle = title.toLowerCase().replaceAll(' ', '-');
    String encodedTitle = Uri.encodeComponent(formattedTitle);
    return 'https://app.bigbreakingwire.in/articles/$encodedTitle-$id';
  }

  // Method to parse the article ID from the URL
  static String parseArticleId(String url) {
    // Extract the article ID from the URL using a regular expression
    RegExp regex = RegExp(r'/articles/([a-z0-9\-]+)-(\d+)$');
    final match = regex.firstMatch(url);

    if (match != null && match.groupCount == 2) {
      return match.group(2)!; // Return the article ID
    }
    throw Exception('Invalid URL format: $url');
  }

  // Method to generate block deal URL
  static String generateBlockDealUrl(String title, String id) {
    // Replace spaces with hyphens and convert to lowercase
    String formattedTitle = title.toLowerCase().replaceAll(' ', '-');
    String encodedTitle = Uri.encodeComponent(formattedTitle);
    return 'https://app.bigbreakingwire.in/block-deals/$encodedTitle-$id';
  }

  // Method to parse the block deal ID from the URL
  static String parseBlockDealId(String url) {
    // Extract the block deal ID from the URL using a regular expression
    RegExp regex = RegExp(r'/block-deals/([a-z0-9\-]+)-(\d+)$');
    final match = regex.firstMatch(url);

    if (match != null && match.groupCount == 2) {
      return match.group(2)!; // Return the block deal ID
    }
    throw Exception('Invalid URL format: $url');
  }
}
