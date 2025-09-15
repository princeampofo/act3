import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TabsDemo(),
    );
  }
}

class TabsDemo extends StatefulWidget {
  @override
  _TabsDemoState createState() => _TabsDemoState();
}

class _TabsDemoState extends State<TabsDemo>
    with SingleTickerProviderStateMixin, RestorationMixin {
  late TabController _tabController;
  final RestorableInt tabIndex = RestorableInt(0);

  @override
  String get restorationId => 'tabs_demo';

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(tabIndex, 'tab_index');

    // Initialize TabController here with restored index
    _tabController = TabController(
      initialIndex: tabIndex.value,
      length: 3,
      vsync: this,
    );

    _tabController.addListener(() {
      setState(() {
        tabIndex.value = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    tabIndex.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tabs = ['Cat', 'Dog', 'Lizard'];
    final pets = [
      Image.asset('assets/pets/cat.png'),
      Image.asset('assets/pets/dog.png'),
      Image.asset('assets/pets/lizard.png'),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Pet Tabs Demo'),
        bottom: _tabController == null
            ? null
            : TabBar(
                controller: _tabController,
                tabs: [for (final tab in tabs) Tab(text: tab)],
              ),
      ),
      body: _tabController == null
          ? Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                for (final pet in pets)
                  Center(
                    child: pet,
                  ),
              ],
            ),
    );
  }
}
