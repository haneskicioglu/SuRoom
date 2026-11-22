import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';


class MapButton extends Positioned {
  final text = "";
  MapButton({
    super.key,
    required double left,
    required double top,
    required double width,
    required double height,
    VoidCallback ? onPressed,
  }) : super(
    left: left,
    top: top,
    width: width,
    height: height,
    child: Material(
      color: Color(0x00000000),
      borderRadius: BorderRadius.circular(8),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onPressed,
      ),
    )
  );
}

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
      ),
      body: Container(
        color: AppColors.blue_background,
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Center(
                  child: Stack(
                    children: [
                      // 1. Base child: defines the exact width & height of the Stack
                      Image.asset('assets/images/campus.png'),

                      // 2. Hotspot layer matching the exact image bounds
                      Positioned.fill(
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            final imgW = constraints.maxWidth;
                            final imgH = constraints.maxHeight;

                            return Stack(
                              children: [
                                MapButton(left: imgW * 0.28, top: imgH * 0.1, width: imgW * 0.41, height: imgH * 0.19, onPressed: () {Navigator.pushNamed(context, '/building_map', arguments: {'building': 'UC'});}),
                                MapButton(left: imgW * 0.12, top: imgH * 0.28, width: imgW * 0.25, height: imgH * 0.3, onPressed: () {Navigator.pushNamed(context, '/building_map', arguments: {'building': 'FMAN'});}),
                                MapButton(left: imgW * 0.18, top: imgH * 0.60, width: imgW * 0.14, height: imgH * 0.29, onPressed: () {Navigator.pushNamed(context, '/building_map', arguments: {'building': 'SL'});}),
                                MapButton(left: imgW * 0.58, top: imgH * 0.30, width: imgW * 0.24, height: imgH * 0.27, onPressed: () {Navigator.pushNamed(context, '/building_map', arguments: {'building': 'FENS'});}),
                                MapButton(left: imgW * 0.58, top: imgH * 0.61, width: imgW * 0.22, height: imgH * 0.27, onPressed: () {Navigator.pushNamed(context, '/building_map', arguments: {'building': 'FASS'});}),
                              ],
                            );
                          },
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
}