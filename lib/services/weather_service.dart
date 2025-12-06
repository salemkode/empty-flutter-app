import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather_model.dart';

class WeatherService {
  // Using Open-Meteo API (Free, no key required)
  // Defaulting to Montreal coordinates: 45.5017° N, 73.5673° W
  static const String _baseUrl = 'https://api.open-meteo.com/v1/forecast';
  final double lat;
  final double lon;

  WeatherService({this.lat = 45.5017, this.lon = -73.5673});

  Future<WeatherData> fetchWeather() async {
    final url = Uri.parse(
      '$_baseUrl?latitude=$lat&longitude=$lon&current=temperature_2m,relative_humidity_2m,weather_code,wind_speed_10m&daily=weather_code,temperature_2m_max,temperature_2m_min&timezone=auto',
    );

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return WeatherData.fromJson(data);
      } else {
        throw Exception('Failed to load weather data');
      }
    } catch (e) {
      throw Exception('Error fetching weather: $e');
    }
  }
}
