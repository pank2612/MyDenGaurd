
import 'package:flutter/material.dart';
import 'package:guard/Constant/globalVeriable.dart' as global;

class UserData {
  String uid;
  String name;
  String email;
  String phoneNo;

  String gender;
  String flatNo;
  String profilePhoto;
  List<AccessList> accessList;
  bool emailVerified;

  UserData({
    this.uid,
    this.name,
    this.email,
    this.phoneNo,
    this.gender,
    this.flatNo,
    this.profilePhoto,
    this.accessList,
    this.emailVerified
  });
  Map toJson() {
    var data = Map<String, dynamic>();
    data['id'] = this.uid;
    data['nickname'] = this.name;
    data['email'] = this.email;
    data['phoneNo'] = this.phoneNo;

    data["gender"] = this.gender;
    data["url"] = this.flatNo;
    data["photoUrl"] = this.profilePhoto;
    //final Map<String, dynamic> data = new Map<String, dynamic>();
    // if (this.accessList != null) {
    //   data['accessList'] = this.accessList.map((v) => v.toMap(v)).toList();
    // }
    return data;
  }
  UserData.fromMap(Map<String, dynamic> mapData) {
    this.uid = mapData['id'];
    this.name = mapData['nickname'];
    this.email = mapData['email'];
    this.phoneNo = mapData['phoneNo'];

    this.gender = mapData['gender'];
    this.flatNo = mapData['flatNo'];
    this.profilePhoto = mapData['photoUrl'];
    if(mapData['accessList']!=null) {
      List<AccessList> mainAccessList = List<AccessList>();
      for (int i = 0; i < mapData['accessList'].length; i++) {
        if(mapData['accessList'][i]['type'] == global.appType){
          print(mapData['accessList'][i]['id']);
          AccessList accessList = AccessList();
          accessList.id = mapData['accessList'][i]['id'];
          accessList.type = mapData['accessList'][i]['type'];
          accessList.status = mapData['accessList'][i]["status"];

          print(accessList);
          mainAccessList.add(accessList);
        }}
      this.accessList = mainAccessList;
    }
  }
}


class AccessList{

  String id;
  bool status;
  String type;


  AccessList({
    this.id,
    this.status,
    this.type,

  });
  Map toMap(AccessList obj) {
    var data = Map<String, dynamic>();
    data['id'] = obj.id;
    data['status'] = obj.status;
    data['type'] = obj.type;


    return data;
  }
  AccessList.fromMap(Map<String, dynamic> mapData) {
    this.id = mapData['id'];
    this.status = mapData['status'];
    this.type = mapData['type'];

  }

}