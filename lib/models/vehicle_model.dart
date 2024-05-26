class VehicleModel {
  String? id;

  String? uid;
  String? aracName;
  String? aracType;
  String? plaka;
  String? aracParkBaslangicZamani;
  String? aracParkBitisZamani;
  bool? aracParktaMi;

  VehicleModel({
    this.id,
    this.uid,
    this.aracName,
    this.aracType,
    this.plaka,
    this.aracParktaMi,
    this.aracParkBitisZamani,
  });

  VehicleModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    uid = json['uid'];
    aracName = json['arac_name'];
    aracType = json['arac_type'];
    plaka = json['plaka'];
    aracParktaMi = json['arac_parkta_mi'];
    aracParkBitisZamani = json['arac_park_bitis_zamani'];
    aracParkBaslangicZamani = json['arac_park_baslangic_zamani'];
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'uid': uid,
        'arac_name': aracName,
        'arac_type': aracType,
        'plaka': plaka,
        'arac_parkta_mi': aracParktaMi,
        'arac_park_bitis_zamani': aracParkBitisZamani,
        'arac_park_baslangic_zamani': aracParkBaslangicZamani,
      };
}
