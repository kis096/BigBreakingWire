import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../utils/constants.dart'; // Import the Constants file

class InterstitialAdWidget {
  InterstitialAd? _interstitialAd;
  bool _isAdLoaded = false;

  // Load the interstitial ad
  void loadAd() {
    InterstitialAd.load(
      adUnitId:
          Constants.interstitialAdUnitId, // Use the Ad Unit ID from Constants
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          _interstitialAd = ad;
          _isAdLoaded = true;
          _interstitialAd!.setImmersiveMode(true);
        },
        onAdFailedToLoad: (LoadAdError error) {
          _isAdLoaded = false;
          _interstitialAd = null;
          print('InterstitialAd failed to load: $error');
        },
      ),
    );
  }

  // Show the interstitial ad
  void showAd() {
    if (_isAdLoaded && _interstitialAd != null) {
      _interstitialAd!.show();
      _interstitialAd = null; // Reset ad after showing it
      _isAdLoaded = false;
      loadAd(); // Preload the next interstitial ad
    } else {
      print('Interstitial ad not ready');
    }
  }

  // Dispose the interstitial ad to free resources
  void dispose() {
    _interstitialAd?.dispose();
  }
}
