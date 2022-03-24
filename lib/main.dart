import 'Common/importer.dart';

import 'Common/japanese_cupertino_localizations.dart';
import 'Views/home/main.dart';

void main() {
  // AdMob 用のプラグイン初期化
  WidgetsFlutterBinding.ensureInitialized();
  // Admob.initialize();
  //向き指定
  SystemChrome.setPreferredOrientations([
    //縦固定
    DeviceOrientation.portraitUp,
  ]);
  // 最初に表示するWidget
  runApp(
    MultiProvider(
      providers: [
        // Todo情報
        ChangeNotifierProvider(create: (_) => ProviderTodo()),
        // 端末保存情報
        ChangeNotifierProvider(create: (_) => ProviderSharedPreferences()),
        // validate用
        ChangeNotifierProvider(create: (_) => ProviderForm()),
        // アプリのバージョン情報取得用
        ChangeNotifierProvider(create: (_) => ProviderPackage()),
        // グループリスト用
        ChangeNotifierProvider(create: (_) => ProviderGroup()),
      ],
      child: HomeScreen(),
    ),
  );
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // ← シミュレータのdebugバーを非表示にする
      home: Main(),
      title: 'ShoppingList',
      theme: ThemeData(
        primarySwatch: context.read<ProviderSharedPreferences>().selectedColor,
      ),
      localizationsDelegates: [
        JapaneseCupertinoLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en'),
        const Locale('ja'),
      ],
    );
  }
}
