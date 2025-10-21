import 'package:eyav2/constants.dart';
import 'package:eyav2/size_config.dart';
import 'package:flutter/material.dart';

import 'components/body.dart';

class SignInScreen extends StatelessWidget {
  static String routeName = "/sign_in";
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return WillPopScope(child:  Scaffold(
      appBar: AppBar(
        title: Text("Connectez-vous à votre espace"),
        centerTitle: true,
        backgroundColor: kPrimaryColor,
        automaticallyImplyLeading: false,
      ),
      body: Body(),
    ), onWillPop: () async => false,) ;

  }
}
