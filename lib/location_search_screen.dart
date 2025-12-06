import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'widgets/liquid_background.dart';
import 'widgets/glass_container.dart';

class LocationSearchScreen extends StatelessWidget {
  final VoidCallback onBack;

  const LocationSearchScreen({super.key, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false, // Prevent resize when keyboard opens
      body: LiquidBackground(
        child: SafeArea(
          child: Stack(
            children: [
              // Main Content
              Padding(
                padding: const EdgeInsets.only(
                  bottom: 100.0,
                ), // Space for bottom search bar
                child: Column(
                  children: [
                    // Custom App Bar Area
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20.0,
                        vertical: 10.0,
                      ),
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: onBack,
                            icon: const Icon(
                              Icons.arrow_back_ios,
                              color: Colors.white,
                            ),
                          ),
                          const Expanded(
                            child: Text(
                              'Search City',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(width: 48), // Balance for back button
                        ],
                      ),
                    ),

                    const SizedBox(height: 10),

                    // Saved Locations (Yemen Cities)
                    Expanded(
                      child: ListView(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        children: [
                          _buildLocationItem(
                            context,
                            'Sana\'a',
                            '18°',
                            'Cloudy',
                            false,
                          ),
                          const SizedBox(height: 15),
                          _buildLocationItem(
                            context,
                            'Aden',
                            '32°',
                            'Sunny',
                            false,
                          ),
                          const SizedBox(height: 15),
                          _buildLocationItem(
                            context,
                            'Mukalla',
                            '29°',
                            'Clear',
                            false,
                          ),
                          const SizedBox(height: 15),
                          _buildLocationItem(
                            context,
                            'Seiyun',
                            '34°',
                            'Sunny',
                            true,
                          ),
                          const SizedBox(height: 15),
                          _buildLocationItem(
                            context,
                            'Shibam',
                            '33°',
                            'Sunny',
                            false,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Bottom Search Bar
              Positioned(
                left: 20,
                right: 20,
                bottom: 20,
                child: GlassContainer(
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
                            decoration: const InputDecoration(
                              hintText: 'Search City...',
                              hintStyle: TextStyle(
                                color: AppColors.textSecondary,
                              ),
                              border: InputBorder.none,
                            ),
                            style: const TextStyle(color: Colors.white),
                            onTapOutside: (event) =>
                                FocusManager.instance.primaryFocus?.unfocus(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
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
