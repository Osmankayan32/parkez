class VehicleModel {
  int? id;

  String? uid;
  String? aracName;
  String? aracType;
  String? plaka;
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
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'uid': uid,
        'arac_name': aracName,
        'arac_type': aracType,
        'plaka': plaka,
      };
}
