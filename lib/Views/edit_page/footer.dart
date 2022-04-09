///
/// Todo編集ページのFooter部
///
import '../../Common/importer.dart';

class Footer extends StatefulWidget {
  const Footer();

  @override
  _Footer createState() => _Footer();
}

class _Footer extends State {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          // ignore: deprecated_member_use
          title: Text('home'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          title: Text('Home2'),
        ),
      ],
    );
  }
}
