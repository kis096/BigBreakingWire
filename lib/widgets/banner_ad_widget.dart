import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../utils/constants.dart';
import '../utils/design_tokens.dart'; // Assuming you have design tokens

class BannerAdWidget extends StatefulWidget {
  const BannerAdWidget({Key? key}) : super(key: key);

  @override
  _BannerAdWidgetState createState() => _BannerAdWidgetState();
}

class _BannerAdWidgetState extends State<BannerAdWidget> {
  BannerAd? _bannerAd;
  bool _isAdLoaded = false;

  @override
  void initState() {
    super.initState();
    _createBannerAd();
  }

  void _createBannerAd() {
    _bannerAd = BannerAd(
      adUnitId: Constants.bannerAdUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          setState(() {
            _isAdLoaded = true;
          });
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          print('Ad failed to load: $error');
          ad.dispose();
        },
      ),
    )..load();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    if (!_isAdLoaded) {
      return const SizedBox
          .shrink(); // Return an empty box if the ad isn't ready yet
    }

    return Container(
      margin: const EdgeInsets.symmetric(
        vertical: smallPadding, // Consistent spacing
        horizontal: smallPadding,
      ),
      decoration: BoxDecoration(
        color: isDarkMode
            ? darkCardColor
            : lightCardColor, // Adapt card color based on mode
        borderRadius:
            BorderRadius.circular(8), // Rounded corners like the article card
      ),
      width: _bannerAd!.size.width.toDouble(),
      height: _bannerAd!.size.height.toDouble(),
      alignment: Alignment.center,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: AdWidget(ad: _bannerAd!),
      ),
    );
  }
}
