import 'package:flutter/material.dart';

class WeatherUtils {
  static String getWeatherCondition(int code) {
    final now = DateTime.now();
    final hour = now.hour;
    final isDayTime = hour >= 6 && hour < 20;
    
    if (code == 0) {
      return isDayTime ? 'مشمس' : 'صافٍ';
    }
    if (code >= 1 && code <= 3) return 'غائم جزئياً';
    if (code == 3) return 'غائم';
    if (code >= 45 && code <= 48) return 'ضبابي';
    if (code >= 51 && code <= 67) return 'ماطر';
    if (code >= 71 && code <= 77) return 'مثلج';
    if (code >= 80 && code <= 82) return 'زخات مطر';
    if (code >= 95) return 'عاصفة رعدية';
    if (code == 63) return 'ماطر';
    return 'غير معروف';
  }

  static IconData getWeatherIcon(int code) {
    final now = DateTime.now();
    final hour = now.hour;
    final isDayTime = hour >= 6 && hour < 20;
    
    if (code == 0) {
      return isDayTime ? Icons.wb_sunny_rounded : Icons.nightlight_round;
    }
    if (code == 3) return Icons.wb_cloudy_rounded; // Specific cloudy
    if (code >= 1 && code <= 3) return Icons.wb_cloudy_rounded;
    if (code >= 51) return Icons.water_drop_rounded;
    if (code == 63) return Icons.water_drop_rounded; // Rain
    return isDayTime ? Icons.wb_sunny_rounded : Icons.nightlight_round;
  }

}

