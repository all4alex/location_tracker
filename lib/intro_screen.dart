import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_udid/flutter_udid.dart';
import 'package:location_tracker/app/app_colors.dart';
import 'package:location_tracker/map_screen.dart';
import 'package:location_tracker/trip_model.dart';
import 'package:location_tracker/user_details_form.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();

  String uuid = '';

  @override
  void initState() {
    _getDeviceId();
    super.initState();
  }

  Map<String, dynamic> _readAndroidBuildData(AndroidDeviceInfo build) {
    return <String, dynamic>{
      'version.securityPatch': build.version.securityPatch,
      'version.sdkInt': build.version.sdkInt,
      'version.release': build.version.release,
      'version.previewSdkInt': build.version.previewSdkInt,
      'version.incremental': build.version.incremental,
      'version.codename': build.version.codename,
      'version.baseOS': build.version.baseOS,
      'board': build.board,
      'bootloader': build.bootloader,
      'brand': build.brand,
      'device': build.device,
      'display': build.display,
      'fingerprint': build.fingerprint,
      'hardware': build.hardware,
      'host': build.host,
      'id': build.id,
      'manufacturer': build.manufacturer,
      'model': build.model,
      'product': build.product,
      'supported32BitAbis': build.supported32BitAbis,
      'supported64BitAbis': build.supported64BitAbis,
      'supportedAbis': build.supportedAbis,
      'tags': build.tags,
      'type': build.type,
      'isPhysicalDevice': build.isPhysicalDevice,
      'systemFeatures': build.systemFeatures,
      'displaySizeInches':
          ((build.displayMetrics.sizeInches * 10).roundToDouble() / 10),
      'displayWidthPixels': build.displayMetrics.widthPx,
      'displayWidthInches': build.displayMetrics.widthInches,
      'displayHeightPixels': build.displayMetrics.heightPx,
      'displayHeightInches': build.displayMetrics.heightInches,
      'displayXDpi': build.displayMetrics.xDpi,
      'displayYDpi': build.displayMetrics.yDpi,
      'serialNumber': build.serialNumber,
    };
  }

  void _getDeviceId() async {
    uuid = await FlutterUdid.consistentUdid;
    await ();
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
              alignment: Alignment.center,
              height: 300,
              child: Image.asset('assets/tracking_icon1.png')),
          SizedBox(
            height: 100,
          ),
          Text('Welcome!',
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium!
                  .copyWith(fontWeight: FontWeight.bold)),
          SizedBox(
            height: 50,
          ),
          Text('Real-time GPS Tracker',
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium!
                  .copyWith(fontWeight: FontWeight.bold)),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
          heroTag: 'uniqueTag',
          backgroundColor: AppColors.apPurple,
          label: Row(
            children: [
              Text(
                'GO',
                style: TextStyle(color: AppColors.appWhite, fontSize: 16),
              ),
              Icon(
                Icons.arrow_forward,
                color: AppColors.appWhite,
              ),
            ],
          ),
          onPressed: () {
            showMaterialModalBottomSheet(
                context: context,
                builder: (BuildContext context) => Container(
                    height: screenSize.height * .8,
                    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 5),
                    child: UserDetailsForm(
                      uuid: uuid,
                    )));
          }),
    );
  }
}
