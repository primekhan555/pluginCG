import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pluginCG/Mainsection/MergeScreen.dart';
import 'package:pluginCG/resources/Color.dart' as colors;
import 'package:pluginCG/Globals/Globals.dart' as globals;

class Remainders extends StatefulWidget {
  Remainders({Key key}) : super(key: key);

  @override
  _RemaindersState createState() => _RemaindersState();
}

class _RemaindersState extends State<Remainders> {
  StateSetter _stateSetter;
  String date = "Select Date", time = "Select Time";
  DateTime todayDate = DateTime.now();
  int years, months, days, hours, minutes;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    // final height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 25, right: 25, top: 15),
              height: 35,
              // color: Colors.orange,
              width: width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: width / 1.32,
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Search ",
                        suffixIcon: Icon(
                          Icons.search,
                          size: 30,
                          color: colors.pBlue,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    // color: Colors.red,
                    width: width / 10,
                    child: IconButton(
                      icon: FaIcon(
                        FontAwesomeIcons.solidBell,
                        color: colors.pBlue,
                      ),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            ),
            bigContainers(
              "Test Remainders",
              330,
            ),
            // Container(
            //     alignment: Alignment.bottomRight,
            //     margin: EdgeInsets.only(top: 20, right: 25),
            //     child: FlatButton.icon(
            //       color: colors.pCyan,
            //       onPressed: () {},
            //       icon: Icon(
            //         Icons.menu,
            //         color: Colors.white,
            //       ),
            //       label: text("Add Test", 14, FontWeight.normal, Colors.white),
            //     )),
          ],
        ),
      ),
    );
  }

  bigContainers(String hText, double bheight) {
    return Container(
        decoration:
            BoxDecoration(border: Border.all(width: 1, color: colors.pBlue)),
        margin: EdgeInsets.only(left: 25, right: 25, top: 20),
        height: bheight,
        child: Column(
          children: <Widget>[
            Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(left: 10, right: 10),
                color: colors.pBlue,
                height: 35,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    text("$hText", 15, FontWeight.w900, Colors.white),
                    InkWell(
                      onTap: () {
                        var route = MaterialPageRoute(
                            builder: (context) => MergeScreen());
                        Navigator.push(context, route);
                      },
                      child: Icon(
                        Icons.merge_type,
                        color: Colors.white,
                      ),
                    )
                  ],
                )),
            Expanded(
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
                      child: ListView.separated(
                        separatorBuilder: (context, index) => Divider(
                          color: colors.pBlue,
                          endIndent: 30,
                          indent: 30,
                        ),
                        shrinkWrap: true,
                        itemCount: snapshot.data.documents.length,
                        itemBuilder: (BuildContext context, int index) {
                          var data = snapshot.data.documents;
                          return Container(
                            padding: EdgeInsets.only(left: 5, right: 5),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                   Container(
                                     width: 80,
                                     child:  text("${data[index]["testName"]}", 14,
                                        FontWeight.w900, colors.pBlue),),
                                    data[index]["remind_1"]
                                        ? Container(
                                            color: Colors.grey[300],
                                            child: Column(
                                              children: <Widget>[
                                                text(
                                                    "${data[index]["remind_1_time"]}",
                                                    14,
                                                    FontWeight.w900,
                                                    Colors.black),
                                              ],
                                            ))
                                        : Container(),
                                    data[index]["remind_2"]
                                        ? Container(
                                          color: Colors.grey[300],
                                          child: text(
                                            "${data[index]["remind_2_time"]}",
                                            14,
                                            FontWeight.w900,
                                            Colors.black))
                                        : Container(),
                                    Row(
                                      children: <Widget>[
                                        data[index]["remind_1"] == false ||
                                                data[index]["remind_2"] == false
                                            ? InkWell(
                                                onTap: () => setReminder(
                                                    "${data[index]["testName"]}",
                                                    320,
                                                    data[index]["remind_1"] ==
                                                            false
                                                        ? "remind_1"
                                                        : "remind_2",
                                                    data[index].documentID),
                                                child: Icon(
                                                  FontAwesomeIcons.calendarPlus,
                                                  color: colors.pBlue,
                                                ),
                                              )
                                            : Container(),
                                        InkWell(
                                          onTap: () => setReminder(
                                              "${data[index]["testName"]}",
                                              320,
                                              "test",
                                              "${data[index].documentID}"),
                                          child: Icon(
                                            Icons.edit,
                                            color: colors.pBlue,
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Container(
                                      width: 80,
                                      child: text("${data[index]["date"]}", 12,
                                        FontWeight.normal, Colors.black)),
                                    data[index]["remind_1"]
                                        ? Container(
                                            color: Colors.grey[300],
                                            child: Column(
                                              children: <Widget>[
                                                text(
                                                    "${data[index]["remind_1_date"]}",
                                                    14,
                                                    FontWeight.w900,
                                                    Colors.black),
                                              ],
                                            ))
                                        : Container(),
                                    data[index]["remind_2"]
                                        ? Container(
                                            color: Colors.grey[300],
                                            child: text(
                                                "${data[index]["remind_2_date"]}",
                                                14,
                                                FontWeight.w900,
                                                Colors.black))
                                        : Container(),
                                    text("${data[index]["time"]}", 12,
                                        FontWeight.normal, Colors.black),
                                  ],
                                )
                              ],
                            ),
                          );
                        },
                      ),
                    );
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ),
          ],
        ));
  }

  text(String text, double fontSize, FontWeight fontWeight, Color color) {
    return Text(
      "$text",
      overflow: TextOverflow.ellipsis,
      style:
          TextStyle(color: color, fontSize: fontSize, fontWeight: fontWeight,),
    );
  }

  setReminder(String testName, double height, String remind, String docId) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) => AlertDialog(
            insetPadding: EdgeInsets.symmetric(horizontal: 2),
            backgroundColor: Colors.transparent,
            content: StatefulBuilder(
                builder: (BuildContext context, StateSetter stateSetter) {
              _stateSetter = stateSetter;
              return SingleChildScrollView(
                child: Container(
                  height: height,
                  color: Colors.white,
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(left: 7, right: 7),
                        height: 40,
                        color: colors.pBlue,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              child: Row(
                                children: <Widget>[
                                  icon(Icons.menu),
                                  Text("Add Reminder",
                                      style: TextStyle(color: Colors.white)),
                                ],
                              ),
                            ),
                            InkWell(
                                onTap: () {
                                  var mili = DateTime(this.years, this.months,
                                          this.days, this.hours, this.minutes)
                                      .millisecondsSinceEpoch;

                                  String min =
                                      ((mili / 1000) / 60).round().toString();
                                  DocumentReference docRef = Firestore.instance
                                      .collection("tests")
                                      .document("${globals.uid}")
                                      .collection("${globals.uid}")
                                      .document("$docId");
                                  if (remind == "test") {
                                    docRef.updateData({
                                      "date": "$date",
                                      "time": "$time",
                                      "testTimeStamp": "$min"
                                    });
                                  }

                                  if (remind == "remind_1") {
                                    docRef.updateData({
                                      "remind_1": true,
                                      "remind_1_date": "$date",
                                      "remind_1_time": "$time",
                                      "remind_1_timeStamp": "$min"
                                    });
                                  }
                                  if (remind == "remind_2") {
                                    docRef.updateData({
                                      "remind_2": true,
                                      "remind_2_date": "$date",
                                      "remind_2_time": "$time",
                                      "remind_2_timeStamp": "$min"
                                    });
                                  }

                                  Navigator.pop(context);
                                },
                                child: Container(child: icon(Icons.check)))
                          ],
                        ),
                      ),
                      Text("Reminder Text"),
                      Container(
                          height: 40,
                          width: 170,
                          alignment: Alignment.centerLeft,
                          margin: EdgeInsets.only(top: 10, right: 25, left: 25),
                          padding: EdgeInsets.only(left: 10),
                          decoration: BoxDecoration(
                              border: Border.all(color: colors.pBlue)),
                          child: Text("$testName")
                          // TextField(
                          //   textAlign: TextAlign.center,
                          //   decoration: InputDecoration(
                          //       hintText: "Test # 1", border: InputBorder.none),
                          // ),
                          ),
                      Container(
                        margin: EdgeInsets.only(top: 10),
                        child: Text("Date :"),
                      ),
                      InkWell(
                          onTap: () {
                            pickDateTime(context, CupertinoDatePickerMode.date,
                                "date", _stateSetter);
                          },
                          child: dateTimeCon(date)),
                      Container(
                        margin: EdgeInsets.only(top: 10),
                        child: Text("Time :"),
                      ),
                      InkWell(
                        onTap: () {
                          pickDateTime(context, CupertinoDatePickerMode.time,
                              "time", _stateSetter);
                        },
                        child: dateTimeCon(time),
                      ),
                      Container(
                        alignment: Alignment.bottomRight,
                        child: MaterialButton(
                          child: Text(
                            "Cancel",
                            style: TextStyle(color: Colors.red),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      )
                    ],
                  ),
                ),
              );
            })
            ));
  }

  icon(IconData icon) => Icon(
        icon,
        color: Colors.white,
      );
  dateTimeCon(String value) {
    return Container(
        alignment: Alignment.center,
        height: 40,
        width: 100,
        margin: EdgeInsets.only(top: 10, right: 100, left: 100),
        decoration: BoxDecoration(border: Border.all(color: colors.pBlue)),
        child: Text("$value"));
  }

  pickDateTime(context, var mode, String type, var _setState) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return SizedBox(
            height: 200,
            child: CupertinoDatePicker(
              mode: mode,
              initialDateTime: todayDate,
              minimumDate: new DateTime(2020, 6),
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
                _setState(() {
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
