import 'package:eyav2/constants.dart';
import 'package:flutter/material.dart';

import 'components/body.dart';


class CompleteProfileScreen extends StatefulWidget {
  static String routeName = "/CheckoutPage";
  String nom;
  String prenom;
  String ville;
  String adresse;
  String pseudo;

   CompleteProfileScreen({ Key? key, required this.nom,required this.prenom,required this.ville,required this.adresse,required this.pseudo}) : super(key: key);

  @override
  State<CompleteProfileScreen> createState() => _CompleteProfileState();
}

class _CompleteProfileState extends State<CompleteProfileScreen> {
  static String routeName = "/complete_profile";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Veuillez completer votre profil'),
        backgroundColor: kPrimaryColor,
      ),
      body: Body(nom: widget.nom,prenom: widget.prenom,ville: widget.ville,adresse: widget.adresse,pseudo: widget.pseudo,),
    );
  }
}


