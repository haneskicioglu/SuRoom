import 'package:flutter/material.dart';

import 'app_colors.dart';

class BottomNav extends StatelessWidget {
  final int current;
  final ValueChanged<int> onTap;
  const BottomNav({super.key, required this.current, required this.onTap});

  static const _items = [
    (Icons.home_outlined, 'Home'),
    (Icons.search, 'Search'),
    (Icons.confirmation_number_outlined, 'Bookings'),
    (Icons.map_outlined, 'Map'),
    (Icons.person_outline, 'My Account'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.cream,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            children: List.generate(_items.length, (i) {
              final (icon, label) = _items[i];
              final selected = i == current;
              final color = selected ? AppColors.teal : AppColors.grey;
              return Expanded(
                child: GestureDetector(
                  onTap: () => onTap(i),
                  behavior: HitTestBehavior.opaque,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: selected
                          ? const Color(0xFFE3EAE6)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(icon, color: color, size: 26),
                        const SizedBox(height: 4),
                        Text(label,
                            style: TextStyle(
                                fontSize: 12,
                                color: color,
                                fontWeight: selected
                                    ? FontWeight.w700
                                    : FontWeight.w500)),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
