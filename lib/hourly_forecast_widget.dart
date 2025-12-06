import 'package:flutter/material.dart';
import 'glass_container.dart';
import 'app_colors.dart';

class HourlyForecastWidget extends StatelessWidget {
  const HourlyForecastWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
          child: Text(
            'Hourly Forecast',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: 140,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 24, // Mock 24 hours
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: GlassContainer(
                  width: 80,
                  borderRadius: BorderRadius.circular(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${index + 12}:00',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 8),
                      Icon(
                        index % 2 == 0 ? Icons.wb_cloudy : Icons.wb_sunny,
                        color: Colors.white,
                        size: 32,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${20 + (index % 5)}°',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
