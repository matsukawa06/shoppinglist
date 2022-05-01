import 'Common/importer.dart';

import 'Common/japanese_cupertino_localizations.dart';
import 'Views/home/main.dart';

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
    MultiProvider(
      providers: [
        // Todo情報
        ChangeNotifierProvider(create: (_) => ProviderTodo()),
        // 端末保存情報
        ChangeNotifierProvider(create: (_) => ProviderSharedPreferences()),
        // validate用
        ChangeNotifierProvider(create: (_) => ProviderForm()),
        // グループリスト用
        ChangeNotifierProvider(create: (_) => ProviderGroup()),
      ],
      child: const HomeScreen(),
    ),
  );
}

class HomeScreen extends StatelessWidget {
  // final _primarySwatch = Colors.blue;
  final _isDark = false;

  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _groupProvider = context.watch<ProviderGroup>();
    return MaterialApp(
      debugShowCheckedModeBanner: false, // ← シミュレータのdebugバーを非表示にする
      home: const Main(),
      title: 'ShoppingList',
      theme: ThemeData(
        primarySwatch: createMaterialColor(_groupProvider.primarySwatch),
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
  }
}
