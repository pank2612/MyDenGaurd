import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
    globals.type = 'Select Type';

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
                        globals.mobileNumberController,
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
                                    "0",
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
                 visitors();
                   globals.uuid = Uuid().v1();
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
    if (formKey.currentState.validate()) {
      Firestore.instance
          .collection(globals.SOCIETY)
          .document(globals.mainId)
          .collection("Houses")
          .where("flatNumber", isEqualTo: "C32")
          .getDocuments()
          .then((value) {
        value.documents.forEach((element) {
          Visitor visitor = Visitor(
              name: _nameController.text,
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
              .setData(jsonDecode(jsonEncode(visitor.toJson())))
              .then((value) {
            print("add djfltejer");
          });
        });
      });
    }
  }




}
