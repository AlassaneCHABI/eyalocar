import 'package:eyav2/constants.dart';
import 'package:eyav2/size_config.dart';
import 'package:flutter/material.dart';
import '../widgets/DrawerMenuWidget.dart';
import '../widgets/bottomnav.dart';
import 'components/body.dart';

class AjoutConducteurScreen extends StatelessWidget {
  static String routeName = "/sign_up";
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Ajout  de conducteur"),
        backgroundColor: kPrimaryColor,
      ),
      drawer: DrawerMenuWidget(),
      bottomNavigationBar:bottomNvigator(),


      body: Body(),
    );
  }
}
