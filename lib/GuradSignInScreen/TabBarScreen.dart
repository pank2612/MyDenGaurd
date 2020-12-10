

import 'dart:io';



import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:guard/Constant/Constant_Color.dart';
import 'package:guard/MainScreen/mainScreen.dart';
import 'package:guard/Constant/globalVeriable.dart' as global;


//SharedPreferences prefs;
class TabBarScreen extends StatefulWidget {
  final society;

  const TabBarScreen({Key key, this.society}) : super(key: key);
  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<TabBarScreen> {
  int _page = 0;
  GlobalKey _bottomNavigationKey = GlobalKey();
  PageController pageController;
  final pages = [MainScreen(),MainScreen(),MainScreen(),MainScreen(),MainScreen()];





  @override
  void initState() {
    print("societyid ${global.mainId}");

    // savelocalCode().toGetDate(societyId).then((value){
    //   setState(() {
    //     globals.societyId = value;
    //
    //     activationValue = value;
    //   });
    //
    // }
    // );
//    print("hbjbvksdfbvksdf");
    //print(globals.societyId);
//    print(activationValue);

    super.initState();
    pageController = PageController();
  }


  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  void navigationTapped(int page) {
    pageController.jumpToPage(page);
  }





  Future<bool> onBackPress() {
    openDialog();
    return Future.value(false);
  }

  Future<Null> openDialog() async {
    switch (await showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            contentPadding: EdgeInsets.only(left: 0.0, right: 0.0, top: 0.0, bottom: 0.0),
            children: <Widget>[
              Container(
                color: UniversalVariables.background,
                margin: EdgeInsets.all(0.0),
                padding: EdgeInsets.only(bottom: 10.0, top: 10.0),
                height: 120.0,
                child: Column(
                  children: <Widget>[
                    Container(
                      child: Icon(
                        Icons.exit_to_app,
                        size: 30.0,
                        color: Colors.white,
                      ),
                      margin: EdgeInsets.only(bottom: 10.0),
                    ),
                    Text(
                      'Exit app',
                      style: TextStyle(color: Colors.white, fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Are you sure to exit app?',
                      style: TextStyle(color: Colors.white70, fontSize: 14.0),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15,bottom: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SimpleDialogOption(
                      onPressed: () {
                        Navigator.pop(context, 0);
                      },
                      child: Row(

                        children: <Widget>[
                          Container(
                            child: Icon(
                              Icons.cancel,
                              //  color: primaryColor,
                            ),
                            margin: EdgeInsets.only(right: 10.0),
                          ),
                          Text(
                            'No',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ),

                    SimpleDialogOption(
                      onPressed: () {
                        Navigator.pop(context, 1);
                      },
                      child: Row(
                        children: <Widget>[
                          Container(
                            child: Icon(
                              Icons.check_circle,
                              //  color: primaryColor,
                            ),
                            margin: EdgeInsets.only(right: 10.0),
                          ),
                          Text(
                            'YES',
                            style: TextStyle(
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),

            ],
          );
        })) {
      case 0:
        break;
      case 1:
        exit(0);
        break;
    }
  }



  @override
  Widget build(BuildContext context) {
    return

      Scaffold(
        body: WillPopScope(
            onWillPop: onBackPress,
            child: pages[_page]),
        bottomNavigationBar: CurvedNavigationBar(
          key: _bottomNavigationKey,
          index: 0,
          height: 50.0,
          items: <Widget>[

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                  children: [
                    SizedBox(height: 10,),
                    Icon(Icons.home, size: 20,color: UniversalVariables.ScaffoldColor,),
                    Text("Home",style: TextStyle(color: UniversalVariables.ScaffoldColor,fontSize: 10),)
                  ]),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                  children: [
                    SizedBox(height: 10,),
                    Icon(Icons.watch_later, size: 20,color: UniversalVariables.ScaffoldColor,),
                    Text("Activity",style: TextStyle(color: UniversalVariables.ScaffoldColor,fontSize: 10),)
                  ]),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(Icons.add, size: 30,color: UniversalVariables.ScaffoldColor,),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                  children: [
                    SizedBox(height: 10,),
                    Icon(Icons.settings, size: 20,color: UniversalVariables.ScaffoldColor,),
                    Text("Setting",style: TextStyle(color: UniversalVariables.ScaffoldColor,fontSize: 10),)
                  ]),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                  children: [
                    SizedBox(height: 10,),
                    Icon(Icons.cloud_done, size: 20,color: UniversalVariables.ScaffoldColor,),
                    Text("MyDen",style: TextStyle(color: UniversalVariables.ScaffoldColor,fontSize: 10),)
                  ]),
            ),

          ],
          color: UniversalVariables.background,
          buttonBackgroundColor: UniversalVariables.background,
          backgroundColor: UniversalVariables.ScaffoldColor,
          animationCurve: Curves.easeInOut,
          animationDuration: Duration(milliseconds: 600),
          onTap: (index) {
            setState(() {

              _page = index;

            });
          },
        ),

      );
  }
}