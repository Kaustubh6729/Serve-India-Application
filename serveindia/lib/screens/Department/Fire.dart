import 'package:flutter/material.dart';
import 'package:flutter_app/screens/Authenticate/sign_in_fire.dart';
//import 'package:flutter_app/services/Auth.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_app/screens/Department/Fire_requests/new_requests.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'Fire_requests/completed_requests.dart';
import 'Fire_requests/in_progress_requests.dart';
import 'Fire_requests/pending_requests.dart';

class Fire extends StatelessWidget {
  Material myItems(IconData icon, String heading, int color) {
    return Material(
      color: Colors.white,
      elevation: 14.0,
      shadowColor: Color(0x802196F3),
      borderRadius: BorderRadius.circular(24.0),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      heading,
                      style: TextStyle(color: new Color(color), fontSize: 20.0),
                    ),
                  ),
                  Material(
                    color: new Color(color),
                    borderRadius: BorderRadius.circular(24.0),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Icon(
                        icon,
                        color: Colors.white,
                        size: 30.0,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[50],
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text("Fire Department Page"),
        backgroundColor: Colors.red,
        elevation: 0.0,
        actions: <Widget>[
          FlatButton.icon(
            icon: Icon(Icons.person),
            label: Text('Logout'),
            onPressed: () async {
              //await _auth.signOut();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SignInFire()),
              );
            },
          )
        ],
      ),
      body: StaggeredGridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: 12.0,
        mainAxisSpacing: 12.0,
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        children: <Widget>[
          FlatButton(
              child: myItems(Icons.graphic_eq, "New Request", 0xffed622b),
              onPressed: () async {
                print('New request pressed');
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NewRequests()),
                );
              }),
          FlatButton(
              child: myItems(Icons.not_started, "Pending Requests", 0xffff3266),
              onPressed: () async {
                print('Pending Requests pressed');
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PendingRequests()),
                );
              }),
          FlatButton(
              child: myItems(
                  Icons.pending_actions, "In Progress Requests", 0xff3399fe),
              onPressed: () async {
                print('In Progress Requests pressed');
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => InProgressRequests()),
                );
              }),
          FlatButton(
              child:
                  myItems(Icons.done_outline, "Completed Requests", 0xfff4c83f),
              onPressed: () async {
                print('Completed Requests pressed');
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CompletedRequests()),
                );
              }),
        ],
        staggeredTiles: [
          StaggeredTile.extent(2, 130.0),
          StaggeredTile.extent(2, 130.0),
          StaggeredTile.extent(2, 130.0),
          StaggeredTile.extent(2, 130.0),
        ],
      ),
    );
  }
}
