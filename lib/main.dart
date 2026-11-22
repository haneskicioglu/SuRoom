import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'home_screen.dart';
import 'notifications_screen.dart';
import 'campus_activities_screen.dart';
import 'room_details.dart';
import 'search_room_page.dart';
import 'my_account_page.dart';
import 'building_page.dart';
import 'map_page.dart';
import 'login.dart';
import 'room_schedule.dart';

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
        '/login': (context) => const LoginScreen(),
        '/': (context) => const HomeScreen(),
        '/notifications': (context) => const NotificationsScreen(),
        '/activities': (context) => const CampusActivitiesScreen(),
        '/room_details': (context) => const RoomDetails(),
        '/search_room_page': (context) => const SearchPage(),
        '/my_account_page' : (context) => const Accountpage(),
        '/map_page' : (context) => const MapPage(),
        '/building_map' : (context) => const BuildingMap(),
        '/room_schedule' : (context) => const RoomSchedule(),
      }
    );
  }
}
