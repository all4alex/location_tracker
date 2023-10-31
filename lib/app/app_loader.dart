import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:location_tracker/app/app_colors.dart';

class AppLoader {
  static Widget loaderOne = GFLoader(
    type: GFLoaderType.circle,
    loaderColorOne: AppColors.apPurple,
    loaderColorTwo: AppColors.appOrange,
    loaderColorThree: AppColors.appBlue,
    duration: Duration(seconds: 10),
  );
}
