import 'package:eyav2/components/have_a_ccount.dart';
import 'package:flutter/material.dart';
import 'package:eyav2/components/custom_surfix_icon.dart';
import 'package:eyav2/components/default_button.dart';
import 'package:eyav2/components/form_error.dart';

import '../../../constants.dart';
import '../../../size_config.dart';
import '../../complete_profile/complete_profile_screen.dart';

class SignUpForm extends StatefulWidget {
  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();

  String? nom;
  String? prenom;
  String? ville;
  String? adresse;
  String? pseudo;
  bool remember = false;
  final List<String?> errors = [];

  void addError({String? error}) {
    if (!errors.contains(error))
      setState(() {
        errors.add(error);
      });
  }

  void removeError({String? error}) {
    if (errors.contains(error))
      setState(() {
        errors.remove(error);
      });
  }
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Material(

            child: Padding(padding: EdgeInsets.all(8.0),
              child:   Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(width: 5, color: Colors.white),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(color: Colors.black12, blurRadius: 20, offset: const Offset(5, 5),),
                    ],
                  ),
                  child: Image.asset("assets/logo_bleu.jpg",height: 80,)
              ),
            ),
          ),
          buildAPseudoFormField(),
          SizedBox(height: 20),
          buildNomFormField(),
          SizedBox(height: 20),
          buildPrenomFormField(),
          SizedBox(height: 20),
          buildVilleFormField(),
          SizedBox(height: 20),
          buildAdresseFormField(),
          SizedBox(height: 20),
          FormError(errors: errors),
          DefaultButton(
            text: "Continuer",
            press: () {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                // if all are valid then go to success screen
                Navigator.push(context,
                    new MaterialPageRoute(builder: (ctxt) => new CompleteProfileScreen(nom: nom!,prenom: prenom!,ville: ville!,adresse: adresse!,pseudo: pseudo!,))
                );
               // Navigator.pushNamed(context, CompleteProfileScreen.routeName);
              }
            },
          ),
          SizedBox(height: 20),
          HaveAccountText(),
        ],
      ),
    );
  }



  TextFormField buildNomFormField() {
    return TextFormField(
      obscureText: false,
      onSaved: (newValue) => nom = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kNomNullError);
        }
        nom = value;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: kNomNullError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        //labelText: "Nom",
        hintText: "Entrez votre nom",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
      ),
    );
  }



  TextFormField buildAdresseFormField() {
    return TextFormField(
      obscureText: false,
      onSaved: (newValue) => adresse = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kAddressNullError);
        }
        adresse = value;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: kAddressNullError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        //labelText: "Adresse",
        hintText: "Entrez votre adresse",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/adresse.svg"),
      ),
    );
  }

  TextFormField buildAPseudoFormField() {
    return TextFormField(
      obscureText: false,
      onSaved: (newValue) => pseudo = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kAPseudoNullError);
        }
        pseudo = value;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: kAPseudoNullError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        //labelText: "Nom d'utilisateur ",
        hintText: "Entrez votre Nom d'utilisateur",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/about.svg"),
      ),
    );
  }

  TextFormField buildPrenomFormField() {
    return TextFormField(
      obscureText: false,
      onSaved: (newValue) => prenom = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kprenomNullError);
        }
        prenom = value;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: kprenomNullError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
       // labelText: "Prénom",
        hintText: "Entrez votre prénom",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
      ),
    );
  }

  TextFormField buildVilleFormField() {
    return TextFormField(
      obscureText: false,
      onSaved: (newValue) => ville = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kVilleNullError);
        }
        ville = value;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: kVilleNullError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
       // labelText: "Ville",
        hintText: "Entrez votre ville",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/city.svg"),
      ),
    );
  }

}
