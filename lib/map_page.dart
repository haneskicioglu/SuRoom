import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';


class MapPage extends StatelessWidget {
  final VoidCallback? onBack;

  const MapPage({super.key, this.onBack});
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: AppColors.blue_background,
        surfaceTintColor: AppColors.blue_background,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: AppColors.blue_background,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
        title: Text('Campus Map',
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
              onPressed: () => onBack?.call(),
            ),
          ],
        ),
      )
    );
  }
}