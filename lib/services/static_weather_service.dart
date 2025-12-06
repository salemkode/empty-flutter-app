import '../models/weather_model.dart';
import '../constants/locations.dart';

class StaticWeatherService {
  // Get static weather data by city name only
  static WeatherData getWeatherDataByCity(String city) {
    // Get city data from locations.dart
    final cityData = Locations.getLocationByCity(city);
    if (cityData == null) {
      throw Exception('City not found');
    }
    
    // Extract current weather data
    final currentTemp = cityData['currentTemp'] as double;
    final weatherCode = cityData['weatherCode'] as int;
    final windSpeed = cityData['windSpeed'] as double;
    final humidity = cityData['humidity'] as int;
    final pressure = cityData['pressure'] as double;
    
    // Extract daily forecasts (already static)
    final List<DailyForecast> dailyForecasts = [];
    final dailyData = cityData['dailyForecasts'] as List;
    final now = DateTime.now();
    
    for (int i = 0; i < dailyData.length && i < 7; i++) {
      final dayData = dailyData[i] as Map<String, dynamic>;
      final date = now.add(Duration(days: i));
      final dateStr = date.toIso8601String().split('T')[0];
      
      dailyForecasts.add(
        DailyForecast(
          date: dateStr,
          maxTemp: dayData['maxTemp'] as double,
          minTemp: dayData['minTemp'] as double,
          weatherCode: dayData['weatherCode'] as int,
        ),
      );
    }
    
    // Generate hourly forecasts (24 hours) - simple variation
    final List<HourlyForecast> hourlyForecasts = [];
    for (int i = 0; i < 24; i++) {
      final hour = (now.hour + i) % 24;
      final hourStr = '${hour.toString().padLeft(2, '0')}:00';
      
      // Vary temperature throughout the day
      final temp = currentTemp + (hour >= 12 && hour <= 16 ? 3.0 : -2.0);
      
      // Vary weather codes
      final code = hour >= 6 && hour < 20 ? weatherCode : 1;
      
      hourlyForecasts.add(
        HourlyForecast(
          time: hourStr,
          temp: temp,
          weatherCode: code,
        ),
      );
    }
    
    return WeatherData(
      currentTemp: currentTemp,
      weatherCode: weatherCode,
      windSpeed: windSpeed,
      humidity: humidity,
      pressure: pressure,
      dailyForecasts: dailyForecasts,
      hourlyForecasts: hourlyForecasts,
    );
  }
}
