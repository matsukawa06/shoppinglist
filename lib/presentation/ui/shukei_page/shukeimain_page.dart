import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shoppinglist/presentation/ui/shukei_page/day_page.dart';
import 'package:shoppinglist/presentation/ui/shukei_page/month_page.dart';
import 'package:shoppinglist/presentation/ui/shukei_page/year_page.dart';

class TabInfo {
  String label;
  Widget widget;
  TabInfo(this.label, this.widget);
}

class ShukeiMainPage extends ConsumerWidget {
  ShukeiMainPage({Key? key}) : super(key: key);

  final List<TabInfo> _tabs = [
    TabInfo('年別', const YearPage()),
    TabInfo('月別', const MonthPage()),
    TabInfo('日別', const DayPage()),
    TabInfo('すべて', const DayPage()),
  ];
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: _tabs.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(''),
          bottom: PreferredSize(
            child: TabBar(
              isScrollable: true,
              tabs: _tabs.map((TabInfo tab) {
                return Tab(text: tab.label);
              }).toList(),
            ),
            preferredSize: const Size.fromHeight(30.0),
          ),
        ),
        body: TabBarView(children: _tabs.map((tab) => tab.widget).toList()),
      ),
    );
  }
}
