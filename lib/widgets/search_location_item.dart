import 'package:flutter/material.dart';
import 'glass_container.dart';
import '../app_colors.dart';

class SearchLocationItem extends StatelessWidget {
  final String city;
  final bool isCurrent;
  final double lat;
  final double lon;
  final Future<Map<String, dynamic>> weatherFuture;

  const SearchLocationItem({
    super.key,
    required this.city,
    required this.isCurrent,
    required this.lat,
    required this.lon,
    required this.weatherFuture,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: weatherFuture,
      builder: (context, snapshot) {
        String temp = '--°';
        String condition = '--';
        
        if (snapshot.connectionState == ConnectionState.waiting) {
          temp = '...';
          condition = 'جاري التحميل...';
        } else if (snapshot.hasData) {
          temp = snapshot.data!['temp'] ?? '--°';
          condition = snapshot.data!['condition'] ?? '--';
        } else if (snapshot.hasError) {
          temp = '--°';
          condition = 'خطأ في التحميل';
        }
        
        return GlassContainer(
          height: 100,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        city,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                        textDirection: TextDirection.rtl,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        condition,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                        textDirection: TextDirection.rtl,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      temp,
                      style: Theme.of(context).textTheme.displaySmall,
                    ),
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
      },
    );
  }
}

