import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_app/models/dept.dart';
import 'package:flutter_app/screens/Authenticate/register_pothole.dart';
import 'package:flutter_app/screens/Department/Department.dart';
import 'package:flutter_app/screens/Department/Pothole.dart';
import 'package:flutter_app/screens/Wrapper_Pothole.dart';

class SignInPothole extends StatefulWidget {
  SignInPothole({Key key}) : super(key: key);

  @override
  _SignInPotholeState createState() => _SignInPotholeState();
}

class _SignInPotholeState extends State<SignInPothole> {
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
  TextEditingController emailInputController;
  TextEditingController pwdInputController;
  bool islogin = false;
  @override
  initState() {
    emailInputController = new TextEditingController();
    pwdInputController = new TextEditingController();
    super.initState();
  }

  String emailValidator(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return 'Email format is invalid';
    } else {
      return null;
    }
  }

  String pwdValidator(String value) {
    if (value.length < 6) {
      return 'Password must be longer than 6 characters';
    } else {
      return null;
    }
  }

  void _onPressed(String a, String b) async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('PotholeDepartmentUser')
        .get();
    snapshot.docs.forEach((result) {
      Dept d = Dept.fromMap(result.data());
      //print(d.email);
      if (d.email == a && d.password == b) {
        //print("Sarthak OP");
        setState(() => islogin = true);
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => WrapperPothole(islogin: true)),
        );
      } else {
        //print("Sarthak Not so OP");
      }
    });
  }

  void pressed() async {
    FirebaseFirestore.instance
        .collection("PotholeDepartmentUser")
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        var abc = result.data()["role"];
        print(abc);
        if (abc == 'pothole') {
          print("Why I am wrong");
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Pothole()),
          );
        } else {
          print("Login Failed");
          print(_loginFormKey.currentState);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () async {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => MyDepartment()));
            },
          ),
          title: Text("Login"),
          centerTitle: true,
        ),
        body: Container(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
                child: Form(
              key: _loginFormKey,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    decoration:
                        InputDecoration(labelText: 'Email*', hintText: "Email"),
                    controller: emailInputController,
                    keyboardType: TextInputType.emailAddress,
                    validator: emailValidator,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                        labelText: 'Password*', hintText: "Password"),
                    controller: pwdInputController,
                    obscureText: true,
                    validator: pwdValidator,
                  ),
                  FlatButton(
                    child: Text("Login"),
                    color: Theme.of(context).primaryColor,
                    textColor: Colors.white,
                    onPressed: () {
                      if (_loginFormKey.currentState.validate()) {
                        _onPressed(
                            emailInputController.text, pwdInputController.text);
                      }
                    },
                  ),
                  Text("Don't have an account yet?"),
                  FlatButton(
                    child: Text("Register here!"),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RegisterPothole()),
                      );
                    },
                  )
                ],
              ),
            ))));
  }
}
