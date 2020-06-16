import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pin_input_text_field/pin_input_text_field.dart';
import 'package:pluginCG/Components/AButton.dart';
import 'package:pluginCG/Components/LogoText.dart';
import 'package:pluginCG/Mainsection/MainScreen.dart';
import 'package:pluginCG/Screens/SignIn.dart';
import 'package:pluginCG/Screens/UserInformation.dart';
import 'package:pluginCG/resources/Color.dart' as colors;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pluginCG/Globals/Globals.dart' as globals;
import 'package:shared_preferences/shared_preferences.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class PinVerification extends StatefulWidget {
  final number;
  PinVerification({Key key, this.number}) : super(key: key);

  @override
  _PinVerificationState createState() => _PinVerificationState();
}

class _PinVerificationState extends State<PinVerification> {
  final _smsController = TextEditingController();

  @override
  void initState() {
    _verifyPhoneNumber();
    super.initState();
  }

  String _verificationId;
  void _verifyPhoneNumber() async {
    final PhoneVerificationCompleted verificationCompleted =
        (AuthCredential phoneAuthCredential) {
      debugPrint("verification completed called");
      _auth.signInWithCredential(phoneAuthCredential).whenComplete(() {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MainScreen(),
          ),
        );
      });
    };

    final PhoneVerificationFailed verificationFailed =
        (AuthException authException) {
      debugPrint("verification failed");
    };

    final PhoneCodeSent codeSent =
        (String verificationId, [int forceResendingToken]) async {
      debugPrint("code sended to the number");
      SnackBar(
        content: Text("Please check your phone for the verification code"),
      );
      _verificationId = verificationId;
    };

    final PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationId) {
      debugPrint("auto retreival called");
      _verificationId = verificationId;
    };
    await _auth.verifyPhoneNumber(
        phoneNumber: widget.number,
        timeout: const Duration(seconds: 50),
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
  }

  void _signInWithPhoneNumber() async {
    debugPrint("this is the code ${_smsController.text}");
    final AuthCredential credential = PhoneAuthProvider.getCredential(
      verificationId: _verificationId,
      smsCode: _smsController.text,
    );
    // final FirebaseUser user =
    await _auth.signInWithCredential(credential).then((currentUser)async {
      globals.uid=currentUser.user.uid;
      SharedPreferences prefs= await SharedPreferences.getInstance();
      prefs.setString("uid", "${currentUser.user.uid}");
       Firestore.instance
          .collection("users")
          .document("${currentUser.user.uid}")
          .get()
          .then((value) {
            if (value.exists) {
               navigate(context, MainScreen());
            }
            else
        navigate(
            context,
            UserInformation(
              data: [1, 2, 3],
            ));
          });   
      return currentUser.user;
    });
  }

  navigate(BuildContext context, Widget screen) {
    var newRoute = MaterialPageRoute(builder: (context) => screen);
    Navigator.pushAndRemoveUntil(context, newRoute, (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: colors.pBlue,
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                LogoText(
                  margin: height / 10,
                  padding: height / 5,
                ),
                text("NUMBER VERIFICATION", FontWeight.w900, 26, 1.2),
                text("Waiting to automatically detect an SMS sent to",
                    FontWeight.normal, 11, 1),
                text("+923*********", FontWeight.w900, 12, 1.2),
                Container(
                  padding: EdgeInsets.only(left: width / 3, right: width / 3),
                  margin: EdgeInsets.only(top: 25),
                  child: PinInputTextField(
                    onChanged: (value) {
                      if (value.length == 6) {
                        _signInWithPhoneNumber();
                      }
                    },
                    controller: _smsController,
                    enabled: true,
                    pinLength: 6,
                    keyboardType: TextInputType.phone,
                    autoFocus: false,
                    decoration: UnderlineDecoration(
                      textStyle: TextStyle(color: Colors.white, fontSize: 18),
                      color: Colors.white,
                      gapSpaces: [2, 2, 10, 2, 2],
                      obscureStyle: ObscureStyle(
                        isTextObscure: false,
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 20),
                  height: 20,
                  child: Divider(
                    color: Colors.white,
                    indent: width / 3.2,
                    endIndent: width / 3.2,
                    thickness: 0.5,
                  ),
                ),
                text("Enter the 6-digit code", FontWeight.normal, 12, 1),
                Container(
                  margin: EdgeInsets.only(top: height / 4.55),
                  child: AButton(
                    color: colors.pCyan,
                    hei: height / 9,
                    name: "Try Again",
                    screen: SignIn(),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  text(String value, FontWeight fontWeight, double fontSize,
      double letterSpacing) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Text(
        "$value",
        style: TextStyle(
            color: Colors.white,
            fontWeight: fontWeight,
            fontSize: fontSize,
            letterSpacing: letterSpacing),
      ),
    );
  }
}
