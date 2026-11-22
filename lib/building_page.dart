import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';

class VerticalImagePager extends StatelessWidget {
  final List<String> imagePaths;

  const VerticalImagePager({super.key, required this.imagePaths});

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      scrollDirection: Axis.vertical, // Swipe up/down to switch images
      itemCount: imagePaths.length,
      itemBuilder: (context, index) {
        return Center(
          child: Image.asset(imagePaths[index]),
        );
      },
    );
  }
}


class BuildingMap extends StatelessWidget {
  const BuildingMap({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final building = args != null && args.containsKey('building') ? args['building'] : 'Unknown';
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
        title: Text('$building Map',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w700,
            color: AppColors.dark,
          ),
        ),
      ),
      body:
        Center(
          child: Image.asset(
          'assets/images/${building}G.png',
          errorBuilder: (context, error, stack) => Image.asset(
            'assets/images/${building}1.png',
            errorBuilder: (context, error, stack) => Image.asset(
              'assets/images/${building}2.png',
              errorBuilder: (context, error, stack) =>
              const Text('Map not available'),
            ),
          ),
        ),
        ),
    );
  }
}