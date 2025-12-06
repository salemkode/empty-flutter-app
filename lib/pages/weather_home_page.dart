import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/liquid_background.dart';
import '../widgets/glass_container.dart';
import '../app_colors.dart';
import '../services/static_weather_service.dart';
import '../providers/settings_provider.dart';
import '../utils/weather_utils.dart';

class WeatherHomePage extends StatefulWidget {
  const WeatherHomePage({super.key});

  @override
  State<WeatherHomePage> createState() => _WeatherHomePageState();
}

class _WeatherHomePageState extends State<WeatherHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LiquidBackground(
        child: SafeArea(
          child: Consumer<SettingsProvider>(
            builder: (context, settings, child) {
              final weather = StaticWeatherService.getWeatherDataByCity(
                settings.selectedCity,
              );

              final status = WeatherUtils.getWeatherCondition(
                weather.weatherCode,
              );
              final icon = WeatherUtils.getWeatherIcon(weather.weatherCode);

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
