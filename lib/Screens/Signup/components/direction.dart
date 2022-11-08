import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:shipconvenient/Screens/Home/home_screen.dart';
import 'package:shipconvenient/Screens/Login/login_screen.dart';
import 'package:shipconvenient/Screens/Signup/components/signup_form.dart';
import 'package:shipconvenient/Screens/Signup/signup_screen.dart';
import 'package:shipconvenient/Screens/constants.dart';

class Direction extends StatefulWidget {
  const Direction({Key? key}) : super(key: key);

  @override
  State<Direction> createState() => _DirectionState();
}

class _DirectionState extends State<Direction> {

  late String _from = "";
  late String _to = "";
  var fromLocation;
  var toLocation;
  final _fromEditingController = TextEditingController();
  final _toEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chọn lộ trình'),
        backgroundColor: kPrimaryColor,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15, top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 300,
                    height: 60,
                    child: TextField(
                      controller: _fromEditingController,
                      onChanged: (context) {
                        _from = context;
                      },
                      decoration: const InputDecoration(
                        labelText: 'Điểm đi',
                        border: OutlineInputBorder(
                            borderSide: BorderSide(width: 1)),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: SizedBox(
                      width: 60,
                      height: 60,
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          borderRadius: const BorderRadius.all(Radius.circular(5)),
                        ),
                        child: IconButton(
                          onPressed: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                                  return HomePage(_from);
                                })).then((value) {
                                  setState(() {
                                    fromLocation = value as LatLng;
                                  });
                            });
                          },
                          icon: const Icon(Icons.my_location_sharp),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15, top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 300,
                    height: 60,
                    child: TextField(
                      controller: _toEditingController,
                      onChanged: (context) {
                        _to = context;
                      },
                      decoration: const InputDecoration(
                        labelText: 'Điểm đến',
                        border: OutlineInputBorder(
                            borderSide: BorderSide(width: 1)),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: SizedBox(
                      width: 60,
                      height: 60,
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          borderRadius: const BorderRadius.all(Radius.circular(5)),
                        ),
                        child: IconButton(
                          onPressed: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                                  return HomePage(_to);
                                })).then((value) {
                                  setState(() {
                                    toLocation = value as LatLng;
                                  });
                            });
                          },
                          icon: const Icon(Icons.my_location_sharp),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15, top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    '* Nhấn vào',
                    style: TextStyle(fontSize: 20),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 5, right: 5),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        borderRadius: const BorderRadius.all(Radius.circular(5)),
                      ),
                      child: const SizedBox(
                        height: 35,
                        width: 35,
                        child: Icon(Icons.my_location_sharp),
                      ),
                    ),
                  ),
                  const Text(
                    'để chọn trên bản đồ.',
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: SizedBox(
                height: 50,
                width: 130,
                child: ElevatedButton(
                  onPressed: () {
                    _showMyDialog();
                  },
                  child: const Text(
                    'XÁC NHẬN',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Xác nhận lộ trình!'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('Bạn muốn lưu lại lộ trình đã chọn?'),
              ],
            ),
          ),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: SizedBox(
                width: 80,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 40),
                  ),
                  child: const Text('Có'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop([fromLocation, toLocation, _from]);
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: SizedBox(
                width: 80,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 40),
                  ),
                  child: const Text('Không'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
