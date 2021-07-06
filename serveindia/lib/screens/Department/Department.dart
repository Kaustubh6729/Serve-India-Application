import 'package:flutter/material.dart';
import 'package:flutter_app/main.dart';
import 'package:flutter_app/screens/Authenticate/sign_in_fire.dart';
import 'package:flutter_app/screens/Authenticate/sign_in_pothole.dart';
//import 'package:flutter_app/screens/Department/Fire.dart';
//import 'package:flutter_app/screens/Department/Pothole.dart';
//import 'package:flutter_app/screens/Wrapper_Fire.dart';
//import 'package:flutter_app/screens/Wrapper_Pothole.dart';

class MyDepartment extends StatefulWidget {
  MyDepartment({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyDepartment createState() => _MyDepartment();
}

class _MyDepartment extends State<MyDepartment> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => MyApp()));
          },
        ),
        title: Text("Department Page"),
        centerTitle: true,
      ),
      body: Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new FlatButton(
              onPressed: () {},
              child: FlatButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignInFire()),
                    );
                  },
                  icon: Icon(Icons.fireplace),
                  label: Text(
                    'Fire Department',
                    style: TextStyle(fontSize: 17.0),
                  ),
                  color: Colors.amber,
                  minWidth: 220,
                  padding: EdgeInsets.all(15.0)),
            ),
            SizedBox(
              height: 15.0,
            ),
            new FlatButton(
              onPressed: () {},
              child: FlatButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignInPothole()),
                    );
                  },
                  icon: Icon(Icons.home),
                  label: Text(
                    'Pothole Department',
                    style: TextStyle(fontSize: 17.0),
                  ),
                  color: Colors.amber,
                  minWidth: 220,
                  padding: EdgeInsets.all(15.0)),
            ),
          ],
        ),
      ),
    );
  }
}
