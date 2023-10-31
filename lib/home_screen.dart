import 'package:getwidget/components/button/gf_button.dart';
import 'package:getwidget/getwidget.dart';
import 'package:getwidget/shape/gf_button_shape.dart';
import 'package:json_annotation/json_annotation.dart';
import 'dart:async';

import 'package:dot_navigation_bar/dot_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_udid/flutter_udid.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lottie/lottie.dart';

enum _SelectedTab { home, favorite, search, person }

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

@JsonSerializable()
class _HomeScreenState extends State<HomeScreen> {
  String uuid = '';

  var _selectedTab = _SelectedTab.home;

  @override
  void initState() {
    super.initState();
    _getDeviceId();
    _determinePosition();
  }

  void _handleIndexChanged(int i) {
    setState(() {
      _selectedTab = _SelectedTab.values[i];
    });
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  void _getDeviceId() async {
    uuid = await FlutterUdid.consistentUdid;
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      extendBody: true,
      body: Center(
        child: Container(
          height: screenSize.height * .8,
          width: screenSize.width,
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 221, 218, 218),
            image: DecorationImage(
              image: AssetImage("assets/nemsu_logo.png"),
              opacity: .1,
              fit: BoxFit.fitHeight,
            ),
          ),
          child: Center(
            child: Container(
              width: screenSize.width,
              height: screenSize.height,
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  OutlinedButton(
                    onPressed: () => {},
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text('START'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: DotNavigationBar(
        margin: EdgeInsets.only(left: 10, right: 10),
        marginR: EdgeInsets.only(left: 50, right: 50),
        paddingR: EdgeInsets.only(top: 5, bottom: 5),
        currentIndex: _SelectedTab.values.indexOf(_selectedTab),
        dotIndicatorColor: Colors.grey[300],
        unselectedItemColor: Colors.white,
        selectedItemColor: Colors.orange,
        splashBorderRadius: 50,

        // enableFloatingNavBar: false,
        onTap: _handleIndexChanged,
        backgroundColor: Colors.purple,
        items: [
          /// Home
          DotNavigationBarItem(
            icon: Icon(Icons.navigation_sharp),
          ),

          /// Likes
          DotNavigationBarItem(
            icon: Icon(Icons.list_rounded),
          ),

          /// Search
          DotNavigationBarItem(
            icon: Icon(Icons.person),
          ),

          /// Profile
          DotNavigationBarItem(
            icon: Icon(Icons.settings),
          ),
        ],
      ),
    );
  }
}
