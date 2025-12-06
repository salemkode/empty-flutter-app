import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'liquid_background.dart';
import 'glass_container.dart';
import 'app_theme.dart';

class LocationSearchScreen extends StatelessWidget {
  const LocationSearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Manage Locations'),
        centerTitle: true,
      ),
      body: LiquidBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                // Search Bar
                GlassContainer(
                  height: 60,
                  borderRadius: BorderRadius.circular(30),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.search,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'Search City...',
                              hintStyle: TextStyle(
                                color: AppColors.textSecondary,
                              ),
                              border: InputBorder.none,
                            ),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // Saved Locations
                Expanded(
                  child: ListView(
                    children: [
                      _buildLocationItem(
                        context,
                        'Montreal, Canada',
                        '19°',
                        'Rainy',
                        true,
                      ),
                      const SizedBox(height: 15),
                      _buildLocationItem(
                        context,
                        'Toronto, Canada',
                        '22°',
                        'Cloudy',
                        false,
                      ),
                      const SizedBox(height: 15),
                      _buildLocationItem(
                        context,
                        'Tokyo, Japan',
                        '28°',
                        'Sunny',
                        false,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLocationItem(
      BuildContext context,
      String city,
      String temp,
      String condition,
      bool isCurrent,
      ) {
    return GlassContainer(
      height: 100,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  city,
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  condition,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Text(temp, style: Theme.of(context).textTheme.displaySmall),
                if (isCurrent) ...[
                  const SizedBox(width: 10),
                  const Icon(Icons.location_on, color: AppColors.accentColor),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
