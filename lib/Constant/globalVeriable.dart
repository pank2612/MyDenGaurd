
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:guard/Bloc/ConnectivityBloc.dart';


import 'ConstantTextField.dart';


//app
const String appName = 'MyDen';
const appType = "Guard";
//
TextEditingController companycontroller = TextEditingController();
TextEditingController companyImagecontroller = TextEditingController();


//addVisitors
TextEditingController mobileNumberController = TextEditingController();
TextEditingController nameController = TextEditingController();

var isLight = true;
var hourList = ["1 hour","2 hour","3 hour"];
var mainId = "";
//var parentId = "";
var flatNo = "";
String tokn;
String uuid;

var vechicalList = ["Uber",'OLA'];


//AllowDelivry
List<String> selectedReportList = List();
List<String> selectDayList = List();
List<String> selectedFrequentlyList = List();


var documentData = {"Aadhar Card" : validationKey.adharCard,"Pan Card" : validationKey.panCard};
validationKey changeValidation;

//image
File image;
int imageQuelity = 5;

String photoUrl = "";
var notificationKey =
    "key=AAAA7benEuU:APA91bE4pXVdtbXFYWyutC-cCxY76Gt30jDyR0og8iX8f6Jkbo0GLdc95kNusJrXjxPsVOvYsmaY4q7FbP2CH7lqWZtcUKJzUL5rA1oekx1WCo6IEoym4RcSELEt3y0LkiFciAQyvn3y";



//ExpectedVisitor
var type;
var number;
var guestNumber = [1,2,3,4,5];
var guestType = ["Guest","NewsPaper","Friends"];

// deliveryOrder
var time;
var day;
var timeArray = ["Sunday","Monday","Tuesday","Wednesday","Thursday",'Friday','Saturday'];
var dayArray = ["For 1 Days","For 2 Days","For 3 Days","For 4 Days","For 5 Days","For 10 Days","For 15 Days","For 20 Days","For 25 Days","For 30 Days"];

var vehicle = ["MoterBike","Car","Scotter","SchoolVan"];


var RWATokenMsg = "hello,this is yor unique Code dont't share it with another ";

var primaryColorString = '#3145f5';
var secondaryColorString = '#3145f5';

List<String> colors = ['#3145f5', '#32a852', '#e6230e', '#760ee6', '#db0ee6', '#db164e'];
int colorsIndex = 0;
ConnectivityBloc connectivityBloc;

String dateFormat = "dd-MM-yyyy";

//constants
const USERS = 'users';
const SPORTS_DATA = 'sports';
const TOURNAMENTS_DATA = 'tournaments';
const MATCH_DATA = 'matches';
const CONTEST_DATA = 'contest';
const TEAM_DATA = 'feams';
const PARTICIPATION = 'participation';
const FEAMDETAILS = 'feamDetails';
const TRANSACTIONS = 'Transactions';
const SOCIETY = "Society";
const VISITORS = "Visitors";
const HOUSES = "Houses";

final formKey = GlobalKey<FormState>();

////routes
//const String splashRoute = '/';
//const String homeRoute = '/home';
//const String authRoute = '/auth';
//const String loginScreen = '/login';
//const String signupScreen = '/signup';

//fonts
const String quickFont = 'Quicksand';

//colors
const COLOR_ACCENT = 0xFF304FFE;
const COLOR_PRIMARY_DARK = 0xFF1A237E;
const COLOR_PRIMARY = 0xFF3F51B5;
const FACEBOOK_BUTTON_COLOR = 0xFF3b5998;
const GOOGLE_BUTTON_COLOR = 0xFFFFFFFF;

