import 'package:flutter/material.dart';
import 'package:flutter_app/screens/Authenticate/sign_in_pothole.dart';
import 'package:flutter_app/screens/Department/Pothole.dart';

class WrapperPothole extends StatelessWidget {
  final bool islogin;
  WrapperPothole({Key key, @required this.islogin, bool bool})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    //return either Home or Authenticate Widget
    if (!islogin) {
      return SignInPothole();
    } else {
      return Pothole();
    }
  }
}
