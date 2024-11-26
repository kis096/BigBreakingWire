import 'package:html_unescape/html_unescape.dart';

class Article {
  final String id; // Article ID
  final String title; // Article title
  final String content; // Article content
  final String? imageUrl; // Image URL (optional)
  final DateTime postDate; // Article post date and time
  final String body; // Article body

  Article({
    required this.id,
    required this.title,
    required this.content,
    this.imageUrl,
    required this.postDate,
    required this.body, // Add body to constructor
  });

  // Factory method to create an Article instance from JSON
  factory Article.fromJson(Map<String, dynamic> json) {
    HtmlUnescape unescape =
        HtmlUnescape(); // Create an instance of HtmlUnescape

    return Article(
      id: json['id'].toString(), // Ensure the article ID is a string
      title: unescape
          .convert(json['title']['rendered'] ?? 'No Title'), // Decode title
      content: _parseContent(
          json['content']['rendered']), // Clean and decode content
      imageUrl: _parseImageUrl(json), // Extract image URL
      postDate: DateTime.parse(json['date']),
      body: unescape.convert(
          json['content']['rendered'] ?? 'No Content'), // Parse body directly
    );
  }

  // Method to clean the article content by removing HTML tags and decoding HTML entities
  static String _parseContent(String? content) {
    if (content == null || content.isEmpty) {
      return 'No Content'; // Fallback for empty content
    }
    // Remove HTML tags and decode entities
    return HtmlUnescape().convert(content.replaceAll(RegExp(r'<[^>]*>'), ''));
  }

  // Method to extract the image URL from the JSON response
  static String? _parseImageUrl(Map<String, dynamic> json) {
    try {
      // Check if the featured media is available in the embedded JSON
      if (json['_embedded'] != null &&
          json['_embedded']['wp:featuredmedia'] != null &&
          json['_embedded']['wp:featuredmedia'].isNotEmpty) {
        return json['_embedded']['wp:featuredmedia'][0]['source_url']
            as String?;
      } else if (json['better_featured_image'] != null &&
          json['better_featured_image']['source_url'] != null) {
        // Fallback for better featured image
        return json['better_featured_image']['source_url'] as String?;
      }
    } catch (e) {
      // Handle potential errors and return null
      print('Error parsing image URL: $e');
    }
    return null; // Return null if no image is found
  }

  // Method to convert the Article instance to JSON (for potential use)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'imageUrl': imageUrl,
      'postDate':
          postDate.toIso8601String(), // Convert DateTime to string for JSON
      'body': body, // Add body to JSON conversion
    };
  }
}
