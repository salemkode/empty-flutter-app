import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/liquid_background.dart';
import '../widgets/glass_container.dart';
import '../app_colors.dart';
import '../providers/settings_provider.dart';
import '../constants/locations.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('الإعدادات'), // Settings
        centerTitle: true,
        automaticallyImplyLeading: false, // Hide back button
      ),
      body: LiquidBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Consumer<SettingsProvider>(
              builder: (context, settings, child) {
                return Column(
                  children: [
                    GlassContainer(
                      child: ListTile(
                        leading: const Icon(
                          Icons.thermostat,
                          color: Colors.white,
                        ),
                        title: const Text(
                          'الوحدات', // Units
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        subtitle: Text(
                          settings.isMetric
                              ? 'متري (°C, km/h)'
                              : 'إمبراطوري (°F, mph)',
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        trailing: Switch(
                          value: settings.isMetric,
                          onChanged: (value) {
                            settings.toggleUnits(value);
                          },
                          activeColor: Colors.white,
                          activeTrackColor: AppColors.accentColor,
                          inactiveThumbColor: Colors.white54,
                          inactiveTrackColor: Colors.white24,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    InkWell(
                      onTap: () => _showLocationPicker(context, settings),
                      child: _buildSettingsItem(
                        context,
                        Icons.location_on,
                        'الموقع', // Location
                        settings.selectedCity,
                      ),
                    ),
                    const SizedBox(height: 20),
                    InkWell(
                      onTap: () => _showAboutDialog(context),
                      child: _buildSettingsItem(
                        context,
                        Icons.info,
                        'حول التطبيق', // About
                        'اضغط للتفاصيل',
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsItem(
    BuildContext context,
    IconData icon,
    String title,
    String value,
  ) {
    return GlassContainer(
      height: 70,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.white),
                const SizedBox(width: 15),
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(width: 10),
                const Icon(
                  Icons.arrow_forward_ios,
                  color: AppColors.textSecondary,
                  size: 16,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showLocationPicker(BuildContext context, SettingsProvider settings) {
    final locations = Locations.yemenCities;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => GlassContainer(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        child: ListView.builder(
          shrinkWrap: true,
          padding: const EdgeInsets.all(20),
          itemCount: locations.length,
          itemBuilder: (context, index) {
            final loc = locations[index];
            final isSelected = loc['city'] == settings.selectedCity;
            return ListTile(
              leading: Icon(
                Icons.location_on,
                color: isSelected ? AppColors.accentColor : Colors.white54,
              ),
              title: Text(
                loc['city'] as String,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.white70,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
                textDirection: TextDirection.rtl,
              ),
              trailing: isSelected
                  ? const Icon(Icons.check, color: AppColors.accentColor)
                  : null,
              onTap: () {
                settings.setLocation(
                  loc['city'] as String,
                  loc['lat'] as double,
                  loc['lon'] as double,
                );
                Navigator.pop(context);
              },
            );
          },
        ),
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2E335A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'حول التطبيق',
          textDirection: TextDirection.rtl,
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'هذا تطبيق الطقس تم إنشاؤه من قبل طالب في أكاديمية سيئون',
          textDirection: TextDirection.rtl,
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'حسناً',
              style: TextStyle(color: AppColors.accentColor),
            ),
          ),
        ],
      ),
    );
  }
}
