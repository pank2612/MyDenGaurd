import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:guard/Constant/ConstantTextField.dart';
import 'package:guard/Constant/Constant_Color.dart';
import 'package:guard/Constant/globalVeriable.dart' as globals;
import 'package:guard/ModelClass/MaidModel.dart';
import 'package:guard/ModelClass/visitors.dart';
import 'package:guard/VisitorsAtGate/GetAllvisitors.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class VisitorsAtGateTabBar extends StatefulWidget {
  @override
  _StaffAndVandorTabBarState createState() => _StaffAndVandorTabBarState();
}

class _StaffAndVandorTabBarState extends State<VisitorsAtGateTabBar>
    with SingleTickerProviderStateMixin {

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TabController _tabController;
  final formKey = GlobalKey<FormState>();

  TextEditingController searchController = new TextEditingController();
  TextEditingController _flatNumberController = new TextEditingController();
  TextEditingController _nameController = new TextEditingController();
  TextEditingController _mobileNumberController = new TextEditingController();
  bool isAllDay = true;
  bool isLoading = false;
  bool showPhoneNumber = false;


  void showScaffold(String message) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(message),
    ));
  }

  @override
  void initState() {
    super.initState();
    globals.image = null;
    globals.type = 'Select Visitor';
    globals.number = "0";

    _tabController = new TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: UniversalVariables.background,
          title: Text("VisitorsList"),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          bottom: TabBar(
            unselectedLabelColor: Colors.white,
            labelColor: Colors.amber,
            tabs: [
              Tab(
                child: Text(
                  "List",
                  style: TextStyle(fontSize: 20),
                ),
              ),
              Tab(
                child: Text(
                  "AddVisitors",
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ],
            controller: _tabController,
            indicatorColor: Colors.white,
            indicatorSize: TabBarIndicatorSize.tab,
          ),
          bottomOpacity: 1,
        ),
        body: TabBarView(
          children: [GetAllVisitors(), _addGateVisitors()],
          controller: _tabController,
        ));
  }

  Widget _addGateVisitors() {
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.all(20),
          child: ListView(
            children: [
              SizedBox(
                height: 20,
              ),
              Form(
                key: formKey,
                child: Column(
                  children: [
                    constantTextField().InputField(
                        "Enter Mobile Number",
                        "",
                        validationKey.mobileNo,
                        _mobileNumberController,
                        false,
                        IconButton(
                            icon: Icon(Icons.contact_phone), onPressed: () {}),
                        1,
                        1,
                        TextInputType.number,
                        false),
                    SizedBox(
                      height: 20,
                    ),
                    constantTextField().InputField(
                        "Enter Flat Number",
                        "",
                        validationKey.flatNo,
                        _flatNumberController,
                        false,
                        IconButton(
                            icon: Icon(Icons.contact_phone), onPressed: () {}),
                        1,
                        1,
                        TextInputType.name,
                        false),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: constantTextField().InputField(
                              "Visitor's Name",
                              "",
                              validationKey.name,
                              _nameController,
                              false,
                              IconButton(
                                  icon: Icon(Icons.contact_phone),
                                  onPressed: () {}),
                              1,
                              1,
                              TextInputType.text,
                              false),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Icon(
                          Icons.add,
                          size: 30,
                          color: UniversalVariables.background,
                        ),
                        Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(
                                    color: UniversalVariables.background)),
                            child: Padding(
                              padding: EdgeInsets.all(0),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    globals.number ,
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w800),
                                  ),
                                  PopupMenuButton<String>(
                                    icon: const Icon(Icons.arrow_drop_down),
                                    onSelected: (String val) {
                                      globals.number = val;
                                      setState(() {
                                        globals.changeValidation =
                                            globals.documentData[val];
                                      });
                                    },
                                    itemBuilder: (BuildContext context) {
                                      return globals.guestNumber
                                          .map<PopupMenuItem<String>>(
                                              (int val) {
                                        return new PopupMenuItem(
                                            child: new Text(val.toString()),
                                            value: val.toString());
                                      }).toList();
                                    },
                                  ),
                                ],
                              ),
                            )),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Visitor Type",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w800),
                        ),
                        Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(
                                    color: UniversalVariables.background)),
                            child: Padding(
                              padding: EdgeInsets.all(0),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    globals.type,
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w800),
                                  ),
                                  PopupMenuButton<String>(
                                    icon: const Icon(Icons.arrow_drop_down),
                                    onSelected: (String val) {
                                      globals.type = val;
                                      setState(() {
                                        globals.changeValidation =
                                            globals.documentData[val];
                                      });
                                    },
                                    itemBuilder: (BuildContext context) {
                                      return globals.guestType
                                          .map<PopupMenuItem<String>>(
                                              (String val) {
                                        return new PopupMenuItem(
                                            child: new Text(val), value: val);
                                      }).toList();
                                    },
                                  ),
                                ],
                              ),
                            ))
                      ],
                    ),

                  ],
                ),
              ),

              SizedBox(
                height: 50,
              ),
              RaisedButton(
                color: UniversalVariables.background,
                onPressed: () {
                  sendNotification( token,"khgfhgfgmjh");
                // visitors();
                //    globals.uuid = Uuid().v1();
                },
                child: Text(
                  "Add",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: UniversalVariables.ScaffoldColor),
                ),
              ),
              SizedBox(
                height: 50,
              ),
            ],
          ),
        ),
      ],
    );
  }





  visitors() {
    print("aaaa");
    if (formKey.currentState.validate()) {
      print("bbbb");
      print(globals.type);
      if(globals.type == "Select Visitor" || globals.number == "0"){
        showScaffold("Select visitor type or Visitor Number");
        print("cccc");

      }else {
        print("hhhh");
      Firestore.instance
          .collection(globals.SOCIETY)
          .document(globals.mainId)
          .collection("Houses")
          .where("flatNumber", isEqualTo: _flatNumberController.text)
          .getDocuments()
          .then((value) {

        value.documents.forEach((element) {
          print(element['houseId']);
          print(element['flatNumber']);
          print("visitors");
          Visitor visitor = Visitor(
              name: _nameController.text,
              inviteBye: "Guard",
              mobileNumber: _mobileNumberController.text,
              visitorNumber: globals.number,
             visitorType: globals.type,
              houseId: element['houseId'],
              enable: true,
              ownerHouse: _flatNumberController.text,
              ownerName: element['flatOwner'],
              id: globals.uuid,
              inviteDate: DateTime.now(),
              societyId: globals.mainId);
          Firestore.instance
              .collection(globals.SOCIETY)
              .document(globals.mainId)
              .collection('Visitors')
              .document(globals.uuid)
              .setData(jsonDecode(jsonEncode(visitor.toJson())),merge: true)
              .then((value) {
            _showDialog();
            _flatNumberController.clear();
            _mobileNumberController.clear();
            _nameController.clear();
           setState(() {
             globals.type = 'Select Visitor';
             globals.number = "0";
           });


          });sendNotificationToHouseMember(element['houseId']);
        });
      });}
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
                  "Visitor is added & notification is sent to user's mobile ",
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
  // static Future<void> sendNotification(receiver, msg,) async {
  //   final postUrl = 'https://fcm.googleapis.com/fcm/send';
  //
  //
  //   final data = {
  //     "notification": {"body": "Accept Reques", "title": msg},
  //     "priority": "high",
  //     "data": {
  //       "click_action": "FLUTTER_NOTIFICATION_CLICK",
  //       "id": "1",
  //       "status": "done",
  //       "screen":"Visitors",
  //       "name":"hhhhh"
  //
  //     },
  //     "to": "$receiver"
  //   };
  //
  //
  //   final headers = {'content-type': 'application/json', 'Authorization': globals.notificationKey};
  //   BaseOptions options = new BaseOptions(
  //     connectTimeout: 5000,
  //     receiveTimeout: 3000,
  //     headers: headers,
  //   );
  //
  //   try {
  //     print("dfsdfsd   ${receiver}");
  //     final response = await Dio(options).post(postUrl, data: jsonEncode(data));
  //     if (response.statusCode == 200) {
  //       Fluttertoast.showToast(msg: 'Request Sent To HouseMember');
  //       print('visitorName');
  //     } else {
  //       print('notification sending failed');
  //     }
  //   } catch (e) {
  //     print('exception $e');
  //   }
  // }



  static Future<void> sendNotification(receiver, msg,) async {
    final postUrl = 'https://fcm.googleapis.com/fcm/send';
    final data = {
      "notification": {"body": "msg", "title": "Alert"},
      "priority": "high",
      "data": {
        "click_action": "FLUTTER_NOTIFICATION_CLICK",
        "id": "1",
        "status": "done",
        "screen":"AlertsScreen",
        "name":"hhhhh"

      },
      "actionButtons": [
        {
          "key": "REPLY",
          "label": "Reply",
          "autoCancel": true,
          "buttonType":  "InputField",
        },
        {
          "key": "ARCHIVE",
          "label": "Archive",
          "autoCancel": true
        }
      ],
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

  sendNotificationToHouseMember(String houseId) {
    print('visitorName');
    print(houseId);

    Firestore.instance
        .collection(globals.SOCIETY)
        .document(globals.mainId)
         .collection("HouseDevices")
          .where("enable",isEqualTo: true)
          .where("houseId",isEqualTo: houseId)
        .getDocuments()
        .then((value) {
      value.documents.forEach((element) {
        sendNotification(element['token'], _nameController.text +" is on Gate",);
        print(element['token']);
      });
    });
  }

}
var token = "eNnqgunhT6mvk9WlIKhpDc:APA91bH9iYN_YYMcA2Zz8-uVHmKXkaWJcsXnQ74EbLhKMM4jD2X7LNjAhemIlxy69RzQPbq70jahz1GJtn382Tt5EESblirtyCZZVw7F8K4ysDN5eF3d81ER-r8n5smNouMgx3LncN6a";