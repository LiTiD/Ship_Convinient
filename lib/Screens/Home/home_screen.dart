import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:shipconvenient/Screens/Signup/components/direction.dart';
import 'package:shipconvenient/Screens/constants.dart';
import 'package:shipconvenient/components/constants.dart';
import 'package:shipconvenient/components/hyper_stack.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:dio/dio.dart';


class HomePage extends StatefulWidget {
  HomePage(this.searchParam, {Key? key}) : super(key: key);
  final String? searchParam;
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MapBox(widget.searchParam),
    );
  }
}

class MapBox extends StatefulWidget {
  MapBox(this.searchParam, {Key? key}) : super(key: key);
  final String? searchParam;

  @override
  State<MapBox> createState() => _MapBoxState();
}

class _MapBoxState extends State<MapBox> with TickerProviderStateMixin {
  final pageController = PageController();
  int selectedIndex = 0;
  var currentLocation = LatLng(10.84110651757115, 106.80988299716103);
  late StreamSubscription<MapEvent> subscription;
  late MapController mapController = MapController();

  @override
  void initState() {
    super.initState();
    getHttp(widget.searchParam).then((value) {
      getLocationByPlaceId(value).then((location) {
        setState(() {
          print(location);
          currentLocation = location;
          _animatedMapMove(currentLocation, 15);
        });
      });
    });
    subscription = mapController.mapEventStream.listen((MapEvent mapEvent) {
      if (mapEvent is MapEventMove) {
        setState(() {
          currentLocation = mapEvent.center;
        });
      }
    });
  }

  @override
  void dispose() {
    subscription.cancel();
    mapController.dispose();
    super.dispose();
  }


  Future getHttp(String? centerlocation) async {
    try {
      var response = await Dio().get('https://convenient-way.azurewebsites.net/api/v1.0/goongs',
          queryParameters: {'search' : centerlocation, 'longitude' : 106.6485, 'latitude' : 10.807954});
      String placeid = "";
      placeid = response.data['data']['predictions'][0]['place_id'];
      return placeid;
    } catch (e) {
      print(e);
    }
  }

  Future getLocationByPlaceId(String? placeid) async {
    try {
      var response = await Dio().get('https://convenient-way.azurewebsites.net/api/v1.0/goongs/detail',
          queryParameters: {'placeId' : placeid});
      LatLng coordinate = new LatLng(0, 0);
      coordinate.latitude = response.data['data']['result']['geometry']['location']['lat'];
      coordinate.longitude = response.data['data']['result']['geometry']['location']['lng'];
      return coordinate;
    } catch (e) {
      print(e);
    }
  }

  Future<LatLng> _determinePosition() async {
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

    var mylocation = await Geolocator.getCurrentPosition();
    print(mylocation);

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return LatLng(mylocation.latitude, mylocation.longitude);
  }

  void onPointerDown() {
    // isWaiting.value = true;
  }



  void onPointerUp() async {
    // if (isLoadingPlaceDetail.value) return;
    // await fetchPlaceDetail();
    // isWaiting.value = false;
    debugPrint('${mapController.center.latitude} , ${mapController.center.longitude}');
  }

  void _animatedMapMove(LatLng destLocation, double destZoom) {
    final latTween = Tween<double>(
        begin: mapController.center.latitude, end: destLocation.latitude);
    final lngTween = Tween<double>(
        begin: mapController.center.longitude, end: destLocation.longitude);
    final zoomTween = Tween<double>(begin: mapController.zoom, end: destZoom);
    var controller = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    Animation<double> animation =
    CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn);
    controller.addListener(() {
      mapController.move(
        LatLng(latTween.evaluate(animation), lngTween.evaluate(animation)),
        zoomTween.evaluate(animation),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: const Text('Chọn trên bản đồ'),
      ),
      floatingActionButton:
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            elevation: 0,
            fixedSize: Size(100, 50),
            backgroundColor: kPrimaryColor.withOpacity(1),
          ),
          onPressed: (){
            Navigator.of(context).canPop() ? Navigator.of(context).pop(currentLocation) : {print('Can\'t')};
          },
          child: Text(
            'Lưu',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
      body: HyperStack(
        children: [
          FlutterMap(
            mapController: mapController,
            options: MapOptions(
              interactiveFlags:
                InteractiveFlag.pinchZoom | InteractiveFlag.drag,
                center: currentLocation,
                zoom: 10.5,
                minZoom: 5,
                maxZoom: 18.4,
                slideOnBoundaries: true,
                // onTap: (_, coordinate) {
                //   setState(() {
                //     currentLocation =
                //         LatLng(coordinate.latitude, coordinate.longitude);
                //   });
                //   _animatedMapMove(coordinate, 15);
                //}
                ),
            children: [
              TileLayer(
                urlTemplate:
                "https://api.mapbox.com/styles/v1/full9saoxec/cl9y7t2o3000k15qiljama6h9/tiles/256/{z}/{x}/{y}@2x?access_token={access_token}",
                additionalOptions: {
                  "access_token":
                  "pk.eyJ1IjoiZnVsbDlzYW94ZWMiLCJhIjoiY2w5eTduMHo0MDI4eDNvcWwwbGprbG5jZCJ9.bwl8bUXXggxb-hJ1g-RItQ",
                },
              ),
              // PolylineLayer(
              //   polylineCulling: false,
              //   polylines: [
              //     Polyline(
              //       points: [
              //         LatLng(10.845987, 106.814935),
              //         LatLng(10.845288, 106.815471),
              //         LatLng(10.844549, 106.814421),
              //         LatLng(10.844199, 106.814728),
              //         LatLng(10.844091, 106.814885),
              //         LatLng(10.843695, 106.814411),
              //         LatLng(10.842956, 106.815241),
              //         LatLng(10.839578, 106.812006),
              //         LatLng(10.839529, 106.811947),
              //         LatLng(10.839509, 106.811107),
              //         LatLng(10.839589, 106.810980),
              //         LatLng(10.840311, 106.810192),
              //         LatLng(10.840419, 106.810142),
              //         LatLng(10.840599, 106.810252),
              //         LatLng(10.841065, 106.809775),
              //       ],
              //       strokeWidth: 5,
              //       color: Colors.blueAccent,
              //     ),
              //   ],
              // ),
              CurrentLocationLayer(),
              const Center(
                child: Icon(Icons.location_on, color: Colors.redAccent,),
              ),
              Listener(
                onPointerDown: (_) {
                  onPointerDown();
                },
                onPointerUp: (_) {
                  onPointerUp();
                },
                child: Container(
                  color: Colors.white.withOpacity(0),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () async {
                    print("Pressed");
                    var locationn = await _determinePosition();
                    _animatedMapMove(locationn, 15);
                  },
                  child: const Icon(Icons.my_location),
                ),
              ),
            ],
          ),

          // ElevatedButton(
          //       onPressed: () async {
          //         var currentLocation = await _determinePosition();
          //         // mapController.move(currentLocation, 15);
          //         _animatedMapMove(LatLng(10.845987, 106.814935), 15);
          //       },
          //       child: const Icon(Icons.my_location),
          //     ),
              // ElevatedButton(
              //   onPressed: () async {
              //     var bounds = LatLngBounds();
              //     List<LatLng> ways = [
              //       LatLng(10.845987, 106.814935),
              //       LatLng(10.845288, 106.815471),
              //       LatLng(10.844549, 106.814421),
              //       LatLng(10.844199, 106.814728),
              //       LatLng(10.844091, 106.814885),
              //       LatLng(10.843695, 106.814411),
              //       LatLng(10.842956, 106.815241),
              //       LatLng(10.839578, 106.812006),
              //       LatLng(10.839529, 106.811947),
              //       LatLng(10.839509, 106.811107),
              //       LatLng(10.839589, 106.810980),
              //       LatLng(10.840311, 106.810192),
              //       LatLng(10.840419, 106.810142),
              //       LatLng(10.840599, 106.810252),
              //       LatLng(10.841065, 106.809775),
              //     ];
              //     for (var x in ways) {
              //       bounds.extend(x);
              //     }
              //     bounds.pad(15);
              //     bounds.extend(LatLng(10.835596948004833, 106.8087110514264));
              //     var centerZoom = mapController.centerZoomFitBounds(bounds);
              //     _animatedMapMove(centerZoom.center, 15);
              //   },
              //   child: const Icon(Icons.near_me),
              // ),
            ],
          //),
        //]
      ),
    );
  }
}
