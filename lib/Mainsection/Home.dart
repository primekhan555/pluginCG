import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdownfield/dropdownfield.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pluginCG/resources/Color.dart' as colors;
import 'package:pluginCG/Globals/Globals.dart' as globals;
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<String> cities = [
    'HeadAche',
    'Fever',
    'Cold',
    'backpain',
  ];
  String stream;
  SharedPreferences prefs;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
          body: SingleChildScrollView(
              child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(left: 25, right: 25, top: 15),
            height: 35,
            width: width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: width / 1.32,
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Search Diseases...",
                      suffixIcon: Icon(
                        Icons.search,
                        size: 30,
                        color: colors.pBlue,
                      ),
                    ),
                  ),
                ),
                Container(
                  width: width / 10,
                  child: IconButton(
                    icon: FaIcon(
                      FontAwesomeIcons.solidBell,
                      color: colors.pBlue,
                    ),
                    onPressed: () {},
                  ),
                )
              ],
            ),
          ),
          Container(
              margin: EdgeInsets.only(left: 25, right: 25, top: 20),
              decoration: BoxDecoration(
                  border: Border.all(width: 1, color: colors.pBlue)),
              child: DropDownField(
                required: false,
                hintText: 'Diseases',
                items: cities,
                strict: false,
                onValueChanged: (value) {
                  print(value.toString());
                },
              )),
          bigContainers("Scheduled Tests", "No Scheduled tests", "tests",width),
          bigContainers("Health Tips", "No tips yet", "tips",width),
        ],
      ))),
    );
  }

  bigContainers(String hText, String bText, String type,double width) {
    return Container(
        decoration:
            BoxDecoration(border: Border.all(width: 1, color: colors.pBlue)),
        margin: EdgeInsets.only(left: 25, right: 25, top: 20),
        height: type == "tests" ? 155 : 300,
        child: Column(
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(left: 10),
              color: colors.pBlue,
              height: 35,
              child: Text(
                "$hText",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.3),
              ),
            ),
            type == "tests"
                ? Container(
                    height: 115,
                    child: StreamBuilder<QuerySnapshot>(
                      stream: Firestore.instance
                          .collection("tests")
                          .document("${globals.uid}")
                          .collection("${globals.uid}")
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasData) {
                          return Container(
                            height: 30,
                            child: ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount:snapshot.data.documents.length>5? 5:snapshot.data.documents.length,
                                itemBuilder: (BuildContext context, int index) {
                                  var data = snapshot.data.documents;
                                  return Container(
                                      padding: EdgeInsets.only(
                                          left: 10, right: 10, bottom: 7),
                                      child: Row(
                                        children: <Widget>[
                                          Container(
                                            width: width/3,
                                            child: Text(
                                                "${data[index]["testName"]}",overflow: TextOverflow.ellipsis,),
                                          ),
                                          Container(
                                            width: width/4.5,
                                            child: Text(
                                                "${data[index]["date"]}"),
                                          ),
                                          Container(
                                            alignment: Alignment.centerRight,
                                            width: width/4.5,
                                            child: Text(
                                                "${data[index]["time"]}"),
                                          ),
                                        ],
                                      ));
                                }),
                          );
                        } else {
                          return Center(child: CircularProgressIndicator());
                        }
                      },
                    ),
                  )
                : Container(
                    child: StreamBuilder<DocumentSnapshot>(
                      stream: Firestore.instance
                          .collection("HealthTip")
                          .document("BF5Pm7AQoWlp2wnR4uiw")
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<DocumentSnapshot> snapshot) {
                        if (snapshot.hasData) {
                          return Container(
                            padding: EdgeInsets.only(left: 5, right: 5, top: 5),
                            child: Text("${snapshot.data["tip"]}"),
                          );
                        }
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      },
                    ),
                  )
          ],
        ));
  }
}
