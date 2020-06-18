import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pluginCG/resources/Color.dart' as colors;
import 'package:pluginCG/resources/Logo.dart' as logo;
import 'package:pluginCG/Globals/Globals.dart' as globals;
import 'package:image_picker/image_picker.dart';
import 'package:pluginCG/Components/PickerDialogC.dart' as pickerCont;
import 'package:image_cropper/image_cropper.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:toast/toast.dart';

class PersonalInfo extends StatefulWidget {
  PersonalInfo({Key key}) : super(key: key);

  @override
  _PersonalInfoState createState() => _PersonalInfoState();
}

class _PersonalInfoState extends State<PersonalInfo> {
  final picker = ImagePicker();
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              height: 280,
              margin: EdgeInsets.only(bottom: 25),
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/panel.png"), fit: BoxFit.fill)),
              child: Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(
                      left: 10,
                      top: 40,
                      right: 10,
                    ),
                    height: 80,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        InkWell(
                          onTap: () => Navigator.pop(context),
                          child: Icon(
                            Icons.arrow_back,
                            size: 25,
                            color: Colors.white,
                          ),
                        ),
                        Padding(
                            padding: EdgeInsets.only(left: width / 4),
                            child: logo.logo()),
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
                      Stack(
                        alignment: Alignment.bottomRight,
                        children: <Widget>[
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border:
                                    Border.all(width: 1, color: colors.pBlue),
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
                                    child: Image.network(
                                      globals.lUrl,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                          ),
                          InkWell(
                            onTap: () {
                              showChoiceDialogue(context);
                            },
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white //colors.pBlue,

                                  ),
                              child: Icon(
                                Icons.add,
                                color: colors.pBlue,
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    alignment: Alignment.center,
                    height: 25,
                    child: Text(
                      "${globals.lName}",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.5),
                    ),
                  ),
                ],
              ),
            ),
            item("${globals.lName}"),
            item("${globals.lAge}"),
            item("${globals.lGender}"),
            item("${globals.lEmail}"),
            item("Contact Number"),
          ],
        ),
      ),
    );
  }

  item(String itemName) {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20),
      height: 50,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("$itemName"),
          Divider(
            color: colors.pBlue,
            thickness: 2,
          )
        ],
      ),
    );
  }

  Future showChoiceDialogue(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            content: Container(
              height: 140,
              child: Column(
                children: <Widget>[
                  pickerCont.pickerContainer("Select Any", Colors.white,
                      colors.pBlue, 30, FontWeight.w900, 0),
                  InkWell(
                      onTap: () {
                        pickImage(context, "camera");
                        Navigator.of(context).pop();
                      },
                      child: pickerCont.pickerContainer("Camera", Colors.black,
                          Colors.grey[200], 50, FontWeight.normal, 5)),
                  InkWell(
                      onTap: () {
                        pickImage(context, "gallery");
                        Navigator.of(context).pop();
                      },
                      child: pickerCont.pickerContainer("Gallery", Colors.black,
                          Colors.grey[200], 50, FontWeight.normal, 5)),
                ],
              ),
            ),
          );
        });
  }

  pickImage(BuildContext context, String source) async {
    final picture = await picker.getImage(
        source: source == "camera" ? ImageSource.camera : ImageSource.gallery);
    File croppedImage = await ImageCropper.cropImage(
      sourcePath: picture.path,
      // ratioX: 1.0,
      // ratioY: 1.0,
      maxWidth: 512,
      maxHeight: 512,
    );
    StorageReference reference = FirebaseStorage.instance
        .ref()
        .child("profile_Picture")
        .child("${globals.uid}");
    StorageUploadTask uploadTask = reference.putFile(croppedImage);
    StorageTaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;
    String urlOfImage = await storageTaskSnapshot.ref.getDownloadURL();
    DocumentReference ref =
        Firestore.instance.collection("users").document("${globals.uid}");
    ref.updateData({"picUrl": "$urlOfImage"});
    ref.get().then((DocumentSnapshot snapshot) {
      if (snapshot.exists) {
        setState(() {
          globals.lUrl = snapshot.data["picUrl"];
        });
      }
    }).whenComplete(() {
      Toast.show("Profile uploaded", context, gravity: Toast.CENTER);
    });
  }
}
