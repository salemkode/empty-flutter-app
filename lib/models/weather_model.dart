class WeatherData {
  final double currentTemp;
  final int weatherCode;
  final double windSpeed;
  final int humidity;
  final double pressure; // Changed from visibility to pressure as real GFS data
  final List<DailyForecast> dailyForecasts;
  final List<HourlyForecast> hourlyForecasts;

  WeatherData({
    required this.currentTemp,
    required this.weatherCode,
    required this.windSpeed,
    required this.humidity,
    required this.pressure,
    required this.dailyForecasts,
    required this.hourlyForecasts,
  });
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

class HourlyForecast {
  final String time; // HH:00
  final double temp;
  final int weatherCode;

  HourlyForecast({
    required this.time,
    required this.temp,
    required this.weatherCode,
  });
}
