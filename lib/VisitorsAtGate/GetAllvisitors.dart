import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:guard/Constant/Constant_Color.dart';
import 'package:guard/ModelClass/visitors.dart';
import 'package:guard/Constant/globalVeriable.dart' as globals;
import 'package:intl/intl.dart';

class GetAllVisitors extends StatefulWidget {
  @override
  _GetAllVisitorsState createState() => _GetAllVisitorsState();
}

class _GetAllVisitorsState extends State<GetAllVisitors> {
  List<Visitor> visitorsList = List<Visitor>();
  bool hasMore = true;
  bool isLoading = false;
  int documentLimit = 10;
  DocumentSnapshot lastDocument = null;
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
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
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          visitorsList[index].visitorType + " + " + visitorsList[index].visitorNumber,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize: 15),
                                        ),
                                      ],
                                    ),
                                    Divider(
                                      color: Colors.black,
                                    ),
                                    Row(
                                      children: [
                                        Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(70)),
                                            height: 50,
                                            width: 50,
                                            child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(70),
                                                child: Padding(
                                                    padding: EdgeInsets.all(5),
                                                    child: visitorsList[index]
                                                                .accept ==
                                                            true
                                                        ? Image.asset(
                                                            "images/done.png",
                                                            fit: BoxFit.cover)
                                                        : visitorsList[index]
                                                                    .accept ==
                                                                false
                                                            ? Image.asset(
                                                                "images/cancel.png",
                                                                fit: BoxFit
                                                                    .cover)
                                                            : Image.asset(
                                                      "images/coming.png",
                                                      fit: BoxFit.cover,
                                                    )))),
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
                                    // Divider(
                                    //   color: Colors.black,
                                    // ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        visitorsList[index].enable == true
                                            ? Container()
                                            : Card(
                                                color: Colors.grey,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20)),
                                                child: Padding(
                                                  padding: EdgeInsets.all(5),
                                                  child: visitorsList[index].accept ==
                                                          false
                                                      ? Text(
                                                          "Cancel By " +
                                                              visitorsList[
                                                                      index]
                                                                  .deletName,
                                                          style: TextStyle(
                                                              color: UniversalVariables
                                                                  .ScaffoldColor,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w800,
                                                              fontSize: 12),
                                                        )
                                                      : Text(
                                                          "Accept By " +
                                                              visitorsList[
                                                                      index]
                                                                  .deletName,
                                                          style: TextStyle(
                                                              color: UniversalVariables
                                                                  .ScaffoldColor,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w800,
                                                              fontSize: 12),
                                                        ),
                                                ))
                                      ],
                                    )
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
          .where('inviteBye', isEqualTo: "Guard")
          .where("inviteDate",
              isGreaterThanOrEqualTo:
                  DateTime.now().subtract(Duration(days: 1)).toIso8601String())
          .orderBy("inviteDate", descending: true)
          .limit(documentLimit)
          .getDocuments();
    } else {
      querySnapshot = await Firestore.instance
          .collection(globals.SOCIETY)
          .document(globals.mainId)
          .collection(globals.VISITORS)
          .where('inviteBye', isEqualTo: "Guard")
          .where("inviteDate", isGreaterThanOrEqualTo: DateTime.now().subtract(Duration(days: 1)).toIso8601String())
          .orderBy("inviteDate", descending: true)
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
}
