import 'package:flutter/material.dart';
import 'package:flutter_app/models/TheUser.dart';
import 'package:flutter_app/screens/Authenticate/sign_in.dart';
import 'package:flutter_app/services/Auth.dart';
import 'package:provider/provider.dart';
import 'screens/Department/Department.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<TheUser>.value(
      value: AuthService().user,
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primaryColor: Colors.deepOrangeAccent,
          accentColor: Colors.cyan[800],
          primarySwatch: Colors.red,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: MyHomePage(title: 'Welcome to Serve India'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.title),
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
                      MaterialPageRoute(builder: (context) => Login()),
                    );
                  },
                  icon: Icon(Icons.person),
                  label: Text(
                    'User',
                    style: TextStyle(fontSize: 17.0),
                  ),
                  color: Colors.amber,
                  minWidth: 170,
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
                      MaterialPageRoute(builder: (context) => MyDepartment()),
                    );
                  },
                  icon: Icon(Icons.home),
                  label: Text(
                    'Department',
                    style: TextStyle(fontSize: 17.0),
                  ),
                  color: Colors.amber,
                  minWidth: 170,
                  padding: EdgeInsets.all(15.0)),
            ),
          ],
        ),
      ),
    );
  }
}
