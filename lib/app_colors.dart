import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppColors {
  static const green = Color(0xFF5A9E48);
  static const lightGreen = Color(0xFFDDF58A);
  static const blue = Color(0xFF1C3F9A);
  static const teal = Color(0xFF32785F);
  static const blue_background = Color(0xFFCDEBEE);
  static const cream = Color(0xFFF1F6F1);
  static const lime = Color(0xFFE2F59A);
  static const dark = Color(0xFF1E2B33);
  static const grey = Color(0xFF6B7378);
  static const darkYellow = Color(0xFF8D7B47);
  static const red = Color(0xFF851313);
  static const brightGreen = Color(0xFF206D12);
  static const darkRed = Color(0xFF440606);
  static const blurple = Color(0xFF493B54);
}

class RoomAttributeIcon extends StatelessWidget {
  // this either returns an svg or an icon, depending on the type of the icon
  final String? svg;
  final IconData? icon;
  final bool isTeal;
  const RoomAttributeIcon({super.key, this.svg, this.icon, this.isTeal = false});
  @override
  Widget build(BuildContext context) {
    if (svg != null) {
      return SvgPicture.asset(
        svg!,
        width: 24,
        height: 24,
        colorFilter: ColorFilter.mode(
          isTeal ? AppColors.teal : AppColors.lightGreen,
          BlendMode.srcIn,
        ),
      );
    } else if (icon != null) {
      return Icon(icon!, size: 24, color: isTeal ? AppColors.teal : AppColors.lightGreen);
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
    return Padding(
      padding: const EdgeInsets.only(top: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          icon,
          SizedBox(width: 5),
          Expanded(
            child:Text(name, style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: AppColors.cream))),
        ],
      )
    );
  }
}

class AttributeTags {
  static const Map<String, Map<String, dynamic>> attributes = {
    "POWER": {'name': "Power Outlets", 'icon': Icons.electrical_services},
    "ETHERNET": {'name': "Wired Network", 'icon': Icons.lan_outlined},
    "SEATS": {'name': "Proper Seats", 'svg': "assets/icons/seats.svg"},
    "BLACKBOARD": {'name': "Blackboard", 'svg': "assets/icons/blackboard.svg"},
    "CIRCULAR": {'name': "Circular Table", 'icon': Icons.table_bar_outlined},
    "NO_WINDOWS": {'name': "No Windows", 'icon': Icons.web_asset_off},
    'LOCKED': {'name': "Requires Keys", 'svg': 'assets/icons/locked.svg'},
  };

  static Map<String, RoomAttributeIcon> attributeIcons = attributes.map((key, value) {
    if (value.containsKey('svg')) {
      return MapEntry(key, RoomAttributeIcon(svg: value['svg'], isTeal: true));
    } else if (value.containsKey('icon')) {
      return MapEntry(key, RoomAttributeIcon(icon: value['icon'], isTeal: true));
    } else {
      return MapEntry(key, RoomAttributeIcon());
    }
  });

  static Map<String, RoomAttribute> attributeWidgets = attributes.map((key, value) {
    if (value.containsKey('svg')) {
      return MapEntry(key, RoomAttribute(name: value['name'], icon: RoomAttributeIcon(svg: value['svg'], isTeal: false)));
    } else if (value.containsKey('icon')) {
      return MapEntry(key, RoomAttribute(name: value['name'], icon: RoomAttributeIcon(icon: value['icon'], isTeal: false)));
    } else {
      return MapEntry(key, RoomAttribute(name: value['name'], icon: RoomAttributeIcon()));
    }
  });
}

class CustomButton extends SizedBox {
  CustomButton({
    super.key,
    super.width,
    super.height,
    VoidCallback? onPressed,
    required String text,
    double fontSize = 14,
  }) : super(
    child: ElevatedButton(
      onPressed: onPressed,
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
      child: Text(
        text,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  );
}

class AllFloors{
  static String get(int floor) {
    if (floor == 0) {
      return "Ground Floor";
    } else if (floor == -1) {
      return "Lower Ground Floor";
    } else if (floor == 1) {
      return "${floor}st Floor";
    } else if (floor == 2) {
      return "${floor}nd Floor";
    } else if (floor == 3) {
      return "${floor}rd Floor";
    }
    return "${floor}th Floor";
  }
}