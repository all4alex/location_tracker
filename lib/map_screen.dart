import 'dart:async';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dot_navigation_bar/dot_navigation_bar.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:geolocator/geolocator.dart';
import 'package:getwidget/getwidget.dart';
import 'package:location_tracker/app/app_colors.dart';
import 'package:location_tracker/trip_model.dart';
import 'package:location_tracker/utils/tile_servers.dart';
import 'package:location_tracker/utils/utils.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:latlng/latlng.dart';
import 'package:uuid/uuid.dart';

class MapScreen extends StatefulWidget {
  final String name;
  final String startLoc;
  final String endLoc;
  final String uuid;

  const MapScreen(
      {super.key,
      required this.name,
      required this.startLoc,
      required this.endLoc,
      required this.uuid});

  @override
  MapScreenState createState() => MapScreenState();
}

class MapScreenState extends State<MapScreen> with TickerProviderStateMixin {
  final controller = MapController.withUserPosition(
      trackUserLocation: UserTrackingOption(
    enableTracking: true,
    unFollowUser: false,
  ));
  LatLng currentPosition = LatLng(0.0, 0.0);
  bool positionStreamStarted = false;

  static const String _kLocationServicesDisabledMessage =
      'Location services are disabled.';

  static const String _kPermissionDeniedForeverMessage =
      'Permission denied forever.';

  static const String _kPermissionDeniedMessage = 'Permission denied.';
  static const String _kPermissionGrantedMessage = 'Permission granted.';

  Offset? _dragStart;
  final GeolocatorPlatform _geolocatorPlatform = GeolocatorPlatform.instance;
  final GlobalKey<ScaffoldState> _key = GlobalKey(); // Create a key
  final List<_PositionItem> _positionItems = <_PositionItem>[];
  StreamSubscription<Position>? _positionStreamSubscription;
  double _scaleStart = 1.0;
  StreamSubscription<ServiceStatus>? _serviceStatusStreamSubscription;

  @override
  void dispose() {
    if (_positionStreamSubscription != null) {
      _positionStreamSubscription!.cancel();
      _positionStreamSubscription = null;
    }

    super.dispose();
  }

  var uuid = Uuid();

  String tripId = '';
  @override
  void initState() {
    _getCurrentPosition();
    tripId = uuid.v4();
    super.initState();
  }

  void _handleTap(int selectedTab) {
    print('DATAAAAAA: $selectedTab');
    if (selectedTab == 1) {
      controller.centerMap;
    } else if (selectedTab == 2) {
      final bool isDrawerOpen = _key.currentState!.isDrawerOpen;
      if (isDrawerOpen) {
        _key.currentState!.closeDrawer();
      } else {
        _key.currentState!.openDrawer();
      }
    } else if (selectedTab == 3) {
      Navigator.of(context).pop();
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            contentPadding: EdgeInsets.zero,
            insetPadding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(32.0))),
            content: Container(
              height: 300,
              width: 300,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 80,
                    padding: EdgeInsets.only(left: 20, right: 20),
                    decoration: BoxDecoration(
                        color: Colors.purple.withOpacity(.7),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(32),
                            topRight: Radius.circular(32))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'TRIP ID:',
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '${tripId.split("-").first}',
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: double.infinity,
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: Colors.purple,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text('ADDITIONAL INFO:',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                )),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(20),
                    height: 150,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'DRIVER: ${widget.name}',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'GOING TO: ${widget.endLoc}',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'FROM:  ${widget.startLoc}',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'DATE: ${DateTime.now()}',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            actions: [
              IconButton(
                onPressed: () {},
                icon: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("CLOSE",
                      style: TextStyle(color: AppColors.appWhite)),
                ),
              )
            ],
          );
        },
      );
    }
    ;
  }

  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handlePermission();

    if (!hasPermission) {
      return;
    }

    final position = await _geolocatorPlatform.getCurrentPosition();
    _updatePositionList(_PositionItemType.position, position.toString(),
        position: position);
    _toggleServiceStatusStream();
  }

  Future<bool> _handlePermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await _geolocatorPlatform.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      _updatePositionList(
        _PositionItemType.log,
        _kLocationServicesDisabledMessage,
      );

      return false;
    }

    permission = await _geolocatorPlatform.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await _geolocatorPlatform.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        _updatePositionList(
          _PositionItemType.log,
          _kPermissionDeniedMessage,
        );

        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      _updatePositionList(
        _PositionItemType.log,
        _kPermissionDeniedForeverMessage,
      );

      return false;
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    _updatePositionList(
      _PositionItemType.log,
      _kPermissionGrantedMessage,
    );

    return true;
  }

  void _updatePositionList(_PositionItemType type, String displayValue,
      {Position? position}) {
    _positionItems.add(_PositionItem(type, displayValue));

    if (type == _PositionItemType.log) {
      print('LOCATION LOG:' + displayValue);
    }

    if (position != null) {
      currentPosition = LatLng(position.latitude, position.longitude);
      controller.centerMap;
      print(position.toString());
    }
    setState(() {});
  }

  bool _isListening() => !(_positionStreamSubscription == null ||
      _positionStreamSubscription!.isPaused);

  Color _determineButtonColor() {
    return _isListening() ? Colors.green : Colors.red;
  }

  void _toggleServiceStatusStream() {
    if (_serviceStatusStreamSubscription == null) {
      final serviceStatusStream = _geolocatorPlatform.getServiceStatusStream();
      _serviceStatusStreamSubscription =
          serviceStatusStream.handleError((error) {
        _serviceStatusStreamSubscription?.cancel();
        _serviceStatusStreamSubscription = null;
        print('ERROR [_serviceStatusStreamSubscription]: $error');
      }).listen((serviceStatus) {
        String serviceStatusValue;
        if (serviceStatus == ServiceStatus.enabled) {
          if (positionStreamStarted) {
            _toggleListening();
          }
          serviceStatusValue = 'enabled';
        } else {
          if (_positionStreamSubscription != null) {
            setState(() {
              _positionStreamSubscription?.cancel();
              _positionStreamSubscription = null;
              _updatePositionList(
                  _PositionItemType.log, 'Position Stream has been canceled');
            });
          }
          serviceStatusValue = 'disabled';
        }
        _updatePositionList(
          _PositionItemType.log,
          'Location service has been $serviceStatusValue',
        );
      });
    }
  }

  void _toggleListening() {
    if (_positionStreamSubscription == null) {
      final positionStream = _geolocatorPlatform.getPositionStream();
      _positionStreamSubscription = positionStream.handleError((error) {
        _positionStreamSubscription?.cancel();
        _positionStreamSubscription = null;
      }).listen((position) => _updatePositionList(
          _PositionItemType.position, position.toString(),
          position: position));
      _positionStreamSubscription?.pause();
    }

    setState(() {
      if (_positionStreamSubscription == null) {
        return;
      }

      String statusDisplayValue;
      if (_positionStreamSubscription!.isPaused) {
        _positionStreamSubscription!.resume();
        statusDisplayValue = 'resumed';
      } else {
        _positionStreamSubscription!.pause();
        statusDisplayValue = 'paused';
      }

      _updatePositionList(
        _PositionItemType.log,
        'Listening for position updates $statusDisplayValue',
      );
    });
  }

  void _getLastKnownPosition() async {
    final position = await _geolocatorPlatform.getLastKnownPosition();
    if (position != null) {
      _updatePositionList(
        _PositionItemType.position,
        position.toString(),
      );
    } else {
      _updatePositionList(
        _PositionItemType.log,
        'No last known position available',
      );
    }
  }

  void _getLocationAccuracy() async {
    final status = await _geolocatorPlatform.getLocationAccuracy();
    _handleLocationAccuracyStatus(status);
  }

  void _requestTemporaryFullAccuracy() async {
    final status = await _geolocatorPlatform.requestTemporaryFullAccuracy(
      purposeKey: "TemporaryPreciseAccuracy",
    );
    _handleLocationAccuracyStatus(status);
  }

  void _handleLocationAccuracyStatus(LocationAccuracyStatus status) {
    String locationAccuracyStatusValue;
    if (status == LocationAccuracyStatus.precise) {
      locationAccuracyStatusValue = 'Precise';
    } else if (status == LocationAccuracyStatus.reduced) {
      locationAccuracyStatusValue = 'Reduced';
    } else {
      locationAccuracyStatusValue = 'Unknown';
    }
    _updatePositionList(
      _PositionItemType.log,
      '$locationAccuracyStatusValue location accuracy granted.',
    );
  }

  void _openAppSettings() async {
    final opened = await _geolocatorPlatform.openAppSettings();
    String displayValue;

    if (opened) {
      displayValue = 'Opened Application Settings.';
    } else {
      displayValue = 'Error opening Application Settings.';
    }

    _updatePositionList(
      _PositionItemType.log,
      displayValue,
    );
  }

  void _openLocationSettings() async {
    final opened = await _geolocatorPlatform.openLocationSettings();
    String displayValue;

    if (opened) {
      displayValue = 'Opened Location Settings';
    } else {
      displayValue = 'Error opening Location Settings';
    }

    _updatePositionList(
      _PositionItemType.log,
      displayValue,
    );
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    Widget osmMap = OSMFlutter(
        controller: controller,
        osmOption: OSMOption(
          userTrackingOption: UserTrackingOption(
            enableTracking: true,
            unFollowUser: false,
          ),
          zoomOption: ZoomOption(
            initZoom: 8,
            minZoomLevel: 3,
            maxZoomLevel: 19,
            stepZoom: 1.0,
          ),
          userLocationMarker: UserLocationMaker(
            personMarker: MarkerIcon(
              icon: Icon(
                Icons.location_history_rounded,
                color: Colors.red,
                size: 48,
              ),
            ),
            directionArrowMarker: MarkerIcon(
              icon: Icon(
                Icons.double_arrow,
                size: 48,
              ),
            ),
          ),
          roadConfiguration: RoadOption(
            roadColor: Colors.yellowAccent,
          ),
          markerOption: MarkerOption(
              defaultMarker: MarkerIcon(
            icon: Icon(
              Icons.person_pin_circle,
              color: Colors.blue,
              size: 56,
            ),
          )),
        ));

    return Scaffold(
        extendBody: true,
        extendBodyBehindAppBar: true,
        key: _key,
        drawer: GFDrawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              GFDrawerHeader(
                currentAccountPicture: GFAvatar(
                  radius: 80.0,
                  backgroundImage: AssetImage('assets/nemsu_logo.png'),
                ),
              ),
            ],
          ),
        ),
        body: Container(
            height: screenSize.height, width: screenSize.width, child: osmMap),
        bottomNavigationBar: Padding(
            padding: EdgeInsets.only(bottom: 10),
            child: DotNavigationBar(
              margin: EdgeInsets.only(left: 10, right: 10),
              marginR: EdgeInsets.only(left: 20, right: 20),
              paddingR: EdgeInsets.only(top: 5, bottom: 5),
              dotIndicatorColor: Colors.purple,
              unselectedItemColor: Colors.white,
              selectedItemColor: Colors.white,
              splashBorderRadius: 50,
              // enableFloatingNavBar: false,
              onTap: (selectedTab) {
                _handleTap(selectedTab);
                setState(() {});
              },
              backgroundColor: Colors.purple,

              items: [
                DotNavigationBarItem(
                  icon: Icon(Icons.info_outline_rounded),
                ),
                DotNavigationBarItem(
                  icon: Icon(Icons.navigation),
                ),
                DotNavigationBarItem(
                  icon: Icon(Icons.account_circle_rounded),
                ),
                DotNavigationBarItem(
                  icon: Icon(Icons.close_rounded),
                ),
              ],
            )));
  }
}

enum _PositionItemType {
  log,
  position,
}

class _PositionItem {
  _PositionItem(this.type, this.displayValue);

  final String displayValue;
  final _PositionItemType type;
}
