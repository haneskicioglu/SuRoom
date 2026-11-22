import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'room_data_mock.dart';

class FindRoomPage extends StatefulWidget {
  final VoidCallback? onBack;

  const FindRoomPage({super.key, this.onBack});

  @override
  State<FindRoomPage> createState() => _FindRoomPageState();
}

class _FindRoomPageState extends State<FindRoomPage> {
  static const _card = AppColors.cream;
  static const _green = AppColors.green;
  static const _seatOptions = [1, 10, 20, 50];
  static const _weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  static const _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
  ];


  DateTime date = DateTime.now();
  TimeOfDay start = const TimeOfDay(hour: 14, minute: 0);
  TimeOfDay end = const TimeOfDay(hour: 15, minute: 0);
  String building = 'Any building';
  int minSeats = 1;
  Set<String> facilities = {};
  bool ascending = true;


  String appliedBuilding = 'Any building';
  int appliedSeats = 1;
  Set<String> appliedFacilities = {};

  List<String> get buildingOptions {
    final list = MockRooms.rooms
        .map((r) => r['building'].toString())
        .toSet()
        .toList()
      ..sort();
    return ['Any building', ...list];
  }

  List<String> get facilityOptions {
    final set = <String>{};
    for (final r in MockRooms.rooms) {
      set.addAll((r['attributes'] as List? ?? []).map((f) => f.toString()));
    }
    return set.toList()..sort();
  }

  List<Map<String, dynamic>> get filteredRooms {
    final result = MockRooms.rooms.where((room) {
      final buildingMatch =
          appliedBuilding == 'Any building' || room['building'] == appliedBuilding;
      final seatsMatch = (room['capacity'] as int) >= appliedSeats;
      final roomFacilities =
      (room['attributes'] as List? ?? []).map((f) => f.toString()).toSet();
      final facilityMatch = roomFacilities.containsAll(appliedFacilities);
      return buildingMatch && seatsMatch && facilityMatch;
    }).toList();

    result.sort((a, b) {
      final c = a['id'].toString().compareTo(b['id'].toString());
      return ascending ? c : -c;
    });
    return result;
  }

  void find() {
    setState(() {
      appliedBuilding = building;
      appliedSeats = minSeats;
      appliedFacilities = {...facilities};
    });
  }

  void reset() {
    setState(() {
      date = DateTime.now();
      start = const TimeOfDay(hour: 14, minute: 0);
      end = const TimeOfDay(hour: 15, minute: 0);
      building = 'Any building';
      minSeats = 1;
      facilities = {};
      ascending = true;
      appliedBuilding = 'Any building';
      appliedSeats = 1;
      appliedFacilities = {};
    });
  }

  // Colors for the date and time pickers
  Widget _pickerTheme(BuildContext context, Widget? child) {
    return Theme(
      data: Theme.of(context).copyWith(
        colorScheme: const ColorScheme.light(
          primary: AppColors.teal,
          onPrimary: AppColors.cream,
          surface: AppColors.cream,
          onSurface: AppColors.dark,
        ),
      ),
      child: child!,
    );
  }

  Future<void> pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: date,
      firstDate: DateTime(now.year, now.month, now.day),
      lastDate: now.add(const Duration(days: 365)),
      builder: _pickerTheme,
    );
    if (picked != null) setState(() => date = picked);
  }

  Future<void> pickTime() async {
    final s = await showTimePicker(
        context: context,
        initialTime: start,
        helpText: 'Start time',
        builder: _pickerTheme);
    if (s == null || !mounted) return;
    final e = await showTimePicker(
        context: context,
        initialTime: end,
        helpText: 'End time',
        builder: _pickerTheme);
    if (e == null) return;
    setState(() {
      start = s;
      end = e;
    });
  }

  void openFacilities() {
    showModalBottomSheet(
      context: context,
      backgroundColor: _card,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheet) => Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Facilities',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: AppColors.dark)),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: facilityOptions
                    .map((f) => FilterChip(
                  avatar: Icon(facilityIcon(f),
                      size: 18, color: AppColors.teal),
                  label: Text(f,
                      style: const TextStyle(color: AppColors.dark)),
                  backgroundColor: AppColors.cream,
                  selectedColor: AppColors.lime,
                  checkmarkColor: AppColors.teal,
                  side: const BorderSide(color: AppColors.teal),
                  selected: facilities.contains(f),
                  onSelected: (on) {
                    setState(() {
                      if (on) {
                        facilities.add(f);
                      } else {
                        facilities.remove(f);
                      }
                    });
                    setSheet(() {});
                  },
                ))
                    .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData facilityIcon(String f) {
    switch (f) {
      case 'POWER':
        return Icons.power_outlined;
      case 'ETHERNET':
        return Icons.lan_outlined;
      case 'SEATS':
        return Icons.event_seat_outlined;
      case 'BLACKBOARD':
        return Icons.edit_outlined;
      case 'CIRCULAR':
        return Icons.table_restaurant_outlined;
      case 'NO_WINDOWS':
        return Icons.desktop_access_disabled_outlined;
      case 'LOCKED':
        return Icons.lock_outline;
      default:
        return Icons.check_circle_outline;
    }
  }

  String fmt(TimeOfDay t) =>
      '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';

  String get dateText =>
      '${_weekdays[date.weekday - 1]}, ${date.day} ${_months[date.month - 1]}';

  @override
  Widget build(BuildContext context) {
    final rooms = filteredRooms;
    return Scaffold(
      backgroundColor: AppColors.blue_background,
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: AppColors.blue_background,
        surfaceTintColor: AppColors.blue_background,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new,
              color: AppColors.dark, size: 22),
          onPressed: () {
            if (widget.onBack != null) {
              widget.onBack!();
            } else {
              Navigator.maybePop(context);
            }
          },
        ),
        title: const Text('Find the Nearest Room',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: AppColors.dark)),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
        children: [
          _filterCard(),
          const SizedBox(height: 12),
          _buttons(),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Text('${rooms.length} rooms available',
                    style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        color: AppColors.dark)),
              ),
              TextButton(
                onPressed: () => setState(() => ascending = !ascending),
                child: Text(ascending ? 'A → Z ↓' : 'Z → A ↑',
                    style: const TextStyle(color: AppColors.teal)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (rooms.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 32),
              child: Center(
                child: Text('No rooms match these filters.',
                    style: TextStyle(color: AppColors.grey)),
              ),
            ),
          ...rooms.map(_roomCard),
          const SizedBox(height: 12),
          const Text('Availability follows published room schedules.',
              style: TextStyle(fontSize: 13, color: AppColors.dark)),
        ],
      ),
    );
  }

  Widget _filterCard() {
    return Container(
      decoration: BoxDecoration(
          color: _card, borderRadius: BorderRadius.circular(8)),
      child: Column(
        children: [
          ListTile(
            leading:
            const Icon(Icons.calendar_today_outlined, color: AppColors.teal),
            title: Text(dateText,
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.dark)),
            trailing: const Icon(Icons.expand_more, color: AppColors.dark),
            onTap: pickDate,
          ),
          const Divider(
              height: 1,
              indent: 16,
              endIndent: 16,
              color: AppColors.blue_background),
          ListTile(
            leading: const Icon(Icons.schedule, color: AppColors.teal),
            title: Text('${fmt(start)} – ${fmt(end)}',
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.dark)),
            onTap: pickTime,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
            child: Row(
              children: [
                PopupMenuButton<String>(
                  initialValue: building,
                  color: AppColors.cream,
                  onSelected: (v) => setState(() => building = v),
                  itemBuilder: (_) => buildingOptions
                      .map((b) => PopupMenuItem(
                      value: b,
                      child: Text(b,
                          style: const TextStyle(color: AppColors.dark))))
                      .toList(),
                  child: _chipText(building),
                ),
                const SizedBox(width: 16),
                PopupMenuButton<int>(
                  initialValue: minSeats,
                  color: AppColors.cream,
                  onSelected: (v) => setState(() => minSeats = v),
                  itemBuilder: (_) => _seatOptions
                      .map((s) => PopupMenuItem(
                      value: s,
                      child: Text('$s+ seats',
                          style: const TextStyle(color: AppColors.dark))))
                      .toList(),
                  child: _chipText('$minSeats+ seats'),
                ),
                const Spacer(),
                IconButton(
                  onPressed: openFacilities,
                  icon: Badge(
                    isLabelVisible: facilities.isNotEmpty,
                    backgroundColor: AppColors.teal,
                    textColor: AppColors.cream,
                    label: Text('${facilities.length}'),
                    child: const Icon(Icons.tune, color: AppColors.teal),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _chipText(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      child: Text(text,
          style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppColors.teal)),
    );
  }

  Widget _buttons() {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 60,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.lime,
                foregroundColor: AppColors.dark,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: const BorderSide(color: AppColors.teal),
                ),
              ),
              onPressed: find,
              child: const Text('Find',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
            ),
          ),
        ),
        const SizedBox(width: 10),
        SizedBox(
          height: 60,
          width: 60,
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              backgroundColor: AppColors.lime,
              padding: EdgeInsets.zero,
              side: const BorderSide(color: AppColors.teal),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: reset,
            child: const Icon(Icons.refresh, color: AppColors.dark),
          ),
        ),
      ],
    );
  }

  Widget _roomCard(Map<String, dynamic> room) {
    final facs =
    (room['attributes'] as List? ?? []).map((f) => f.toString()).toList();
    final freeUntil = room['freeUntil'];
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: _card,
        borderRadius: BorderRadius.circular(8),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () {},
          child: Container(
            decoration: const BoxDecoration(
              border: Border(left: BorderSide(color: _green, width: 4)),
            ),
            padding: const EdgeInsets.fromLTRB(20, 18, 12, 18),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(room['id'].toString(),
                          style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w600,
                              color: AppColors.dark)),
                      const SizedBox(height: 6),
                      Text(
                          freeUntil != null
                              ? 'Free until $freeUntil'
                              : '${room['building']} · ${room['capacity']} seats',
                          style: const TextStyle(
                              fontSize: 15, color: AppColors.teal)),
                    ],
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: facs
                      .take(4)
                      .map((f) => Padding(
                    padding: const EdgeInsets.only(left: 4),
                    child: Icon(facilityIcon(f),
                        size: 22, color: AppColors.teal),
                  ))
                      .toList(),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.chevron_right,
                    size: 32, color: AppColors.dark),
              ],
            ),
          ),
        ),
      ),
    );
  }
}