import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:latlong2/latlong.dart';
import 'package:shipconvenient/Screens/Main/page/components/booking.dart';
import 'package:shipconvenient/dto/package.dart';

class Dashboard extends StatefulWidget {
  Dashboard(this.token, {Key? key}) : super(key: key);
  final String? token;

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {

  int? indexTmp;

  Future getCombo(String shipper) async {
    try {
      print(shipper);
      List<Combo> result = [];
      var response = await Dio().get(
          'https://convenient-way.azurewebsites.net/api/v1.0/packages/combos',
          queryParameters: {
            "shipperId": shipper,
            'pageIndex': "0",
            "pageSize": "20"
          });
      var packages = response.data['data'];
      print(packages);
      for (var e in packages) {
        result.add(Combo.fromJson(e));
      }
      return result;
    } catch (e) {
      print(e);
    }
  }

  List<Combo>? combo  = [];

  @override
  void initState() {
    // TODO: implement initState
    Map<String, dynamic> payload = Jwt.parseJwt(widget.token!);
    String id = payload['id'];
    getCombo(id).then((value) {
      setState(() {
        combo = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> payload = Jwt.parseJwt(widget.token ?? "");
    String id = payload['id'];
    final List<LatLng> line = [];
    final List<Packages> packages = [];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Đơn hàng đề xuất'),
        backgroundColor: const Color(0x55fa5555),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10, top: 30, bottom: 10),
              child: Text(
                'Danh sách shop:',
                //shop![1].displayName.toString(),
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              itemBuilder: (context, index) {
                indexTmp = index;
                return Column(
                  children: [
                    SizedBox(
                      width: 400,
                      height: 130,
                      child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: InkWell(
                            onTap: () {
                              line.add(LatLng(10.7674, 106.6939));
                              line.add(LatLng(10.840980909890826, 106.80984443092646));
                              line.add(LatLng(combo![index].shop!.latitude!, combo![index].shop!.longitude!));
                              for(var x in combo![index].packages!){
                                line.add(LatLng(x.destinationLatitude!,x.destinationLongitude!));
                              }
                              for(var x in combo![index].packages!){
                                packages.add(x);
                              }
                              Navigator.of(context).push(
                                MaterialPageRoute(builder: (context) {
                                  return Booking(line, packages);
                                }));
                            },
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                  color: Colors.black12,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15))),
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Icon(Icons.arrow_downward),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 14, bottom: 8),
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          child: Text(
                                            combo![index].shop!.displayName.toString(),
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: 12,
                                            ),
                                            maxLines: 2,
                                          ),
                                          width: 200,
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 18.0),
                                          child: SizedBox(
                                            child: Text(
                                              combo![index].shop!.address.toString(),
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontSize: 12,
                                              ),
                                              maxLines: 2,
                                            ),
                                            width: 200,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 14),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Có ${combo![index].packages!.length.toString()} đơn hàng',
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          )),
                    ),
                  ],
                );
              },
              itemCount: combo!.length,
            )
          ],
        ),
      ),
    );
  }
}
