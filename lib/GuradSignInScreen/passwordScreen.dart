import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:guard/Constant/ConstantTextField.dart';
import 'package:guard/Constant/Constant_Color.dart';
import 'package:guard/Constant/globalVeriable.dart' as globals;
import 'package:guard/GuradSignInScreen/TabBarScreen.dart';
import 'package:guard/MainScreen/mainScreen.dart';
import 'package:guard/ModelClass/Devices.dart';
import 'package:imei_plugin/imei_plugin.dart';
class PasswordScreen extends StatefulWidget {
  @override
  _PasswordScreenState createState() => _PasswordScreenState();
}

class _PasswordScreenState extends State<PasswordScreen> {
  TextEditingController _passwordController = TextEditingController();
  bool isLoading = false;

  String _platformImei = 'Unknown';
  String uniqueId = "Unknown";
  @override
  void initState() {
    super.initState();
    initPlatformState();
  }


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
    return  Scaffold(
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
                    Text("Password "),
                    SizedBox(
                      height: 10,
                    ),
                    Form(
                        key: globals.formKey,
                        child: Column(
                          children: [
                            constantTextField().InputField(
                                "Enter Password ",
                                "",
                                validationKey.guardPassword,
                                _passwordController,
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
                      //  Navigator.push(context, MaterialPageRoute(builder: (context)=>MainScreen()));
                       //
                        //getActivationCode();
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


  getActivationCode() async {
    if (globals.formKey.currentState.validate()) {
      await Firestore.instance
          .collection(globals.SOCIETY)
          .getDocuments()
        .then((value) {
          print(value.documents[0]['password']);
            print("${value.documents[0]['password']}");

            if("${value.documents[0]['password']}" == _passwordController.text){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>MainScreen()));
            } else{
              _showDialog();
            }

      });

    }
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
                  "Your Password Is Wrong ",
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

}
