// グループリストのデフォルトID
import 'package:flutter/material.dart';

const int defualtGroupId = 0;
// グループリストの最大件数
const int maxGroupListCount = 7;
// グループリストのデフォルトカラー
const MaterialColor defualtGroupColor = Colors.blue;

///
/// SharedPreferencesに登録する時のキー
///
// 選択中のグループリストID
const String keySelectId = "selectedId";
// 購入済みを表示するかフラグ
const String keyKonyuzumiView = "konyuZumiView";
// // カラー情報
const String keyColor = "color";

// モード
const String modeInsert = "0";
const String modeUpdate = "1";
const String modeDelete = "2";
