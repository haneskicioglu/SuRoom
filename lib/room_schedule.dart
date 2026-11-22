import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_colors.dart' ;
import 'room_data_mock.dart' ;
import 'room_details.dart' ;

class RoomScheduleScreen extends StatefulWidget {
  const RoomScheduleScreen({super.key});

  @override
  State<RoomScheduleScreen> createState() => _RoomScheduleScreenState();
}

class _RoomScheduleScreenState extends State<RoomScheduleScreen> {
  DateTime _selectedDate = DateTime(2026, 11, 2);

  static const _items = [
    (
      '09:00',
      '11:00',
      'SPS 101 · Lecture',
      'Official · Scheduled class',
      'CLASS',
    ),
    (
      '11:00',
      '12:00',
      'Available',
      '1 hour · Open for reservation',
      'AVAILABLE',
    ),
    (
      '12:00',
      '14:00',
      'Club workshop',
      'Official · Club activity',
      'EVENT',
    ),
    (
      '14:00',
      '15:00',
      'Busy',
      'Student app · Group study · 4 students',
      'BUSY',
    ),
    (
      '15:00',
      '16:00',
      'Available',
      '1 hour · Open for reservation',
      'AVAILABLE',
    ),
    (
      '16:00',
      '17:00',
      'HIST 191 · Lecture',
      'Official · Scheduled class',
      'CLASS',
    ),
  ];

  String get _formattedDate {
    const days = [
      'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun',
    ];

    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];

    return '${days[_selectedDate.weekday - 1]}, '
        '${_selectedDate.day} '
        '${months[_selectedDate.month - 1]} '
        '${_selectedDate.year}';
  }

  void _changeDate(int days) {
    setState(() {
      _selectedDate = DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day + days,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)?.settings.arguments;
    final roomId = arguments is Map ? arguments['id'] : null;

    final room = MockRooms.rooms.firstWhere(
      (room) => room['id'] == roomId,
      orElse: () => {},
    );

    final appBar = AppBar(
      toolbarHeight: 80,
      backgroundColor: AppColors.blue_background,
      surfaceTintColor: AppColors.blue_background,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: AppColors.blue_background,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
      title: const Text(
        'Room Schedule',
        style: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.w700,
          color: AppColors.dark,
        ),
      ),
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios_new,
          color: AppColors.dark,
          size: 22,
        ),
        onPressed: () => Navigator.pop(context),
      ),
    );

    if (roomId == null || room.isEmpty) {
      return Scaffold(
        backgroundColor: AppColors.blue_background,
        appBar: appBar,
        body: Center(
          child: Text(
            roomId == null ? 'Room ID not provided' : 'Room not found',
            style: const TextStyle(
              fontSize: 18,
              color: AppColors.dark,
            ),
          ),
        ),
      );
    }

    final hasSchedule = _selectedDate.year == 2026 &&
        _selectedDate.month == 11 &&
        _selectedDate.day == 2;

    return Scaffold(
      backgroundColor: AppColors.blue_background,
      appBar: appBar,
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
          children: [
            Material(
              color: AppColors.teal,
              borderRadius: BorderRadius.circular(8),
              child: InkWell(
                borderRadius: BorderRadius.circular(8),
                onTap: () {
                  Navigator.pushReplacementNamed(
                    context,
                    '/room-details',
                    arguments: {'id': room['id']},
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${room['id']}',
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w700,
                          color: AppColors.cream,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Room information →',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFFDDF983),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.only(left: 12),
              decoration: BoxDecoration(
                color: AppColors.cream,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      _formattedDate,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.dark,
                      ),
                    ),
                  ),
                  IconButton(
                    tooltip: 'Previous day',
                    onPressed: () => _changeDate(-1),
                    icon: const Icon(
                      Icons.chevron_left,
                      color: AppColors.teal,
                      size: 20,
                    ),
                  ),
                  IconButton(
                    tooltip: 'Next day',
                    onPressed: () => _changeDate(1),
                    icon: const Icon(
                      Icons.chevron_right,
                      color: AppColors.teal,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Daily schedule',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: AppColors.dark,
                  ),
                ),
                Text(
                  '${hasSchedule ? _items.length : 0} time slots',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.teal,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (hasSchedule)
              ..._items.map((item) {
                final (start, end, title, description, type) = item;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _ScheduleRow(
                    start: start,
                    end: end,
                    title: title,
                    description: description,
                    type: type,
                  ),
                );
              })
            else
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 32),
                child: Text(
                  'No schedule data for this date.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.dark,
                  ),
                ),
              ),
            const SizedBox(height: 16),
            const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.people_outline,
                  size: 18,
                  color: AppColors.teal,
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Student reservations are visible to all students.',
                    style: TextStyle(
                      fontSize: 12,
                      height: 1.4,
                      color: AppColors.teal,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ScheduleRow extends StatelessWidget {
  const _ScheduleRow({
    required this.start,
    required this.end,
    required this.title,
    required this.description,
    required this.type,
  });

  final String start;
  final String end;
  final String title;
  final String description;
  final String type;

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = AppColors.cream;
    Color titleColor = AppColors.dark;
    Color descriptionColor = AppColors.dark;

    switch (type) {
      case 'AVAILABLE':
        titleColor = AppColors.teal;
        descriptionColor = AppColors.teal;
        break;
      case 'EVENT':
        backgroundColor = const Color(0xFFDDF983);
        break;
      case 'BUSY':
        backgroundColor = AppColors.teal;
        titleColor = AppColors.cream;
        descriptionColor = AppColors.cream;
        break;
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 60,
          child: Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  start,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.dark,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  end,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.teal,
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: titleColor,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 11,
                    height: 1.3,
                    color: descriptionColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
