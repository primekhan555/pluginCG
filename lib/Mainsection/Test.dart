import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dropdownfield/dropdownfield.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pluginCG/Mainsection/NewTest.dart';
import 'package:pluginCG/resources/Color.dart' as colors;

class Test extends StatefulWidget {
  Test({Key key}) : super(key: key);

  @override
  _TestState createState() => _TestState();
}

class _TestState extends State<Test> {
  DateTime todayDate = DateTime.now();
  String date = "Select Date", time = "Select Time";
  List<String> disease = [];
  List<String> recomm = ["Select Disease"];
  List<String> tests = ["Select Disease"];
  int index = 0;

  getDiseases() async {
    await Firestore.instance
        .collection("diseases")
        .getDocuments()
        .then((value) {
      value.documents.forEach((element) {
        disease.add(element.data["disease"]);
        recomm.add(element.data["Recommendation"]);
        tests.add(element.data["test"]);
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getDiseases();
  }

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
                        suffixIcon: icon(Icons.search, colors.pBlue)),
                  ),
                ),
                Container(
                  width: width / 10,
                  child: IconButton(
                    icon: icon(FontAwesomeIcons.solidBell, colors.pBlue),
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
                hintText: 'Disease Name',
                items: disease,
                strict: false,
                onValueChanged: (value) {
                  int index = disease.indexOf(value);
                  setState(() {
                    this.index = index;
                  });
                }),
          ),
          bigContainers(
              "Detail about Disease",
              recomm.length == 1 ? "Select Disease" : recomm[index + 1],
              220,
              "descrip"),
          bigContainers(
              "Recommended Tests",
              tests.length == 1 ? "Select Disease" : tests[index + 1],
              130,
              "tests"),
        ],
      ))),
    );
  }

  icon(IconData icon, Color color) => Icon(
        icon,
        color: color,
      );
  bigContainers(String hText, String bText, double bheight, String type) {
    List<String> testsL = [];
    if (type == "tests") {
      testsL = bText.split(",");
    }
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
                    color: colors.pWhite,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.3),
              ),
            ),
            type == "descrip"
                ? Container(
                    height: bheight - 37,
                    alignment: Alignment.center,
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: Text(bText))
                : Container(
                    height: bheight - 37,
                    padding: EdgeInsets.only(left: 10, right: 10, top: 7),
                    child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          childAspectRatio: 3,
                        ),
                        itemCount: testsL.length,
                        itemBuilder: (context, index) {
                          return Chips(
                            testsL: testsL,
                            index: index,
                          );
                        }))
          ],
        ));
  }
}

class Chips extends StatefulWidget {
  final List<String> testsL;
  final int index;
  Chips({Key key, this.testsL, this.index}) : super(key: key);

  @override
  _ChipsState createState() => _ChipsState();
}

class _ChipsState extends State<Chips> {
  bool toggle = false;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.testsL[0] != "Select Disease"
          ? () {
              var route = MaterialPageRoute(
                  builder: (context) =>
                      NewTest(testName: widget.testsL[widget.index]));
              Navigator.push(context, route);
            }
          : null,
      child: Chip(
        label: Text(
          "${widget.testsL[widget.index]}",
          style: TextStyle(color: colors.pWhite),
        ),
        backgroundColor: colors.pBlue,
        materialTapTargetSize: MaterialTapTargetSize.padded,
      ),
    );
  }
}
