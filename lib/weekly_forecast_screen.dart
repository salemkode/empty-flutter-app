import 'package:flutter/material.dart';
import 'liquid_background.dart';
import 'glass_container.dart';
import 'app_colors.dart';
import 'services/weather_service.dart';
import 'models/weather_model.dart';


class WeeklyForecastScreen extends StatefulWidget {
  const WeeklyForecastScreen({super.key});

  @override
  State<WeeklyForecastScreen> createState() => _WeeklyForecastScreenState();
}

class _WeeklyForecastScreenState extends State<WeeklyForecastScreen> {
  late Future<WeatherData> _weatherFuture;
  final WeatherService _weatherService = WeatherService();

  @override
  void initState() {
    super.initState();
    _weatherFuture = _weatherService.fetchWeather();
  }

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

  String _getStatus(int code) {
    if (code == 0) return 'مشمس';
    if (code >= 1 && code <= 3) return 'غائم جزئياً';
    if (code >= 51) return 'ماطر';
    return 'غائم';
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
          child: FutureBuilder<WeatherData>(
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
                  ),
                );
              }

              final dailyList = snapshot.data!.dailyForecasts;

              return ListView.builder(
                padding: const EdgeInsets.all(20),
                itemCount: dailyList.length,
                itemBuilder: (context, index) {
                  final day = dailyList[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 15.0),
                    child: GlassContainer(
                      height: 80,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: 60, // Widened for Arabic text
                              child: Text(
                                _getDay(day.date),
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(fontWeight: FontWeight.bold),
                                textAlign: TextAlign.right,
                              ),
                            ),
                            Row(
                              children: [
                                Icon(
                                  day.weatherCode < 3
                                      ? Icons.wb_sunny
                                      : Icons.wb_cloudy,
                                  color: Colors.white,
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  _getStatus(day.weatherCode),
                                  style: Theme.of(context).textTheme.bodyMedium
                                      ?.copyWith(
                                        color: AppColors.textSecondary,
                                      ),
                                ),
                              ],
                            ),
                            Text(
                              '${day.maxTemp.round()}° / ${day.minTemp.round()}°',
                              style: Theme.of(context).textTheme.titleMedium,
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
