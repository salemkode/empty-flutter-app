import 'package:flutter/material.dart';
import '../widgets/glass_container.dart';
import 'weekly_forecast_screen.dart';
import 'settings_screen.dart';
import 'weather_home_page.dart';
import 'search_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  void _openSearchScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchScreen(
          onClose: () => Navigator.pop(context),
          onLocationSelected: (city, lat, lon) {
            setState(() => _currentIndex = 0);
          },
        ),
      ),
    );
  }

  // We need to build pages dynamically to pass the callback
  List<Widget> get _pages => [
    const WeatherHomePage(),      // Index 0: Home
    const WeeklyForecastScreen(), // Index 1: Weekly Forecast
    const SettingsScreen(),       // Index 2: Settings
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true, // Important for glass effect
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: _buildAnimatedBottomBar(),
    );
  }

  Widget _buildAnimatedBottomBar() {
    return GlassContainer(
      height: 80,
      borderRadius: BorderRadius.circular(30),
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildNavItem(0, Icons.home_rounded),
          _buildNavItem(1, Icons.calendar_today_rounded),
          _buildNavItem(2, Icons.settings_rounded),
          _buildNavItem(-1, Icons.search_rounded, isSearch: true),
        ],
      ),
    );
  }


  Widget _buildNavItem(int index, IconData icon, {bool isSearch = false}) {
    final isSelected = _currentIndex == index;
    return IconButton(
      onPressed: () {
        if (isSearch) {
          _openSearchScreen();
        } else {
          setState(() {
            _currentIndex = index;
          });
        }
      },
      icon: Icon(
        icon,
        color: isSelected ? Colors.white : Colors.white54,
        size: isSelected ? 30 : 24,
      ),
    );
  }
}
