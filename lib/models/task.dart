
class Task {
  int _idTask = 0;
  String? _nameTask;
  String? _contentTask;
  String _dateTask = "";
  int _validateTask = 0;
  int _idUser = 0;
  int _idCat = 0;

  int get idTask => _idTask;
  String? get nameTask => _nameTask;
  String? get contentTask => _contentTask;
  String get dateTask => _dateTask;
  int get validateTask => _validateTask;
  int get idUser => _idUser;
  int get idCat => _idCat;

  Task({
      required int idTask,
      String? nameTask, 
      String? contentTask,
      required String dateTask,
      required int validateTask,
      required int idUser,
      required int idCat}){
    _idTask = this.idTask;
    _nameTask = nameTask;
    _contentTask = contentTask;
    _dateTask = dateTask;
    _validateTask = validateTask;
    _idUser = this.idUser;
    _idCat = this.idCat;
}

  Task.fromJson(dynamic json) {
    _idTask = json["id_task"];
    _nameTask = json["name_task"];
    _contentTask = json["content_task"];
    _dateTask = json["date_task"];
    _validateTask = json["validate_task"];
    _idUser = json["id_user"];
    _idCat = json["id_cat"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id_task"] = _idTask;
    map["name_task"] = _nameTask;
    map["content_task"] = _contentTask;
    map["date_task"] = _dateTask;
    map["validate_task"] = _validateTask;
    map["id_user"] = _idUser;
    map["id_cat"] = _idCat;
    return map;
  }

}