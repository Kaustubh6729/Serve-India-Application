import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/screens/Authenticate/sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:async/async.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mailer/mailer.dart' as emailAddress;
import 'package:mailer/smtp_server.dart';

class UserPage extends StatefulWidget {
  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  Timer timer;
  File _image;
  final picker = ImagePicker();
  //double _imagewidth;
  //double _imageheight;
  String predictedImage = "";
  String msg = "";
  String imageURI = "";

  //for geo location
  String latitudeData = "";
  String longitudeData = "";
  Position _position;
  StreamSubscription<Position> _streamSubscription;
  Address _address;
  final FirebaseAuth auth = FirebaseAuth.instance;
  String uids = "";
  String name = "";
  String email = "";
  String phone = "";

  @override
  void initState() {
    super.initState();
    getCurrentUserDetails();
  }

  void getCurrentUserDetails() async {
    final User user = auth.currentUser;
    final uid = user.uid;

    FirebaseFirestore.instance
        .collection('users')
        .where('uid', isEqualTo: uid)
        .snapshots()
        .listen((data) {
      setState(() {
        uids = data.docs[0]['uid'];
        name = data.docs[0]['name'];
        email = data.docs[0]['email'];
        phone = data.docs[0]['phone number'];
      });
    });
    /*print(uids);
    print(name);
    print(email);
    print(phone);
    */
  }

  //function to send email to fire department using sampleemailmp@gmail.com email id
  sendMailToFireDepartment() async {
    String username = 'sampleemailmp@gmail.com';
    String password = 'BSK12345';

    final smtpServer = gmail(username, password);
    final message = emailAddress.Message()
      ..from = emailAddress.Address(username)
      ..recipients.add('sarthakmaniar36@gmail.com')
//      ..ccRecipients.addAll(['destCc1@example.com', 'destCc2@example.com'])
//      ..bccRecipients.add(Address('bccAddress@example.com'))
      ..subject = 'New request from ' + email + ' ${DateTime.now()}'
      ..text = 'This is the plain text.\nThis is line 2 of the text part.'
      ..html = "<h1>Request Information : </h1>\n<p> Username : " +
          name +
          "<br> Email : " +
          email +
          "<br> Phone : " +
          phone +
          "<br> Latitude : " +
          _position.latitude.toString() +
          "<br> Longitude : " +
          _position.longitude.toString() +
          "<br> Address : " +
          _address.addressLine +
          "</p>"
      ..attachments.add(emailAddress.FileAttachment(_image));

    try {
      final sendReport = await emailAddress.send(message, smtpServer);
      print('Message sent: ' + sendReport.toString());
    } on emailAddress.MailerException catch (e) {
      print('Message not sent.');
      for (var p in e.problems) {
        print('Problem: ${p.code}: ${p.msg}');
      }
    }
  }

  //function to send email to potholr department using sampleemailmp@gmail.com email id
  sendMailToPotholeDepartment() async {
    String username = 'sampleemailmp@gmail.com';
    String password = 'BSK12345';

    final smtpServer = gmail(username, password);
    final message = emailAddress.Message()
      ..from = emailAddress.Address(username)
      ..recipients.add('bhargavnrao33@gmail.com')
//      ..ccRecipients.addAll(['destCc1@example.com', 'destCc2@example.com'])
//      ..bccRecipients.add(Address('bccAddress@example.com'))
      ..subject = 'New request from ' + email + ' ${DateTime.now()}'
      ..text = 'This is the plain text.\nThis is line 2 of the text part.'
      ..html = "<h1>Request Information : </h1>\n<p> Username : " +
          name +
          "<br> Email : " +
          email +
          "<br> Phone : " +
          phone +
          "<br> Latitude : " +
          _position.latitude.toString() +
          "<br> Longitude : " +
          _position.longitude.toString() +
          "<br> Address : " +
          _address.addressLine +
          "</p>"
      ..attachments.add(emailAddress.FileAttachment(_image));

    try {
      final sendReport = await emailAddress.send(message, smtpServer);
      print('Message sent: ' + sendReport.toString());
    } on emailAddress.MailerException catch (e) {
      print('Message not sent.');
      for (var p in e.problems) {
        print('Problem: ${p.code}: ${p.msg}');
      }
    }
  }

  //function to get image from gallery/camera
  Future getImage() async {
    final pickerImage = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      if (pickerImage != null) {
        _image = File(pickerImage.path);
        //validate();
        uploadImageToPredict(_image);
        //Future.​delayed(const Duration(milliseconds: 1000));
        timer = new Timer(const Duration(seconds: 1), () {
          print("This line will print after two seconds");
          predict(_image);
        });
        //predict(_image);

        //geo loacation ka code start
        _streamSubscription = Geolocator.getPositionStream(
                desiredAccuracy: LocationAccuracy.high, distanceFilter: 10)
            .listen((Position position) {
          setState(() {
            print(position);
            _position = position;

            final coordinates =
                new Coordinates(position.latitude, position.longitude);
            convertCoordinatesToAddress(coordinates)
                .then((value) => _address = value);
          });
        }); //geolocation ka code ends
      } else {
        print('no image selected');
        return;
      }
    });
  }

  void predict(File image) async {
    await uploadandpredict(image);

    FileImage(image)
        .resolve(ImageConfiguration())
        .addListener((ImageStreamListener((ImageInfo info, bool _) {
          setState(() {
            //_imagewidth = info.image.width.toDouble();
            //_imageheight = info.image.height.toDouble();
          });
        })));

    setState(() {
      _image = image;
    });
  }

  void uploadandpredict(File imagefile) async {
    var stream =
        new http.ByteStream(DelegatingStream.typed(imagefile.openRead()));
    var length = await imagefile.length();
    //var uri = Uri.parse("http://192.168.1.220:5000/helloworld");
    var uri = Uri.parse("https://serveindia.herokuapp.com/helloworld");
    var request = http.MultipartRequest("POST", uri);
    var multipartFile = http.MultipartFile('image', stream, length,
        filename: basename(imagefile.path));
    request.files.add(multipartFile);
    var res = await request.send();
    var response = await http.Response.fromStream(res);
    print(response.body);
    var temp = response.body;
    var len = temp.length;
    String str = "";
    for (int i = 11; i < len - 3; i++) str += temp[i];
    setState(() {
      predictedImage = str;
    });
    print("Predicted image is : " + predictedImage);

    if (predictedImage == "Fire") {
      //print('Valid image');
      //Toast.show("Your image has been uploaded succuessfully", context,
      //   duration: 5, gravity: Toast.CENTER);
      setState(() {
        msg =
            "Your image has been uploaded succuessfully and sent to Fire Department!";
      });
      //validate();
      uploadImageToFirebase(_image); //calling uploadImageToFirebase() function
      //uploadRequestToCloudFirestore();
    } else if (predictedImage == "Pothole") {
      setState(() {
        msg =
            "Your image has been uploaded succuessfully and sent to Pothole Department!";
      });
      //validate();
      uploadImageToFirebase(_image);
    } else {
      setState(() {
        msg = "Your image has not been uploaded, try again!";
      });
      //print('Invalid image');
    }
  }

  // function for geo location
  Future<Address> convertCoordinatesToAddress(Coordinates coordinates) async {
    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    _streamSubscription.cancel();
    return addresses.first;
  }

  // function to upload image to firebase
  Future uploadImageToFirebase(File _imageFile) async {
    String fileName = basename(_imageFile.path);
    StorageReference firebaseStorageRef =
        FirebaseStorage.instance.ref().child('uploads/$fileName');
    StorageUploadTask uploadTask = firebaseStorageRef.putFile(_imageFile);
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    taskSnapshot.ref.getDownloadURL().then((value) {
      print("Image uploaded to firebase storage successfully! $value");
      imageURI = value;
      print("Image uri is :" + imageURI);
      uploadRequestToCloudFirestore();
      if (predictedImage == 'Fire') {
        sendMailToFireDepartment();
      } else if (predictedImage == 'Pothole') {
        sendMailToPotholeDepartment();
      } else {}
    });
    //print("Image uri is :" + imageURI);
  }

  Future uploadImageToPredict(File _imageFile) async {
    StorageReference firebaseStorageRef =
        FirebaseStorage.instance.ref().child('images/image_file.jpg');
    firebaseStorageRef.putFile(_imageFile);
  }

  // This function will stoge all the user + image details to firestore Collection named 'Requests'
  uploadRequestToCloudFirestore() async {
    await FirebaseFirestore.instance.collection("Requests").doc().set({
      'user_uid': uids,
      'user_name': name,
      'user_email': email,
      'user_phone': phone,
      'longitude': _position.longitude,
      'latitude': _position.latitude,
      'address': _address.addressLine,
      'status': 'new',
      'image': imageURI,
      'image_name': predictedImage,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[50],
      appBar: AppBar(
        centerTitle: true,
        title: Text("User Dashboard"),
        backgroundColor: Colors.red,
        elevation: 0.0,
        actions: <Widget>[
          FlatButton.icon(
            icon: Icon(Icons.person),
            label: Text('Logout'),
            onPressed: () async {
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => Login()));
            },
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: _image == null
                ? Text(
                    '',
                  )
                : Image.file(_image),
          ),
          Container(
            child: _image == null
                ? Text('')
                : Text(
                    "Predict = " + predictedImage,
                  ),
          ),
          /*  SizedBox(
            height: 30,
          ),
          Text(
              "Location latitude: ${_position?.latitude ?? '-'} , longitude : ${_position?.longitude ?? '-'}"),
          SizedBox(
            height: 30,
          ),
          Text("${_address?.addressLine ?? '-'}"), 
          SizedBox(
            height: 30,
          ),  */
          _image == null
              ? Text('')
              : Container(
                  margin: const EdgeInsets.all(15.0),
                  padding: const EdgeInsets.all(3.0),
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.red)),
                  child: Text(
                    msg,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 30,
                        color: Colors.blueAccent[700],
                        fontWeight: FontWeight.bold),
                  ),
                ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          getImage();
        },
        child: Icon(Icons.photo_album),
      ),
    );
  }
}
