import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:guard/Constant/ConstantTextField.dart';
import 'package:guard/Constant/Constant_Color.dart';
import 'package:guard/ModelClass/visitors.dart';
import 'package:intl/intl.dart';
import 'package:guard/Constant/globalVeriable.dart' as globals;

class VisitorsCheckOut extends StatefulWidget {
  @override
  _VisitorsCheckOutState createState() => _VisitorsCheckOutState();
}

class _VisitorsCheckOutState extends State<VisitorsCheckOut>  with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  List<Visitor> visitorsList = List<Visitor>();
  TextEditingController _passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool isLoading = false;
  bool hasMore = true;
  int documentLimit = 10;
  DocumentSnapshot lastDocument = null;
  ScrollController _scrollController = ScrollController();
  TabController _tabController;

  //
  // String RandomPassword(int strlen) {
  //   Random rnd = new Random(new DateTime.now().millisecondsSinceEpoch);
  //   String result = "";
  //   for (var i = 0; i < strlen; i++) {
  //     result += rnd.nextInt.toString();
  //   }
  //   return result;
  // }

  void showScaffold(String message) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(message),
    ));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getExpectedVisitors(lastDocument);
    _tabController = new TabController(length: 2, vsync: this);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: UniversalVariables.background,
          title: Text("Visitors Out Screen"),
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
                  "VisitorsList",
                  style: TextStyle(fontSize: 20),
                ),
              ),
              Tab(
                child: Text(
                  "PassCode",
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
          children: [
            getVisitorsList(),
            _passCodeScreen()
            // AllowOnceCab(),
            // GetFrequentlyCab()
          ],
          controller: _tabController,
        ));
  }

  Widget getVisitorsList(){
    _scrollController.addListener(() {
      double maxScroll = _scrollController.position.maxScrollExtent;
      double currentScroll = _scrollController.position.pixels;
      double delta = MediaQuery.of(context).size.height * 0.20;
      if (maxScroll - currentScroll <= delta) {
        getExpectedVisitors(lastDocument);
      }
    });
    return Scaffold(
      body: Stack(children: [
        Column(children: [
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15, right: 15),
          ),
          Expanded(
            child: visitorsList.length == 0
                ? Center(
                child: Text(
                  "No Expected visitors have yet",
                  style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 20,
                      color: UniversalVariables.background),
                ))
                : ListView.builder(
              controller: _scrollController,
              itemCount: visitorsList.length,
              itemBuilder: (context, index) {
                return Padding(
                    padding: const EdgeInsets.only(left: 15, right: 15),
                    child: Card(
                      elevation: 10,
                      child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                visitorsList[index].visitorType,
                                style: TextStyle(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 15),
                              ),
                              Divider(
                                color: Colors.black,
                              ),
                              Row(
                                children: [
                                  CircleAvatar(
                                    backgroundColor: UniversalVariables.background,
                                    minRadius: 30,
                                    child: visitorsList[index]
                                        .inOut ==
                                        null
                                        ? Text("",
                                      style: TextStyle(
                                          fontWeight:
                                          FontWeight
                                              .w800,
                                          fontSize: 30,
                                          color:
                                          Colors.green),
                                    )
                                        : visitorsList[index]
                                        .inOut ==
                                        true
                                        ? Text("OUT",
                                      style: TextStyle(
                                          fontWeight:
                                          FontWeight
                                              .w800,
                                          fontSize: 30,
                                          color:
                                          Colors.green),
                                    ):Text("IN",
                                      style: TextStyle(
                                          fontWeight:
                                          FontWeight
                                              .w800,
                                          fontSize: 30,
                                          color:
                                          Colors.green),
                                    )
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        child: Text(
                                          visitorsList[index].name,
                                          style: TextStyle(
                                              fontWeight:
                                              FontWeight.w800),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                      ),
                                      Text(
                                        visitorsList[index].mobileNumber,
                                      ),
                                      Text(
                                        DateFormat(globals.dateFormat)
                                            .format(visitorsList[index]
                                            .inviteDate),
                                        style: TextStyle(
                                            fontWeight: FontWeight.w800),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ],
                          )),
                    ));
              },
            ),
          ),
          isLoading
              ? Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.all(5),
            color: UniversalVariables.background,
            child: Text(
              'Loading......',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: UniversalVariables.ScaffoldColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
              : Container()
        ]),
      ]),
    );

  }


  getExpectedVisitors(
      DocumentSnapshot _lastDocument,
      ) async {
    // print(houseId);
    print("jkjbk");
    if (!hasMore) {
      print('No More Data');
      return;
    }
    if (isLoading) {
      return;
    }
    setState(() {
      isLoading = true;
    });
    QuerySnapshot querySnapshot;
    if (_lastDocument == null) {
      visitorsList.clear();
      querySnapshot = await Firestore.instance
          .collection(globals.SOCIETY)
          .document(globals.mainId)
          .collection(globals.VISITORS)
          .where("inOut",isEqualTo: true)
          .where("inviteDate",
          isGreaterThanOrEqualTo:
          DateTime.now().subtract(Duration(days: 1)).toIso8601String())
          .orderBy("inviteDate", descending: false)
          .limit(documentLimit)
          .getDocuments();
    } else {
      querySnapshot = await Firestore.instance
          .collection(globals.SOCIETY)
          .document(globals.mainId)
          .collection(globals.VISITORS)
          .where("inOut",isEqualTo: true)
          .where("inviteDate",
          isGreaterThanOrEqualTo:
          DateTime.now().subtract(Duration(days: 1)).toIso8601String())
          .orderBy("inviteDate", descending: false)
          .startAfterDocument(_lastDocument)
          .limit(documentLimit)
          .getDocuments();
    }
    if (querySnapshot.documents.length < documentLimit) {
      hasMore = false;
    }
    if (querySnapshot.documents.length != 0) {
      lastDocument =
      querySnapshot.documents[querySnapshot.documents.length - 1];

      setState(() {
        querySnapshot.documents.forEach((element) {
          var visitors = Visitor();
          visitors = Visitor.fromJson(element.data);
          visitorsList.add(visitors);
        });
      });
    }
    setState(() {
      isLoading = false;
    });
  }



  Widget _passCodeScreen(){
    return Scaffold(
      key: _scaffoldKey,
      body: Container(
          width: MediaQuery
              .of(context)
              .size
              .width,
          height: MediaQuery
              .of(context)
              .size
              .height,
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
                            "Please type the verification code to checkOut the Visitor's ",
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
                  )))),
    );
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
          showSociety(element['id']);
        });
      });
    }
  }

  showSociety(String vistorsId){
    Firestore.instance
        .collection(globals.SOCIETY)
        .document(globals.mainId)
        .collection(globals.VISITORS)
        .document(vistorsId).setData({"inOut": true},merge: true).then((value) async{
          setState(() {
            isLoading = false;
          });
          showScaffold("Visitors Check out The Society");
          _passwordController.clear();
    }).then(onGoBack);
  }
  FutureOr onGoBack(dynamic value) {
    hasMore = true;
    getExpectedVisitors(null);

  }

}

