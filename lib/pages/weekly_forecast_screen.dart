import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/liquid_background.dart';
import '../widgets/glass_container.dart';
import '../app_colors.dart';
import '../services/static_weather_service.dart';
import '../providers/settings_provider.dart';
import '../utils/weather_utils.dart';

class WeeklyForecastScreen extends StatefulWidget {
  const WeeklyForecastScreen({super.key});

  @override
  State<WeeklyForecastScreen> createState() => _WeeklyForecastScreenState();
}

class _WeeklyForecastScreenState extends State<WeeklyForecastScreen> {

  String _getDay(String dateStr) {
    final date = DateTime.parse(dateStr);
    final dayName = date.weekday == 1
        ? 'Mon'
        : date.weekday == 2
        ? 'Tue'
        : date.weekday == 3
        ? 'Wed'
        : date.weekday == 4
        ? 'Thu'
        : date.weekday == 5
        ? 'Fri'
        : date.weekday == 6
        ? 'Sat'
        : 'Sun';
    switch (dayName) {
      case 'Mon':
        return 'الاثنين';
      case 'Tue':
        return 'الثلاثاء';
      case 'Wed':
        return 'الأربعاء';
      case 'Thu':
        return 'الخميس';
      case 'Fri':
        return 'الجمعة';
      case 'Sat':
        return 'السبت';
      case 'Sun':
        return 'الأحد';
      default:
        return dayName;
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('توقعات 7 أيام'), // 7 Days Forecast
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: LiquidBackground(
        child: SafeArea(
          child: Consumer<SettingsProvider>(
            builder: (context, settings, child) {
              final weather = StaticWeatherService.getWeatherDataByCity(
                settings.selectedCity,
              );
              final dailyList = weather.dailyForecasts;
              
              return ListView.builder(
                    padding: const EdgeInsets.all(20),
                    itemCount: dailyList.length,
                    itemBuilder: (context, index) {
                      final day = dailyList[index];
                      
                      final status = WeatherUtils.getWeatherCondition(
                        day.weatherCode,
                      );
                      final icon = WeatherUtils.getWeatherIcon(
                        day.weatherCode,
                      );
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 15.0),
                        child: GlassContainer(
                          height: 80,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20.0,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: 60, // Widened for Arabic text
                                  child: Text(
                                    _getDay(day.date),
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.right,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Icon(
                                      icon,
                                      color: Colors.white,
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      status,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            color: AppColors.textSecondary,
                                          ),
                                    ),
                                  ],
                                ),
                                Consumer<SettingsProvider>(
                                  builder: (context, settingsProvider, child) {
                                    final maxTemp = settingsProvider.convertTemp(day.maxTemp).round();
                                    final minTemp = settingsProvider.convertTemp(day.minTemp).round();
                                    final tempUnit = settingsProvider.tempUnit;
                                    return Text(
                                      '$maxTemp$tempUnit / $minTemp$tempUnit',
                                      style: Theme.of(
                                        context,
                                      ).textTheme.titleMedium,
                                    );
                                  },
                                ),
                              ],
                            ),
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
}
