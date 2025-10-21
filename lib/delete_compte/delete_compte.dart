import 'package:eyav2/constants.dart';
import 'package:eyav2/size_config.dart';
import 'package:flutter/material.dart';
import 'package:eyav2/delete_compte/components/body.dart';


class DeleteCompteScreen extends StatelessWidget {
  static String routeName = "/forgot_password";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Demande de suppression",style: TextStyle(color: Colors.white),),
        backgroundColor: kPrimaryColor,
      ),
      body: Body(),
    );
  }
}
