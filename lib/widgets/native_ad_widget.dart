import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../utils/design_tokens.dart'; // Import design tokens
import '../utils/constants.dart'; // Import the constants file for the AdUnit ID

class NativeAdWidget extends StatefulWidget {
  const NativeAdWidget({super.key});

  @override
  _NativeAdWidgetState createState() => _NativeAdWidgetState();
}

class _NativeAdWidgetState extends State<NativeAdWidget> {
  NativeAd? _nativeAd;
  bool _isAdLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadNativeAd();
  }

  void _loadNativeAd() {
    _nativeAd = NativeAd(
      adUnitId: Constants.nativeAdUnitId,
      factoryId: 'listTile',
      listener: NativeAdListener(
        onAdLoaded: (Ad ad) {
          setState(() {
            _isAdLoaded = true;
          });
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          ad.dispose();
          setState(() {
            _isAdLoaded = false;
          });
        },
      ),
      request: const AdRequest(),
    )..load();
  }

  @override
  void dispose() {
    _nativeAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    if (!_isAdLoaded) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: smallPadding),
      padding: const EdgeInsets.all(mediumPadding),
      decoration: BoxDecoration(
        color: isDarkMode ? darkCardColor : lightCardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: isDarkMode
                ? Colors.black.withOpacity(0.2)
                : Colors.grey.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: _nativeAd != null
          ? AdWidget(ad: _nativeAd!)
          : const SizedBox.shrink(), // AdWidget renders the native ad
    );
  }
}
