import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shoppinglist/common/common_util.dart';
import 'package:shoppinglist/models/group_provider.dart';

import 'Common/japanese_cupertino_localizations.dart';
import 'presentation/ui/home_page/home_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // AdMob 用のプラグイン初期化
  // Admob.initialize();
  MobileAds.instance.initialize();
  //向き指定
  SystemChrome.setPreferredOrientations([
    //縦固定
    DeviceOrientation.portraitUp,
  ]);
  // 最初に表示するWidget
  runApp(
    const ProviderScope(
      child: HomeScreen(),
    ),
  );
}

class HomeScreen extends StatelessWidget {
  final _isDark = false;

  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final _groupProvider = context.watch<GroupProvider>();
    return Consumer(
      builder: (context, ref, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false, // ← シミュレータのdebugバーを非表示にする
          title: 'ShoppingList',
          home: const HomePage(),
          theme: ThemeData(
            // primarySwatch: createMaterialColor(_groupProvider.primarySwatch),
            primarySwatch: createMaterialColor(ref.watch(groupProvider).primarySwatch),
            brightness: _isDark ? Brightness.dark : Brightness.light,
          ),
          localizationsDelegates: const [
            JapaneseCupertinoLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en'),
            Locale('ja'),
          ],
        );
      },
    );
  }
}
