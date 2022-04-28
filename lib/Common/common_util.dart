import 'importer.dart';
import 'package:intl/intl.dart';

/*
 sqlite にBool型がないので、Int型に変換してやり取りする。
 主に、swichで利用する。
 swich オン = true = 1
 swich オフ = false = 0
*/
int boolToInt(bool value) {
  return value ? 1 : 0;
}

bool intToBool(int value) {
  return value == 1 ? true : false;
}

String formatPrice(int value) {
  final formatter = NumberFormat("#,###");
  return formatter.format(value).toString();
}

String dateToString(DateTime value) {
  // 日付を文字列に変換して返す
  var formatter = DateFormat('yyyy/MM/dd(E)', "ja_JP");
  return formatter.format(value);
}

DateTime stringToDate(String value) {
  // 文字列を日付型に変換して返す
  return DateTime.parse(value).toLocal();
}

/*
Widget間のスペース（マージン）をSpaceBoxで調整する
*/
class SpaceBox extends SizedBox {
  const SpaceBox({Key? key, double width = 8, double height = 8})
      : super(key: key, width: width, height: height);

  const SpaceBox.width({Key? key, double value = 8})
      : super(key: key, width: value);
  const SpaceBox.height({Key? key, double value = 8})
      : super(key: key, height: value);
}
