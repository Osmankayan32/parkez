class UserModel {
  int? id;
  String? uid;
  String? name;

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    uid = json['uid'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'uid': uid,
    'name': name,
  };

}