import 'package:flutter/material.dart';
import 'liquid_background.dart';
import 'glass_container.dart';
import 'hourly_forecast_widget.dart';
import 'weekly_forecast_screen.dart';
import 'location_search_screen.dart';
import 'settings_screen.dart';
import 'app_colors.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LiquidBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Location Header
                  const SizedBox(height: 20),
                  Text(
                    'Montreal, Canada',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Tue, Jun 30',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Main Weather Icon (Placeholder)
                  // In real app, use SvgPicture.asset('assets/icons/sun.svg')
                  const Icon(
                    Icons.wb_sunny_rounded,
                    size: 120,
                    color: Colors.amber,
                  ),

                  const SizedBox(height: 20),

                  // Temperature
                  Text(
                    '19°',
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      fontSize: 100,
                      fontWeight: FontWeight.w200,
                    ),
                  ),
                  Text(
                    'Rainy',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
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
                          '12km/h',
                          'Wind',
                        ),
                        _buildWeatherDetail(
                          context,
                          Icons.water_drop,
                          '24%',
                          'Humidity',
                        ),
                        _buildWeatherDetail(
                          context,
                          Icons.visibility,
                          '87%',
                          'Rain',
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Hourly Forecast (Interface 2)
                  const HourlyForecastWidget(),

                  const SizedBox(height: 20),

                  // Navigation to Weekly Forecast
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const WeeklyForecastScreen(),
                        ),
                      );
                    },
                    child: GlassContainer(
                      height: 60,
                      child: Center(
                        child: Text(
                          'Next 7 Days >',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                            color: AppColors.accentColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 100), // Bottom padding for navbar
                ],
              ),
            ),
          ),
        ),
      ),
      // Glass Bottom Navigation Bar (Placeholder)
      extendBody: true,

      bottomNavigationBar: GlassContainer(
        height: 80,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.home, color: Colors.white),
            ),
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LocationSearchScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.search, color: Colors.white54),
            ),
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const WeeklyForecastScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.calendar_today, color: Colors.white54),
            ),
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SettingsScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.settings, color: Colors.white54),
            ),
          ],
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
        ),
      ],
    );
  }
}
