import 'package:flutter/material.dart';
import 'package:pluginCG/Screens/SignIn.dart';
import 'package:pluginCG/resources/Color.dart' as colors;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pluginCG/Globals/Globals.dart' as globals;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pluginCG/resources/Logo.dart' as logo;
import 'package:share/share.dart';

class DrawerC extends StatefulWidget {
  DrawerC({Key key}) : super(key: key);

  @override
  _DrawerCState createState() => _DrawerCState();
}

class _DrawerCState extends State<DrawerC> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body:SingleChildScrollView(
        child: Container(
          alignment: Alignment.topCenter,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                height: 270,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/panel.png"),
                        fit: BoxFit.fill)),
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(
                        top: 40,
                        right: 10,
                      ),
                      height: 80,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Padding(
                              padding: EdgeInsets.only(right: width / 7),
                              child: logo.logo()),
                          InkWell(
                            onTap: () => Navigator.pop(context),
                            child: Icon(
                              Icons.close,
                              size: 35,
                              color: colors.pWhite,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      alignment: Alignment.topCenter,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                              color: colors.pWhite,
                              border: Border.all(width: 1, color: colors.pBlue),
                              borderRadius: BorderRadius.circular(10)),
                          margin: EdgeInsets.only(top: 30),
                          height: 100,
                          width: 100,
                          child: globals.lUrl == ""
                              ? Icon(
                                  Icons.person,
                                  size: 70,
                                  color: colors.pBlue,
                                )
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.network(globals.lUrl,fit: BoxFit.cover,),
                                ),
                        ),
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      alignment: Alignment.center,
                      height: 25,
                      child: Text(
                        "${globals.lName}",
                        style: TextStyle(
                            color: colors.pWhite,
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.5),
                      ),
                    ),
                  ],
                ),
              ),
              
                    text("Home"),
                    text("Contact Us"),
                    InkWell(
                      onTap: () => _share(context, "www.google.com", "welcome to the plugincg"),
                      child: text("Share"),
                    ),
                    
                    text("Invite Friends"),
                    text("Follow Us"),
                    text("About"),
                    Divider(
                      color: colors.pBlue,
                      indent: 20,
                      endIndent: 20,
                      thickness: 2,
                    ),
                  
              SizedBox(
                height: height / 4.19,
              ),
              InkWell(
                onTap: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  prefs.remove("fullRegister");
                  prefs.remove("partialRegister");
                  prefs.setString("uid", "");
                  _auth.signOut();
                  globals.lEmail = "";
                  globals.lName = "";
                  globals.lUrl = "";
                  globals.uid = "";
                  var newroute = MaterialPageRoute(builder: (_) => SignIn());
                  Navigator.pushAndRemoveUntil(
                      context, newroute, (route) => false);
                },
                child: Container(
                  child: Align(
                    alignment: FractionalOffset.bottomCenter,
                    child: Container(
                      color: colors.pBlue,
                      height: 70,
                      alignment: Alignment.center,
                      child: Text(
                        "SIGN OUT",
                        style: TextStyle(
                            color: colors.pWhite,
                            fontWeight: FontWeight.w900,
                            fontSize: 17),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  text(String value) {
    return Container(
      padding: EdgeInsets.only(top: 15.0, left: 20),
      child: Text(
        "$value",
        style: TextStyle(
          fontWeight: FontWeight.w900,
          letterSpacing: 1.3,
          fontSize: 14,
        ),
      ),
    );
  }
  _share(BuildContext context, String url, String descrip) {
    final RenderBox box = context.findRenderObject();
    Share.share(
      url,
      subject: descrip,
      sharePositionOrigin: box.globalToLocal(Offset.zero) & box.size,
    );
  }
}
