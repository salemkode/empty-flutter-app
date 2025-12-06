import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/liquid_background.dart';
import '../widgets/glass_container.dart';
import '../app_colors.dart';
import '../services/weather_service.dart';
import '../models/weather_model.dart';
import '../providers/settings_provider.dart';

class WeatherHomePage extends StatefulWidget {
  const WeatherHomePage({super.key});

  @override
  State<WeatherHomePage> createState() => _WeatherHomePageState();
}

class _WeatherHomePageState extends State<WeatherHomePage> {
  late Future<WeatherData> _weatherFuture;
  late WeatherService _weatherService;
  double _currentLat = 0;
  double _currentLon = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final settings = Provider.of<SettingsProvider>(context, listen: false);
    // Only update if location changed
    if (_currentLat != settings.selectedLat || _currentLon != settings.selectedLon) {
      _currentLat = settings.selectedLat;
      _currentLon = settings.selectedLon;
      _updateWeather();
    }
  }

  void _updateWeather() {
    _weatherService = WeatherService(
      lat: _currentLat,
      lon: _currentLon,
    );
    setState(() {
      _weatherFuture = _weatherService.fetchWeather();
    });
  }

  String _getWeatherStatus(int code) {
    final now = DateTime.now();
    final settings = Provider.of<SettingsProvider>(context, listen: false);
    final isDayTime = _isDayTime(now, settings.selectedLat, settings.selectedLon);
    
    if (code == 0) {
      return isDayTime ? 'مشمس' : 'صافٍ'; // Clear Sky - Day/Night
    }
    if (code >= 1 && code <= 3) return 'غائم جزئياً'; // Partly Cloudy - generic
    if (code == 3) return 'غائم'; // Cloudy
    if (code >= 45 && code <= 48) return 'ضبابي'; // Foggy
    if (code >= 51 && code <= 67) return 'ماطر'; // Rainy
    if (code >= 71 && code <= 77) return 'مثلج'; // Snowy
    if (code >= 80 && code <= 82) return 'زخات مطر'; // Rain Showers
    if (code >= 95) return 'عاصفة رعدية'; // Thunderstorm
    if (code == 63) return 'ماطر'; // Custom code for rain
    return 'غير معروف'; // Unknown
  }

  bool _isDayTime(DateTime time, double lat, double lon) {
    // Simple approximation: check if current hour is between 6 AM and 8 PM
    final hour = time.hour;
    return hour >= 6 && hour < 20;
  }

  IconData _getWeatherIcon(int code) {
    final now = DateTime.now();
    final settings = Provider.of<SettingsProvider>(context, listen: false);
    final isDayTime = _isDayTime(now, settings.selectedLat, settings.selectedLon);
    
    if (code == 0) {
      return isDayTime ? Icons.wb_sunny_rounded : Icons.nightlight_round;
    }
    if (code == 3) return Icons.wb_cloudy_rounded; // Specific cloudy
    if (code >= 1 && code <= 3) return Icons.wb_cloudy_rounded;
    if (code >= 51) return Icons.water_drop_rounded;
    if (code == 63) return Icons.water_drop_rounded; // Rain
    return isDayTime ? Icons.wb_sunny_rounded : Icons.nightlight_round;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LiquidBackground(
        child: SafeArea(
          child: Consumer<SettingsProvider>(
            builder: (context, settings, child) {
              return FutureBuilder<WeatherData>(
                future: _weatherFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'خطأ: ${snapshot.error}',
                        style: const TextStyle(color: Colors.white),
                        textDirection: TextDirection.rtl,
                      ),
                    );
                  } else if (!snapshot.hasData) {
                    return const Center(
                      child: Text(
                        'لا توجد بيانات',
                        style: TextStyle(color: Colors.white),
                        textDirection: TextDirection.rtl,
                      ),
                    );
                  }

                  final weather = snapshot.data!;
                  final status = _getWeatherStatus(weather.weatherCode);
                  final icon = _getWeatherIcon(weather.weatherCode);

                  // Unit conversions
                  final temp = settings
                      .convertTemp(weather.currentTemp)
                      .round();
                  final wind = settings.convertSpeed(weather.windSpeed).round();
                  final tempUnit = settings.tempUnit;
                  final windUnit = settings.speedUnit;

                  return SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Location Header
                          const SizedBox(height: 20),
                          Text(
                            '${settings.selectedCity}، اليمن',
                            style: Theme.of(context).textTheme.headlineMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                            textDirection: TextDirection.rtl,
                          ),
                          Text(
                            DateTime.now().toString().split(
                              ' ',
                            )[0], // Simple date
                            style: Theme.of(context).textTheme.bodyLarge
                                ?.copyWith(color: AppColors.textSecondary),
                          ),

                          const SizedBox(height: 40),

                          // Main Weather Icon
                          Icon(icon, size: 120, color: Colors.amber),

                          const SizedBox(height: 20),

                          // Temperature
                          Text(
                            '$temp$tempUnit',
                            style: Theme.of(context).textTheme.displayLarge
                                ?.copyWith(
                                  fontSize: 100,
                                  fontWeight: FontWeight.w200,
                                ),
                          ),
                          Text(
                            status,
                            style: Theme.of(context).textTheme.headlineSmall
                                ?.copyWith(color: AppColors.textSecondary),
                            textDirection: TextDirection.rtl,
                          ),

                          const SizedBox(height: 40),

                          // Weather Details Glass Card
                          GlassContainer(
                            height: 120,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _buildWeatherDetail(
                                  context,
                                  Icons.air,
                                  '$wind $windUnit',
                                  'الرياح', // Wind
                                ),
                                _buildWeatherDetail(
                                  context,
                                  Icons.water_drop,
                                  '${weather.humidity}%',
                                  'الرطوبة', // Humidity
                                ),
                                _buildWeatherDetail(
                                  context,
                                  Icons.speed, // gauge icon for pressure
                                  '${weather.pressure.round()} hPa',
                                  'الضغط', // Pressure
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 20),


                          const SizedBox(height: 20),

                          const SizedBox(
                            height: 100,
                          ), // Bottom padding for navbar
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildWeatherDetail(
    BuildContext context,
    IconData icon,
    String value,
    String label,
  ) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: Colors.white),
        const SizedBox(height: 8),
        Text(
          value,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
          textDirection: TextDirection.rtl,
        ),
      ],
    );
  }
}
