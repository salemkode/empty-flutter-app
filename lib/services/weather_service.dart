import 'dart:convert';
import 'package:intl/intl.dart';
import 'dart:math';
import 'package:http/http.dart' as http;
import '../models/weather_model.dart';
import 'package:flutter/foundation.dart';

class WeatherService {
  // Windy Point Forecast API
  static const String _baseUrl = 'https://api.windy.com/api/point-forecast/v2';
  static const String _apiKey = 'KbRwU9lSNAcAofTO7uBNVJgqLDXAqvPF';

  final double lat;
  final double lon;

  // Default to Sana'a, Yemen
  WeatherService({this.lat = 15.3694, this.lon = 44.1910});

  Future<WeatherData> fetchWeather() async {
    final url = Uri.parse(_baseUrl);

    // GFS Parameters including pressure (surface pressure)
    // Note: 'pressure' is in permitted list for GFS.
    final body = {
      "lat": lat,
      "lon": lon,
      "model": "gfs",
      "parameters": [
        "temp",
        "wind",
        "rh",
        "precip",
        "lclouds",
        "mclouds",
        "hclouds",
        "pressure",
      ],
      "levels": ["surface"],
      "key": _apiKey,
    };

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(body),
      );
      print(response.body);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return _parseWindyData(data);
      } else {
        if (kDebugMode) {
          print('Windy API Error: ${response.statusCode} ${response.body}');
        }
        throw Exception(
          'Failed to load weather data: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching weather: $e');
      }
      throw Exception('Error fetching weather: $e');
    }
  }

  WeatherData _parseWindyData(Map<String, dynamic> data) {
    final List<dynamic> ts = data['ts'] ?? [];
    final List<dynamic> temps = data['temp-surface'] ?? [];

    // Wind might be returned as 'wind-surface' OR as components 'wind_u-surface' / 'wind_v-surface'
    List<dynamic> winds = data['wind-surface'] ?? [];
    final List<dynamic> windU = data['wind_u-surface'] ?? [];
    final List<dynamic> windV = data['wind_v-surface'] ?? [];

    // Precip might be 'precip-surface' or 'past3hprecip-surface' for some models
    List<dynamic> precip = data['precip-surface'] ?? [];
    if (precip.isEmpty) {
      precip = data['past3hprecip-surface'] ?? [];
    }

    final List<dynamic> humidity = data['rh-surface'] ?? [];
    final List<dynamic> pressureList = data['pressure-surface'] ?? [];

    final List<dynamic> lclouds = data['lclouds-surface'] ?? [];
    final List<dynamic> mclouds = data['mclouds-surface'] ?? [];
    final List<dynamic> hclouds = data['hclouds-surface'] ?? [];

    if (ts.isEmpty) {
      throw Exception('No weather data available');
    }

    // Find closest index to now
    final nowMs = DateTime.now().millisecondsSinceEpoch;
    int currentIndex = 0;
    int minDiff = (nowMs - (ts[0] as num).toInt()).abs();

    for (int i = 1; i < ts.length; i++) {
      final diff = (nowMs - (ts[i] as num).toInt()).abs();
      if (diff < minDiff) {
        minDiff = diff;
        currentIndex = i;
      }
    }

    // --- Current Data ---
    double rawTemp = 0.0;
    if (temps.isNotEmpty && currentIndex < temps.length) {
      rawTemp = (temps[currentIndex] as num).toDouble();
      if (rawTemp > 200) rawTemp -= 273.15; // Kelvin to Celsius
    }

    double rawWind = 0.0;
    if (winds.isNotEmpty && currentIndex < winds.length) {
      rawWind = (winds[currentIndex] as num).toDouble();
      rawWind *= 3.6; // m/s to km/h
    } else if (windU.isNotEmpty &&
        windV.isNotEmpty &&
        currentIndex < windU.length) {
      // Calculate wind speed from U and V components
      double u = (windU[currentIndex] as num).toDouble();
      double v = (windV[currentIndex] as num).toDouble();
      rawWind = sqrt(u * u + v * v) * 3.6; // m/s to km/h
    }

    int hum = 0;
    if (humidity.isNotEmpty && currentIndex < humidity.length) {
      hum = (humidity[currentIndex] as num).toInt();
    } // Ensure 0-100 range if needed, usually is.

    double currentPressure = 0.0;
    if (pressureList.isNotEmpty && currentIndex < pressureList.length) {
      currentPressure = (pressureList[currentIndex] as num).toDouble();
      // Pressure typically returned in Pa, need hPa (divide by 100)
      if (currentPressure > 2000) currentPressure /= 100.0;
    }

    double currentPrecip = 0.0;
    if (precip.isNotEmpty && currentIndex < precip.length) {
      currentPrecip = (precip[currentIndex] as num).toDouble();
    }

    double cloudCover = _calculateCloudCover(
      lclouds,
      mclouds,
      hclouds,
      currentIndex,
    );
    final int code = _deriveWeatherCode(currentPrecip, cloudCover);

    // --- Daily Forecast ---
    List<DailyForecast> dailyList = [];
    final Map<String, List<double>> dailyTemps = {};
    final Map<String, double> dailyMaxTemps = {};
    final Map<String, double> dailyPrecip = {};
    final Map<String, double> dailyClouds = {};
    final Map<String, int> dailyWeatherCodes = {};

    // Collect all temperature data for each day
    for (int i = 0; i < ts.length; i++) {
      if (i >= temps.length) break;
      final dateMs = (ts[i] as num).toInt();
      final date = DateTime.fromMillisecondsSinceEpoch(dateMs);
      final dateStr = date.toIso8601String().split('T')[0];

      double dTemp = (temps[i] as num).toDouble();
      if (dTemp > 200) dTemp -= 273.15; // Convert Kelvin to Celsius

      // Store temperature for this day
      if (!dailyTemps.containsKey(dateStr)) {
        dailyTemps[dateStr] = [];
      }
      dailyTemps[dateStr]!.add(dTemp);

      // Track max temp (around noon/afternoon)
      if (date.hour >= 12 && date.hour <= 15) {
        if (!dailyMaxTemps.containsKey(dateStr) || 
            dTemp > dailyMaxTemps[dateStr]!) {
          dailyMaxTemps[dateStr] = dTemp;
          
          // Also store precip and cloud data for this representative time
          double dPrecip = 0.0;
          if (i < precip.length) dPrecip = (precip[i] as num).toDouble();
          dailyPrecip[dateStr] = dPrecip;
          
          double dCloud = _calculateCloudCover(lclouds, mclouds, hclouds, i);
          dailyClouds[dateStr] = dCloud;
          dailyWeatherCodes[dateStr] = _deriveWeatherCode(dPrecip, dCloud);
        }
      }
    }

    // Create daily forecasts with real min/max temperatures
    final sortedDates = dailyTemps.keys.toList()..sort();
    for (final dateStr in sortedDates) {
      if (dailyList.length >= 7) break;
      
      final tempsForDay = dailyTemps[dateStr]!;
      final minTemp = tempsForDay.reduce((a, b) => a < b ? a : b);
      final maxTemp = dailyMaxTemps[dateStr] ?? tempsForDay.reduce((a, b) => a > b ? a : b);
      
      dailyList.add(
        DailyForecast(
          date: dateStr,
          maxTemp: maxTemp,
          minTemp: minTemp,
          weatherCode: dailyWeatherCodes[dateStr] ?? 0,
        ),
      );
    }

    // --- Hourly Forecast (Next 24h) ---
    List<HourlyForecast> hourlyList = [];
    // Start from current index, take next 24 points (assuming data is hourly or 3-hourly)
    // Windy GFS point forecast is usually 3-hourly steps.
    for (int i = currentIndex; i < ts.length; i++) {
      if (i >= temps.length) break;

      final dateMs = (ts[i] as num).toInt();
      final date = DateTime.fromMillisecondsSinceEpoch(dateMs);

      double hTemp = (temps[i] as num).toDouble();
      if (hTemp > 200) hTemp -= 273.15;

      double hPrecip = 0.0;
      if (i < precip.length) hPrecip = (precip[i] as num).toDouble();

      double hCloud = _calculateCloudCover(lclouds, mclouds, hclouds, i);

      // Simple hour formatting: "HH:00"
      String hourStr = '${date.hour.toString().padLeft(2, '0')}:00';

      hourlyList.add(
        HourlyForecast(
          time: hourStr,
          temp: hTemp,
          weatherCode: _deriveWeatherCode(hPrecip, hCloud),
        ),
      );

      if (hourlyList.length >= 24) break;
    }

    return WeatherData(
      currentTemp: rawTemp,
      weatherCode: code,
      windSpeed: rawWind,
      humidity: hum,
      pressure: currentPressure,
      dailyForecasts: dailyList,
      hourlyForecasts: hourlyList,
    );
  }

  double _calculateCloudCover(
    List<dynamic> l,
    List<dynamic> m,
    List<dynamic> h,
    int index,
  ) {
    double lc = (index < l.length) ? (l[index] as num).toDouble() : 0.0;
    double mc = (index < m.length) ? (m[index] as num).toDouble() : 0.0;
    double hc = (index < h.length) ? (h[index] as num).toDouble() : 0.0;
    return [lc, mc, hc].reduce(max);
  }

  int _deriveWeatherCode(double precip, double clouds) {
    // precip is likely mm. If > 0.1, it's raining/snowing.
    if (precip > 0.1) return 63; // Rain
    if (clouds > 50)
      return 3; // Cloudy (Cloud cover is usually %, if Windy returns 0-100)
    return 0; // Sunny
  }
}
