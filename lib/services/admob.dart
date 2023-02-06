import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'dart:io';

class AdMobService {
  String getBannerAdUnitId() {
    String bannerId = "";
    // iOSとAndroidで広告ユニットIDを分岐させる
    if (Platform.isAndroid) {
      // Androidの広告ユニットID
      // return 'ca-app-pub-1667936047040887/1282958246';
      bannerId = "";
    } else if (Platform.isIOS) {
      // iOSの広告ユニットID（テスト）
      // bannerId = 'ca-app-pub-3940256099942544/2934735716';
      // iOSの広告ユニットID（本番）
      bannerId = 'ca-app-pub-9231213341698825/5726594816';
    }
    return bannerId;
  }

  // 表示するバナー広告の高さを計算
  double getHeight(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final percent = (height * 0.06).toDouble();

    return percent;
  }

  ///
  /// BannerAdの設定
  ///
  BannerAd setBannerAd() {
    return BannerAd(
      adUnitId: getBannerAdUnitId(),
      size: AdSize.banner,
      listener: const BannerAdListener(),
      request: const AdRequest(),
    );
  }

  ///
  /// addContainerの設定
  ///
  Widget setAdContainer(BuildContext context, AdWidget adWidget) {
    return Container(
      alignment: Alignment.bottomCenter,
      child: adWidget,
      // width: myBanner.size.width.toDouble(),
      // height: myBanner.size.height.toDouble(),
      width: MediaQuery.of(context).size.width.toDouble(),
      height: AdMobService().getHeight(context).toDouble(),
    );
  }
}
