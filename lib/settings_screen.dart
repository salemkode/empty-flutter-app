import 'package:flutter/material.dart';
import 'liquid_background.dart';
import 'glass_container.dart';
import 'app_colors.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Settings'),
        centerTitle: true,
      ),
      body: LiquidBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                _buildSettingItem(context, 'Units', 'Metric (°C, km/h)'),
                const SizedBox(height: 15),
                _buildSettingItem(context, 'Language', 'English'),
                const SizedBox(height: 15),
                _buildSettingItem(context, 'Notifications', 'On'),
                const SizedBox(height: 15),
                _buildSettingItem(context, 'Theme', 'Dark Mode'),
                const SizedBox(height: 15),
                _buildSettingItem(context, 'About', 'Weather App v1.0'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSettingItem(BuildContext context, String title, String value) {
    return GlassContainer(
      height: 70,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                Text(
                  value,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(width: 10),
                const Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Colors.white54,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
