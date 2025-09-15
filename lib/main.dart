import 'package:flutter/material.dart';
import 'dart:math';

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

  // Add weather state variables
  String? _currentCity;
  int? _currentTemperature;
  String? _currentWeather;
  final Random _random = Random();

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

  // Add weather mapping function
  String _getWeatherFromTemperature(int temperature) {
    if (temperature <= 10) return 'Snowy';
    if (temperature <= 20) return 'Rainy';
    if (temperature <= 30) return 'Cloudy';
    if (temperature <= 40) return 'Sunny';
    return 'Hot';
  }

  // Add fetch weather function
  void _fetchWeather() {
    if (_cityController.text.isNotEmpty) {
      setState(() {
        _currentCity = _cityController.text;
        _currentTemperature = _random.nextInt(51); // 0-50
        _currentWeather = _getWeatherFromTemperature(_currentTemperature!);
      });
    }
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
          isScrollable: true,
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
                    onPressed: _fetchWeather,
                    child: Text('Fetch Weather'),
                  ),
                  // Add weather display section
                  if (_currentCity != null && _currentTemperature != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 30),
                      child: Card(
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            children: [
                              Text(
                                days[i],
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue[800],
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                _currentCity!,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                '$_currentTemperature°C',
                                style: TextStyle(
                                  fontSize: 36,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.orange[700],
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                _currentWeather!,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontStyle: FontStyle.italic,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}