
import 'package:flutter/material.dart';
import 'app_colors.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _SearchPageContent();
  }
}

class _SearchPageContent extends StatefulWidget {
  const _SearchPageContent();

  @override
  State<_SearchPageContent> createState() => _SearchPageContentState();
}

class _SearchPageContentState extends State<_SearchPageContent> {
  final TextEditingController searchController = TextEditingController();

  String building = 'Any building';
  String roomType = 'Any room type';
  String capacity = 'Any capacity';
  String facility = 'Any facilities';

  String searchQuery = '';
  bool ascending = true;
//MOCK DATA
  final List<Map<String, dynamic>> rooms = [
    {
      'id': 'FENS G035',
      'building': 'FENS',
      'type': 'Classroom',
      'capacity': 30,
      'facilities': ['Projector', 'Whiteboard', 'Accessible'],
      'available': '16:00',
    },
    {
      'id': 'FMAN L014',
      'building': 'FMAN',
      'type': 'Lecture hall',
      'capacity': 80,
      'facilities': ['Projector', 'Whiteboard'],
      'available': '16:00',
    },
    {
      'id': 'FENS 1033',
      'building': 'FENS',
      'type': 'Classroom',
      'capacity': 25,
      'facilities': [
        'Projector',
        'Whiteboard',
        'Inaccessible',
      ],
      'available': '16:00',
    },
  ];

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get filteredRooms {
    final result = rooms.where((room) {
      final idMatch = room['id']
          .toString()
          .toLowerCase()
          .contains(searchQuery.toLowerCase());

      final buildingMatch =
          building == 'Any building' || room['building'] == building;

      final typeMatch =
          roomType == 'Any room type' || room['type'] == roomType;

      final int roomCapacity = room['capacity'] as int;

      final capacityMatch = capacity == 'Any capacity' ||
          (capacity == '1-20' && roomCapacity <= 20) ||
          (capacity == '21-50' &&
              roomCapacity >= 21 &&
              roomCapacity <= 50) ||
          (capacity == '50+' && roomCapacity > 50);

      final facilityMatch = facility == 'Any facilities' ||
          (room['facilities'] as List<String>).contains(facility);

      return idMatch &&
          buildingMatch &&
          typeMatch &&
          capacityMatch &&
          facilityMatch;
    }).toList();

    result.sort((a, b) => ascending
        ? a['id'].compareTo(b['id'])
        : b['id'].compareTo(a['id']));

    return result;
  }

  void resetFilters() {
    setState(() {
      building = 'Any building';
      roomType = 'Any room type';
      capacity = 'Any capacity';
      facility = 'Any facilities';
      searchQuery = '';
      searchController.clear();
      ascending = true;
    });
  }

  Widget filterDropdown(
      String title,
      String value,
      List<String> options,
      ValueChanged<String?> onChanged,
      ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 9,
          vertical: 5,
        ),
        decoration: BoxDecoration(
          color: AppColors.cream,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 10,
                color: AppColors.grey,
              ),
            ),
            DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: value,
                isExpanded: true,
                isDense: true,
                icon: const Icon(
                  Icons.keyboard_arrow_down,
                  size: 17,
                  color: AppColors.teal,
                ),
                style: const TextStyle(
                  color: AppColors.dark,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
                dropdownColor: AppColors.cream,
                items: options.map((option) {
                  return DropdownMenuItem<String>(
                    value: option,
                    child: Text(
                      option,
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                }).toList(),
                onChanged: onChanged,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget facilityIcon(IconData icon) {
    return Icon(
      icon,
      size: 19,
      color: AppColors.teal,
    );
  }

  Widget roomCard(Map<String, dynamic> room) {
    final facilities = room['facilities'] as List<String>;

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          '/room_details',
          arguments: room['id'],
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 9),
        decoration: BoxDecoration(
          color: AppColors.cream,
          borderRadius: BorderRadius.circular(8),
        ),
        child: IntrinsicHeight(
          child: Row(
            children: [
              Container(
                width: 4,
                margin: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.green,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 11,
                    vertical: 11,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              room['id'],
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: AppColors.dark,
                              ),
                            ),
                          ),
                          if (facilities.contains('Accessible'))
                            facilityIcon(Icons.accessible),
                          if (facilities.contains('Projector'))
                            facilityIcon(Icons.cast),
                          if (facilities.contains('Whiteboard'))
                            facilityIcon(Icons.draw_outlined),
                          const SizedBox(width: 5),
                          const Icon(
                            Icons.chevron_right,
                            size: 25,
                            color: AppColors.dark,
                          ),
                        ],
                      ),
                      const SizedBox(height: 13),
                      Text(
                        'Free until ${room['available']}',
                        style: const TextStyle(
                          color: AppColors.teal,
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final results = filteredRooms;

    return Scaffold(
      backgroundColor: AppColors.blue_background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: 22,
            vertical: 22,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // HEADER
              Row(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      size: 19,
                    ),
                    onPressed: () => Navigator.pushReplacementNamed(context, '/'),
                  ),
                  const Text(
                    'Search Room',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.dark,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 18),

              Text(
                'Search by ID or narrow down with filters.',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.grey,
                ),
              ),

              const SizedBox(height: 12),

              // SEARCH FIELD
              const Text(
                'Room ID (optional)',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.dark,
                ),
              ),

              const SizedBox(height: 5),

              TextField(
                controller: searchController,
                onSubmitted: (_) {
                  setState(() {
                    searchQuery = searchController.text.trim();
                  });
                },
                decoration: InputDecoration(
                  hintText: 'e.g. FASS G015',
                  hintStyle: TextStyle(
                    color: AppColors.grey,
                    fontSize: 12,
                  ),
                  prefixIcon: const Icon(
                    Icons.search,
                    color: AppColors.teal,
                  ),
                  filled: true,
                  fillColor: AppColors.cream,
                  isDense: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 14),

              // FILTERS
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Filters',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: AppColors.dark,
                    ),
                  ),
                  TextButton(
                    onPressed: resetFilters,
                    child: const Text(
                      'Reset',
                      style: TextStyle(
                        color: AppColors.teal,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ],
              ),

              Row(
                children: [
                  filterDropdown(
                    'Building',
                    building,
                    ['Any building', 'FENS', 'FMAN', 'FASS'],
                        (value) => setState(() => building = value!),
                  ),
                  const SizedBox(width: 9),
                  filterDropdown(
                    'Room type',
                    roomType,
                    [
                      'Any room type',
                      'Classroom',
                      'Lecture hall',
                      'Study room',
                    ],
                        (value) => setState(() => roomType = value!),
                  ),
                ],
              ),

              const SizedBox(height: 9),

              Row(
                children: [
                  filterDropdown(
                    'Capacity',
                    capacity,
                    ['Any capacity', '1-20', '21-50', '50+'],
                        (value) => setState(() => capacity = value!),
                  ),
                  const SizedBox(width: 9),
                  filterDropdown(
                    'Facilities',
                    facility,
                    [
                      'Any facilities',
                      'Projector',
                      'Whiteboard',
                      'Accessible',
                    ],
                        (value) => setState(() => facility = value!),
                  ),
                ],
              ),

              const SizedBox(height: 15),

              // SEARCH BUTTON
              SizedBox(
                width: double.infinity,
                height: 43,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      searchQuery = searchController.text.trim();
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.lime,
                    foregroundColor: AppColors.dark,
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7),
                      side: const BorderSide(
                        color: AppColors.green,
                      ),
                    ),
                  ),
                  child: const Text(
                    'Search',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 18),

              // RESULTS HEADER
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${results.length} rooms found',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: AppColors.dark,
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () {
                      setState(() => ascending = !ascending);
                    },
                    icon: Icon(
                      ascending
                          ? Icons.arrow_upward
                          : Icons.arrow_downward,
                      size: 14,
                      color: AppColors.teal,
                    ),
                    label: const Text(
                      'Room ID',
                      style: TextStyle(
                        color: AppColors.teal,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 6),

              // ROOM RESULTS
              if (results.isEmpty)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(30),
                    child: Text(
                      'No rooms found.',
                      style: TextStyle(color: AppColors.grey),
                    ),
                  ),
                )
              else
                ...results.map(roomCard),
            ],
          ),
        ),
      ),
    );
  }
}
