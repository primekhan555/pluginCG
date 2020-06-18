import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pluginCG/Mainsection/PersonalInfo.dart';
import 'package:pluginCG/Mainsection/Test.dart';
import 'package:pluginCG/resources/Color.dart' as colors;
import 'package:shared_preferences/shared_preferences.dart';
import 'DrawerC.dart';
import 'Home.dart';
import 'Remainders.dart';
import 'package:pluginCG/resources/Logo.dart' as logo;
import 'package:pluginCG/Globals/Globals.dart' as globals;

class MainScreen extends StatefulWidget {
  MainScreen({Key key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  int _selectedIndex = 1;
  List<Widget> widgets = [Test(), Home(), Remainders()];
  userState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("fullRegister", true);
    prefs.setBool("partialRegister", false);
  }

  @override
  void initState() {
    getUserInfo();
    userState();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
        child: DrawerC(),
      ),
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.menu,
            color: Colors.white,
            size: 30,
          ),
          onPressed: () => _scaffoldKey.currentState.openDrawer(),
        ),
        centerTitle: true,
        backgroundColor: colors.pBlue,
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
      body: widgets.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
          onTap: _onItemTapped,
          currentIndex: _selectedIndex,
          items: [
            barItem(FontAwesomeIcons.vial),
            barItem(FontAwesomeIcons.home),
            barItem(FontAwesomeIcons.bars),
          ]),
    );
  }

  barItem(IconData icon) {
    return BottomNavigationBarItem(
      activeIcon: FaIcon(
        icon,
        size: 33,
        color: colors.pCyan,
      ),
      icon: FaIcon(
        icon,
        color: colors.pBlue,
      ),
      title: Text(""),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  getUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String uid = prefs.getString("uid");
    globals.uid = uid;
    await Firestore.instance
        .collection("users")
        .document("$uid")
        .get()
        .then((DocumentSnapshot ds) {
      if (ds.exists) {
        setState(() {
          globals.lName = ds.data["name"];
          globals.lEmail = ds.data["email"];
          globals.lUrl = ds.data["picUrl"];
          globals.lGender = ds.data["gender"];
          globals.lCountry = ds.data["country"];
          globals.lAge = ds.data["age"];
        });
      }
    });
  }
}
