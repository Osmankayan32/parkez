class UserModel {

  /*
  "email" : email,
      "name": name,
      "password": password,
      "uid": user.uid,
   */
  String? email;
  String? name;
  String? password;
  String? uid;

  UserModel({this.email, this.name, this.password, this.uid});

  UserModel.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    name = json['name'];
    password = json['password'];
    uid = json['uid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['email'] = email;
    data['name'] = name;
    data['password'] = password;
    data['uid'] = uid;
    return data;
  }

}