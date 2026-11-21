import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'home_screen.dart';
import 'notifications_screen.dart';
import 'campus_activities_screen.dart';
import 'room_details.dart';
import 'search_room_page.dart';

void main() {
  runApp(const SuRoomApp());
}

class SuRoomApp extends StatelessWidget {
  const SuRoomApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SuRoom',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: AppColors.green,
        scaffoldBackgroundColor: AppColors.blue_background,
        fontFamily: 'Nexa',
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/notifications': (context) => const NotificationsScreen(),
        '/activities': (context) => const CampusActivitiesScreen(),
        '/room_details': (context) => const RoomDetails(),
        '/search_room_page': (context) => const SearchPage(),
      }
    );
  }
}
