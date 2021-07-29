import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:universal_platform/universal_platform.dart';

import 'constants.dart';
import 'models/task.dart';
import 'models/user.dart';

class TaskApi {

  static Future getTasks() async {
    String url = '';
    if(UniversalPlatform.isAndroid){
      url = "http://10.0.2.2/task/api/getTasks.php";
    }else if (UniversalPlatform.isWeb) {
      url = "http://localhost/task/api/getTasks.php";
    }
    return http.get(Uri.parse(url),);
  }

  static Future getCats() async {
    String url = '';
    if(UniversalPlatform.isAndroid){
      url = "http://10.0.2.2/task/api/getCats.php";
    }else if (UniversalPlatform.isWeb) {
      url = "http://localhost/task/api/getCats.php";
    }
    return http.get(Uri.parse(url),);
  }

  static Future login(String login, String password) async {
    String url = '';
    if(UniversalPlatform.isAndroid){
      url = "http://10.0.2.2/task/api/login.php";
    }else if (UniversalPlatform.isWeb){
      url = "http://localhost/task/api/login.php";
    }
    try {
      final response = await http.post(Uri.parse(url),
        body: jsonEncode({
          "login_user": login,
          "mdp_user": password}),
      );
      print(response.body);
      print(response.statusCode);
      if (response.statusCode == 200) {
        var test = jsonDecode(response.body);
        print(test);
        userLog = User.fromJson(test);
        print(userLog);
        return true;
      } else {
        print(response.body);
        print(response.statusCode);
        errorLog = jsonDecode(response.body);
        return false;
      }
    } on Exception catch (e) {
      print(e);
      print(Exception);
      print("Error occured");
    }
  }

  static Future register(String name, String firstname, String login, String password) async {
    String url = '';
    if(UniversalPlatform.isAndroid){
      url = "http://10.0.2.2/task/api/createUser.php";
    }else if (UniversalPlatform.isWeb){
      url = "http://localhost/task/api/createUser.php";
    }
    try {
      final response = await http.post(Uri.parse(url),
        body: jsonEncode({
          "name_user": name,
          "first_name_user": firstname,
          "login_user": login,
          "mdp_user": password}),
      );
      print(response.statusCode);
      if (response.statusCode == 200) {
        var test = jsonDecode(response.body);
        print(test);
        userLog = User.fromJson(response.body);
        return true;
      } else {
        print(response.body);
        print(response.statusCode);
        errorLog = jsonDecode(response.body);
        return false;
      }
    } on Exception catch (e) {
      print(e);
      print(Exception);
      print("Error occured");
    }
  }

  static Future addTask(
      String name, String content, String date, int valid, int idUser, int idCat)
  async {
    String url = '';
    if(UniversalPlatform.isAndroid){
      url = "http://10.0.2.2/task/api/createTask.php";
    }else if (UniversalPlatform.isWeb){
      url = "http://localhost/task/api/createTask.php";
    }
    try {
      final response = await http.post(Uri.parse(url),
        body: jsonEncode({
          "name_task": name,
          "content_task": content,
          "date_task": date,
          "validate_task": valid,
          "id_user": idUser,
          "id_cat": idCat}),
      );
      print(response.statusCode);
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } on Exception catch (e) {
      print(e);
      print(Exception);
      print("Error occured");
    }
  }

  static Future updateTask(Task task) {
    String url = '';
    String? nameTask = task.nameTask;
    String? contentTask = task.contentTask;
    String? dateTask = task.dateTask;
    int? validTask = task.validateTask;
    int? idUser = task.idUser;

    if(UniversalPlatform.isAndroid){
      url = "http://10.0.2.2/test/api/updateTask.php";
    }else if (UniversalPlatform.isWeb){
      url = "http://localhost/test/api/updateTask.php";
    }
    return http.post(Uri.parse(url),
      body: jsonEncode(<String, String>{
        "name_task": nameTask!,
        "content_task": contentTask!,
        "date_task": dateTask!,
        "validate_task": validTask.toString(),
        "id_user": idUser.toString()
      }),
    );
  }
}