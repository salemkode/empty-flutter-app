import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/glass_container.dart';
import '../widgets/liquid_background.dart';
import 'weekly_forecast_screen.dart';
import 'settings_screen.dart';
import 'weather_home_page.dart';
import '../app_colors.dart';
import '../providers/settings_provider.dart';
import '../services/weather_service.dart';
import '../constants/locations.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  int _currentIndex = 0;
  bool _isSearchActive = false;
  late final AnimationController _searchAnimationController;
  final TextEditingController _searchController = TextEditingController();
  
  // List of locations from constants
  final List<Map<String, dynamic>> _locations = Locations.yemenCities;
  
  // Cache for weather data by city (with timestamp)
  final Map<String, Map<String, dynamic>> _weatherCache = {};

  @override
  void initState() {
    super.initState();
    _searchAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    // Listen to search text changes
    _searchController.addListener(() {
      setState(() {}); // Rebuild to update filtered list
    });
  }

  @override
  void dispose() {
    _searchAnimationController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _toggleSearch() {
    setState(() {
      _isSearchActive = !_isSearchActive;
      if (_isSearchActive) {
        _searchAnimationController.forward();
        // Focus search field after animation starts
        Future.delayed(const Duration(milliseconds: 200), () {
          FocusScope.of(context).requestFocus(FocusNode());
        });
      } else {
        _searchAnimationController.reverse();
        _searchController.clear();
        FocusScope.of(context).unfocus();
      }
    });
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
      body: Stack(
        children: [
          IndexedStack(index: _currentIndex, children: _pages),
          // Search overlay that appears when search is active
          AnimatedBuilder(
            animation: _searchAnimationController,
            builder: (context, child) {
              return _buildSearchOverlay();
            },
          ),
        ],
      ),
      bottomNavigationBar: AnimatedBuilder(
        animation: _searchAnimationController,
        builder: (context, child) {
          return _buildAnimatedBottomBar();
        },
      ),
    );
  }

  Widget _buildAnimatedBottomBar() {
    // Animate between navigation bar and search bar
    // Apply curve manually: easeInOutCubic
    final t = _searchAnimationController.value;
    final curvedValue = t < 0.5 
        ? 4 * t * t * t 
        : 1 - math.pow(-2 * t + 2, 3) / 2;
    
    // Only show navigation bar when search is not active
    if (!_isSearchActive && curvedValue < 0.01) {
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
            _buildNavItem(-1, Icons.search_rounded, isSearch: true), // Search on the right
          ],
        ),
      );
    }
    
    // Show search bar when search is active
    return Transform.scale(
      scale: 0.8 + (curvedValue * 0.2), // Scale from 80% to 100%
      alignment: Alignment.bottomCenter,
      child: Opacity(
        opacity: curvedValue,
        child: IgnorePointer(
          ignoring: curvedValue < 0.01,
          child: GlassContainer(
            height: 60,
            borderRadius: BorderRadius.circular(30),
            margin: const EdgeInsets.fromLTRB(20, 0, 20, 30),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                children: [
                  Icon(
                    Icons.search_rounded,
                    color: Colors.white,
                    size: 24,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      autofocus: _isSearchActive,
                      decoration: const InputDecoration(
                        hintText: 'ابحث عن مدينة...',
                        hintStyle: TextStyle(
                          color: AppColors.textSecondary,
                        ),
                        border: InputBorder.none,
                      ),
                      style: const TextStyle(color: Colors.white),
                      onTapOutside: (event) => FocusManager.instance.primaryFocus?.unfocus(),
                    ),
                  ),
                  IconButton(
                    onPressed: _toggleSearch,
                    icon: const Icon(
                      Icons.close_rounded,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchOverlay() {
    // Apply curve manually: easeInOutCubic
    final t = _searchAnimationController.value;
    final curvedValue = t < 0.5 
        ? 4 * t * t * t 
        : 1 - math.pow(-2 * t + 2, 3) / 2;
    return IgnorePointer(
      ignoring: curvedValue == 0,
      child: Opacity(
        opacity: curvedValue,
        child: LiquidBackground(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 100.0),
              child: Column(
                children: [
                  // Custom App Bar Area
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 10.0,
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: _toggleSearch,
                          icon: const Icon(
                            Icons.arrow_back_ios,
                            color: Colors.white,
                          ),
                        ),
                        const Expanded(
                          child: Text(
                            'البحث عن مدينة',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            textDirection: TextDirection.rtl,
                          ),
                        ),
                        const SizedBox(width: 48),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Saved Locations List - Filtered
                  Expanded(
                    child: _buildFilteredLocationsList(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFilteredLocationsList() {
    final searchQuery = _searchController.text.toLowerCase().trim();
    final filteredLocations = searchQuery.isEmpty
        ? _locations
        : _locations.where((location) {
            final city = location['city'].toString().toLowerCase();
            return city.contains(searchQuery);
          }).toList();

    if (filteredLocations.isEmpty) {
      return Center(
        child: Text(
          'لا توجد نتائج',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppColors.textSecondary,
              ),
          textDirection: TextDirection.rtl,
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      itemCount: filteredLocations.length,
      itemBuilder: (context, index) {
        final location = filteredLocations[index];
        final settings = Provider.of<SettingsProvider>(context, listen: false);
        final isCurrent = location['city'] == settings.selectedCity;
        final cityName = location['city'] as String;
        
        return Padding(
          padding: EdgeInsets.only(bottom: index < filteredLocations.length - 1 ? 15 : 0),
          child: _buildLocationItem(
            cityName,
            isCurrent,
            location['lat'] as double,
            location['lon'] as double,
          ),
        );
      },
    );
  }

  Widget _buildLocationItem(
    String city,
    bool isCurrent,
    double lat,
    double lon,
  ) {
    return InkWell(
      onTap: () {
        final settings = Provider.of<SettingsProvider>(context, listen: false);
        settings.setLocation(city, lat, lon);
        _toggleSearch();
        // Refresh weather page
        setState(() {
          _currentIndex = 0;
        });
      },
      borderRadius: BorderRadius.circular(20),
      child: FutureBuilder<Map<String, dynamic>>(
        future: _getWeatherForCity(city, lat, lon),
        builder: (context, snapshot) {
          String temp = '--°';
          String condition = '--';
          
          if (snapshot.connectionState == ConnectionState.waiting) {
            temp = '...';
            condition = 'جاري التحميل...';
          } else if (snapshot.hasData) {
            temp = snapshot.data!['temp'] ?? '--°';
            condition = snapshot.data!['condition'] ?? '--';
          } else if (snapshot.hasError) {
            temp = '--°';
            condition = 'خطأ في التحميل';
          }
          
          return GlassContainer(
            height: 100,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          city,
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                          textDirection: TextDirection.rtl,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          condition,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: AppColors.textSecondary,
                              ),
                          textDirection: TextDirection.rtl,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        temp,
                        style: Theme.of(context).textTheme.displaySmall,
                      ),
                      if (isCurrent) ...[
                        const SizedBox(width: 10),
                        const Icon(Icons.location_on, color: AppColors.accentColor),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<Map<String, dynamic>> _getWeatherForCity(String city, double lat, double lon) async {
    // Check cache first (but refresh if old)
    final cacheKey = '$city-$lat-$lon';
    if (_weatherCache.containsKey(cacheKey)) {
      final cached = _weatherCache[cacheKey]!;
      final cacheTime = cached['timestamp'] as int? ?? 0;
      final now = DateTime.now().millisecondsSinceEpoch;
      // Use cache if less than 5 minutes old
      if (now - cacheTime < 300000) {
        return {
          'temp': cached['temp'],
          'condition': cached['condition'],
        };
      }
    }
    
    try {
      final weatherService = WeatherService(lat: lat, lon: lon);
      final weatherData = await weatherService.fetchWeather();
      
      final settings = Provider.of<SettingsProvider>(context, listen: false);
      final temp = settings.convertTemp(weatherData.currentTemp).round();
      final tempUnit = settings.tempUnit;
      
      String condition = _getWeatherCondition(weatherData.weatherCode, lat, lon);
      
      final result = {
        'temp': '$temp$tempUnit',
        'condition': condition,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      };
      
      _weatherCache[cacheKey] = result;
      return {
        'temp': result['temp'],
        'condition': result['condition'],
      };
    } catch (e) {
      // Return error state
      return {
        'temp': '--°',
        'condition': 'خطأ في التحميل',
      };
    }
  }

  String _getWeatherCondition(int code, double lat, double lon) {
    final now = DateTime.now();
    final isDayTime = _isDayTime(now, lat, lon);
    
    if (code == 0) {
      return isDayTime ? 'مشمس' : 'صافٍ';
    }
    if (code >= 1 && code <= 3) return 'غائم جزئياً';
    if (code == 3) return 'غائم';
    if (code >= 45 && code <= 48) return 'ضبابي';
    if (code >= 51 && code <= 67) return 'ماطر';
    if (code >= 71 && code <= 77) return 'مثلج';
    if (code >= 80 && code <= 82) return 'زخات مطر';
    if (code >= 95) return 'عاصفة رعدية';
    if (code == 63) return 'ماطر';
    return 'غير معروف';
  }

  bool _isDayTime(DateTime time, double lat, double lon) {
    // Simple approximation: check if current hour is between 6 AM and 8 PM
    // For more accuracy, you could calculate sunrise/sunset based on lat/lon
    final hour = time.hour;
    return hour >= 6 && hour < 20;
  }

  Widget _buildNavItem(int index, IconData icon, {bool isSearch = false}) {
    final isSelected = _currentIndex == index && !_isSearchActive;
    return IconButton(
      onPressed: () {
        if (isSearch) {
          _toggleSearch();
        } else {
          setState(() {
            _currentIndex = index;
            // Close search if navigating away
            if (_isSearchActive) {
              _isSearchActive = false;
              _searchAnimationController.reverse();
              _searchController.clear();
              FocusScope.of(context).unfocus();
            }
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
