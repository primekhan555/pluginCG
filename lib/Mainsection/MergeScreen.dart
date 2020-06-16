import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pluginCG/resources/Logo.dart' as logo;
import 'package:pluginCG/resources/Color.dart' as colors;
import 'package:pluginCG/Globals/Globals.dart' as globals;
import 'package:pluginCG/resources/warning.dart' as alert;

List<String> testList = [];
List<String> docList = [];
String names = "";

class MergeScreen extends StatefulWidget {
  MergeScreen({Key key}) : super(key: key);

  @override
  _MergeScreenState createState() => _MergeScreenState();
}

class _MergeScreenState extends State<MergeScreen> {
  StateSetter _stateSetter;
  String date = "Select Date", time = "Select Time";
  DateTime todayDate = DateTime.now();
  int years, months, days, hours, minutes;
  @override
  void initState() {
    testList = [];
    docList = [];
    names = "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: colors.pBlue,
        title: logo.logo(),
        leading:IconButton(icon: icon(Icons.arrow_back), onPressed: ()=>Navigator.pop(context)),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.check,
              color: Colors.white,
            ),
            onPressed: () {
              if (testList.isEmpty) {
                alert.toast(context, "Please Select Tests to merge");
              } else {
                setReminder("$names", 320);
              }
            },
          )
        ],
      ),
      body: Container(
        child: StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance
              .collection("tests")
              .document("${globals.uid}")
              .collection("${globals.uid}")
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            var data = snapshot.data.documents;
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data.documents.length,
                itemBuilder: (BuildContext context, int index) {
                  return CardItem(
                    testName: data[index]["testName"],
                    testDate: data[index]["date"],
                    testTime: data[index]["time"],
                    docId: data[index].documentID,
                  );
                },
              );
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }

  setReminder(String testName, double height) {
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
                                  CollectionReference collecRef = Firestore
                                      .instance
                                      .collection("tests")
                                      .document("${globals.uid}")
                                      .collection("${globals.uid}");
                                  collecRef.document().setData({
                                    "testName": "$testName",
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
                                  });
                                  docList.forEach((element) {
                                    print(element);
                                    collecRef.document("$element").delete();
                                  });
                                  Navigator.pop(context);
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
                          child: Text("$testName")),
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
            })));
  }

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

  icon(IconData icon) => Icon(
        icon,
        color: Colors.white,
      );
}

class CardItem extends StatefulWidget {
  final String testName, testDate, testTime, docId;
  CardItem({Key key, this.testName, this.testDate, this.testTime, this.docId})
      : super(key: key);

  @override
  _CardItemState createState() => _CardItemState();
}

class _CardItemState extends State<CardItem> {
  bool toggle = false;
  @override
  Widget build(BuildContext context) {
    return Card(
        child: Row(
      children: <Widget>[
        Checkbox(
          value: toggle,
          activeColor: colors.pBlue,
          onChanged: (value) {
            setState(() {
              toggle = value;
              if (value) {
                testList.add(widget.testName);
                docList.add(widget.docId);
              } else {
                testList.remove(widget.testName);
                docList.remove(widget.docId);
              }
            });
            String list = "";
            for (var item in testList) {
              list = list != "" ? list + " + " + item : item;
            }
            names = list;
          },
        ),
        Container(
            width: 135,
            child: Text(
              "${widget.testName}",
              overflow: TextOverflow.ellipsis,
            )),
        Container(
            alignment: Alignment.centerRight,
            width: 85,
            child: Text("${widget.testDate}")),
        Container(
            alignment: Alignment.centerRight,
            width: 70,
            child: Text("${widget.testTime}")),
      ],
    ));
  }
}
