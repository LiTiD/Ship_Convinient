import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latlong2/latlong.dart';
import 'package:shipconvenient/Screens/Login/login_screen.dart';
import 'package:shipconvenient/Screens/Signup/components/direction.dart';
import 'package:shipconvenient/Screens/Signup/components/gender.dart';
import '../../constants.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({
    Key? key,
  }) : super(key: key);

  @override
  State<SignUpForm> createState() {
    return _SignUpForm();
  }
}

class DropdownItem extends StatefulWidget {
  const DropdownItem({Key? key, required this.callback}) : super(key: key);
  final Function callback;

  @override
  State<DropdownItem> createState() => _DropdownItemState();
}

class _DropdownItemState extends State<DropdownItem> {
  String selectedValue = "Male";

  @override
  Widget build(BuildContext context) {
    return DropdownButton(
      value: selectedValue,
      style: const TextStyle(color: kPrimaryColor, fontSize: 15),
      onChanged: (String? value) {
        setState(() {
          selectedValue = value!;
          widget.callback(value);
        });
      },
      items: dropdownItems,
    );
  }
}

class _SignUpForm extends State<SignUpForm> {
  String _username = "";
  String _password = "";
  String _email = "";
  String _displayname = "";
  String _gender = "";
  String _phone = "";
  String _address = "";
  LatLng? fromLocation;
  LatLng? toLocation;
  final _usernameEditingController = TextEditingController();
  final _passwordEditingController = TextEditingController();
  final _emailEditingController = TextEditingController();
  final _displaynameEditingController = TextEditingController();
  final _phoneEditingController = TextEditingController();
  final _addressEditingController = TextEditingController();

  Future postHttp(
      String username,
      String pass,
      String email,
      String displayname,
      String phone,
      String image,
      String address,
      String gender,
      String fromLong,
      String fromLat,
      String toLong,
      String toLat) async {
    try {
      var response = await Dio().post(
          'https://convenient-way.azurewebsites.net/api/v1.0/shippers/register',
          data: {
            'userName': username,
            'password': pass,
            "email": email,
            "displayName": displayname,
            "phoneNumber": phone,
            "photoUrl": image,
            "status": "DEFAULT",
            "address": address,
            "gender": gender,
            "homeLongitude": fromLong,
            "homeLatitude": fromLat,
            "destinationLongitude": toLong,
            "destinationLatitude": toLat,
          });
      return response.data['success'];
    } catch (e) {
      print(e);
    }
  }

  void setGender(String value) {
    _gender = value;
    print(_gender);
  }

  File? image = null;

  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);

      if (image == null) return;

      final imageTemp = File(image.path);

      setState(() => this.image = imageTemp);
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.only(bottom: 15),
          child: Text(
            'Đăng ký',
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              color: kPrimaryColor,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: SizedBox(
            height: 50,
            child: TextFormField(
              controller: _usernameEditingController,
              onChanged: (text) {
                _username = text;
              },
              textInputAction: TextInputAction.next,
              cursorColor: kPrimaryColor,
              decoration: const InputDecoration(
                labelText: "Tài khoản",
                contentPadding: EdgeInsets.symmetric(
                    horizontal: defaultPadding, vertical: defaultPadding),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                  borderSide: BorderSide(color: Colors.black, width: 0.0),
                ),
                prefixIcon: Icon(Icons.person),
                //  ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: SizedBox(
            height: 50,
            child: TextFormField(
              controller: _passwordEditingController,
              onChanged: (text) {
                _password = text;
              },
              obscureText: true,
              cursorColor: kPrimaryColor,
              decoration: const InputDecoration(
                labelText: "Mật khẩu",
                contentPadding: EdgeInsets.symmetric(
                    horizontal: defaultPadding, vertical: defaultPadding),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                  borderSide: BorderSide(color: Colors.black, width: 0.0),
                ),
                prefixIcon: Icon(Icons.lock),
                //  ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: SizedBox(
            height: 50,
            child: TextFormField(
              controller: _emailEditingController,
              onChanged: (text) {
                _email = text;
              },
              cursorColor: kPrimaryColor,
              decoration: const InputDecoration(
                labelText: "Email",
                contentPadding: EdgeInsets.symmetric(
                    horizontal: defaultPadding, vertical: defaultPadding),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                  borderSide: BorderSide(color: Colors.black, width: 0.0),
                ),
                prefixIcon: Icon(Icons.mail),
                //  ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: SizedBox(
            height: 50,
            child: TextFormField(
              controller: _displaynameEditingController,
              onChanged: (text) {
                _displayname = text;
              },
              cursorColor: kPrimaryColor,
              decoration: const InputDecoration(
                labelText: "Tên hiển thị",
                contentPadding: EdgeInsets.symmetric(
                    horizontal: defaultPadding, vertical: defaultPadding),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                  borderSide: BorderSide(color: Colors.black, width: 0.0),
                ),
                prefixIcon: Icon(Icons.perm_contact_cal),
                //  ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: SizedBox(
            height: 50,
            child: TextFormField(
              controller: _phoneEditingController,
              onChanged: (text) {
                _phone = text;
              },
              cursorColor: kPrimaryColor,
              decoration: const InputDecoration(
                labelText: "Số điện thoại",
                contentPadding: EdgeInsets.symmetric(
                    horizontal: defaultPadding, vertical: defaultPadding),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                  borderSide: BorderSide(color: Colors.black, width: 0.0),
                ),
                prefixIcon: Icon(Icons.phone),
                //  ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Row(
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 12),
                child: Icon(
                  Icons.location_history,
                  color: kPrimaryColor,
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 20),
                child: Text(
                  'Tuyến đường:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: kPrimaryColor,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: SizedBox(
                  width: 40,
                  height: 40,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: const BorderRadius.all(Radius.circular(5)),
                    ),
                    child: IconButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => Direction())
                        ).then((value) {
                          fromLocation = value[0] as LatLng;
                          toLocation = value[1] as LatLng;
                          _address = value[2] as String;
                        });
                      },
                      icon: const Icon(Icons.location_on),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Row(
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 12),
                child: Icon(
                  Icons.image,
                  color: kPrimaryColor,
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 20),
                child: Text(
                  'Ảnh',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: kPrimaryColor,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: SizedBox(
                  width: 40,
                  height: 40,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: const BorderRadius.all(Radius.circular(5)),
                    ),
                    child: IconButton(
                      onPressed: () {
                        pickImage();
                      },
                      icon: const Icon(Icons.collections),
                    ),
                  ),
                ),
              ),
              // Container(
              //   margin: EdgeInsets.all(5),
              //   height: 60.0,
              //   width: 60.0,
              //   decoration: BoxDecoration(
              //     borderRadius: BorderRadius.circular(50),
              //     //set border radius to 50% of square height and width
              //     image: DecorationImage(
              //       image: FileImage(image!) ? FileImage(image!) : SizedBox(),
              //       fit: BoxFit.cover, //change image fill type
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
        Row(
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 12),
              child: Icon(
                Icons.person,
                color: kPrimaryColor,
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 20),
              child: Text(
                'Giới tính',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: kPrimaryColor,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: DropdownItem(
                callback: setGender,
              ),
            ),
          ],
        ),
        const SizedBox(height: defaultPadding / 2),
        ElevatedButton(
          onPressed: () async {
            if (_username == "" ||
                _password == "" ||
                _email == "" ||
                _displayname == "" ||
                _phone == "" ||
                //_image == "" ||
                _address == "" ||
                _gender == "") {
              await Fluttertoast.showToast(
                  msg:
                      "Đăng ký không thành công!\nVui lòng nhập đầu đủ thông tin!",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0);
            } else if (fromLocation == null || toLocation == null) {
              // Fluttertoast.showToast(
              //     msg: "Đăng ký thành công!",
              //     toastLength: Toast.LENGTH_SHORT,
              //     gravity: ToastGravity.CENTER,
              //     backgroundColor: Colors.red,
              //     textColor: Colors.white,
              //     fontSize: 16.0
              // );
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return const Direction();
                  },
                ),
              ).then((value) {
                fromLocation = value[0] as LatLng;
                toLocation = value[1] as LatLng;
                _address = value[2] as String;
              });
            } else if (fromLocation != null && toLocation != null) {
              if (await postHttp(
                      _username,
                      _password,
                      _email,
                      _displayname,
                      _phone,
                      image!.path.toString(),
                      _address,
                      _gender,
                      fromLocation!.longitude.toString(),
                      fromLocation!.latitude.toString(),
                      toLocation!.longitude.toString(),
                      toLocation!.latitude.toString()) ==
                  true) {
                await Fluttertoast.showToast(
                    msg: "Đăng ký thành công!",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.CENTER,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                    fontSize: 16.0);
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => LoginScreen()));
              }
            }
          },
          style: ElevatedButton.styleFrom(
            shape: const StadiumBorder(),
            maximumSize: const Size(double.infinity, 56),
            minimumSize: const Size(double.infinity, 56),
          ),
          child: Text("Sign Up".toUpperCase()),
        ),
        const SizedBox(height: defaultPadding),
      ],
    );
  }
}
