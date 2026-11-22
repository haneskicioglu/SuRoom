import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'room_data_mock.dart';
import 'app_colors.dart';


class AvailabilityCard extends Container {
  final Map<String, dynamic> room;
  AvailabilityCard({super.key, required this.room});

  @override
  Widget build(BuildContext context) {
    final Map<String,dynamic> availability = room['available'] ?? {
      'type': 'UNKNOWN',
      'until': null,
    };
    Color color = AppColors.dark;
    String titleText = 'Unknown Availability';
    String subtitleText = 'We don\'t have information about this room\'s availability.';

    if (availability['type'] == 'AVAILABLE') {
      color = AppColors.teal;
      titleText = 'Available until ${availability['until']}';
      subtitleText = 'Please check the room yourself to confirm.';
    } else if (availability['type'] == 'CLAIMED') {
      color = AppColors.darkYellow;
      titleText = 'Claimed by another student';
      subtitleText = 'This room is likely occupied by another student.\nPlease check the room yourself to confirm.';
    } else if (availability['type'] == 'RESERVED') {
      color = AppColors.red;
      titleText = 'Reserved';
      subtitleText = 'This room is reserved until ${availability['until']} for ${availability['event']['name']} by ${availability['event']['instructors'].join(', ')}.';
    }

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(titleText,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: AppColors.cream)),
          SizedBox(height: 5),
          Text(subtitleText,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w400,
              color: AppColors.cream)),
        ]
      )
    );
  }
}

class RoomDetails extends StatelessWidget {
  const RoomDetails({super.key});

  @override
  Widget build(BuildContext context) {
    final AppBar myBar = AppBar(
      toolbarHeight: 80,
      backgroundColor: AppColors.blue_background,
      surfaceTintColor: AppColors.blue_background,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: AppColors.blue_background,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
      title: Text('Room Details',
      style: TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.w700,
        color: AppColors.dark,
      ),
    ),
      leading: Row(
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back_ios_new,
                color: AppColors.dark, size: 22),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args?['id'] == null) {
      return Scaffold(
        appBar: myBar,
        body: Center(
          child: Text('Room ID not provided'),
        ),
      );
    }
    final room = MockRooms.rooms.firstWhere((r) => r['id'] == args?['id'], orElse: () => {});
    if (room.isEmpty) {
      return Scaffold(
        appBar: myBar,
        body: Center(
          child: Text('Room not found'),
        ),
      );
    }

    final List<RoomAttribute> columnOne = [];
    final List<RoomAttribute> columnTwo = [];
    bool firstColumn = false;

    columnOne.add(RoomAttribute(name: "${room['capacity']} Seats", icon: RoomAttributeIcon(svg:"assets/icons/people.svg")));
    for (var attribute in room['attributes']) {
      if (AttributeTags.attributeWidgets.containsKey(attribute)) {
        final attr = AttributeTags.attributeWidgets[attribute]!;
        if (firstColumn) {
          columnOne.add(attr);
          firstColumn = false;
        } else {
          columnTwo.add(attr);
          firstColumn = true;
        }
      }
    }

    return Scaffold(
      backgroundColor: AppColors.blue_background,
      appBar: myBar,
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
                Text('${room['type']}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: AppColors.cream)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('${room['id']}',
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w800,
                        color: AppColors.cream)),
                    CustomButton(
                      text: 'Navigate',
                      onPressed: () {},
                    )
                  ]
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: columnOne
                      )
                    ),
                    Expanded(
                      child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: columnTwo
                      )
                    )
                  ]
                ),
              ]
            ),
          ),
          SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
            decoration: BoxDecoration(
              color: AppColors.cream,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.location_on_outlined, size: 24, color: AppColors.teal),
                SizedBox(width: 5),
                Expanded(
                  child: Text('${room['building']}\n${AllFloors.get(room['floor'])}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: AppColors.dark)),
                )
              ]
            )
          ),
          SizedBox(height: 10),
          AvailabilityCard(
            room: room
          )
        ]
      ),
    );
  }
}
