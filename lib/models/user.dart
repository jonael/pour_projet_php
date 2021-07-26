class User {
  int _idUser = 0;
  String? _nameUser;
  String? _firstNameUser;
  String? _loginUser;
  String? _mdpUser;

  int get idUser => _idUser;
  String? get nameUser => _nameUser;
  String? get firstNameUser => _firstNameUser;
  String? get loginUser => _loginUser;
  String? get mdpUser => _mdpUser;

  User({
      required int idUser,
      String? nameUser,
      String? firstNameUser,
      String? loginUser,
      String? mdpUser}){
    _idUser =this.idUser;
    _nameUser = nameUser;
    _firstNameUser = firstNameUser;
    _loginUser = loginUser;
    _mdpUser = mdpUser;
}

  User.fromJson(dynamic json) {
    _idUser = json["id_user"];
    _nameUser = json["name_user"];
    _firstNameUser = json["first_name_user"];
    _loginUser = json["login_user"];
    _mdpUser = json["mdp_user"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id_user"] = _idUser;
    map["name_user"] = _nameUser;
    map["first_name_user"] = _firstNameUser;
    map["login_user"] = _loginUser;
    map["mdp_user"] = _mdpUser;
    return map;
  }

}