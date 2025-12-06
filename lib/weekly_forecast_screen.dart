import 'package:flutter/material.dart';
import 'liquid_background.dart';
import 'glass_container.dart';
import 'app_colors.dart';

class WeeklyForecastScreen extends StatelessWidget {
  const WeeklyForecastScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('7 Days Forecast'),
        centerTitle: true,
      ),
      body: LiquidBackground(
        child: SafeArea(
          child: ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: 7,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 15.0),
                child: GlassContainer(
                  height: 80,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _getDay(index),
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        Row(
                          children: [
                            Icon(
                              index % 2 == 0 ? Icons.wb_sunny : Icons.wb_cloudy,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              index % 2 == 0 ? 'Sunny' : 'Cloudy',
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(color: AppColors.textSecondary),
                            ),
                          ],
                        ),
                        Text(
                          '${22 + index}° / ${15 + index}°',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  String _getDay(int index) {
    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[index % 7];
  }
}
