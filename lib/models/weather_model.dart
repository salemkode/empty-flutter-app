class WeatherData {
  final double currentTemp;
  final int weatherCode;
  final double windSpeed;
  final int humidity;
  final List<DailyForecast> dailyForecasts;

  WeatherData({
    required this.currentTemp,
    required this.weatherCode,
    required this.windSpeed,
    required this.humidity,
    required this.dailyForecasts,
  });

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    final current = json['current'];
    final daily = json['daily'];

    List<DailyForecast> dailyList = [];
    if (daily != null) {
      for (int i = 0; i < (daily['time'] as List).length; i++) {
        dailyList.add(
          DailyForecast(
            date: daily['time'][i],
            maxTemp: (daily['temperature_2m_max'][i] as num).toDouble(),
            minTemp: (daily['temperature_2m_min'][i] as num).toDouble(),
            weatherCode: daily['weather_code'][i],
          ),
        );
      }
    }

    return WeatherData(
      currentTemp: (current['temperature_2m'] as num).toDouble(),
      weatherCode: current['weather_code'] as int,
      windSpeed: (current['wind_speed_10m'] as num).toDouble(),
      humidity: current['relative_humidity_2m'] as int,
      dailyForecasts: dailyList,
    );
  }
}

class DailyForecast {
  final String date;
  final double maxTemp;
  final double minTemp;
  final int weatherCode;

  DailyForecast({
    required this.date,
    required this.maxTemp,
    required this.minTemp,
    required this.weatherCode,
  });
}
