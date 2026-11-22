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
    final List<Container> eventContainer = [];

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
      if (availability['event'] == null) {
        titleText = 'Reserved';
        subtitleText = 'This room is reserved until ${availability['until']}.';
      } else {
        if (availability['event']['type'] == 'Class') {
          titleText = 'Class in Progress';
          eventContainer.add(Container(
              padding: const EdgeInsets.fromLTRB(5, 2, 5, 2),
              decoration: BoxDecoration(
                color: AppColors.brightGreen,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${availability['event']['name']}',
                            style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: AppColors.cream)),
                        Text('Instructed by ${availability['event']['instructors'].join(', ')}',
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: AppColors.cream)),
                      ]
                  )
              )
          ));
        } else if (availability['event']['type'] == 'Exam') {
          titleText = 'Exam in Progress';
          eventContainer.add(Container(
              padding: const EdgeInsets.fromLTRB(5, 2, 5, 2),
              decoration: BoxDecoration(
                color: AppColors.darkRed,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${availability['event']['name']}',
                            style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: AppColors.cream)),
                        Text('Reserved by ${availability['event']['occupier']}',
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: AppColors.cream)),
                      ]
                  )
              )
          ));
        } else if (availability['event']['type'] == 'Club Event') {
          titleText = 'Club Event in Progress';
          eventContainer.add(Container(
              padding: const EdgeInsets.fromLTRB(5, 2, 5, 2),
              decoration: BoxDecoration(
                color: AppColors.blurple,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('By ${availability['event']['club'] ?? 'Unknown Club'}',
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: AppColors.cream)),
                        Text('${availability['event']['name']}',
                            style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: AppColors.cream)),
                        Text('Reserved by ${availability['event']['occupier']}',
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: AppColors.cream)),
                      ]
                  )
              )
          ));
        } else {
          titleText = 'Reserved';
        }
        subtitleText = 'Next availability: ${availability['until']}';
      }
    }

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(titleText,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: AppColors.cream)),
          ...eventContainer,
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

    final List<Container> extraDetails = [];

    if (room['available']['type'] == 'AVAILABLE') {
      extraDetails.add(Container(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
        decoration: BoxDecoration(
          color: AppColors.darkYellow,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('In this room? Claim it!',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: AppColors.cream)),
            Text('If you are currently in this room, you can claim it to let other students know that it is occupied.',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppColors.cream)),
            CustomButton(text: 'Claim This Room', onPressed: () {}, fontSize: 18),
          ]
        )
      ));
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
                      fontSize: 14,
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
          ),
          SizedBox(height: 10),
          _RoomAvailabilityPreview(roomId: '${room['id']}'),
          SizedBox(height: 10),
          ...extraDetails
        ]
      ),
    );
  }
}

class _RoomAvailabilityPreview extends StatelessWidget {
  final String roomId;

  const _RoomAvailabilityPreview({required this.roomId});

  static const _slots = [
    ('14:00 – 15:00', 'Reserved', false),
    ('15:00 – 16:00', 'Available', true),
    ('16:00 – 17:00', 'Lecture', false),
  ];

  void _openSchedule(BuildContext context) {
    Navigator.pushNamed(context, '/room_schedule', arguments: {'id': roomId});
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.cream,
      borderRadius: BorderRadius.circular(8),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => _openSchedule(context),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Room availability',
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: AppColors.dark)),
              Row(
                children: [
                  const Expanded(
                    child: Text('Mon, 2 Nov 2026',
                        style: TextStyle(fontSize: 15, color: AppColors.grey)),
                  ),
                  TextButton(
                    onPressed: () => _openSchedule(context),
                    child: const Text('View day →',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: AppColors.teal)),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Column(
                children: _slots.map((slot) {
                  final (time, label, available) = slot;
                  return Container(
                    margin: const EdgeInsets.only(bottom: 6),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: available ? AppColors.teal : Colors.transparent,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(time,
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: available
                                      ? AppColors.cream
                                      : AppColors.dark)),
                        ),
                        if (available)
                          const Padding(
                            padding: EdgeInsets.only(right: 8),
                            child: Icon(Icons.check,
                                size: 18, color: AppColors.lime),
                          ),
                        Text(label,
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: available
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                                color: available
                                    ? AppColors.cream
                                    : AppColors.grey)),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}