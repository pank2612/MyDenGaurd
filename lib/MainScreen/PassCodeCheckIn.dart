import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:guard/Bloc/AuthBloc.dart';
import 'package:guard/Constant/ConstantTextField.dart';
import 'package:guard/Constant/Constant_Color.dart';
import 'package:guard/Constant/globalVeriable.dart' as globals;
import 'package:guard/ModelClass/userModelClass.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PassCodeCheckIn extends StatefulWidget {
  @override
  _PassCodeCheckInState createState() => _PassCodeCheckInState();
}

class _PassCodeCheckInState extends State<PassCodeCheckIn> {
  TextEditingController _passwordController = TextEditingController();


  final formKey = GlobalKey<FormState>();

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
        _showDialog(value);
        print("QQQQQQ");
        value.documents.forEach((element) {
          print(element['token']);
          showSociety(element['id']);
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
                width: MediaQuery
                    .of(context)
                    .size
                    .width,
                color: UniversalVariables.background,
                child: Padding(
                    padding: EdgeInsets.all(5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Expected Visitors Details',
                          style: TextStyle(
                              color: UniversalVariables.ScaffoldColor),
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
                      Text(element['name'])
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
                      Text(element['ownerName'])
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

  Future<void> _showWrong() async {
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
                  "Please Enter Correct Code",
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
  showSociety(String vistorsId){
    Firestore.instance
        .collection(globals.SOCIETY)
        .document(globals.mainId)
        .collection(globals.VISITORS)
        .document(vistorsId).setData({"inOut": false},merge: true);
  }




}
