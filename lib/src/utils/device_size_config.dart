import 'package:flutter/material.dart';

class DeviceSizeConfig {
  late MediaQueryData mediaQueryData;
  late double screenHeight;
  late double screenWidth;
  late double blockSizeHorizontal;
  late double blockSizeVertical;

  DeviceSizeConfig(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);
    screenHeight = mediaQueryData.size.height;
    screenWidth = mediaQueryData.size.width;
    blockSizeVertical = (screenHeight -
            (mediaQueryData.padding.top + mediaQueryData.padding.bottom)) /
        100;
    blockSizeHorizontal = (screenWidth -
            (mediaQueryData.padding.left + mediaQueryData.padding.right)) /
        100;
  }
}
