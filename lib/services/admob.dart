import 'dart:io';
import 'package:flutter/material.dart';

class AdMobService {
  String? getBannerAdUnitId() {
    // iOSとAndroidで広告ユニットIDを分岐させる
    if (Platform.isAndroid) {
      // Androidの広告ユニットID
      // return 'ca-app-pub-1667936047040887/1282958246';
      return null;
    } else if (Platform.isIOS) {
      // iOSの広告ユニットID（テスト）
      // return 'ca-app-pub-3940256099942544/2934735716';
      // iOSの広告ユニットID（本番）
      return 'ca-app-pub-9231213341698825/5726594816';
    }
    return null;
  }

  // 表示するバナー広告の高さを計算
  double getHeight(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final percent = (height * 0.06).toDouble();

    return percent;
  }
}
