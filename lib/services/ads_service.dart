import 'package:flutter/material.dart';
import '../widgets/banner_ad_widget.dart';
import '../widgets/interstitial_ad_widget.dart';
import '../widgets/native_ad_widget.dart';

class AdsService {
  final InterstitialAdWidget _interstitialAdWidget = InterstitialAdWidget();

  // Load the interstitial ad
  void loadInterstitialAd() {
    _interstitialAdWidget.loadAd();
  }

  // Show the interstitial ad
  void showInterstitialAd() {
    _interstitialAdWidget.showAd();
  }

  // Dispose the interstitial ad
  void disposeInterstitialAd() {
    _interstitialAdWidget.dispose();
  }

  // For Banner Ads
  Widget getBannerAd() {
    return const BannerAdWidget(); // Assuming this widget manages its own loading and display
  }

  // For Native Ads
  Widget getNativeAd() {
    return const NativeAdWidget(); // Assuming this widget manages its own loading and display
  }
}
