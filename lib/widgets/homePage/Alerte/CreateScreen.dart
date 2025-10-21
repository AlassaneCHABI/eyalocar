import 'package:eyav2/constants.dart';
import 'package:flutter/material.dart';
import 'package:eyav2/widgets/homePage/Alerte/body.dart';

class CreateAlerteScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Nouvelle Alerte"),
        backgroundColor: kPrimaryColor,
      ),
      body: Body(),
    );
  }
}
