import 'package:flutter/material.dart';
import 'package:guard/Constant/Constant_Color.dart';
import 'package:intl/intl.dart';

import 'Constant/ConstantTextField.dart';
import 'ModelClass/visitors.dart';
import 'package:guard/Constant/globalVeriable.dart' as global;
class AddVisitors extends StatefulWidget {
  @override
  _AddVisitorsState createState() => _AddVisitorsState();
}

class _AddVisitorsState extends State<AddVisitors> {
  List<Visitor> vendorsList = List<Visitor>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  TextEditingController _dateController = TextEditingController();
  TextEditingController _tokenController = TextEditingController();
  TextEditingController _firstTimeController = TextEditingController();
  TextEditingController _secondTimeController = TextEditingController();

  TextEditingController searchController = new TextEditingController();


  bool isAllDay = true;
  bool isLoading = false;
  bool showPhoneNumber = false;

  Future<Null> _selectDate(BuildContext context, DateTime firstDate,
      DateTime lastDate) async {
    DateTime selectedDate = firstDate;
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: firstDate,
        lastDate: lastDate);
    if (picked != null) selectedDate = picked;
    String _formattedate =
    new DateFormat(global.dateFormat).format(selectedDate);
    setState(() {
      _dateController.value = TextEditingValue(text: _formattedate);
    });
  }


  @override
  void initState() {


    global.type = "Select Visitor ";
    global.number = "0";
    global.mobileNumberController.clear();
    global.nameController.clear();
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: UniversalVariables.background,
          title: Text("Expected Visitors"),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Stack(
          children: [
            Padding(
              padding: EdgeInsets.all(20),
              child: ListView(
                children: [
                  SizedBox(
                    height: 20,
                  ),

                  SizedBox(
                    height: 40,
                  ),
                  Form(
                    child: Column(
                      children: [
                        constantTextField().InputField(
                            "Enter Mobile Number",
                            "",
                            validationKey.mobileNo,
                            global.mobileNumberController,
                            false,
                            IconButton(
                                icon: Icon(Icons.contact_phone),
                                onPressed: () {}),
                            1,
                            1,
                            TextInputType.number,
                            false),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: constantTextField().InputField(
                                  "Visitor's Name",
                                  "",
                                  validationKey.name,
                                  global.nameController,
                                  false,
                                  IconButton(
                                      icon: Icon(Icons.contact_phone),
                                      onPressed: () {}),
                                  1,
                                  1,
                                  TextInputType.text,
                                  false),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Icon(
                              Icons.add,
                              size: 30,
                              color: UniversalVariables.background,
                            ),
                            Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(
                                        color: UniversalVariables.background)),
                                child: Padding(
                                  padding: EdgeInsets.all(0),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        "0",
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w800),
                                      ),
                                      PopupMenuButton<String>(
                                        icon: const Icon(Icons.arrow_drop_down),
                                        onSelected: (String val) {
                                          global.number = val;
                                          setState(() {
                                            global.changeValidation =
                                            global.documentData[val];
                                          });
                                        },
                                        itemBuilder: (BuildContext context) {
                                          return global.guestNumber
                                              .map<PopupMenuItem<String>>(
                                                  (int val) {
                                                return new PopupMenuItem(
                                                    child: new Text(
                                                        val.toString()),
                                                    value: val.toString());
                                              }).toList();
                                        },
                                      ),
                                    ],
                                  ),
                                )),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Visitor Type",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w800),
                            ),
                            Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(
                                        color: UniversalVariables.background)),
                                child: Padding(
                                  padding: EdgeInsets.all(0),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        "",
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w800),
                                      ),
                                      PopupMenuButton<String>(
                                        icon: const Icon(Icons.arrow_drop_down),
                                        onSelected: (String val) {
                                          global.type = val;
                                          setState(() {
                                            global.changeValidation =
                                            global.documentData[val];
                                          });
                                        },
                                        itemBuilder: (BuildContext context) {
                                          return global.guestType
                                              .map<PopupMenuItem<String>>(
                                                  (String val) {
                                                return new PopupMenuItem(
                                                    child: new Text(val),
                                                    value: val);
                                              }).toList();
                                        },
                                      ),
                                    ],
                                  ),
                                ))
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        InkWell(
                          onTap: () {
                            _selectDate(
                                context,
                                DateTime.now().subtract(Duration(days: 0)),
                                DateTime.now().add(Duration(days: 365)));
                          },
                          child: IgnorePointer(
                              child: constantTextField().InputField(
                                  "Enter Date",
                                  "",
                                  validationKey.date,
                                  _dateController,
                                  true,
                                  IconButton(
                                    icon: Icon(Icons.calendar_today),
                                    onPressed: () {},
                                  ),
                                  1,
                                  1,
                                  TextInputType.name,
                                  false)),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            Checkbox(
                              activeColor: UniversalVariables.background,
                              value: isAllDay,
                              onChanged: (value) {
                                setState(() {
                                  isAllDay = value;
                                  print(isAllDay);
                                });
                              },
                            ),
                            Text("All Day"),
                          ],
                        ),
                        !isAllDay
                            ? Column(
                          children: [
                            InkWell(
                                onTap: () {
                                  showTimePicker(
                                      context: context,
                                      initialTime: TimeOfDay(
                                          hour: DateTime
                                              .now()
                                              .hour,
                                          minute:
                                          DateTime
                                              .now()
                                              .minute))
                                      .then((TimeOfDay value) {
                                    if (value != null) {
                                      _firstTimeController.text =
                                          value.format(context);
                                    }
                                  });
                                },
                                child: IgnorePointer(
                                  child: constantTextField().InputField(
                                      "9:00 pm",
                                      "",
                                      validationKey.time,
                                      _firstTimeController,
                                      true,
                                      IconButton(
                                          icon:
                                          Icon(Icons.arrow_drop_down),
                                          onPressed: () {}),
                                      1,
                                      1,
                                      TextInputType.emailAddress,
                                      false),
                                )),
                            SizedBox(
                              height: 10,
                            ),
                            InkWell(
                                onTap: () {
                                  showTimePicker(
                                      context: context,
                                      initialTime: TimeOfDay(
                                          hour: DateTime
                                              .now()
                                              .hour,
                                          minute:
                                          DateTime
                                              .now()
                                              .minute))
                                      .then((TimeOfDay value) {
                                    if (value != null) {
                                      _secondTimeController.text =
                                          value.format(context);
                                    }
                                  });
                                },
                                child: IgnorePointer(
                                  child: constantTextField().InputField(
                                      "6:00 am",
                                      "6:00 am",
                                      validationKey.time,
                                      _secondTimeController,
                                      true,
                                      IconButton(
                                        icon: Icon(Icons.arrow_drop_down),
                                        onPressed: () {},
                                      ),
                                      1,
                                      1,
                                      TextInputType.emailAddress,
                                      false),
                                )),
                          ],
                        )
                            : Container()
                      ],
                    ),
                  ),
               //   _imageFile != null ? Image.file(_imageFile) : Container(),
                  SizedBox(
                    height: 50,
                  ),
                  RaisedButton(
                    color: UniversalVariables.background,
                    onPressed: () {
                      // global.uuid = Uuid().v1();
                      // _tokenController.text = RandomString(10);
                      // addExpected();

                      // getHouseDetails();
                    },
                    child: Text(
                      "Add",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: UniversalVariables.ScaffoldColor),
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                ],
              ),
            ),

          ],
        ));
  }
}
