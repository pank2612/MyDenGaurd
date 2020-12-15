import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:guard/Constant/Constant_Color.dart';
import 'package:guard/ModelClass/visitors.dart';
import 'package:intl/intl.dart';
import 'package:guard/Constant/globalVeriable.dart' as globals;

class VisitorsCheckIn extends StatefulWidget {
  @override
  _VendorsScreenState createState() => _VendorsScreenState();
}

class _VendorsScreenState extends State<VisitorsCheckIn> {
  List<Visitor> visitorsList = List<Visitor>();
  bool isLoading = false;
  bool hasMore = true;
  int documentLimit = 10;
  DocumentSnapshot lastDocument = null;
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    getExpectedVisitors(lastDocument);
  }

  @override
  Widget build(BuildContext context) {
    _scrollController.addListener(() {
      double maxScroll = _scrollController.position.maxScrollExtent;
      double currentScroll = _scrollController.position.pixels;
      double delta = MediaQuery.of(context).size.height * 0.20;
      if (maxScroll - currentScroll <= delta) {
        getExpectedVisitors(lastDocument);
      }
    });
    return Scaffold(
      appBar: AppBar(
        backgroundColor: UniversalVariables.background,
        title: Text(
          "Visitors Screen",
          style: TextStyle(color: UniversalVariables.ScaffoldColor),
        ),
      ),
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
                                          minRadius: 25,
                                                  child: visitorsList[index]
                                                              .inOut ==
                                                          false
                                                      ? Text(
                                                          "IN",
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w800,
                                                              fontSize: 30,
                                                              color:
                                                                  Colors.green),
                                                        )
                                                      : Text(
                                                          "",
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w800,
                                                              fontSize: 25,
                                                              color:
                                                                  Colors.green),
                                                        ),
                                                ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  1.5,
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
      // floatingActionButton: FloatingActionButton(
      //   backgroundColor: UniversalVariables.background,
      //   onPressed: () {
      //     Navigator.push(context, MaterialPageRoute(builder: (context)=>AddExpected()));
      //     // navigateSecondPage();
      //   },
      //   child: Icon(Icons.add),
      // ));
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
          .limit(documentLimit)
          .where("inOut",isEqualTo: false)
          .where("inviteDate", isGreaterThanOrEqualTo:
                  DateTime.now().subtract(Duration(days: 1)).toIso8601String())


          .getDocuments();
    } else {
      querySnapshot = await Firestore.instance
          .collection(globals.SOCIETY)
          .document(globals.mainId)
          .collection(globals.VISITORS)
          .limit(documentLimit)
          .where("inOut",isEqualTo: false)
          .where("inviteDate",
              isGreaterThanOrEqualTo:
                  DateTime.now().subtract(Duration(days: 1)).toIso8601String())
          .startAfterDocument(_lastDocument)
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
}
