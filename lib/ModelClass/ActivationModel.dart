class ActivationCode {
  String iD;
  String type;
  String society;
  DateTime creationDate;
  String societyId;
  bool enable;
  String flatNo;
  bool master;


  ActivationCode({this.iD, this.type,this.society, this.creationDate,
    this.societyId, this.enable,this.flatNo,this.master});

  ActivationCode.fromJson(Map<String, dynamic> json)
      : iD = json['iD'],
        type = json['type'],
        master = json['master'],
        flatNo = json['flatNo'],
        society = json['society'],
        creationDate = DateTime.tryParse(json['creationDate']),
        societyId = json['tokenNo'],
        enable = json['enable'];

  Map<String, dynamic> toJson() =>
      {
        'iD': iD,
        'type': type,
        'master': master,
        'flatNo': flatNo,
        'society': society,
        'creationDate': creationDate.toIso8601String(),
        'tokenNo': societyId,
        'enable' : enable
      };

}
