import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'app_colors.dart';


class RoomAttributeIcon extends StatelessWidget {
  // this either returns an svg or an icon, depending on the type of the icon
  final String? svg;
  final IconData? icon;
  const RoomAttributeIcon({super.key, this.svg, this.icon});
  @override
  Widget build(BuildContext context) {
    if (svg != null) {
      return SvgPicture.asset(
        svg!,
        width: 24,
        height: 24,
      );
    } else if (icon != null) {
      return Icon(icon!, size: 24, color: AppColors.lightGreen);
    } else {
      return const SizedBox.shrink();
    }
  }

}

class RoomAttribute extends ListTile {
  final String name;
  final RoomAttributeIcon icon;

  const RoomAttribute({super.key, required this.name, required this.icon});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      minVerticalPadding: 0,
      visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
      minLeadingWidth: 0,
      leading: icon,
      title: Text(name,
          style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: AppColors.cream)),
    );
  }
}

class RoomDetails extends StatelessWidget {
  const RoomDetails({super.key});

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
                    color: AppColors.cream)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: ListView(
                        shrinkWrap: true,
                        children: [
                          RoomAttribute(name: "yes yes", icon: RoomAttributeIcon(svg:"assets/icons/people.svg")),
                        ]
                      )
                    ),
                    Expanded(
                      child: ListView(
                        shrinkWrap: true,
                        children: [
                          RoomAttribute(name: "good class", icon: RoomAttributeIcon(icon:Icons.thumb_up)),
                        ]
                      )
                    )
                  ]
                ),
              ]
            ),
          )
        ]
      ),
    );
  }
}
