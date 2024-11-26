import 'package:flutter/material.dart';
import 'package:bigbreakingwire/services/api_service.dart';
import 'package:bigbreakingwire/models/article_model.dart';

class NotificationDesignScreen extends StatefulWidget {
  const NotificationDesignScreen({Key? key}) : super(key: key);

  @override
  _NotificationDesignScreenState createState() =>
      _NotificationDesignScreenState();
}

class _NotificationDesignScreenState extends State<NotificationDesignScreen> {
  final ApiService _apiService = ApiService();
  Article? _latestArticle;

  @override
  void initState() {
    super.initState();
    _fetchLatestArticle();
  }

  // Fetch latest article from BigBreakingNow category
  Future<void> _fetchLatestArticle() async {
    Article? latestArticle =
        await _apiService.fetchLatestPostFromBigBreakingNow();
    setState(() {
      _latestArticle = latestArticle;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification Design Preview'),
      ),
      body: Center(
        child: _latestArticle == null
            ? const CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Notification Box (Without Image)
                  Container(
                    padding: const EdgeInsets.all(15),
                    margin: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey[200],
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.notifications,
                            size: 50, color: Colors.blue),
                        const SizedBox(width: 15),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _latestArticle?.title ?? 'Loading...',
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                _latestArticle?.content.substring(0, 50) ??
                                    'Fetching article content...',
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        const Text(
                          'Now',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),

                  // Notification Box with Image
                  Container(
                    padding: const EdgeInsets.all(15),
                    margin: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 1,
                            blurRadius: 7),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.notifications,
                                size: 50, color: Colors.blue),
                            const SizedBox(width: 15),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _latestArticle?.title ?? 'Loading...',
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    _latestArticle?.content.substring(0, 50) ??
                                        'Fetching article content...',
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            const Text(
                              'Now',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        // Add Image to Notification
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            _latestArticle?.imageUrl ??
                                'https://via.placeholder.com/150',
                            height: 100,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
