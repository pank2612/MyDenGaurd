import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:guard/Constant/ConstantTextField.dart';
import 'package:guard/Constant/Constant_Color.dart';
import 'package:guard/Constant/globalVeriable.dart' as globals;
import 'package:guard/ModelClass/MaidModel.dart';

class StaffAndVandorTabBar extends StatefulWidget {
  final staffType;
  final documebtId;

  const StaffAndVandorTabBar({Key key, this.staffType, this.documebtId})
      : super(key: key);

  @override
  _StaffAndVandorTabBarState createState() => _StaffAndVandorTabBarState();
}

class _StaffAndVandorTabBarState extends State<StaffAndVandorTabBar>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TabController _tabController;
  TextEditingController _passwordController = TextEditingController();
  List<AllService> serviceList = List<AllService>();

  bool showInsideService = false;
  bool changeSociety = false;

  bool isLoading = false;
  bool hasMore = true;
  int documentLimit = 15;
  DocumentSnapshot lastDocument = null;
  ScrollController _scrollController = ScrollController();

  void showScaffold(String message) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(message),
    ));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getSocietyrServices(lastDocument);
    _tabController = new TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: UniversalVariables.background,
          title: Text(widget.staffType),
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
                  widget.staffType,
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
          children: [_staffList(), _passCodeScreen()],
          controller: _tabController,
        ));
  }

  Widget _staffList() {
    _scrollController.addListener(() {
      double maxScroll = _scrollController.position.maxScrollExtent;
      double currentScroll = _scrollController.position.pixels;
      double delta = MediaQuery.of(context).size.height * 0.20;
      if (maxScroll - currentScroll <= delta) {
        getSocietyrServices(lastDocument);
      }
    });
    return Scaffold(
      //  key: _scaffoldKey,
      body: Stack(children: [
        Column(children: [
          Padding(
            padding: const EdgeInsets.only(left: 15, right: 15),
          ),
          Expanded(
            child: serviceList.length == 0
                ? Center(
                    child: Text(
                    "No " + widget.staffType + " have yet",
                    style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 20,
                        color: UniversalVariables.background),
                  ))
                : ListView.builder(
                    controller: _scrollController,
                    itemCount: serviceList.length,
                    itemBuilder: (context, index) {
                      return Padding(
                          padding: const EdgeInsets.only(left: 15, right: 15),
                          child: GestureDetector(
                              onTap: () {
                                // Route route = CupertinoPageRoute(builder: (context) =>ShowFullDetails(
                                //   allService: serviceList[index],
                                // ));
                                // Navigator.push(context, route).then(onGoBack);
                              },
                              child: Card(
                                elevation: 10,
                                child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: Colors.black54),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          50)),
                                              child: Container(
                                                  height: 70,
                                                  width: 70,
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            50),
                                                    child: CachedNetworkImage(
                                                      placeholder:
                                                          (context, url) =>
                                                              Container(
                                                        child:
                                                            CircularProgressIndicator(
                                                          valueColor:
                                                              AlwaysStoppedAnimation<
                                                                      Color>(
                                                                  UniversalVariables
                                                                      .background),
                                                        ),
                                                        width: 50.0,
                                                        height: 50.0,
                                                      ),
                                                      imageUrl:
                                                          serviceList[index]
                                                              .photoUrl,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  )),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    SizedBox(
                                                      width: 5,
                                                    ),
                                                    Text(
                                                      serviceList[index].name,
                                                      style: TextStyle(
                                                          fontSize: 17,
                                                          fontWeight:
                                                              FontWeight.w800),
                                                    ),
                                                    Icon(
                                                      Icons.arrow_forward_ios,
                                                      size: 18,
                                                    )
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Icon(
                                                      Icons.star,
                                                      color: Colors.yellow,
                                                    ),
                                                    Text("5.0")
                                                  ],
                                                )
                                              ],
                                            ),
                                            Spacer(),
                                            CircleAvatar(
                                              backgroundColor:
                                                  UniversalVariables.background,
                                              minRadius: 30,
                                              child: serviceList[index]
                                                          .passwordEnable ==
                                                      true
                                                  ? Text(
                                                      "IN",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w800,
                                                          fontSize: 30,
                                                          color: Colors.green),
                                                    )
                                                  : Text(
                                                      "Out",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w800,
                                                          fontSize: 25,
                                                          color: Colors.green),
                                                    ),
                                            ),
                                          ],
                                        )
                                      ],
                                    )),
                              )));
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

  getSocietyrServices(DocumentSnapshot _lastDocument) async {
    if (!hasMore) {
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
      serviceList.clear();
      querySnapshot = await Firestore.instance
          .collection(globals.SOCIETY)
          .document(globals.mainId)
          .collection(widget.staffType)
          .where('enable', isEqualTo: true)
          .limit(documentLimit)
          .getDocuments();
    } else {
      querySnapshot = await Firestore.instance
          .collection(globals.SOCIETY)
          .document(globals.mainId)
          .collection(widget.staffType)
          .where('enable', isEqualTo: true)
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
          var service = AllService();
          service = AllService.fromJson(element.data);
          serviceList.add(service);
        });
      });
    }
    setState(() {
      isLoading = false;
    });
  }

  Widget _passCodeScreen() {
    return Scaffold(
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
                      style:
                          TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Text(
                        "Please type the verification code to CheckIn/checkOut the Staff",
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 15),
                        textAlign: TextAlign.center),
                    SizedBox(
                      height: 60,
                    ),
                    Form(
                      // key: formKey,
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        RaisedButton(
                          onPressed: () {
                            _checkIn();
                          },
                          child: Text("CheckIn"),
                        ),
                        RaisedButton(
                          onPressed: () {
                            _checkOut();
                          },
                          child: Text("CheckOut"),
                        )
                      ],
                    )
                  ],
                ),
              )))),
    );
  }

  _checkOut() async {
    print("start checkout");
    final snapshot = await Firestore.instance
        .collection(globals.SOCIETY)
        .document(globals.mainId)
        .collection(widget.staffType)
        .where("password", isEqualTo: _passwordController.text)
        .getDocuments()
        .then((value) {
      value.documents.forEach((element) {
        print("data checkout");
        print(element['documentNumber']);
        Firestore.instance
            .collection(globals.SOCIETY)
            .document(globals.mainId)
            .collection(widget.staffType)
            .document(element['documentNumber'])
            .setData({"passwordEnable": false}, merge: true).then(onGoBack);
        _showCheckOutDialog(value);
      });
    });
    if (snapshot == null)  {
      print(snapshot);
      showScaffold("PlZ Enter correct password");
    }
  }

  Future<void> _showCheckOutDialog(QuerySnapshot data) async {
    data.documents.forEach((element) {
      return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black54),
                      borderRadius: BorderRadius.circular(50)),
                  child: Container(
                      height: 70,
                      width: 70,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: CachedNetworkImage(
                          placeholder: (context, url) => Container(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  UniversalVariables.background),
                            ),
                            width: 50.0,
                            height: 50.0,
                          ),
                          imageUrl: element['photoUrl'],
                          fit: BoxFit.cover,
                        ),
                      )),
                ),
                Column(
                  children: [
                    Text(
                      element["name"],
                      style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontStyle: FontStyle.italic),
                    ),
                    Text(
                      ("CheckOut"),
                      style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontStyle: FontStyle.italic),
                    ),
                  ],
                )
              ],
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "DutyTiming",
                        style: TextStyle(fontWeight: FontWeight.w800),
                      ),
                      Text(element['dutyTiming'])
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Text(
                        element['name'] + " CheckOut the Society",
                        style: TextStyle(
                            fontWeight: FontWeight.w800, fontSize: 20),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            actions: [
              RaisedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("OK"),
              )
            ],
          );
        },
      );
    });
  }

  _checkIn() {
    Firestore.instance
        .collection(globals.SOCIETY)
        .document(globals.mainId)
        .collection(widget.staffType)
        .where("password", isEqualTo: _passwordController.text)
        .getDocuments()
        .then((value) {
      value.documents.forEach((element) {
        print(element['documentNumber']);
        Firestore.instance
            .collection(globals.SOCIETY)
            .document(globals.mainId)
            .collection(widget.staffType)
            .document(element['documentNumber'])
            .setData({"passwordEnable": true}, merge: true).then(onGoBack);
        _showCheckInDialog(value);
        _passwordController.clear();
      });
    });
  }

  Future<void> _showCheckInDialog(QuerySnapshot data) async {
    data.documents.forEach((element) {
      return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black54),
                      borderRadius: BorderRadius.circular(50)),
                  child: Container(
                      height: 70,
                      width: 70,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: CachedNetworkImage(
                          placeholder: (context, url) => Container(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  UniversalVariables.background),
                            ),
                            width: 50.0,
                            height: 50.0,
                          ),
                          imageUrl: element['photoUrl'],
                          fit: BoxFit.cover,
                        ),
                      )),
                ),
                Column(
                  children: [
                    Text(
                      element["name"],
                      style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontStyle: FontStyle.italic),
                    ),
                    Text(
                      ("CheckIn"),
                      style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontStyle: FontStyle.italic),
                    ),
                  ],
                )
              ],
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "DutyTiming",
                        style: TextStyle(fontWeight: FontWeight.w800),
                      ),
                      Text(element['dutyTiming'])
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Text(
                        element['name'] + " CheckIn the Society",
                        style: TextStyle(
                            fontWeight: FontWeight.w800, fontSize: 20),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            actions: [
              RaisedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("OK"),
              )
            ],
          );
        },
      );
    });
  }

  FutureOr onGoBack(dynamic value) {
    hasMore = true;
    getSocietyrServices(null);
  }
}
