import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shipconvenient/Screens/Home/home_screen.dart';
import 'package:shipconvenient/Screens/Main/main_screen.dart';
import '../../constants.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({
    Key? key,
  }) : super(key: key);

  @override
  State<LoginForm> createState(){
    return _LoginForm();
  }

}

class _LoginForm extends State<LoginForm> {

  var token;
  String _email = "";
  String _password = "";
  final _emailEditingController = TextEditingController();
  final _passwordEditingController = TextEditingController();

  Future postHttp(String email, String pass) async {
    try {
      var response = await Dio().post('https://convenient-way.azurewebsites.net/api/v1.0/authorizes?isShop=false&isShipper=true&isAdmin=false', data: {'userName' : email, 'password' : pass});
      return response.data['data']['token'];
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        child: Column(
          children: [
            TextField(
              controller: _emailEditingController,
              onChanged: (text){
                _email = text;
              },
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              cursorColor: kPrimaryColor,
              decoration: const InputDecoration(
                labelText: "Username",
                contentPadding: EdgeInsets.symmetric(
                    horizontal: defaultPadding, vertical: defaultPadding),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                  borderSide: BorderSide(color: Colors.black, width: 0.0),
                ),
                prefixIcon: Padding(
                  padding: EdgeInsets.all(defaultPadding),
                  child: Icon(Icons.person),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: defaultPadding),
              child: TextField(
                controller: _passwordEditingController,
                onChanged: (text){
                  _password = text;
                },
                textInputAction: TextInputAction.done,
                obscureText: true,
                cursorColor: kPrimaryColor,
                decoration: const InputDecoration(
                  labelText: "Password",
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: defaultPadding, vertical: defaultPadding),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                    borderSide: BorderSide(color: Colors.black, width: 0.0),
                  ),
                  //hintText: ,
                  prefixIcon: Padding(
                    padding: EdgeInsets.all(defaultPadding),
                    child: Icon(Icons.lock),
                  ),
                ),
              ),
            ),
            const SizedBox(height: defaultPadding),
            Hero(
              tag: "login_btn",
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: const StadiumBorder(),
                  maximumSize: const Size(double.infinity, 56),
                  minimumSize: const Size(double.infinity, 56),
                ),
                onPressed: () async{
                  token = await postHttp(_email, _password);
                  if(_email=="" || _password==""){
                    Fluttertoast.showToast(
                        msg: "LOGIN FAIL\n Username or Password wrong \n Please try again! ",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 16.0
                    );
                  }
                  if(token == false){
                    Fluttertoast.showToast(
                        msg: "LOGIN FAIL\n Username or Password wrong \n Please try again! ",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 16.0
                    );
                  } else
                    if (token != null)
                  {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return MainPage(token);
                        },
                      ),
                    );
                  }
                },
                child: Text(
                  "Login".toUpperCase(),
                ),
              ),
            ),
            const SizedBox(height: defaultPadding),
          ],
        )
    );
  }
}