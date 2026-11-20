import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_colors.dart';



class RoomDetails extends StatelessWidget {
  final String? roomName;
  const RoomDetails({super.key, this.roomName});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final String roomName = args?['roomName'];
    final String building = args?['building'];
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
        'Room Details',
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


      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 22),
            decoration: BoxDecoration(
              color: AppColors.teal,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Large Classroom',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: AppColors.cream)),
                Text('$building $roomName',
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                    color: AppColors.cream))

              ],
            ),
          )
        ]
      ),
    );
  }
}
