import 'package:flutter/material.dart';
import '../models/article_model.dart';
import '../utils/design_tokens.dart'; // Import design tokens

class ArticleCardWidget extends StatelessWidget {
  final Article article;
  final VoidCallback onTap;

  const ArticleCardWidget({
    Key? key,
    required this.article,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Determine if dark mode is active
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Card(
        margin: const EdgeInsets.symmetric(
          vertical: smallPadding,
          horizontal: smallPadding,
        ), // Use design tokens for consistent spacing
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(8), // Rounded corners for the card
        ),
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(smallPadding), // Consistent padding
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Display the image if available
              if (article.imageUrl != null && article.imageUrl!.isNotEmpty)
                ClipRRect(
                  borderRadius:
                      BorderRadius.circular(8), // Rounded corners for the image
                  child: Image.network(
                    article
                        .imageUrl!, // Display image directly from the network
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 150.0, // Fixed height for the image
                  ),
                ),
              const SizedBox(height: smallPadding),

              // Display article title
              Text(
                article.title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? darkTextColor : lightTextColor,
                ),
              ),
              const SizedBox(height: smallPadding),

              // Display snippet of article content
              Text(
                article.content,
                maxLines: 2, // Limit content to two lines
                overflow: TextOverflow.ellipsis, // Handle overflow gracefully
                style: TextStyle(
                  color: isDarkMode
                      ? darkSecondaryTextColor
                      : lightSecondaryTextColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
