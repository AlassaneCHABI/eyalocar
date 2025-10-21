import 'package:flutter/material.dart';
import 'package:eyav2/constants.dart';
import 'package:eyav2/size_config.dart';

import 'complete_profile_form.dart';


class Body extends StatefulWidget {
  static String routeName = "/CheckoutPage";
  String nom;
  String prenom;
  String ville;
  String adresse;
  String pseudo;

  Body({ Key? key, required this.nom,required this.prenom,required this.ville,required this.adresse,required this.pseudo}) : super(key: key);

  @override
  State<Body> createState() => _BodyProfileState();
}

class _BodyProfileState extends State<Body> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding:
          EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              children: [

               // SizedBox(height: SizeConfig.screenHeight * 0.06),
                CompleteProfileForm(nom: widget.nom,prenom: widget.prenom,ville: widget.ville,adresse: widget.adresse,pseudo: widget.pseudo,),
                SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

