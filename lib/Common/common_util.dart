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

///
/// DBに登録した文字列をColorに変換して返却する
///
Color stringToColor(String pStr) {
  if (pStr == '') {
    return Colors.blue;
  } else {
    String valueString = pStr.split('(0x')[1].split(')')[0];
    return Color(int.parse(valueString, radix: 16));
  }
}

///
/// MaterialColorを作成する
///
MaterialColor createMaterialColor(Color color) {
  //渡されたカラーを分解
  final r = color.red;
  final g = color.green;
  final b = color.blue;

  //カラーの濃さのベースをなるリストを作成
  final strengths = <double>[.05];
  final swatch = <int, Color>{};
  for (var i = 1; i < 10; i++) {
    strengths.add(0.1 * i);
  }
  //50~900のカラーパレット(Map)を作成
  for (final strength in strengths) {
    final ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      r + ((ds < 0 ? r : (255 - r)) * ds).round(),
      g + ((ds < 0 ? g : (255 - g)) * ds).round(),
      b + ((ds < 0 ? b : (255 - b)) * ds).round(),
      1,
    );
  }
  return MaterialColor(color.value, swatch);
}
