import 'package:eyav2/constants.dart';
import 'package:eyav2/size_config.dart';
import 'package:flutter/material.dart';

import 'components/body.dart';

class ForgotPasswordScreen extends StatelessWidget {
  static String routeName = "/forgot_password";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Mot de passe oublié",style: TextStyle(color: Colors.white),),
        backgroundColor: kPrimaryColor,
      ),
      body: Body(),
    );
  }
}
