class VehicleModel {
  String? id;

  String? uid;
  String? aracName;
  String? aracType;
  String? plaka;
  bool? aracParktaMi;

  VehicleModel({
    this.id,
    this.uid,
    this.aracName,
    this.aracType,
    this.plaka,
  });

  VehicleModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    uid = json['uid'];
    aracName = json['arac_name'];
    aracType = json['arac_type'];
    plaka = json['plaka'];
    aracParktaMi = json['arac_parkta_mi'];
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'uid': uid,
        'arac_name': aracName,
        'arac_type': aracType,
        'plaka': plaka,
        'arac_parkta_mi': aracParktaMi,
      };
}
