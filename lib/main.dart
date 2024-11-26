import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:app_links/app_links.dart';
import 'package:bigbreakingwire/services/notification_service.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'services/ads_service.dart';
import 'routes.dart';
import 'utils/themes.dart';
import 'screens/splash_screen.dart';
import 'services/api_service.dart';
import 'services/link_service.dart';
import 'widgets/navbar.dart';

Future<void> initializeService() async {
  final service = FlutterBackgroundService();

  await service.configure(
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      autoStart: true,
      isForegroundMode: false, // Set to false to avoid a permanent icon
    ),
    iosConfiguration: IosConfiguration(
      autoStart: true,
      onForeground: onStart,
      onBackground: onIosBackground,
    ),
  );

  service.startService();
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();

  if (service is AndroidServiceInstance) {
    service.on('stopService').listen((event) {
      service.stopSelf();
    });
  }

  // Background task: Check for new articles every 15 minutes
  Timer.periodic(Duration(minutes: 15), (timer) async {
    NotificationService notificationService = NotificationService();
    await notificationService.checkForNewArticlesAndSendNotification();
  });
}

@pragma('vm:entry-point')
Future<bool> onIosBackground(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();

  return true;
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize and configure the notification service
  NotificationService notificationService = NotificationService();
  await notificationService.initialize();

  // Start the background service
  await initializeService();

  runApp(const BigBreakingWireApp());
}

class BigBreakingWireApp extends StatefulWidget {
  const BigBreakingWireApp({super.key});

  @override
  _BigBreakingWireAppState createState() => _BigBreakingWireAppState();
}

class _BigBreakingWireAppState extends State<BigBreakingWireApp> {
  static const platform =
      MethodChannel('com.bigbreakingwire.app/deepLinkChannel');
  final AppLinks _appLinks = AppLinks();
  final ApiService _apiService = ApiService();
  final AdsService _adsService = AdsService();
  final NotificationService _notificationService = NotificationService();

  ThemeMode _themeMode = ThemeMode.system;
  int _currentIndex = 0;
  bool _isSplashScreen = true;
  bool _hasNavigated = false;

  late Future<void> Function(bool) _toggleThemeMode;

  @override
  void initState() {
    super.initState();
    _initializeAds();
    _setupDeepLinkListener();
    _setupMethodChannel();

    // Fetch articles and send notification at startup
    _notificationService.fetchArticlesAndSendNotification();
    _toggleThemeMode = (bool isDarkMode) async {
      setState(() {
        _themeMode = isDarkMode ? ThemeMode.dark : ThemeMode.light;
      });
    };
  }

  void _initializeAds() {
    _adsService.loadInterstitialAd();
  }

  void _setupMethodChannel() {
    platform.setMethodCallHandler((call) async {
      if (call.method == 'handleDeepLink') {
        String path = call.arguments;
        _handleDeepLink(path);
      }
    });
  }

  void _setupDeepLinkListener() {
    _appLinks.uriLinkStream.listen(
      (Uri? uri) {
        if (uri != null) {
          _handleDeepLink(uri.toString());
        }
      },
      onError: (Object err) {
        print("Deep link error: $err");
      },
      cancelOnError: true,
    );
  }

  void _handleDeepLink(String path) {
    print("Deep link received: $path");

    if (path.startsWith('https://app.bigbreakingwire.in/articles/')) {
      String id = LinkService.parseArticleId(path);
      print("Extracted article ID: $id");

      _apiService.fetchArticleById(id).then((article) {
        if (article != null) {
          _navigateToArticle(article.id);
        } else {
          print("Article not found.");
        }
      }).catchError((error) {
        print("Error fetching article: $error");
      });
    } else if (path.startsWith('https://app.bigbreakingwire.in/block-deals/')) {
      String id = LinkService.parseBlockDealId(path);
      print("Extracted Block Deal ID: $id");

      // Assuming Block Deal uses a similar fetch function
      _apiService.fetchArticleById(id).then((blockDeal) {
        if (blockDeal != null) {
          _navigateToBlockDeal(blockDeal.id);
        } else {
          print("Block Deal not found.");
        }
      }).catchError((error) {
        print("Error fetching Block Deal: $error");
      });
    } else {
      setState(() {
        _isSplashScreen = true; // Reset splash screen if the link is invalid
      });
    }
  }

  void _navigateToArticle(String articleId) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _isSplashScreen = true;
        _hasNavigated = true;
      });
      Navigator.pushNamed(
        context,
        '/article',
        arguments: articleId,
      );
    });
  }

  void _navigateToBlockDeal(String blockDealId) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _isSplashScreen = true;
        _hasNavigated = true;
      });
      Navigator.pushNamed(
        context,
        '/block-deal',
        arguments: blockDealId,
      );
    });
  }

  @override
  void dispose() {
    _adsService.disposeInterstitialAd();
    super.dispose();
  }

  void _onNavItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });

    if (index == 0 || index == 1 || index == 2) {
      _adsService.showInterstitialAd();
    }

    switch (index) {
      case 0:
        Navigator.pushNamed(context, '/home');
        break;
      case 1:
        Navigator.pushNamed(context, '/block-deals');
        break;
      case 2:
        Navigator.pushNamed(context, '/short-news');
        break;
      default:
        print('Unhandled navigation for index: $index');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BigBreakingWire',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: _themeMode,
      home: _isSplashScreen
          ? SplashScreen(onThemeChanged: _toggleThemeMode)
          : _hasNavigated
              ? Scaffold(
                  body: CustomBottomNavBar(
                    currentIndex: _currentIndex,
                    onNavItemTapped: _onNavItemTapped,
                  ),
                )
              : Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
      routes: appRoutes(
        context,
        _toggleThemeMode,
        _currentIndex,
        _onNavItemTapped,
      ),
    );
  }
}
