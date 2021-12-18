import 'dart:io';

import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdState {
  Future<InitializationStatus> initialization;

  AdState({required this.initialization});

  String get bannerId =>
      Platform.isAndroid ? "	ca-app-pub-3940256099942544/2934735716" : "";
  AdManagerBannerAdListener get adListener => _adListener;
  final AdManagerBannerAdListener _adListener = AdManagerBannerAdListener(
    onAdClosed: (ad) => print('Ad loaded: ${ad.adUnitId}'),
    onAdFailedToLoad: (ad, error) => print('Ad loaded: ${ad.adUnitId}, $error'),
    onAdImpression: (ad) => print('Ad loaded: ${ad.adUnitId}'),
    onAdLoaded: (ad) => print('Ad loaded: ${ad.adUnitId}'),
    onAdOpened: (ad) => print('Ad loaded: ${ad.adUnitId}'),
    onAdWillDismissScreen: (ad) => print('Ad loaded: ${ad.adUnitId}'),
    onPaidEvent: (ad, valueMicros, precision, currencyCode) =>
        print('${ad.adUnitId} ${currencyCode}'),
  );
}
