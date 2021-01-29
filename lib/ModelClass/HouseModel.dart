import 'dart:convert';

import 'dart:core';

import 'dart:core';

class House {
  String houseId;
  String flatMember;
  String flatNumber;
  String flatOwner;
  String tower;
  bool enable;
  String tokenNo;
  String flag;
  List<Localservices> localServiceList;
  List<TwoWheeler> twoWheeler;
  List<FourWheeler> fourWheeler;

  House(
      {this.flatMember,
        this.houseId,
        this.flatNumber,
        this.flatOwner,
        this.tower,
        this.flag,
        this.enable,
        this.localServiceList,
        this.twoWheeler,
        this.fourWheeler,
        this.tokenNo});

  House.fromJson(Map<String, dynamic> json)
      : flatOwner = json['flatOwner'],
        flatNumber = json['flatNumber'],
        flatMember = json['flatMember'],
        tower = json['tower'],
        houseId = json['houseId'],
        enable = json['enable'],
        flag = json['flag'],
        localServiceList = List<Localservices>.from(
            json["localServiceList"].map((x) => Localservices.fromJson(x))),
        fourWheeler = List<FourWheeler>.from(
            json["fourWheeler"].map((x) => FourWheeler.fromJson(x))),
        twoWheeler = List<TwoWheeler>.from(
            json["twoWheeler"].map((x) => TwoWheeler.fromJson(x))),
        tokenNo = json['tokenNo'];

  Map<String, dynamic> toJson() => {
    'flatOwner': flatOwner,
    'houseId': houseId,
    'flag': flag,
    'flatNumber': flatNumber,
    'flatMember': flatMember,
    'tower': tower,
    'enable': enable,
    'localServiceList':
    List<dynamic>.from(localServiceList.map((x) => x.toJson())),
    'twoWheeler': List<dynamic>.from(twoWheeler.map((x) => x.toJson())),
    'fourWheeler': List<dynamic>.from(fourWheeler.map((x) => x.toJson())),
    'tokenNo': tokenNo
  };
}

class Localservices {
  String id;
  String service;
  bool enable;

  Localservices({this.id, this.service, this.enable});

  Localservices.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        service = json['service'],
        enable = json['enable'];

  Map<String, dynamic> toJson() => {
    'id': id,
    'service': service,
    'enable': enable,
  };
}

class TwoWheeler {
  String twoName;
  String twoNumber;

  TwoWheeler({
    this.twoName,
    this.twoNumber,
  });

  TwoWheeler.fromJson(Map<String, dynamic> json)
      : twoName = json['twoName'],
        twoNumber = json['twoNumber'];

  Map<String, dynamic> toJson() => {
    'twoName': twoName,
    'twoNumber': twoNumber,
  };
}

class FourWheeler {
  String fourName;
  String fourNumber;

  FourWheeler({
    this.fourName,
    this.fourNumber,
  });

  FourWheeler.fromJson(Map<String, dynamic> json)
      : fourName = json['fourName'],
        fourNumber = json['fourNumber'];

  Map<String, dynamic> toJson() => {
    'fourName': fourName,
    'fourNumber': fourNumber,
  };
}





class HouseId {
  String id;

  bool enable;

  HouseId({this.id,  this.enable});

  HouseId.fromJson(Map<String, dynamic> json)
      : id = json['id'],

        enable = json['enable'];

  Map<String, dynamic> toJson() => {
    'id': id,

    'enable': enable,
  };
}