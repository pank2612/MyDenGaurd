import 'dart:collection';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:guard/Constant/Constant_Color.dart';

import 'StaffAndVendorTabBar.dart';






class LocalService extends StatefulWidget {
  @override
  _MaidScreenState createState() => _MaidScreenState();
}

class _MaidScreenState extends State<LocalService> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: UniversalVariables.background,
        title: Text("Local Service"),
      ),
      body: Padding(
        padding: EdgeInsets.all(15),
        child: StreamBuilder(
            stream: Firestore.instance.collection('ServiceName').snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return const Text('loading....');
              return ListView.builder(
                  reverse: true,
                  shrinkWrap: true,
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (context, index) {
                    return _buildListItem(
                        context, snapshot.data.documents[index]);
                  });
            }),
      ),
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot document) {
    return Padding(
        padding: EdgeInsets.all(0),
        child: optionList(document["LocalService"]));
  }

  Widget optionList(List data,) {
    return Container(
      width: MediaQuery.of(context).size.width / 1.2,
      child: ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: data.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=> StaffAndVandorTabBar(
                  staffType: data[index],
                )));
              },
              child: Card(
                color: UniversalVariables.background,
                  elevation: 2,
                  margin: const EdgeInsets.only(top: 10),
                  child: Padding(padding: EdgeInsets.all(5),
                    child: Text(
                      data[index],
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,fontStyle: FontStyle.italic,
                        color: UniversalVariables.ScaffoldColor
                      ),
                    ),
                  )
              ),
            );
          }),
    );
  }
}
