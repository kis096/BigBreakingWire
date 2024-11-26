import 'dart:async';
import 'dart:ui';

import 'package:bigbreakingwire/services/notification_service.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter/material.dart';

class BackgroundService {
  static Future<void> initializeService() async {
    final service = FlutterBackgroundService();

    await service.configure(
      androidConfiguration: AndroidConfiguration(
        onStart: onStart,
        autoStart: true,
        isForegroundMode: true, // Run in the background without foreground mode
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
  static void onStart(ServiceInstance service) async {
    DartPluginRegistrant.ensureInitialized();

    // Listen for events to stop the service
    service.on('stopService').listen((event) {
      service.stopSelf();
    });

    // Background task: Check for new articles every 15 minutes
    Timer.periodic(Duration(minutes: 15), (timer) async {
      NotificationService notificationService = NotificationService();
      await notificationService.checkForNewArticlesAndSendNotification();
    });
  }

  @pragma('vm:entry-point')
  static Future<bool> onIosBackground(ServiceInstance service) async {
    WidgetsFlutterBinding.ensureInitialized();
    DartPluginRegistrant.ensureInitialized();

    return true;
  }
}
