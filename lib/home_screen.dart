import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_colors.dart';
import 'bottom_navigation.dart';
import 'notifications_screen.dart';
import 'campus_activities_screen.dart';

class HomeScreen extends StatefulWidget {
  final int initialTab;
  const HomeScreen({super.key, this.initialTab = 0});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late int _tab = widget.initialTab;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _tab == 0
          ? _buildAppBar(context, (tab) {
        if (tab != null) setState(() => _tab = tab);
      })
          : null,
      body: switch (_tab) {
        0 => const _HomeBody(),
        1 => const Center(child: Text('Search page')),
        2 => const Center(child: Text('Bookings page')),
        3 => const Center(child: Text('Map page')),
        _ => const Center(child: Text('My Account page')),
      },
      bottomNavigationBar: BottomNav(
        current: _tab,
        onTap: (i) => setState(() => _tab = i),
      ),
    );
  }
}

class _HomeBody extends StatelessWidget {
  const _HomeBody();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
      children: const [
        _ActivitiesCard(),
        SizedBox(height: 12),
        _ActionTile(
          icon: Icons.location_on_outlined,
          title: 'Nearest Empty Room',
          subtitle: 'Nearest rooms with no activity',
        ),
        SizedBox(height: 12),
        _ActionTile(
          icon: Icons.search,
          title: 'Search Room',
          subtitle: 'Search by room ID or filters',
        ),
        SizedBox(height: 12),
        _ActionTile(
          icon: Icons.confirmation_number_outlined,
          title: 'Room Check-in',
          subtitle: 'Check into the room that you are in',
        ),
        SizedBox(height: 16),
        _CampusMapButton(),
      ],
    );
  }
}


PreferredSizeWidget _buildAppBar(
    BuildContext context, void Function(int?) onReturn) {
  return AppBar(
    toolbarHeight: 80,
    backgroundColor: Colors.white,

    systemOverlayStyle: const SystemUiOverlayStyle(
      statusBarColor: Colors.white,
    ),
    title: RichText(
      text: const TextSpan(
        children: [
          TextSpan(
            text: 'SU',
            style: TextStyle(
              fontSize: 44,
              fontWeight: FontWeight.w900,
              color: AppColors.blue,
              letterSpacing: -1,
            ),
          ),
          TextSpan(
            text: 'R',
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.w800,
              color: AppColors.teal,
            ),
          ),
          TextSpan(
            text: 'OO',
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.w800,
              color: AppColors.green,
            ),
          ),
          TextSpan(
            text: 'M',
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.w800,
              color: AppColors.teal,
            ),
          ),
        ],
      ),
    ),
    actions: [
      Padding(
        padding: const EdgeInsets.only(right: 16),
        child: Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: AppColors.lime,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.18),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: IconButton(
            icon: const Icon(Icons.notifications_none, color: AppColors.teal),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const NotificationsScreen()),
              );
            },
          ),
        ),
      ),
    ],
  );
}

class _ActivitiesCard extends StatelessWidget {
  const _ActivitiesCard();

  void _open(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const CampusActivitiesScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _open(context),
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 18, 16, 16),
        decoration: BoxDecoration(
          color: AppColors.green,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.auto_awesome_outlined,
                    color: Colors.white, size: 28),
                const SizedBox(width: 14),
                const Expanded(
                  child: Text(
                    'Campus Activities',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () => _open(context),
                  child: const Text(
                    'View all →',
                    style: TextStyle(
                      color: AppColors.lime,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            const Text(
              'Upcoming events',
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
            const SizedBox(height: 12),
            const _EventItem(
              day: '02',
              month: 'NOV',
              title: 'Board games & good company',
              info: '16:30 · University Center',
            ),
            const SizedBox(height: 14),
            const _EventItem(
              day: '03',
              month: 'NOV',
              title: 'A conversation on climate',
              info: '18:00 · FASS G062',
            ),
          ],
        ),
      ),
    );
  }
}

class _EventItem extends StatelessWidget {
  final String day, month, title, info;
  const _EventItem({
    required this.day,
    required this.month,
    required this.title,
    required this.info,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      decoration: BoxDecoration(
        color: AppColors.cream,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 60,
            child: Column(
              children: [
                Text(day,
                    style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w600,
                        color: AppColors.teal)),
                Text(month,
                    style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.teal)),
              ],
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.dark)),
                const SizedBox(height: 8),
                Text(info,
                    style:
                    const TextStyle(fontSize: 14, color: AppColors.grey)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


class _ActionTile extends StatelessWidget {
  final IconData icon;
  final String title, subtitle;
  const _ActionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: AppColors.cream,
          borderRadius: BorderRadius.circular(6),
        ),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                width: 76,
                color: AppColors.green,
                child: Icon(icon, color: Colors.white, size: 28),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 22, 10, 22),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title,
                          style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: AppColors.dark)),
                      const SizedBox(height: 4),
                      Text(subtitle,
                          style: const TextStyle(
                              fontSize: 15, color: AppColors.dark)),
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
}

class _CampusMapButton extends StatelessWidget {
  const _CampusMapButton();

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.lime,
      borderRadius: BorderRadius.circular(6),
      child: GestureDetector(
        onTap: () {},
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          decoration: BoxDecoration(
            color: AppColors.lime,
            borderRadius: BorderRadius.circular(6),
          ),
          child: const Row(
            children: [
              Icon(Icons.map_outlined, color: AppColors.dark),
              SizedBox(width: 16),
              Expanded(
                child: Text('Campus map',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppColors.dark)),
              ),
              Icon(Icons.arrow_forward, color: AppColors.teal),
            ],
          ),
        ),
      ),
    );
  }
}
