class VehicleModel {
  int? id;

  String? userId;
  String? aracName;
  String? aracType;
  String? plaka;
  VehicleModel({
    this.id,
    this.userId,
    this.aracName,
    this.aracType,
    this.plaka,
  });
  VehicleModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    aracName = json['arac_name'];
    aracType = json['arac_type'];
    plaka = json['plaka'];
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'arac_name': aracName,
        'arac_type': aracType,
        'plaka': plaka,
      };
}
