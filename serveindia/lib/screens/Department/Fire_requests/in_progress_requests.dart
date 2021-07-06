import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/models/Request.dart';

class InProgressRequests extends StatefulWidget {
  @override
  _InProgressRequestsState createState() => _InProgressRequestsState();
}

class _InProgressRequestsState extends State<InProgressRequests> {
  String uid;
  String name;
  String phone;
  String email;
  String longitude;
  String latitude;
  String address;
  String status;
  String imageName;
  String img;
  String documentID;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pending Requests - Fire Department'),
      ),
      body: Center(
        child: Container(
            padding: const EdgeInsets.all(10.0),
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('Requests')
                  .where("image_name", isEqualTo: "Fire")
                  .where("status", isEqualTo: "in-progress")
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError)
                  return new Text('Error: ${snapshot.error}');
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return new Text('Loading...');
                  default:
                    return new ListView(
                      children:
                          snapshot.data.docs.map((DocumentSnapshot document) {
                        Request r = Request.fromMap(document.data());
                        return new CustomCard(
                          documentID: document.id,
                          name: r.name,
                          email: r.email,
                          phone: r.phone,
                          imageName: r.imageName,
                          latitude: r.latitude.toString(),
                          longitude: r.longitude.toString(),
                          address: r.address,
                          status: r.status,
                          img: r.img,
                        );
                      }).toList(),
                    );
                }
              },
            )),
      ),
    );
  }
}

class CustomCard extends StatelessWidget {
  final String name;
  final String phone;
  final String email;
  final String longitude;
  final String latitude;
  final String address;
  final String status;
  final String imageName;
  final String img;
  final String documentID;
  CustomCard({
    this.documentID,
    this.name,
    this.email,
    this.phone,
    this.imageName,
    this.latitude,
    this.longitude,
    this.address,
    this.status,
    this.img,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          ListTile(
            leading: Icon(Icons.arrow_drop_down_circle),
            title: Text(name),
            subtitle: Text(
              email + " | " + phone,
              style: TextStyle(color: Colors.black.withOpacity(0.6)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Latitude : ' + latitude,
              style: TextStyle(color: Colors.black.withOpacity(0.6)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Longitude : ' + longitude,
              style: TextStyle(color: Colors.black.withOpacity(0.6)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Address : ' + address,
              style: TextStyle(color: Colors.black.withOpacity(0.6)),
            ),
          ),
          Image.network(img, width: 280.0),
          ButtonBar(
            alignment: MainAxisAlignment.start,
            children: [
              FlatButton(
                textColor: const Color(0xFF6200EE),
                onPressed: () {
                  //print("Buttons 1 clicked");
                  FirebaseFirestore.instance
                      .collection('Requests')
                      .doc(documentID)
                      .update({"status": "complete"}).then((result) {
                    print("status of " +
                        documentID +
                        " has changed from 'pending' to 'complete'");
                  }).catchError((onError) {
                    print("onError");
                  });
                },
                child: const Text('Move to Completed Requests'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
