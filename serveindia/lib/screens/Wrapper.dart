import 'package:flutter/material.dart';
import 'package:flutter_app/models/TheUser.dart';
import 'package:flutter_app/screens/Authenticate/authenticate.dart';
import 'package:flutter_app/screens/User/UserPage.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<TheUser>(context);
    //return either Home or Authenticate Widget
    if (user == null) {
      return Authenticate();
    } else {
      return UserPage();
    }
  }
}
