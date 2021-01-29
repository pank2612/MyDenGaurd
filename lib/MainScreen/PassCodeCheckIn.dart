import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:guard/Bloc/AuthBloc.dart';
import 'package:guard/Constant/ConstantTextField.dart';
import 'package:guard/Constant/Constant_Color.dart';
import 'package:guard/Constant/globalVeriable.dart' as globals;
import 'package:intl/intl.dart';


class PassCodeCheckIn extends StatefulWidget {
  @override
  _PassCodeCheckInState createState() => _PassCodeCheckInState();
}

class _PassCodeCheckInState extends State<PassCodeCheckIn> {
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _vehicleNameController = TextEditingController();
  TextEditingController _vehicleNumberController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool showCheckBox = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: UniversalVariables.background,
          title: Text("Pass-Code Check In"),
        ),
        body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Padding(
                padding: EdgeInsets.all(15),
                child: SingleChildScrollView(
                    child: Form(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 30,
                      ),
                      Text(
                        "Verification Code",
                        style: TextStyle(
                            fontWeight: FontWeight.w800, fontSize: 15),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Text(
                          "Please type the verification code sent on the Visitor's Mobile",
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 15),
                          textAlign: TextAlign.center),
                      SizedBox(
                        height: 60,
                      ),
                      Form(
                        key: formKey,
                        child: Column(
                          children: [
                            constantTextField().InputField(
                                "Enter Password Here",
                                "",
                                validationKey.societyCode,
                                _passwordController,
                                false,
                                IconButton(
                                    icon: Icon(Icons.remove_red_eye),
                                    onPressed: () {}),
                                1,
                                1,
                                TextInputType.emailAddress,
                                false),
                            Row(
                              children: [
                                Checkbox(
                                  activeColor: UniversalVariables.background,
                                  value: showCheckBox,
                                  onChanged: (value) {
                                    setState(() {
                                      showCheckBox = value;
                                    });
                                  },
                                ),
                                Text("Select Vehicle"),
                              ],
                            ),
                            !showCheckBox
                                ? Column(
                                    children: [
                                      Stack(
                                        children: [
                                          IgnorePointer(
                                            child: constantTextField()
                                                .InputField(
                                                    "Select Vehicle",
                                                    "",
                                                    validationKey
                                                        .isValidVehicleType,
                                                    _vehicleNameController,
                                                    false,
                                                    IconButton(
                                                      icon: Icon(
                                                          Icons.arrow_back_ios),
                                                      onPressed: () {},
                                                    ),
                                                    1,
                                                    1,
                                                    TextInputType.name,
                                                    false),
                                          ),
                                          Positioned(
                                            right: 0,
                                            child: Container(
                                              alignment: Alignment.centerRight,
                                              child: PopupMenuButton<String>(
                                                icon: const Icon(
                                                    Icons.arrow_downward),
                                                onSelected: (String val) {
                                                  _vehicleNameController.text =
                                                      val;
                                                },
                                                itemBuilder:
                                                    (BuildContext context) {
                                                  return globals.vehicle.map<
                                                          PopupMenuItem<
                                                              String>>(
                                                      (String val) {
                                                    return new PopupMenuItem(
                                                        child: new Text(val),
                                                        value: val);
                                                  }).toList();
                                                },
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      constantTextField().InputField(
                                          "Enter Vehicle Number",
                                          "",
                                          validationKey.vehical,
                                          _vehicleNumberController,
                                          false,
                                          IconButton(
                                              icon: Icon(Icons.remove_red_eye),
                                              onPressed: () {}),
                                          1,
                                          1,
                                          TextInputType.emailAddress,
                                          false),
                                    ],
                                  )
                                : Container(),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      RaisedButton(
                        onPressed: () {

                           getDetails();
                        },
                        child: Text("Submit"),
                      )
                    ],
                  ),
                )))));
  }

  getDetails() async {
    if (formKey.currentState.validate()) {
      await Firestore.instance
          .collection(globals.SOCIETY)
          .document(globals.mainId)
          .collection("Visitors")
          .where("token", isEqualTo: _passwordController.text)
          .where("enable", isEqualTo: true)
          .getDocuments()
          .then((value) {
        value.documents.forEach((element) {
          _showDialog(value);
          addVehicleSociety(element['id']);
          sendNotificationToHouseMember(element['houseId'],element['name']);
        });
      });
    }
  }

  Future<void> _showDialog(QuerySnapshot data) async {
    print("yyyy");
    data.documents.forEach((element) {
      print(element['token']);
      DateTime date = DateFormat('yyyy-MM-dd').parse(element['inviteDate']);
      print("uuu");
      return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Container(
                width: MediaQuery.of(context).size.width,
                color: UniversalVariables.background,
                child: Padding(
                    padding: EdgeInsets.all(0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                      Expanded(
                        child:   Text(
                          'Expected Visitors Details',
                          style: TextStyle(
                              color: UniversalVariables.ScaffoldColor),
                        ),
                      ),
                        InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Card(
                              elevation: 10,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              child: Icon(Icons.clear),
                            ))
                      ],
                    ))),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Visitor Name",
                        style: TextStyle(fontWeight: FontWeight.w800),
                      ),
                      Expanded(child: Text(element['name'],textAlign: TextAlign.right,))
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Invite On",
                        style: TextStyle(fontWeight: FontWeight.w800),
                      ),
                      Text(DateFormat(globals.dateFormat).format(date)),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Visitor Number",
                        style: TextStyle(fontWeight: FontWeight.w800),
                      ),
                      Text(element['mobileNumber'])
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Visitor Type",
                        style: TextStyle(fontWeight: FontWeight.w800),
                      ),
                      Text(element['visitorType'] +
                          " + " +
                          element['visitorNumber'])
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Owner Name",
                        style: TextStyle(fontWeight: FontWeight.w800),
                      ),
                      Expanded(child: Text(element['ownerName'],textAlign: TextAlign.right,))
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "House Number",
                        style: TextStyle(fontWeight: FontWeight.w800),
                      ),
                      Text(element['ownerHouse'])
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Owner Mobile",
                        style: TextStyle(fontWeight: FontWeight.w800),
                      ),
                      Text(element['ownerMobileNumber'])
                    ],
                  ),
                  SizedBox(
                    height: 2,
                  ),
                  Text(
                    "You are invited on " +
                        DateFormat(globals.dateFormat).format(date),
                    textAlign: TextAlign.center,
                  )
                ],
              ),
            ),
          );
        },
      );
    });
  }

  // Future<void> _showWrong() async {
  //   return showDialog<void>(
  //     context: context,
  //     barrierDismissible: false, // user must tap button!
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         // title: Text('AlertDialog Title'),
  //         content: SingleChildScrollView(
  //           child: ListBody(
  //             children: <Widget>[
  //               Text(
  //                 "Please Enter Correct Code",
  //                 style: TextStyle(color: UniversalVariables.background),
  //               )
  //             ],
  //           ),
  //         ),
  //         actions: <Widget>[
  //           RaisedButton(
  //             child: Text('ok'),
  //             onPressed: () {
  //               Navigator.pop(context);
  //             },
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }
  addVehicleSociety(String vistorsId) {
    Firestore.instance
        .collection(globals.SOCIETY)
        .document(globals.mainId)
        .collection(globals.VISITORS)
        .document(vistorsId)
        .setData({
      "inOut": false,
      "vehicleNumber": _vehicleNumberController.text
    }, merge: true);
  }

  static Future<void> sendNotification(receiver, msg,name) async {
    final postUrl = 'https://fcm.googleapis.com/fcm/send';


    final data = {
    "notification": {"body": "Accept Reques", "title": msg},
    "priority": "high",
    "data": {
    "click_action": "FLUTTER_NOTIFICATION_CLICK",
    "id": "1",
    "status": "done",
      "screen":"_showDialog",
      "name":"hhhhh"

    },
      "apns": {
        "payload": {
          "aps": {
            "mutable-content": 1
          }
        },
        "fcm_options": {
          "image": "https://aubergestjacques.com/wp-content/uploads/2017/04/check-out-1.png"
        }
      },
    "to": "$receiver"
    };


    final headers = {'content-type': 'application/json', 'Authorization': globals.notificationKey};
    BaseOptions options = new BaseOptions(
      connectTimeout: 5000,
      receiveTimeout: 3000,
      headers: headers,
    );

    try {
      final response = await Dio(options).post(postUrl, data: jsonEncode(data));
      if (response.statusCode == 200) {
        Fluttertoast.showToast(msg: 'Request Sent To HouseMember');
      } else {
        print('notification sending failed');
      }
    } catch (e) {
      print('exception $e');
    }
  }

  sendNotificationToHouseMember(String houseId,String visitorName) {
    Firestore.instance
        .collection(globals.SOCIETY)
        .document(globals.mainId)
        .collection("HouseDevices")
        .where("enable",isEqualTo: true)
        .where("houseId",isEqualTo: houseId)
        .getDocuments()
        .then((value) {
          value.documents.forEach((element) {
            sendNotification(element['token'], visitorName+" is on Gate",element['name']);
            print(element['token']);
          });
    });
  }
}



// var token =
//     "ecdp0cPTTHmUL8sMAbAJ3y:APA91bG14spmr6PkNQVKbXqeJT1O1FTW5izehkwU6HUxyyrOUQHhoixHD-Ng8aOHlVd9HQ1A7gXU_3jnVh3ESTzVAusD7b1Ys_C_ApMhxe0OSM47aDjlldfg-5DIh-vijpxrAg7q6Tbv";
  var ppustoken = "ejBtPz25Sb6uqSU7_LbPN9:APA91bFC23OVufZLxBR6kAUTlxgLspkYQ7qNLyKGUXLtGTxyKzMx_8YHmE9hjS46MWxDHYhWBTV8lPbiVVT9cIR0UmjnmysfDeVLj4ofkLMBbU8jo9DU0uFPccMLl0G9WbuLvHDsphGj";