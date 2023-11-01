import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dot_navigation_bar/dot_navigation_bar.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:getwidget/getwidget.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:location_tracker/app/app_colors.dart';
import 'package:location_tracker/trip_location_model.dart';
import 'package:location_tracker/trip_location_updates_model.dart';
import 'package:location_tracker/trip_model.dart';
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
  static const _startedId = 'AnimatedMapController#MoveStarted';
  static const _inProgressId = 'AnimatedMapController#MoveInProgress';
  static const _finishedId = 'AnimatedMapController#MoveFinished';

  LatLng currentPosition = LatLng(0.0, 0.0);

  bool positionStreamStarted = false;
  late final MapController mapController;

  final GlobalKey<ScaffoldState> _key = GlobalKey(); // Create a key

  @override
  void dispose() {
    super.dispose();
  }

  CollectionReference trips = FirebaseFirestore.instance.collection('trips');
  CollectionReference tripLocationUpdates =
      FirebaseFirestore.instance.collection('tripLocationUpdataes');

  Future<void> startTrip({required TripLocationModel tripLocationModel}) {
    return trips
        .doc(tripLocationModel.tripId)
        .set(tripLocationModel.toMap())
        .then((value) => print("Trip Added"))
        .catchError((error) => print("Failed to add trip: $error"));
  }

  Future<void> saveTripLocationUpdates(
      {required TripLocationUpdatesModel tripLocationUpdatesModel}) {
    return tripLocationUpdates
        .doc(tripLocationUpdatesModel.dateTime.toString())
        .set(tripLocationUpdatesModel.toMap())
        .then((value) => print("Trip Added"))
        .catchError((error) => print("Failed to add trip: $error"));
  }

  var uuid = Uuid();

  String tripId = '';
  @override
  void initState() {
    super.initState();
    tripId = uuid.v4();
    mapController = MapController();
    requestLocationPermission();
  }

  // StreamSubscription<Position> positionStream = Geolocator.getPositionStream(
  //     locationSettings: LocationSettings(
  //   accuracy: LocationAccuracy.high,
  //   distanceFilter: 100,
  // ));

  // .listen(
  //   (Position? position) {
  //       print(position == null ? 'Unknown' : '${position.latitude.toString()}, ${position.longitude.toString()}');
  //   });

  void _animatedMapMove(LatLng destLocation, double destZoom) {
    // Create some tweens. These serve to split up the transition from one location to another.
    // In our case, we want to split the transition be<tween> our current map center and the destination.
    final camera = mapController.camera;
    final latTween = Tween<double>(
        begin: camera.center.latitude, end: destLocation.latitude);
    final lngTween = Tween<double>(
        begin: camera.center.longitude, end: destLocation.longitude);
    final zoomTween = Tween<double>(begin: camera.zoom, end: destZoom);

    // Create a animation controller that has a duration and a TickerProvider.
    final controller = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    // The animation determines what path the animation will take. You can try different Curves values, although I found
    // fastOutSlowIn to be my favorite.
    final Animation<double> animation =
        CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn);

    // Note this method of encoding the target destination is a workaround.
    // When proper animated movement is supported (see #1263) we should be able
    // to detect an appropriate animated movement event which contains the
    // target zoom/center.
    final startIdWithTarget =
        '$_startedId#${destLocation.latitude},${destLocation.longitude},$destZoom';
    bool hasTriggeredMove = false;

    controller.addListener(() {
      final String id;
      if (animation.value == 1.0) {
        id = _finishedId;
      } else if (!hasTriggeredMove) {
        id = startIdWithTarget;
      } else {
        id = _inProgressId;
      }

      hasTriggeredMove |= mapController.move(
        LatLng(latTween.evaluate(animation), lngTween.evaluate(animation)),
        zoomTween.evaluate(animation),
        id: id,
      );
    });

    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.dispose();
      } else if (status == AnimationStatus.dismissed) {
        controller.dispose();
      }
    });

    controller.forward();
  }

  void requestLocationPermission() async {
    await Geolocator.requestPermission();
  }

  Future<LatLng> getInitialLocation() async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    return LatLng(position.latitude, position.longitude);
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

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
        body: FutureBuilder<LatLng>(
          future: getInitialLocation(),
          builder: (
            BuildContext context,
            AsyncSnapshot<LatLng> snapshot,
          ) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                return const Text('Error');
              } else if (snapshot.hasData) {
                currentPosition = snapshot.data!;
                startTrip(
                    tripLocationModel: TripLocationModel(
                  dateTime: DateTime.now().millisecondsSinceEpoch,
                  tripId: tripId,
                  driver: widget.name,
                  from: widget.startLoc,
                  to: widget.endLoc,
                  startLat: currentPosition.latitude,
                  startLon: currentPosition.longitude,
                  status: 'started',
                ));
              }
            } else {
              return Text('State: ${snapshot.connectionState}');
            }

            return StreamBuilder<Position>(
                stream: Geolocator.getPositionStream(
                    locationSettings: const LocationSettings(
                  accuracy: LocationAccuracy.bestForNavigation,
                  distanceFilter: 50,
                )),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    LatLng newLoc = LatLng(
                        snapshot.data!.latitude, snapshot.data!.longitude);

                    if (newLoc != currentPosition) {
                      currentPosition = LatLng(
                          snapshot.data!.latitude, snapshot.data!.longitude);
                      saveTripLocationUpdates(
                          tripLocationUpdatesModel: TripLocationUpdatesModel(
                              dateTime: DateTime.now().millisecondsSinceEpoch,
                              tripId: tripId,
                              driver: widget.name,
                              currentLat: currentPosition.latitude,
                              currentLong: currentPosition.longitude,
                              from: widget.startLoc,
                              to: widget.endLoc));
                    }

                    // _animatedMapMove(currentPosition, 20);
                  } else {}
                  return FlutterMap(
                    mapController: mapController,
                    options: MapOptions(
                      initialCenter: currentPosition,
                      initialZoom: 18,
                      cameraConstraint: CameraConstraint.contain(
                        bounds: LatLngBounds(
                          LatLng(-90, -180),
                          LatLng(90, 180),
                        ),
                      ),
                    ),
                    children: [
                      TileLayer(
                        urlTemplate:
                            'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        userAgentPackageName:
                            'dev.fleaflet.flutter_map.example',
                        tileUpdateTransformer:
                            _animatedMoveTileUpdateTransformer,
                      ),
                      CurrentLocationLayer(
                        followOnLocationUpdate: FollowOnLocationUpdate.always,
                        turnOnHeadingUpdate: TurnOnHeadingUpdate.never,
                        style: LocationMarkerStyle(
                          marker: DefaultLocationMarker(
                            color: AppColors.apPurple,
                            child: Icon(
                              Icons.navigation_sharp,
                              color: AppColors.appWhite,
                              size: 30,
                            ),
                          ),
                          markerSize: Size(40, 40),
                          markerDirection: MarkerDirection.heading,
                        ),
                      ),

                      // MarkerLayer(markers: [
                      //   Marker(
                      //     width: 60,
                      //     height: 60,
                      //     point: currentPosition,
                      //     child: Image.asset('assets/navigator_icon.png'),
                      //   ),
                      // ]),
                    ],
                  );
                });
          },
        ),
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
              onTap: _handleTap,
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

  final _animatedMoveTileUpdateTransformer =
      TileUpdateTransformer.fromHandlers(handleData: (updateEvent, sink) {
    final mapEvent = updateEvent.mapEvent;

    final id = mapEvent is MapEventMove ? mapEvent.id : null;
    if (id?.startsWith(MapScreenState._startedId) == true) {
      final parts = id!.split('#')[2].split(',');
      final lat = double.parse(parts[0]);
      final lon = double.parse(parts[1]);
      final zoom = double.parse(parts[2]);

      // When animated movement starts load tiles at the target location and do
      // not prune. Disabling pruning means existing tiles will remain visible
      // whilst animating.
      sink.add(
        updateEvent.loadOnly(
          loadCenterOverride: LatLng(lat, lon),
          loadZoomOverride: zoom,
        ),
      );
    } else if (id == MapScreenState._inProgressId) {
      // Do not prune or load whilst animating so that any existing tiles remain
      // visible. A smarter implementation may start pruning once we are close to
      // the target zoom/location.
    } else if (id == MapScreenState._finishedId) {
      // We already prefetched the tiles when animation started so just prune.
      sink.add(updateEvent.pruneOnly());
    } else {
      sink.add(updateEvent);
    }
  });

  void _handleTap(int selectedTab) {
    print('DATAAAAAA: $selectedTab');
    if (selectedTab == 1) {
      _animatedMapMove(currentPosition, 20);
    } else if (selectedTab == 2) {
      final bool isDrawerOpen = _key.currentState!.isDrawerOpen;
      if (isDrawerOpen) {
        _key.currentState!.closeDrawer();
      } else {
        _key.currentState!.openDrawer();
      }
    } else if (selectedTab == 3) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Exit current trip"),
            content: Text(
                "You will be redirected to home. Location updates with the current trip will be stopped."),
            actions: [
              ElevatedButton(
                child: Text("No"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              ElevatedButton(
                child: Text("Yes"),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
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
}
