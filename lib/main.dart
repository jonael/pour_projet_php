import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:pour_projet_php/constants.dart';
import 'package:pour_projet_php/task_api.dart';
import 'package:pour_projet_php/tasks_page.dart';

import 'models/user.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  /// constructeur
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      /// je retire la bannière debug
      debugShowCheckedModeBanner: false,
      title: 'projet php',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MaPageAccueil(title: "Page d'accueil"),
    );
  }
}

class MaPageAccueil extends StatefulWidget {
  MaPageAccueil({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _MaPageAccueilState createState() => _MaPageAccueilState();
}

class _MaPageAccueilState extends State<MaPageAccueil> {

  final loginController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final nameController = TextEditingController();
  final firstNameController = TextEditingController();

  bool choice = false;
  bool change = false;
  bool onlyForCreate = false;
  bool visible = false;
  bool visibleError = false;

  String error = "";

  List<User> utilisateurs = <User>[];

  void loginApi(String login, String password) async {
    visible = !visible;
    TaskApi.login(login, password).then((response) {
      setState(() {
        if(response == true ) {
          visible = !visible;
          User user = userLog;
          print('connecté');
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) {
                    return TasksPage(user: user);
                  }
              )
          );
        } else {
          error = errorLog;
          visible = !visible;
          visibleError = !visibleError;
        }
      });
    });
  }

  void registerApi( String login, String password, String name, String firstname,) async {
    visible = !visible;
    TaskApi.register(login, password, name, firstname, ).then((response) {
      setState(() {
        if(response == true) {
          visible = !visible;
          User user = userLog;
          print('création compte');
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) {
                    return TasksPage(user: user);
                  }
              )
          );
        } else {
          error = errorLog;
          visible = !visible;
          visibleError = !visibleError;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: body(),
    );
  }

  Widget body() {
    Size size = MediaQuery.of(context).size;
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 10.0, left : 10.0, right : 10.0),
        child: Column(
          children: <Widget> [
            Image.asset(
              'logo.png',
              fit: BoxFit.fill,
            ),
            SizedBox(height: size.height * 0.02),
            NeumorphicText(
              updateTitlePage(),
              style: NeumorphicStyle(
                depth: 10,
                color: Colors.blue,
              ),
              textStyle: NeumorphicTextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 30.0
              ),
            ),
            SizedBox(height: size.height * 0.03),
            Container(
              width:  size.width *0.70,
              child: TextFormField(
                controller: loginController,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Login'
                ),
              ),
            ),
            SizedBox(height: size.height * 0.03),
            Container(
              width: size.width * 0.70,
              child: TextFormField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'password'
                ),
              ),
            ),
            Visibility(
              visible: visible,
              child: Container(
                margin: const EdgeInsets.all(10.0),
                child: const CircularProgressIndicator(),
              ),
            ),
            Visibility(
              visible: onlyForCreate,
              child: SizedBox(height: size.height * 0.03),
            ),
            Visibility(
              visible: onlyForCreate,
              child: Container(
                width: size.width * 0.70,
                child: TextFormField(
                  controller: confirmPasswordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: 'Confirm password'
                  ),
                ),
              ),
            ),
            Visibility(
                visible: onlyForCreate,
                child: SizedBox(height: size.height * 0.03)),
            Visibility(
              visible: onlyForCreate,
              child: Container(
                width: size.width * 0.70,
                child: TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: 'name'
                  ),
                ),
              ),
            ),
            Visibility(
              visible: onlyForCreate,
              child: SizedBox(height: size.height * 0.03)),
            Visibility(
              visible: onlyForCreate,
              child: Container(
                width: size.width * 0.70,
                child: TextFormField(
                  controller: firstNameController,
                  decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: 'firstname'
                  ),
                ),
              ),
            ),
            SizedBox(height: size.height * 0.01),
            Visibility(
              visible: visibleError,
              child: Container(
                width: size.width * 0.70,
                child: Text(
                  error,
                  style: const TextStyle(
                    color: Colors.redAccent,
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                  ),
                ),
              ),
            ),
            TextButton(
                onPressed: updateState,
                child: Text(
                  updateChoice(),
                  style: const TextStyle(
                    color: Colors.red,
                    fontStyle: FontStyle.italic,
                    fontSize: 16.0,
                  ),
                ),
            ),
            NeumorphicButton(
              margin: const EdgeInsets.all(10.0),
              onPressed: () {
                String login = loginController.text.toString();
                String password = passwordController.text.toString();
                String confirmPassword = confirmPasswordController.text.toString();
                String name = nameController.text.toString();
                String firstname = firstNameController.text.toString();
                logOrReg(login, password, confirmPassword, name, firstname,);
              },
              style: NeumorphicStyle(
                shape: NeumorphicShape.concave,
                color: Colors.black.withOpacity(0.1),
                boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(15))
              ),
              child: const Text(
                "Valider",
                style: const TextStyle(
                  color: Colors.lightBlue,
                  fontWeight:  FontWeight.bold,
                  fontSize: 20.0,
                ),
              ),
            ),
            SizedBox(height: size.height * 0.05),
          ]
        ),
      ),
    );
  }

  String updateTitlePage() {
    return (choice)? "Créer compte" : "Se connecter";
  }

  String updateChoice() {
    return (change)? "Déjà un compte?" : "Pas encore de compte";
  }

  updateState() {
    setState(() {
      choice = !choice;
      change = !change;
      onlyForCreate = !onlyForCreate;
    });
  }

  void logOrReg( String login, String password, String confirmPass, String name , String firstName,) {
    print(name);
    print(firstName);
    print(login);
    print(password);
    print(confirmPass);
    print(onlyForCreate);
    if(onlyForCreate == true) {
      if(password == confirmPass) {
        if(login.isEmpty) {
          setState(() {
            visibleError = !visibleError;
            error = "Veuillez renseigner un login ou email";
          });
        } else if(password.isEmpty) {
          setState(() {
            visibleError = !visibleError;
            error = "Veuillez renseigner un mot de passe";
          });
        } else if(confirmPass.isEmpty) {
          setState(() {
            visibleError = !visibleError;
            error = "Veuillez confirmer votre mot de passe";
          });
        } else if(name.isEmpty) {
          setState(() {
            visibleError = !visibleError;
            error = "Veuillez renseigner un nom";
          });
        } else if(firstName.isEmpty) {
          setState(() {
            visibleError = !visibleError;
            error = "Veuillez renseigner un prénom";
          });
        } else {
          registerApi( login, password, name, firstName,);
        }
      } else {
        setState(() {
          visibleError = !visibleError;
          error = "Les mot de passes ne correspondent pas";
        });
      }
    } else {
      if(login.isEmpty) {
        setState(() {
          visibleError = !visibleError;
          error = "Veuillez renseigner un login ou email";
        });
      } else if (password.isEmpty) {
        setState(() {
          visibleError = !visibleError;
          error = "Veuillez renseigner un mot de passe";
        });
      } else {
        loginApi(login, password);
      }
    }
  }
}
