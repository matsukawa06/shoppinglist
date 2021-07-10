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
