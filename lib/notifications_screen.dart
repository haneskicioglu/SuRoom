import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_colors.dart';
import 'bottom_navigation.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  static const _items = [
    ('Upcoming Lecture!',
    'A lecture is about to start in 15 minutes in this room'),
    ('Upcoming Event!',
    'An event is going to take place in 15 minutes in this room'),
    ('Leaving the room?',
    'Don’t forget to check out so that other students know that the room is available'),
    ('Room Available!',
    'FENS G032 has no recorded activity going on right now'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blue_background,
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: AppColors.blue_background,
        surfaceTintColor: AppColors.blue_background,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: AppColors.blue_background,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),title: const Text(
            'Notifications',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w700,
              color: AppColors.dark,
            ),
          ),
        leading: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back_ios_new,
                  color: AppColors.dark, size: 22),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),

        ),


      body: ListView.separated(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
        itemCount: _items.length,
        separatorBuilder: (_, _) => const SizedBox(height: 16),
        itemBuilder: (_, i) {
          final (title, body) = _items[i];
          return Container(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 22),
            decoration: BoxDecoration(
              color: AppColors.cream,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: AppColors.teal)),
                const SizedBox(height: 14),
                Text(body,
                    style: const TextStyle(
                        fontSize: 18, height: 1.3, color: Colors.black)),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: BottomNav(
        current: -1 ,
        onTap: (_) {},

      ),
    );
  }
}
