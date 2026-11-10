import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_colors.dart';
import 'bottom_navigation.dart';
import 'home_screen.dart';

class CampusActivitiesScreen extends StatefulWidget {
  const CampusActivitiesScreen({super.key});

  @override
  State<CampusActivitiesScreen> createState() => _CampusActivitiesScreenState();
}

class _CampusActivitiesScreenState extends State<CampusActivitiesScreen> {
  static const _darkTeal = Color(0xFF2E6B5A);
  static const _filters = ['All activities', 'Talks', 'Clubs'];
  int _filter = 0;

  // (day, month, title, time · place, category)
  static const _events = [
    ('02', 'NOV', 'Board games & good company',
    '16:30 – 18:00 · University Center', 'Clubs'),
    ('03', 'NOV', 'A conversation on climate',
    '18:00 – 19:00 · FASS G062', 'Talk'),
    ('05', 'NOV', 'An evening of acoustic music',
    '19:00 – 20:30 · Performing Arts Center', 'Arts'),
  ];

  @override
  Widget build(BuildContext context) {
    final shown = _events.where((e) {
      if (_filter == 1) return e.$5 == 'Talk';
      if (_filter == 2) return e.$5 == 'Clubs';
      return true;
    }).toList();

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
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new,
              color: AppColors.dark, size: 22),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Campus Activities',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: AppColors.dark,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        children: [
          const Text(
            "Today's events in the campus",
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppColors.dark),
          ),
          const SizedBox(height: 18),

          
          Row(
            children: List.generate(_filters.length, (i) {
              final selected = i == _filter;
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(right: i < 2 ? 12 : 0),
                  child: GestureDetector(
                    onTap: () => setState(() => _filter = i),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: selected ? _darkTeal : AppColors.cream,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        _filters[i],
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: selected ? Colors.white : _darkTeal,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 20),


          Container(
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
            decoration: BoxDecoration(
              color: _darkTeal,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.lime,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text('THIS WEEK',
                          style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: AppColors.dark)),
                    ),
                    const Spacer(),
                    Container(
                      width: 62,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E3A44),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Column(
                        children: [
                          Text('NOV',
                              style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white)),
                          Text('04',
                              style: TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white)),
                        ],
                      ),
                    ),
                  ],
                ),
                const Text(
                  'Ideas worth\nsharing.',
                  style: TextStyle(
                    fontSize: 30,
                    height: 1.2,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 12),
                const Text('Student innovation meetup',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white)),
                const SizedBox(height: 6),
                const Row(
                  children: [
                    Expanded(
                      child: Text('17:30 · University Center',
                          style:
                          TextStyle(fontSize: 12, color: Colors.white70)),
                    ),
                    Icon(Icons.arrow_forward, color: AppColors.lime, size: 20),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          const Text(
            'Coming up on campus',
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.dark),
          ),
          const SizedBox(height: 12),


          for (final e in shown) ...[
            Container(
              padding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              decoration: BoxDecoration(
                color: AppColors.cream,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: 44,
                    child: Column(
                      children: [
                        Text(e.$1,
                            style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w600,
                                color: AppColors.teal)),
                        Text(e.$2,
                            style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: AppColors.teal)),
                      ],
                    ),
                  ),
                  const SizedBox(width: 18),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(e.$3,
                            style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                                color: AppColors.dark)),
                        const SizedBox(height: 6),
                        Text(e.$4,
                            style: const TextStyle(
                                fontSize: 12, color: AppColors.grey)),
                        const SizedBox(height: 2),
                        Text(e.$5,
                            style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: AppColors.teal)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
          ],
        ],
      ),
    bottomNavigationBar: BottomNav(
       current: -1 ,
       onTap: (i) => Navigator.pushAndRemoveUntil(
       context,
       MaterialPageRoute(builder: (_) => HomeScreen(initialTab: i)),
      (route) => false,

    ),
    ),
    );
  }
}
