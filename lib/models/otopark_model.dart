class OtoparkModel {
  String? uid;
  String? firebaseId;
  String? otoparkIsmi;
  String? otoparkAdresi;
  int? otoparkKapasitesi;
  double? saatlikUcret;
  int? katSayisi;
  List<OtaparkKatModel>? katlar;

  OtoparkModel({
    this.firebaseId,
    this.uid,
    this.otoparkIsmi,
    this.otoparkAdresi,
    this.otoparkKapasitesi,
    this.katSayisi,
    this.katlar,
    this.saatlikUcret,
  });

  OtoparkModel.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    otoparkIsmi = json['otoparkIsmi'];
    otoparkAdresi = json['otoparkAdresi'];
    otoparkKapasitesi = json['otoparkKapasitesi'];
    katSayisi = json['katSayisi'];
    saatlikUcret = json['saatlikUcret'];
    if(json['katlar'] != null){
      katlar = (json['katlar'] as List).map((e) => OtaparkKatModel.formJson(e)).toList();
    }

  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'otoparkIsmi': otoparkIsmi,
      'otoparkAdresi': otoparkAdresi,
      'otoparkKapasitesi': otoparkKapasitesi,
      'katSayisi': katSayisi,
      'saatlikUcret': saatlikUcret,
      'katlar': katlar?.map((e) => e.toMap()).toList(),
    };
  }
}

class OtaparkKatModel {
  String? katIsmi;
  int? katKapasitesi;
  List<ParkYeriModel>? parkYerleri=[];

  OtaparkKatModel({ this.katIsmi,  this.katKapasitesi,  this.parkYerleri});

  OtaparkKatModel.formJson(Map<String, dynamic> json) {
    katIsmi = json['katIsmi'];
    katKapasitesi = json['katKapasitesi'];
    if(json['parkYerleri'] != null){
      parkYerleri = (json['parkYerleri'] as List).map((e) => ParkYeriModel.formJson(e)).toList();
    }

  }

  Map<String, dynamic> toMap() {
    return {
      'katIsmi': katIsmi,
      'katKapasitesi': katKapasitesi,
      'parkYerleri': parkYerleri?.map((e) => e.toMap()).toList(),
    };
  }

}

class ParkYeriModel {
  String? parkYeriIsmi;
  String? aracPlaka;
  bool? aracVarMi;

  ParkYeriModel({ this.parkYeriIsmi,  this.aracVarMi,this.aracPlaka});

  ParkYeriModel.formJson(Map<String, dynamic> json){
    parkYeriIsmi = json['parkYeriIsmi'];
    aracVarMi = json['aracVarMi'];
    aracPlaka = json['aracPlaka'];
  }

  Map<String, dynamic> toMap() {
    return {
      'parkYeriIsmi': parkYeriIsmi,
      'aracVarMi': aracVarMi,
      'aracPlaka': aracPlaka,
    };
  }

}
