import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:guard/Bloc/AuthBloc.dart';
import 'package:guard/Constant/ConstantTextField.dart';
import 'package:guard/Constant/Constant_Color.dart';
import 'package:guard/Constant/sharedPref.dart';
import 'package:guard/ModelClass/ActivationModel.dart';
import 'package:guard/ModelClass/userModelClass.dart';
import 'package:guard/Constant/globalVeriable.dart' as globals;

import 'package:flutter_bloc/flutter_bloc.dart';

import 'TabBarScreen.dart';

class ActivationScreen extends StatefulWidget {
  @override
  _ActivationScreenState createState() => _ActivationScreenState();
}

class _ActivationScreenState extends State<ActivationScreen> {
  TextEditingController _activationController = TextEditingController();
  TextEditingController _societyController = TextEditingController();
  UserData _userData = UserData();
  List<ActivationCode> activationCodelist = List<ActivationCode>();
  var society = [
    'MilanDeep',
    'MilanSar',
  ];

  bool isLoading = false;

  @override
  void initState() {
    _userData = context.bloc<AuthBloc>().getCurrentUser();
    print(_userData.email);
    print(_userData.uid);
    //  _getUserDetails();
    // getActivationCode();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: MediaQuery
                          .of(context)
                          .size
                          .height / 3,
                    ),
                    Text("Activated Code"),
                    SizedBox(
                      height: 10,
                    ),
                    Form(
                        key: globals.formKey,
                        child: Column(
                          children: [
                            constantTextField().InputField(
                                "Enter Activation Code",
                                "",
                                validationKey.societyCode,
                                _activationController,
                                false,
                                IconButton(
                                    icon: Icon(Icons.remove_red_eye),
                                    onPressed: () {}),
                                1,
                                1,
                                TextInputType.emailAddress,
                                false),
                            SizedBox(
                              height: 10,
                            ),
                          ],
                        )),
                    SizedBox(
                      height: 20,
                    ),
                    RaisedButton(
                      onPressed: () {
                        getActivationCode();
                      },
                      child: Text("Submit"),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              child: isLoading
                  ? Container(
                color: Colors.transparent,
                child: Center(child: CircularProgressIndicator()),
              )
                  : Container(),
            ),
          ],
        ));
  }


  Future<void> _showDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          // title: Text('AlertDialog Title'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  "Your Activation Code Is Wrong ",
                  style: TextStyle(color: UniversalVariables.background),
                )
              ],
            ),
          ),
          actions: <Widget>[
            RaisedButton(
              child: Text('ok'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  buttonclicked() {
    Firestore.instance
        .collection('ActivationCode')
        .document()
        .updateData({"enable": false});
  }

  getActivationCode() async {
    if (globals.formKey.currentState.validate()) {
      await Firestore.instance
          .collection('ActivationCode')
          .where("tokenNo", isEqualTo: _activationController.text)
          .where("enable", isEqualTo: true)
          .where("type", isEqualTo: "Residents")
          .getDocuments()
          .then((value) {
        print(value.documents.length);

        value.documents.forEach((element) {
          print(element["iD"]);
        });

        if (value.documents.length == 1) {
          setState(() {
            globals.mainId = value.documents[0]["society"];
            globals.parentId = value.documents[0]["iD"];
            globals.flatNo = value.documents[0]["flatNo"];
            savelocalCode().toSaveStringValue(
                residentHouseId, value.documents[0]["society"]);
            savelocalCode().toSaveStringValue(
                flatNoId, value.documents[0]["flatNo"]);
            savelocalCode()
                .toSaveStringValue(residentId, value.documents[0]["iD"]);
            isLoading = true;
          });
          saveAccesList(value);
          disableSocietyId(value.documents[0]['iD']);
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => TabBarScreen()));
        } else {
          _showDialog();
        }
      });
    }
  }

  disableSocietyId(String societyEnable) {
    Firestore.instance
        .collection('ActivationCode')
        .document(societyEnable)
        .updateData({"enable": false});
  }
  saveAccesList(QuerySnapshot accessList,) {
    accessList.documents.forEach((element) {
      Firestore.instance.collection("users").document(_userData.uid).setData({
        "accessList": FieldValue.arrayUnion(
          [
            {
              "id": element['society'],
              "type": element['type'],
              "status": true,
              "residentId": element['iD'],
              "master": element['master'],
              'flatNo': element['flatNo']
            }
          ],
        ),
      }, merge: true);
     // saveFamilyMembers(element['iD']);
    });
  }

  // saveFamilyMembers(String houseId)  {
  //   HouseMember houseMember = HouseMember(
  //     id: _userData.uid,
  //     enrolDate: DateTime.now(),
  //     deactivateDate: DateTime.now(),
  //     enable: true,
  //   );
  //    Firestore.instance
  //       .collection(globals.SOCIETY)
  //       .document(globals.mainId)
  //       .collection(globals.HOUSES)
  //       .document(houseId)
  //       .collection("members")
  //       .document(_userData.uid)
  //       .setData(jsonDecode(jsonEncode(houseMember.toJson())));
  // }
}
