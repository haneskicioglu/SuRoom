
import 'package:flutter/material.dart';
import 'app_colors.dart';

class Accountpage extends StatelessWidget {
  final VoidCallback? onBack;

  const Accountpage({super.key, this.onBack});

  @override
  Widget build(BuildContext context) {
    return _AccountpageContent(onBack: onBack);
  }
}

class _AccountpageContent extends StatelessWidget {
  final VoidCallback? onBack;

  const _AccountpageContent({this.onBack});


  Widget settingsCard({
    required String title,
    required String description,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: AppColors.cream,
        borderRadius: BorderRadius.circular(7),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(7),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 15,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.teal,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 11),
                Text(
                  description,
                  style: const TextStyle(
                    color: AppColors.dark,
                    fontSize: 13,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.blue_background,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 22,
            vertical: 20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // HEADER
              Row(
                children: [
                  IconButton(
                    onPressed: onBack,
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      color: AppColors.dark,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Text(
                    'Settings',
                    style: TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                      color: AppColors.dark,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),


              // NOTIFICATIONS
              settingsCard(
                title: 'Notifications',
                description:
                'Notification settings regarding upcoming '
                    'events, upcoming reserved rooms, etc.',
                onTap: () {
                  Navigator.pushNamed(context, '/notifications');
                },
              ),

                // PRIVACY SETTINGS
              settingsCard(
                title: 'Privacy Settings',
                description:
                'Location accuracy setup, event privacy '
                    'settings, etc.',
                onTap: () {
                  // TODO: Open privacy settings page.
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Privacy Settings')),
                  );
                },
              ),

                // CO-HOST PRIVACY
              settingsCard(
                title: 'Co-Host Privacy',
                description:
                'Permissions for other club board members '
                    'to co-host events on your reserved rooms',
                onTap: () {
                  // TODO: Open co-host privacy page.
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Co-Host Privacy')),
                  );
                },
              ),

            ],
          ),
        ),
      ),
    );
  }
}
