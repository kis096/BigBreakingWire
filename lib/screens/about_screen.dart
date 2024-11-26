import 'package:flutter/material.dart';
import '../models/article_model.dart';
import '../services/api_service.dart';
// Import the design system

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  _AboutScreenState createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  late Future<Article> _article;

  @override
  void initState() {
    super.initState();
    _article = ApiService().fetchPage('21'); // ID for "About" page
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context)
            .appBarTheme
            .backgroundColor, // Use the themed AppBar color
        title: Text(
          'About',
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(color: Colors.white), // Themed title
        ),
        iconTheme: Theme.of(context).iconTheme, // Use the theme for icon colors
      ),
      body: FutureBuilder<Article>(
        future: _article,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      snapshot.data!.title,
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall, // Use themed text for the title
                    ),
                    const SizedBox(height: 16),
                    Text(
                      snapshot.data!.content,
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge, // Themed body text
                    ),
                  ],
                ),
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
