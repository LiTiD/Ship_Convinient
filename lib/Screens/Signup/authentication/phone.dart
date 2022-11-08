import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:shipconvenient/Screens/Welcome/welcome_screen.dart';
import 'package:shipconvenient/Screens/constants.dart';

class checkOtp extends StatefulWidget {
  checkOtp(this.phone, {Key? key}) : super(key: key);
  String? phone;

  @override
  State<checkOtp> createState() => _checkOtpState();
}

class _checkOtpState extends State<checkOtp> {

  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();
  String? verificationCode;
  final TextEditingController _pinputController = TextEditingController();
  final FocusNode _pinputFocusNode = FocusNode();
  final BoxDecoration punPutDecoration = BoxDecoration(
    color: kPrimaryColor,
    borderRadius: BorderRadius.circular(10),
    border: Border.all(
      color: const Color.fromRGBO(126, 203, 224, 1)
    )
  );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _verifyPhone();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldkey,
      appBar: AppBar(
        title: Text('OPT Verification'),
      ),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 40),
            child: Center(
              child: Text(
                'Verifi +84-${widget.phone}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 26,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(30),
            child: Pinput(
              length: 6,
              controller: _pinputController,
              focusNode: _pinputFocusNode,
              pinAnimationType: PinAnimationType.fade,
              onSubmitted: (pin) async {
                try {
                  await FirebaseAuth.instance
                      .signInWithCredential(PhoneAuthProvider.credential(
                      verificationId: verificationCode!, smsCode: pin))
                      .then((value) async {
                    if (value.user != null) {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => WelcomeScreen()),
                        (route) => false);
                    }
                  });
                } catch (e){
                  FocusScope.of(context).unfocus();
                  _scaffoldkey.currentState
                      ?.showBottomSheet((context) => SnackBar(content: Text('invalid OTP')));
                }
              }
            ),
          )
        ],
      ),
    );
  }

  _verifyPhone() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: '+84${widget.phone}',
        verificationCompleted: (PhoneAuthCredential credential) async {
          await FirebaseAuth.instance
              .signInWithCredential(credential)
              .then((value) async {
            if (value.user != null) {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => WelcomeScreen()),
                      (route) => false);
            }
          });
        },
        verificationFailed: (FirebaseAuthException e){
          print(e.message);
        },
        codeSent: (String verificationId, forceResendingToken) {
          setState(() {
            verificationCode = verificationId;
          });
        },
        codeAutoRetrievalTimeout: (String verificationID){
          setState(() {
            verificationCode = verificationID;
          });
        },
        timeout: Duration(seconds: 60));
  }

}
