import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_multi_select_items/flutter_multi_select_items.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:shipconvenient/Screens/constants.dart';
import 'package:shipconvenient/components/hyper_stack.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:dio/dio.dart';
import 'package:shipconvenient/dto/package.dart';

class Booking extends StatefulWidget {
  Booking(this.line, this.package, {Key? key}) : super(key: key);
  final List<LatLng>? line;
  final List<Packages>? package;

  @override
  State<Booking> createState() => _BookingState();
}

class _BookingState extends State<Booking> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: MapBoxs(widget.line!,widget.package!));
  }
}

class MapBoxs extends StatefulWidget {
  MapBoxs(this.line, this.package, {Key? key}) : super(key: key);
  final List<LatLng>? line;
  final List<Packages>? package;

  @override
  State<MapBoxs> createState() => _MapBoxsState();
}

class _MapBoxsState extends State<MapBoxs> with TickerProviderStateMixin {
  final pageController = PageController();
  int selectedIndex = 0;
  var currentLocation = LatLng(10.84110651757115, 106.80988299716103);
  late StreamSubscription<MapEvent> subscription;
  late MapController mapController = MapController();

  List<LatLng> list = [];

  @override
  void initState() {
    //print('${widget.line}');
    for (var x in widget.line!) {
      list.add(x);
      print(x);
    }
    print(list);
    super.initState();
    setState(() {
      //_animatedMapMove(currentLocation, 15);
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
    debugPrint(
        '${mapController.center.latitude} , ${mapController.center.longitude}');
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
        title: const Text('Lựa chọn đơn hàng'),
      ),
      floatingActionButton: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          fixedSize: Size(150, 50),
          backgroundColor: kPrimaryColor.withOpacity(1),
        ),
        onPressed: () {
          widget.line!.clear();
          Navigator.of(context).canPop()
              ? Navigator.of(context).pop()
              : {print('Can\'t')};
        },
        child: Text(
          'Xác nhận',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 7,
            child: FlutterMap(
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
                  MarkerLayer(
                    markers: [
                      Marker(
                          point: widget.line![0], // Shipper From
                          builder: (_) {
                            return Icon(
                              Icons.home,
                              size: 20,
                            );
                          }),
                      Marker(
                          point: widget.line![1], // Shipper To
                          builder: (_) {
                            return Icon(
                              Icons.school,
                              size: 20,
                            );
                          }),
                      Marker(
                          point: widget.line![2], // Shop
                          builder: (_) {
                            return Icon(
                              Icons.shopping_bag_rounded,
                              size: 20,
                            );
                          }),
                      for (int i = 3; i < widget.line!.length; i++)
                        Marker(
                            point: widget.line![i], // Package To
                            builder: (_) => Icon(Icons.location_on, size: 20))
                    ],
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
                  // const Center(
                  //   child: Icon(
                  //     Icons.location_on,
                  //     color: Colors.redAccent,
                  //   ),
                  // ),
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
                  // Padding(
                  //   padding: const EdgeInsets.all(8.0),
                  //   child: ElevatedButton(
                  //     onPressed: () async {
                  //       print("Pressed");
                  //       var locationn = await _determinePosition();
                  //       _animatedMapMove(locationn, 15);
                  //     },
                  //     child: const Icon(Icons.my_location),
                  //   ),
                  // ),
                ]),
          ),
          Expanded(
              flex: 4,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: [
                    MultiSelectCheckList(
                      textStyles: const MultiSelectTextStyles(
                          selectedTextStyle: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold)),
                      itemsDecoration: MultiSelectDecorations(
                          selectedDecoration:
                          BoxDecoration(color: Colors.indigo.withOpacity(0.8))),
                      listViewSettings: ListViewSettings(
                          separatorBuilder: (context, index) => const Divider(
                            height: 0,
                          )),
                      //controller: _controller,
                      items: List.generate(
                          widget.package!.length,
                              (index) => CheckListCard(
                              value: index,
                              title: Text('Gửi cho : ${widget.package![index].receiverName.toString()}'),
                              subtitle: Text('Trọng lượng đơn hàng: ${widget.package![index].weight.toString()}Kg'),
                              selectedColor: Colors.white,
                              checkColor: Colors.indigo,
                              checkBoxBorderSide:
                              const BorderSide(color: Colors.blue),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5)))),
                      onChange: (allSelectedItems, selectedItem) {
                      },
                    )
                  ],
                ),
              ))

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
