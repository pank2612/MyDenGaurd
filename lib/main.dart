

import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';


import 'package:bloc/bloc.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'Bloc/ConnectivityBloc.dart';
import 'Bloc/MainBloc.dart';
import 'package:guard/Constant/globalVeriable.dart' as globals;

import 'GuradSignInScreen/SplashScreen.dart';
import 'MainScreen/mainScreen.dart';


//test
class SimpleBlocObserver extends BlocObserver {
  @override
  void onEvent(Bloc bloc, Object event) {
    print('bloc: ${bloc.runtimeType}, event: $event');
    super.onEvent(bloc, event);
  }

  @override
  void onChange(Cubit cubit, Change change) {
    print('cubit: ${cubit.runtimeType}, change: $change');
    super.onChange(cubit, change);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    print('bloc: ${bloc.runtimeType}, transition: $transition');
    super.onTransition(bloc, transition);
  }

  @override
  void onError(Cubit cubit, Object error, StackTrace stackTrace) {
    print('cubit: ${cubit.runtimeType}, error: $error');
    super.onError(cubit, error, stackTrace);
  }
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  //BlocSupervisor().delegate = SimpleBlocDelegate();
  Bloc.observer = SimpleBlocObserver();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then((_) => runApp(

      MultiBlocProvider(
          providers: MainBloc.allBlocs(),
          child:
          new MyApp()
      )
  ));
}


class MyApp extends StatefulWidget {

  static setCustomeTheme(BuildContext context, int index) {
    final _MyAppState state = context.findAncestorStateOfType<_MyAppState>();
    state.setCustomeTheme(index);
  }

  @override
  State<StatefulWidget> createState() => _MyAppState();
}


class _MyAppState extends State<MyApp> {
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();



  @override
  void initState() {

    globals.connectivityBloc = ConnectivityBloc();
    globals.connectivityBloc.onInitial();


    super.initState();
  }

  showMessage(title, description) {
    showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Text(title),
            content: Text(description),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.pop(ctx);
                },
                child: Text("Dismiss"),
              )
            ],
          );
        });
  }

  void setCustomeTheme(int index) {
    setState(() {
      globals.colorsIndex = index;
      globals.primaryColorString = globals.colors[globals.colorsIndex];
      globals.secondaryColorString = globals.primaryColorString;
    });
  }


  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: globals.isLight ? Brightness.dark : Brightness.light,
    ));
    return Container(
      // color: AllCoustomTheme.getThemeData().primaryColor,
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: globals.appName,
          // theme: AllCoustomTheme.getThemeData(),
          // routes: routes,
          home: SplashScreen()
      ),
    );
  }
  @override
  void dispose() {
    super.dispose();
  }

}


// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// void main(){
//   runApp(MaterialApp(
//     home: Message(),
//   ));
// }
//
// class Message extends StatefulWidget {
//   @override
//   _MessageState createState() => _MessageState();
// }
//
// class _MessageState extends State<Message> {
//   final Firestore _db = Firestore.instance;
//   final FirebaseMessaging _fcm = FirebaseMessaging();
//
//   @override
//   void initState() {
//     super.initState();
//
//     _fcm .configure(
//       onMessage: (Map<String, dynamic> message) async{
//          print("onMessage: $message");
//          showDialog(context: context,
//          builder: (context) => AlertDialog(
//            content: ListTile(
//              title: Text(message['notification']['title']),
//              subtitle:Text(message['notification']['body']),
//            ),
//            actions: [
//              FlatButton(onPressed: (){
//                Navigator.pop(context);
//              }, child: Text("Ok"))
//            ],
//          ),
//          );
//       },
//         onResume: (Map<String, dynamic> message) async{
//         print("onResume: $message");
//       },
//       onLaunch: (Map<String, dynamic> message) async{
//         print("onLaunch: $message");
//       },
//
//
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Container();
//   }
// }
//
