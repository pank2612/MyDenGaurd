import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:guard/Bloc/AuthBloc.dart';
import 'package:guard/Constant/ConstantTextField.dart';
import 'package:guard/Constant/Constant_Color.dart';
import 'package:guard/Constant/sharedPref.dart';
import 'package:guard/GuradSignInScreen/passwordScreen.dart';
import 'package:guard/ModelClass/ActivationModel.dart';
import 'package:guard/ModelClass/Devices.dart';
import 'package:guard/ModelClass/userModelClass.dart';
import 'package:guard/Constant/globalVeriable.dart' as globals;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:imei_plugin/imei_plugin.dart';




class ActivationScreen extends StatefulWidget {
  @override
  _ActivationScreenState createState() => _ActivationScreenState();
}

class _ActivationScreenState extends State<ActivationScreen> {
  TextEditingController _activationController = TextEditingController();
  UserData _userData = UserData();
  final formKey = GlobalKey<FormState>();
  List<ActivationCode> activationCodelist = List<ActivationCode>();

  bool isLoading = false;

  @override
  void initState() {
    _userData = context.bloc<AuthBloc>().getCurrentUser();
    print(_userData.email);
    print(_userData.uid);
    //  _getUserDetails();

    super.initState();
    initPlatformState();
  }

  String _platformImei = 'Unknown';
  String uniqueId = "Unknown";

  Future<void> initPlatformState() async {
    String platformImei;
    String idunique;
    try {
      platformImei =
          await ImeiPlugin.getImei(shouldShowRequestPermissionRationale: false);
      List<String> multiImei = await ImeiPlugin.getImeiMulti();
      print(multiImei);
      idunique = await ImeiPlugin.getId();
    } on PlatformException {
      platformImei = 'Failed to get platform version.';
    }

    if (!mounted) return;

    setState(() {
      _platformImei = platformImei;

      uniqueId = idunique;
    });
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
                  height: MediaQuery.of(context).size.height / 3,
                ),
                Text("Activated Code"),
                SizedBox(
                  height: 10,
                ),
                Form(
                    key: formKey,
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
    if (formKey.currentState.validate()) {
      await Firestore.instance
          .collection('ActivationCode')
          .where("tokenNo", isEqualTo: _activationController.text)
          .where("enable", isEqualTo: true)
          .where("type", isEqualTo: "Guard")
          .getDocuments()
          .then((value) {
        print(value.documents.length);

        value.documents.forEach((element) {
          if (_activationController.text == element["tokenNo"]) {
            setState(() {
              globals.mainId = value.documents[0]["society"];
              savelocalCode().toSaveStringValue(
                  residentHouseId, value.documents[0]["society"]);
            });
            saveAccesList(value);
            disableSocietyId(value.documents[0]['iD']);
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => PasswordScreen(
                    )));
          } else {
            _showDialog();
          }

        });
       // value.documents.length == 1

      });
    }
  }

  disableSocietyId(String societyEnable) {
    Firestore.instance
        .collection('ActivationCode')
        .document(societyEnable)
        .updateData({"enable": false});
  }

  saveAccesList(
    QuerySnapshot accessList,
  ) {
    accessList.documents.forEach((element) {
      Firestore.instance.collection("users").document(_userData.uid).setData({
        "accessList": FieldValue.arrayUnion(
          [
            {
              "id": element['society'],
              "type": element['type'],
              "status": true,
            }
          ],
        ),
      }, merge: true);
      SaveDevice(element['society'],);
    });

  }

  SaveDevice(String societyId) {
    Devices devices = Devices(
        activationDate: DateTime.now(),
        deactivationDate: DateTime.now(),
        enable: true,
        imei: '$_platformImei');
    Firestore.instance
        .collection(globals.SOCIETY)
        .document(societyId)
        .collection("Devices")
        .document('$_platformImei')
        .setData(jsonDecode(jsonEncode(devices.toJson())));
  }


}
