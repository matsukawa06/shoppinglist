import 'Common/importer.dart';

import 'Common/japanese_cupertino_localizations.dart';
import 'Views/main_page/mainlist_page.dart';

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
        ChangeNotifierProvider(create: (_) => ProviderTodo()),
        ChangeNotifierProvider(create: (_) => ProviderSharedPreferences()),
        ChangeNotifierProvider(create: (_) => ProviderForm()),
        ChangeNotifierProvider(create: (_) => ProviderPackage()),
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
      home: MainListPage(),
      title: 'ShoppingList',
      theme: ThemeData(
        primarySwatch: Colors.blue,
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
