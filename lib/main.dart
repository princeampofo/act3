import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 7,
        child: _WeatherTabsDemo(),
      ),
    );
  }
}

class _WeatherTabsDemo extends StatefulWidget {
  @override
  _WeatherTabsDemoState createState() => _WeatherTabsDemoState();
}

class _WeatherTabsDemoState extends State<_WeatherTabsDemo>
    with SingleTickerProviderStateMixin, RestorationMixin {
  late TabController _tabController;
  final TextEditingController _cityController = TextEditingController();

  final RestorableInt tabIndex = RestorableInt(0);

  @override
  String get restorationId => 'weather_tabs_demo';

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(tabIndex, 'tab_index');
    _tabController.index = tabIndex.value;
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      initialIndex: 0,
      length: 7,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    _cityController.dispose();
    tabIndex.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          '7-Day Weather Forecast',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.blue[600],
        bottom: TabBar(
          controller: _tabController,
          // isScrollable: true,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.blue[100],
          tabs: [
            for (final day in days) Tab(text: day),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          for (int i = 0; i < days.length; i++)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 20),
                  TextField(
                    controller: _cityController,
                    decoration: InputDecoration(
                      labelText: 'Enter city name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      // Fetch weather functionality will be added next
                    },
                    child: Text('Fetch Weather'),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}