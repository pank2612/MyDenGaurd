//
// import 'package:contacts_service/contacts_service.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// class PushMessagingExample extends StatefulWidget {
//   @override
//   _PushMessagingExampleState createState() => new _PushMessagingExampleState();
// }
//
// class _PushMessagingExampleState extends State<PushMessagingExample> {
//   String _homeScreenText = "Waiting for token...";
//   bool _topicButtonsDisabled = false;
//
//   final FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();
//   final TextEditingController _topicController =
//   new TextEditingController(text: 'topic');
//
//   Future<Null> _showItemDialog(Map<String, dynamic> message) async {
//     final Item item = _itemForMessage(message);
//     showDialog<Null>(
//         context: context,
//         child: new AlertDialog(
//           content: new Text("Item ${message} has been updated"),
//           actions: <Widget>[
//             new FlatButton(
//                 child: const Text('CLOSE'),
//                 onPressed: () {
//                   Navigator.pop(context, false);
//                 }),
//             new FlatButton(
//                 child: const Text('SHOW'),
//                 onPressed: () {
//                   Navigator.pop(context, true);
//                 }),
//           ],
//         )).then((bool shouldNavigate) {
//       if (shouldNavigate == true) {
//         _navigateToItemDetail(message);
//       }
//     });
//   }
//
//   Future<Null> _navigateToItemDetail(Map<String, dynamic> message) async     {
//     final Item item = _itemForMessage(message);
// // Clear away dialogs
//     Navigator.popUntil(context, (Route<dynamic> route) => route is PageRoute);
//     if (!item.route.isCurrent) {
//       Navigator.push(context, item.route);
//     }
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     _firebaseMessaging.configure(
//       onMessage: (Map<String, dynamic> message) {
//         print("onMessage: $message");
//         print(message);
//         _showItemDialog(message);
//       },
//       onLaunch: (Map<String, dynamic> message) {
//         print("onLaunch: $message");
//         print(message);
//         _navigateToItemDetail(message);
//       },
//       onResume: (Map<String, dynamic> message) {
//         print("onResume: $message");
//         print(message);
//         _navigateToItemDetail(message);
//       },
//     );
//     _firebaseMessaging.requestNotificationPermissions(
//         const IosNotificationSettings(sound: true, badge: true, alert: true));
//     _firebaseMessaging.onIosSettingsRegistered
//         .listen((IosNotificationSettings settings) {
//       print("Settings registered: $settings");
//     });
//     _firebaseMessaging.getToken().then((String token) {
//       assert(token != null);
//       setState(() {
//         _homeScreenText = "Push Messaging token: $token";
//       });
//       print(_homeScreenText);
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return new Scaffold(
//
//
//         body: new Material(
//           child: new Column(
//             children: <Widget>[
//               new Center(
//                 child: new Text(_homeScreenText),
//               ),
//
//             ],
//           ),
//         ));
//   }
//
// }