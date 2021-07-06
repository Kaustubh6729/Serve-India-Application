import 'package:flutter/material.dart';
import 'package:flutter_app/screens/Authenticate/sign_in_fire.dart';
import 'package:flutter_app/screens/Department/Fire.dart';

class WrapperFire extends StatelessWidget {
  final bool islogin;

  WrapperFire({Key key, @required this.islogin, bool bool}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //return either Home or Authenticate Widget
    if (!islogin) {
      return SignInFire();
    } else {
      return Fire();
    }
  }
}
