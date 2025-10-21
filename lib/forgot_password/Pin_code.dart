import 'package:eyav2/constants.dart';
import 'package:eyav2/forgot_password/components/Pine_body.dart';

import 'package:flutter/material.dart';

import 'components/body.dart';


class PinPasswordScreen extends StatefulWidget{
  static String routeName = "/Liste_Pharmacie";
  final String email;

  const PinPasswordScreen({super.key, required this.email,});
  @override
  State<StatefulWidget> createState() {
    return _PinPasswordScreen();
  }
}

class _PinPasswordScreen extends State<PinPasswordScreen> {

  static String routeName = "/forgot_password";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Mise à jour du mot de passe",style: TextStyle(color: Colors.white),),
        backgroundColor: kPrimaryColor,
      ),
      body: PinBody(email:widget.email),
    );
  }

}




