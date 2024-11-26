
import 'dart:async';
import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:bigbreakingwire/services/api_service.dart';
import 'package:bigbreakingwire/models/article_model.dart';
import 'package:html/parser.dart' as html_parser;

class NotificationService {
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
  final ApiService _apiService = ApiService();

  Timer? _articlePollingTimer; // Timer for article notifications
  Timer? _scheduledNotificationTimer; // Timer for scheduled notifications

  /// Initializes the notification plugin.
  Future<void> initialize() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
    InitializationSettings(android: initializationSettingsAndroid);

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (response) {
        final payload = response.payload;
        if (payload != null) {
          // Navigate to the respective screen when notification is tapped
          print('Notification clicked with payload: $payload');
        }
      },
    );

    await _createNotificationChannels();
  }

  /// Dynamically creates notification channels for categories and block deals.
  Future<void> _createNotificationChannels() async {
    final categories = _apiService.getCategories().keys;

    for (var category in categories) {
      final channel = AndroidNotificationChannel(
        category, // id
        category, // name
        description: 'Channel for $category notifications',
        importance: Importance.max,
      );
      await _flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);
    }

    // Block Deals channel
    final blockDealsChannel = AndroidNotificationChannel(
      'BlockDeals',
      'Block Deals',
      description: 'Channel for Block Deals notifications',
      importance: Importance.max,
    );
    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(blockDealsChannel);
  }

  /// Downloads and saves an image for notification if applicable.
  Future<String?> _downloadAndSaveImage(String imageUrl, String fileName) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/$fileName';
      final response = await http.get(Uri.parse(imageUrl));

      if (response.statusCode == 200) {
        final file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);
        return filePath;
      } else {
        print('Failed to download image. Status Code: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error downloading image: $e');
      return null;
    }
  }

  /// Sends a notification with optional image support.
  Future<void> sendNotification({
    required String title,
    required String body,
    required String payload,
    String? imageUrl,
    required String channelId,
  }) async {
    try {
      String? bigPicturePath;

      if (imageUrl != null && imageUrl.isNotEmpty) {
        bigPicturePath = await _downloadAndSaveImage(imageUrl, 'big_picture.jpg');
      }

      final styleInformation = BigPictureStyleInformation(
        bigPicturePath != null
            ? FilePathAndroidBitmap(bigPicturePath)
            : const DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
        largeIcon: const DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
        contentTitle: title,
        summaryText: body,
        htmlFormatContentTitle: true,
        htmlFormatSummaryText: true,
      );

      final androidDetails = AndroidNotificationDetails(
        channelId,
        channelId,
        channelDescription: 'Channel for $channelId notifications',
        importance: Importance.max,
        priority: Priority.high,
        styleInformation: styleInformation,
      );

      await _flutterLocalNotificationsPlugin.show(
        0,
        title,
        body,
        NotificationDetails(android: androidDetails),
        payload: payload,
      );
    } catch (e) {
      print('Error sending notification: $e');
    }
  }

  /// Polls the server for new articles and sends notifications if found.
  Future<void> checkForNewArticlesAndSendNotification() async {
    try {
      final categories = _apiService.getCategories().keys;

      for (var category in categories) {
        final response = await http.get(Uri.parse(
            'https://bigbreakingwire.in/wp-json/wp/v2/posts?categories=${_apiService.getCategories()[category]}'));

        if (response.statusCode == 200) {
          final articles = await _apiService.parseArticles(response.body);

          if (articles.isNotEmpty) {
            final latestArticle = articles.first;
            await sendNotification(
              title: latestArticle.title,
              body: latestArticle.body,
              payload: latestArticle.id,
              imageUrl: latestArticle.imageUrl,
              channelId: category,
            );
          }
        } else {
          print('Failed to load articles for category $category');
        }
      }
    } catch (e) {
      print('Error checking for new posts: $e');
    }
  }
}
