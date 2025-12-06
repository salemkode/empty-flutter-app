import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/locations.dart';

class SettingsProvider extends ChangeNotifier {
  bool _isMetric = true;
  bool get isMetric => _isMetric;

  String _selectedCity = Locations.defaultCity;
  double _selectedLat = Locations.defaultLat;
  double _selectedLon = Locations.defaultLon;
  
  String get selectedCity => _selectedCity;
  double get selectedLat => _selectedLat;
  double get selectedLon => _selectedLon;

  SettingsProvider() {
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    _isMetric = prefs.getBool('isMetric') ?? true;
    _selectedCity = prefs.getString('selectedCity') ?? Locations.defaultCity;
    _selectedLat = prefs.getDouble('selectedLat') ?? Locations.defaultLat;
    _selectedLon = prefs.getDouble('selectedLon') ?? Locations.defaultLon;
    notifyListeners();
  }

  Future<void> toggleUnits(bool value) async {
    _isMetric = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isMetric', _isMetric);
    notifyListeners();
  }

  Future<void> setLocation(String city, double lat, double lon) async {
    _selectedCity = city;
    _selectedLat = lat;
    _selectedLon = lon;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedCity', city);
    await prefs.setDouble('selectedLat', lat);
    await prefs.setDouble('selectedLon', lon);
    notifyListeners();
  }

  // Helper methods for conversion
  String get tempUnit => _isMetric ? '°C' : '°F';
  String get speedUnit => _isMetric ? 'km/h' : 'mph';

  double convertTemp(double tempC) {
    if (_isMetric) return tempC;
    return (tempC * 9 / 5) + 32;
  }

  double convertSpeed(double speedKmh) {
    if (_isMetric) return speedKmh;
    return speedKmh * 0.621371;
  }
}
