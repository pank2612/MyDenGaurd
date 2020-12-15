class Devices {

  String imei;
  DateTime activationDate;
  DateTime deactivationDate;
  bool enable;

  Devices({

    this.imei,
    this.activationDate,
    this.deactivationDate,
    this.enable,
  });

  Devices.fromJson(Map<String, dynamic> json)
      :
        imei = json['imei'],
        activationDate = DateTime.tryParse(json['activationDate']),
        deactivationDate = DateTime.tryParse(json['deactivationDate']),
        enable = json['enable'];

  Map<String, dynamic> toJson() => {

        'imei': imei,
        'activationDate': activationDate.toIso8601String(),
        'deactivationDate': deactivationDate.toIso8601String(),
        'enable': enable
      };
}
