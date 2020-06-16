import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pluginCG/Mainsection/MainScreen.dart';
import 'package:pluginCG/resources/Logo.dart' as logo;
import 'package:pluginCG/resources/Color.dart' as colors;
import 'package:pluginCG/resources/warning.dart' as alert;
import 'package:pluginCG/Globals/Globals.dart' as globals;
import 'PersonalInfo.dart';

class NewTest extends StatefulWidget {
  final testName;
  NewTest({Key key, this.testName}) : super(key: key);

  @override
  _NewTestState createState() => _NewTestState();
}

class _NewTestState extends State<NewTest> {
  String date = "Date", time = "Time";//, testName = "";
  DateTime _todayDate;
  String name;
  int years, months, days, hours, minutes;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: colors.pBlue,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: logo.logo(),
        actions: <Widget>[
          IconButton(
              icon: Icon(
                Icons.person,
                color: Colors.white,
                size: 30,
              ),
              onPressed: () {
                var route = MaterialPageRoute(builder: (_) => PersonalInfo());
                Navigator.push(context, route);
              })
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
            child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 25, right: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                height: 40,
                width: width,
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.only(top: 10, right: 25, left: 25),
                padding: EdgeInsets.only(left: 10),
                decoration:
                    BoxDecoration(border: Border.all(color: colors.pBlue)),
                child: Text("${widget.testName}")),
            Container(
              margin: EdgeInsets.only(top: 10, right: 25, left: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  InkWell(
                    onTap: () {
                      pickDateTime(
                          context, CupertinoDatePickerMode.date, "date");
                    },
                    child: dateTimeCon(width, "$date"),
                  ),
                  InkWell(
                    onTap: () {
                      pickDateTime(
                          context, CupertinoDatePickerMode.time, "time");
                    },
                    child: dateTimeCon(width, "$time"),
                  ),
                ],
              ),
            ),
            Container(
              alignment: Alignment.centerRight,
              margin: EdgeInsets.only(top: 10, right: 25),
              child: FlatButton(
                  color: colors.pCyan,
                  onPressed: ()async {
                    print(globals.uid);
                    if (date == "Date") {
                      alert.showWarning(
                          "Alert", "please Enter Date", context, Colors.red);
                    } else if (time == "Time") {
                      alert.showWarning(
                          "Alert", "please Enter Time", context, Colors.red);
                    } else {
                      var mili = DateTime(this.years, this.months, this.days,
                              this.hours, this.minutes)
                          .millisecondsSinceEpoch;
                      String min = ((mili / 1000) / 60).round().toString();
                    await  Firestore.instance
                          .collection("tests")
                          .document("${globals.uid}")
                          .collection("${globals.uid}")
                          .document()
                          .setData({
                        "testName": "${widget.testName}",
                        "date": "$date",
                        "time": "$time",
                        "testTimeStamp": "$min",
                        "remind_1": false,
                        "remind_1_date": "",
                        "remind_1_time": "",
                        "remind_1_timeStamp": "",
                        "remind_2": false,
                        "remind_2_date": "",
                        "remind_2_time": "",
                        "remind_2_timeStamp": "",
                      }).whenComplete(() {
                        var newRoute = MaterialPageRoute(
                            builder: (context) => MainScreen());
                        Navigator.pushAndRemoveUntil(
                            context, newRoute, (route) => false);
                      });
                    }
                  },
                  child: Text("Confirm",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.3))),
            ),
            bigContainers("Scheduled Tests", ["No Scheduled tests"], 200)
          ],
        )),
      ),
    );
  }

  dateTimeCon(double width, String content) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.only(left: 10),
      width: width / 2.4,
      height: 40,
      decoration: BoxDecoration(border: Border.all(color: colors.pBlue)),
      child: Text("$content"),
    );
  }

  bigContainers(String hText, List<String> bText, double bheight) {
    return Container(
        decoration:
            BoxDecoration(border: Border.all(width: 1, color: colors.pBlue)),
        margin: EdgeInsets.only(left: 25, right: 25, top: 20),
        height: bheight,
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
            Container(
              height: bheight - 37,
              alignment: Alignment.center,
              child: ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: bText.length,
                itemBuilder: (BuildContext context, int index) {
                  return Text("  ${bText[index]}");
                },
              ),
            ),
          ],
        ));
  }

  pickDateTime(context, var mode, String type) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return SizedBox(
            height: 200,
            child: CupertinoDatePicker(
              mode: mode,
              initialDateTime: _todayDate,
              minimumDate: DateTime(
                1900,
              ),
              use24hFormat: false,
              onDateTimeChanged: (dateTime) {
                String amPm, hours;
                if (type == "time") {
                  this.hours = dateTime.hour;
                  this.minutes = dateTime.minute;
                  if (dateTime.hour < 13) {
                    hours = dateTime.hour.toString();
                    amPm = "AM";
                  } else {
                    amPm = "PM";
                    hours = (dateTime.hour.toInt() - 12).toString();
                  }
                }
                setState(() {
                  if (type == "date") {
                    this.years = dateTime.year;
                    this.months = dateTime.month;
                    this.days = dateTime.day;
                    date = dateTime.year.toString() +
                        " - " +
                        dateTime.month.toString() +
                        " - " +
                        dateTime.day.toString();
                  } else {
                    time =
                        hours + " : " + dateTime.minute.toString() + " " + amPm;
                  }
                });
              },
            ),
          );
        });
  }
}
