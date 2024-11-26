import 'package:flutter/material.dart';
import '../models/article_model.dart';
import '../services/api_service.dart';
import '../utils/design_tokens.dart'; // Import design tokens
import '../widgets/banner_ad_widget.dart'; // Import Banner Ad Widget

class DisclaimerScreen extends StatefulWidget {
  const DisclaimerScreen({super.key});

  @override
  _DisclaimerScreenState createState() => _DisclaimerScreenState();
}

class _DisclaimerScreenState extends State<DisclaimerScreen> {
  late Future<Article> _article;

  @override
  void initState() {
    super.initState();
    _article = ApiService().fetchPage('10'); // ID for "Disclaimer" page
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryRedColor, // Consistent AppBar color
        title: const Text(
          'Disclaimer',
          style: TextStyle(color: Colors.white), // White title text
        ),
        iconTheme: const IconThemeData(color: Colors.white), // White icons
      ),
      body: FutureBuilder<Article>(
        future: _article,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(smallPadding), // Design tokens
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title with consistent styling
                  Text(
                    snapshot.data!.title,
                    style: isDarkMode
                        ? h5StyleDark // Dark mode title style
                        : h5StyleLight, // Light mode title style
                  ),
                  const SizedBox(height: mediumPadding), // Design tokens

                  // Content with consistent text style
                  Text(
                    snapshot.data!.content,
                    style: TextStyle(
                      fontSize: 16,
                      color: isDarkMode
                          ? Colors.white // White content text in dark mode
                          : Colors.black, // Black content text in light mode
                    ),
                    textAlign: TextAlign.justify,
                  ),
                  const SizedBox(height: largePadding), // Design tokens

                  // Add BannerAdWidget at the bottom
                  const Center(
                    child: BannerAdWidget(),
                  ),
                ],
              ),
            );
          } else {
            return const Center(child: Text('No data available'));
          }
        },
      ),
    );
  }
}
