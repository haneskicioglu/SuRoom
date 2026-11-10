import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'home_screen.dart';

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
      home: const HomeScreen(),
    );
  }
}
