import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:guard/Bloc/AuthBloc.dart';
import 'package:guard/Constant/Constant_Color.dart';
import 'package:guard/GuradSignInScreen/activationScreen.dart';
import 'package:guard/VisitorsAtGate/VisitorsAtGateTabBarScreen.dart';
import 'package:guard/VisitorsCheckIn/VisitorsCheckIn.dart';
import 'package:guard/VisitorsCheckIn/VisitorsCheckOut.dart';
import 'package:guard/main.dart';
import 'package:guard/notification.dart';
import 'package:guard/staffAndVendorOut/MainScreen.dart';
import 'package:imei_plugin/imei_plugin.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../AddVisitors.dart';
import 'PassCodeCheckIn.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
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
    return Scaffold(
      appBar: AppBar(

        backgroundColor: UniversalVariables.background,
        title: Text("Home Page"),
        actions: [
          IconButton(icon: Icon(Icons.clear), onPressed: (){
            context.bloc<AuthBloc>().signOut().then((value) =>
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>MyApp())));
         })
        ],
        leading: IconButton(icon: Icon(Icons.dehaze), onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=> ActivationScreen()));
        }),
      ),
      body:ListView(
        children: [
          Padding(
            padding: const EdgeInsets.only(
                left: 16, right: 16, bottom: 12),
            child: GridView.count(
                crossAxisCount: 2,
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                children:
                List.generate(_categories.length, (index) {
                  return Padding(
                    padding:
                    const EdgeInsets.only(top: 10, bottom: 5),
                    child: InkWell(
                      splashColor: UniversalVariables.background,
                      onTap: () {
                        _NavigateScreen(index);
                      },
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                                Radius.circular(15))),
                        elevation: 10,
                        child: Column(
                          children: [
                            Container(
                              child: Image.network(
                                _categories[index]["image"],
                                height: 90,
                                width: 90,
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Expanded(
                                child: Padding(padding: EdgeInsets.only(left: 10,right: 6),
                                  child: Text(
                                    _categories[index]["name"],
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),)
                            ),

                            Expanded(
                                child: Padding(padding: EdgeInsets.only(left: 10,right: 6),
                                  child: Text(
                                    _categories[index]["secondName"],
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),)
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                })),
          )
        ],
      ),
    );
  }
  List<Map<String, dynamic>> _categories = [
    {
      'name': 'New Visitors',
      'secondName': 'Visitors Check In',
      'image': "https://degoo.com/android-chrome-256x256.png?v=3eB5GjaPya"
    },
    {
      'name': "Visitors Check-Out",
      'secondName': 'Visitors Check-Out',
      'image':
      "https://aubergestjacques.com/wp-content/uploads/2017/04/check-out-1.png"
    },
    {
      'name': 'Pass-Code Check In',
      'secondName': 'Pass-Code Check In',
      'image':
      "https://static-s.aa-cdn.net/img/gp/20600003668724/XvTPINgieeXN06Yke_vvQFFJY9O4GRFZhx3L8myKTIyLmTdVMotkOiparqwpgWRQfok=w300?v=1"
    },
    {
      'name': "Staff & Vendor Out",
      'secondName': 'Staff & Vendor Out',
      'image':
      "https://www.manageteamz.com/blog/wp-content/uploads/2019/12/Grocery-Delivery.png"
    },
    {
      'name': "Visitor's At Gate",
      'secondName': 'Accept/Reject Visitors',
      'image': "https://mclean.co.in/homeservices/wp-content/uploads/2020/04/trained-personnel.png"
    },
    {
      'name': "Visitor's Logs",
      'secondName': 'Visitors Check In',
      'image':
      "https://is1-ssl.mzstatic.com/image/thumb/Purple4/v4/c4/7c/a3/c47ca35d-1284-a4df-6723-83465fcca22a/source/256x256bb.jpg"
    },
    {
      'name': "Car IN/OUT",
      'secondName': 'Car IN/OUT',
      'image': "https://www.shareicon.net/data/2015/06/05/49543_polls_256x256.png"
    },



  ];

  Widget _NavigateScreen(int indexValue) {
    if (indexValue == 0) {
      Navigator.push(
          context, CupertinoPageRoute(builder: (context) => VisitorsAtGateTabBar()));
    } else if (indexValue == 1) {
      Navigator.push(
          context, CupertinoPageRoute(builder: (context) => VisitorsCheckOut()));
    } else if (indexValue == 2) {
      Navigator.push(
          context, CupertinoPageRoute(builder: (context) => PassCodeCheckIn()));
    }
    else if (indexValue == 3) {
      Navigator.push(
          context, CupertinoPageRoute(builder: (context) => LocalService()));
    }
    else if (indexValue == 4) {
      Navigator.push(
          context, CupertinoPageRoute(builder: (context) => VisitorsAtGateTabBar()));}
     else if (indexValue == 5) {
      Navigator.push(
          context, CupertinoPageRoute(builder: (context) => VisitorsCheckIn()));
     }
    // else if (indexValue == 6) {
    //   Navigator.push(
    //       context, CupertinoPageRoute(builder: (context) => mainPollScreen()));
    // } else if (indexValue == 7) {
    //   Navigator.push(
    //       context, CupertinoPageRoute(builder: (context) => GatesScreen()));
    // } else if (indexValue == 8) {
    //   Navigator.push(
    //       context, CupertinoPageRoute(builder: (context) => VendorsScreen()));
    // } else if (indexValue == 9) {
    //   Navigator.push(
    //       context, CupertinoPageRoute(builder: (context) => AmenityScreen()));
    // }else if (indexValue == 10) {
    //   // Navigator.push(
    //   //     context, CupertinoPageRoute(builder: (context) => Visitors()));
    // }

    else {
      return Text("");
    }
  }
}
