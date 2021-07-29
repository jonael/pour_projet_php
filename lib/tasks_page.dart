import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:pour_projet_php/constants.dart';
import 'package:pour_projet_php/models/user.dart';
import 'package:pour_projet_php/task_api.dart';
import 'package:universal_platform/universal_platform.dart';

import 'models/cat.dart';
import 'models/task.dart';

class TasksPage extends StatefulWidget {
  TasksPage({Key? key, this.title, required this.user,}) : super(key: key);
  final String? title;
  final User user;

  @override
  _TasksPageState createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {

  bool visible = false;
  bool check = false;
  List<Task> tasks = <Task>[];
  List<Cat> cats = <Cat>[];
  List<DropdownMenuItem<String>> listCats = [];

  final taskNameController = TextEditingController();
  final taskContentController = TextEditingController();

  DateTime initialDate = DateTime.now();
  late int idCat;
  String? catName = null;

  DateTime? myDate;

  void addListItem() {
    listCats.clear();
    listCats.add(
        DropdownMenuItem(
          value: 'category',
          child: Text('category')
        ),
    );
    cats.forEach((element) {
      listCats.add(
        DropdownMenuItem(
            value: element.name_cat,
            child: Text(
              element.name_cat,
              style: TextStyle(
                  color: Colors.indigo,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold
              ),
            ),
        ),
      );
    });
  }

  getTasksfromApi() async {
    TaskApi.getTasks().then((response) {
      setState(() {
        Iterable list = json.decode(response.body);
        print(list);
        tasks = list.map((model) => Task.fromJson(model)).toList();
      });
    });
  }

  getCatsfromApi() async {
    TaskApi.getCats().then((response) {
      setState(() {
        Iterable list = json.decode(response.body);
        print(list);
        cats = list.map((model) => Cat.fromJson(model)).toList();
      });
    });
  }

  @override
  void initState() {
    getTasksfromApi();
    getCatsfromApi();
    print(tasks);
    print(cats);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("tasks"),
      ),
      body: body(),
    );
  }

  Widget body() {
    addListItem();
    print(listCats);
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Center(
        child: Column(
          children: <Widget>[
            SizedBox(height: size.height * 0.02),
            const Text(
              "Ajouter une tâche",
              style: TextStyle(
                color: Colors.blueAccent,
                fontWeight: FontWeight.bold,
                fontSize: 24.0,
              ),
            ),
            SizedBox(height: size.height * 0.01),
            Container(
              width: size.width * 0.98,
              padding: const EdgeInsets.only(top: 5.0, left: 5.0, right: 5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: size.width * 0.25,
                    child: TextFormField(
                      controller: taskNameController,
                      autocorrect: true,
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'nom tâche',
                      ),
                    ),
                  ),
                  SizedBox(width: size.width * 0.01),
                  choosePlatform(size),
                  SizedBox(width: size.width * 0.01),
                  IconButton(
                    color: Colors.lightBlue,
                    hoverColor: Colors.purpleAccent,
                    onPressed: () {
                      showDatePicker(
                        context: context,
                        initialDate: initialDate,
                        firstDate: initialDate,
                        lastDate: DateTime(2030),
                      ).then((value) => {
                        if(value != null){
                          myDate = value
                        }
                      });
                    },
                    icon: Icon(
                      Icons.calendar_view_day_sharp,),
                    tooltip: 'Choose date',
                  ),
                ],
              ),
            ),
            SizedBox(height: size.height * 0.01),
            Container(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SingleChildScrollView(
                      child: Center(
                        child: DropdownButton(
                          value: catName,
                          elevation: 15,
                          items: listCats,
                          hint: Text(
                            'category',
                            style: TextStyle(
                                color: Colors.indigo,
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                          onChanged: (value) {
                            setState(() {
                              catName = value as String?;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: size.height * 0.01),
            /*ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.lightBlue,
                elevation: 15,
                shadowColor: Colors.deepPurple,
              ),
              onPressed: () {
                String name = taskNameController.text.toString();
                String content = taskContentController.text.toString();
                createTask(name, content);
              },
              child: const Text(
                "Valider",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                ),
              ),
            ),
            SizedBox(height: size.height * 0.03),*/
            Center(
              child: Container(
                child: NeumorphicButton(
                  margin: const EdgeInsets.only(top: 10),
                  onPressed: () {
                    String name = taskNameController.text.toString();
                    String content = taskContentController.text.toString();
                    int idUser = widget.user.idUser;
                    String date = myDate as String;
                    cats.forEach((element) {
                      if(element.name_cat == catName){
                        idCat = element.id_cat;
                      }
                    });
                    createTask(name, content, date, idUser, idCat);
                  },
                  style: NeumorphicStyle(
                    color: Colors.lightBlue,
                    shape: NeumorphicShape.concave,
                    boxShape:
                    NeumorphicBoxShape.roundRect(BorderRadius.circular(8)),
                  ),
                  child: const Text(
                    "Ajouter Tâche",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: size.height * 0.05),
            const Text(
              "Mes tâches",
              style: TextStyle(
                color: Colors.blueAccent,
                fontWeight: FontWeight.bold,
                fontSize: 24.0,
              ),
            ),
            SizedBox(height: size.height * 0.01),
            Visibility(
              visible: visible,
              child: CircularProgressIndicator()),
            listBuilder(size),
            SizedBox(height: size.height * 0.01),
          ],
        ),
      ),
    );
  }

  void createTask(String name, String content, String date, int idUser, int idCat) async{
    int valid = 0;
    TaskApi.addTask(name, content, date, valid, idUser, idCat).then((response) {
      if(response == true){
        setState(() {
          visible = !visible;
          new TasksPage(user: widget.user);
        });
      }
    });
  }

  updateState(Task task) {
    setState(() {
      check = !check;
      tasks.remove(task);
      TaskApi.updateTask(task);
      new TasksPage(user: widget.user);
    });
  }

  checkValue(int validTask) {
    print(validTask);
    if(validTask == 0) {
      return check = false;
    } else {
      return check = true;
    }
  }

  Widget choosePlatform(Size size) {
    if(UniversalPlatform.isDesktopOrWeb){
      return Container(
        width: size.width * 0.65,
        child: TextFormField(
          controller: taskContentController,
          autocorrect: true,
          decoration: const InputDecoration(
            border: UnderlineInputBorder(),
            labelText: 'description tâche',
          ),
        ),
      );
    } else {
      return Container(
        width: size.width * 0.45,
        child: TextFormField(
          controller: taskContentController,
          autocorrect: true,
          decoration: const InputDecoration(
            border: UnderlineInputBorder(),
            labelText: 'description tâche',
          ),
        ),
      );
    }
  }

  listBuilder(Size size) {
    if(UniversalPlatform.isWeb) {
      return ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: tasks.length,
        itemBuilder: (context, i) {
          return Container(
            padding: const EdgeInsets.all(5.0),
            child: Row(
              children: [
                Container(
                  width: size.width * 0.15,
                  child: ListTile(
                    title: Text(
                      tasks[i].nameTask!,
                      style: TextStyle(
                        color: Colors.blueAccent,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                ),
                Container(
                  width: size.width * 0.50,
                  child: ListTile(
                    title: Text(
                      tasks[i].contentTask!,
                      style: TextStyle(
                        color: Colors.blueAccent,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                ),
                Container(
                  width: size.width * 0.20,
                  child: ListTile(
                    title: Text(
                      tasks[i].dateTask!,
                      style: TextStyle(
                        color: Colors.blueAccent,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                ),
                Container(
                  width: size.width * 0.05,
                  child: NeumorphicCheckbox(
                    value: checkValue(tasks[i].validateTask!),
                    onChanged: (value) { updateState(tasks[i]); },
                  ),
                ),
              ],
            ),
          );
        },
      );
    } else {
      return ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: tasks.length,
        itemBuilder: (context, i) {
          return Container(
            padding: const EdgeInsets.all(5.0),
            child: Row(
              children: [
                Container(
                  width: size.width * 0.20,
                  child: ListTile(
                    title: Text(
                      tasks[i].nameTask!,
                      style: TextStyle(
                        color: Colors.blueAccent,
                        fontWeight: FontWeight.bold,
                        fontSize: 12.0,
                      ),
                    ),
                  ),
                ),
                Container(
                  width: size.width * 0.40,
                  child: ListTile(
                    title: Text(
                      tasks[i].contentTask!,
                      style: TextStyle(
                        color: Colors.blueAccent,
                        fontWeight: FontWeight.bold,
                        fontSize: 12.0,
                      ),
                    ),
                  ),
                ),
                Container(
                  width: size.width * 0.25,
                  child: ListTile(
                    title: Text(
                      tasks[i].dateTask!,
                      style: TextStyle(
                        color: Colors.blueAccent,
                        fontWeight: FontWeight.bold,
                        fontSize: 12.0,
                      ),
                    ),
                  ),
                ),
                Container(
                  width: size.width * 0.10,
                  child: NeumorphicCheckbox(
                    value: checkValue(tasks[i].validateTask!),
                    onChanged: (value) { updateState(tasks[i]); },
                  ),
                ),
              ],
            ),
          );
        },
      );
    }
  }
}