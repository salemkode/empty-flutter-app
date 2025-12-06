import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/liquid_background.dart';
import '../widgets/search_location_item.dart';
import '../app_colors.dart';
import '../providers/settings_provider.dart';
import '../constants/locations.dart';
import '../services/static_weather_service.dart';
import '../utils/weather_utils.dart';

class SearchScreen extends StatefulWidget {
  final VoidCallback onClose;
  final Function(String city, double lat, double lon)? onLocationSelected;

  const SearchScreen({
    super.key,
    required this.onClose,
    this.onLocationSelected,
  });

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final List<Map<String, dynamic>> _locations = Locations.yemenCities;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {}); // Rebuild to update filtered list
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _selectLocation(String city, double lat, double lon) {
    final settings = Provider.of<SettingsProvider>(context, listen: false);
    settings.setLocation(city, lat, lon);
    
    if (widget.onLocationSelected != null) {
      widget.onLocationSelected!(city, lat, lon);
    }
    
    widget.onClose();
  }

  Future<Map<String, dynamic>> _getWeatherForCity(
    BuildContext context,
    String city,
  ) async {
    try {
      final weatherData = StaticWeatherService.getWeatherDataByCity(city);
      final settings = Provider.of<SettingsProvider>(context, listen: false);
      final temp = settings.convertTemp(weatherData.currentTemp).round();
      final tempUnit = settings.tempUnit;
      
      final condition = WeatherUtils.getWeatherCondition(
        weatherData.weatherCode,
      );
      
      return {
        'temp': '$temp$tempUnit',
        'condition': condition,
      };
    } catch (e) {
      return {
        'temp': '--°',
        'condition': 'خطأ في التحميل',
      };
    }
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
          child: InkWell(
            onTap: () {
              _selectLocation(
                cityName,
                location['lat'] as double,
                location['lon'] as double,
              );
            },
            borderRadius: BorderRadius.circular(20),
            child: SearchLocationItem(
              city: cityName,
              isCurrent: isCurrent,
              lat: location['lat'] as double,
              lon: location['lon'] as double,
              weatherFuture: _getWeatherForCity(context, cityName),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LiquidBackground(
        child: SafeArea(
          child: Column(
            children: [
              // Custom App Bar
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 10.0,
                ),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: widget.onClose,
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
              // Search Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: ValueListenableBuilder<TextEditingValue>(
                  valueListenable: _searchController,
                  builder: (context, value, child) {
                    return TextField(
                      controller: _searchController,
                      autofocus: true,
                      decoration: InputDecoration(
                        hintText: 'ابحث عن مدينة...',
                        hintStyle: const TextStyle(
                          color: AppColors.textSecondary,
                        ),
                        prefixIcon: const Icon(
                          Icons.search_rounded,
                          color: Colors.white,
                        ),
                        suffixIcon: value.text.isNotEmpty
                            ? IconButton(
                                onPressed: () {
                                  _searchController.clear();
                                },
                                icon: const Icon(
                                  Icons.close_rounded,
                                  color: Colors.white,
                                ),
                              )
                            : null,
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.1),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      style: const TextStyle(color: Colors.white),
                      textDirection: TextDirection.rtl,
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              // Filtered Locations List
              Expanded(
                child: _buildFilteredLocationsList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

