import 'package:eyav2/components/have_a_ccount.dart';
import 'package:flutter/material.dart';
import 'package:eyav2/components/custom_surfix_icon.dart';
import 'package:eyav2/components/default_button.dart';
import 'package:eyav2/components/form_error.dart';

import '../../../constants.dart';
import '../../../size_config.dart';
import 'package:eyav2/function/function.dart' as function ;

class Create_Alerte extends StatefulWidget {
  @override
  _Create_AlerteFormState createState() => _Create_AlerteFormState();
}

class _Create_AlerteFormState extends State<Create_Alerte> {
  final _formKey = GlobalKey<FormState>();

  String? alerte_name;
  String? alerte_car_informations;
  String? alerte_email;
  String? alerte_type;
  String? alerte_telephone;
  String? alerte_date ;
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
          /*Material(

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
                  child: Image.asset("assets/logo.jpg",height: 80,)
              ),
            ),
          ),*/
          buildalerte_nameFormField(),
          SizedBox(height: 20),
          buildcar_informationsFormField(),
          SizedBox(height: 20),
          buildemailFormField(),
          SizedBox(height: 20),
          buildtypeFormField(),
          SizedBox(height: 20),
          buildtelephoneFormField(),
          SizedBox(height: 20),
          builddateFormField(),
          SizedBox(height: 20),
          FormError(errors: errors),
          DefaultButton(
            text: "Enregistrée",
            press: () {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();

                function.Add_Alerte(alerte_name!, alerte_car_informations!, alerte_email!, alerte_type!, alerte_telephone!, alerte_date!);
                // if all are valid then go to success screen
                /*Navigator.push(context,
                    new MaterialPageRoute(builder: (ctxt) => new CompleteProfileScreen(nom: nom!,prenom: prenom!,ville: ville!,adresse: adresse!,pseudo: pseudo!,))
                );*/
                // Navigator.pushNamed(context, CompleteProfileScreen.routeName);
              }
            },
          ),
          SizedBox(height: 20),
          //HaveAccountText(),
        ],
      ),
    );
  }



  TextFormField buildalerte_nameFormField() {
    return TextFormField(
      obscureText: false,
      onSaved: (newValue) => alerte_name = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kalerte_nameNullError);
        }
        alerte_name = value;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: kalerte_nameNullError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Nom de l'alerte",
        hintText: "Entrez votre le nom",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
      ),
    );
  }



  TextFormField buildcar_informationsFormField() {
    return TextFormField(
      obscureText: false,
      onSaved: (newValue) => alerte_car_informations = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kcar_informationsNullError);
        }
        alerte_car_informations = value;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: kcar_informationsNullError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Détails du véhicule",
        hintText: "Entrez les détails du véhicule",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/adresse.svg"),
      ),
    );
  }

  TextFormField buildemailFormField() {
    return TextFormField(
      obscureText: false,
      onSaved: (newValue) => alerte_email = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kAemailNullError);
        }
        alerte_email = value;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: kAemailNullError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Votre mail ",
        hintText: "Entrez votre mail",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/about.svg"),
      ),
    );
  }

  TextFormField buildtypeFormField() {
    return TextFormField(
      obscureText: false,
      onSaved: (newValue) => alerte_type = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: ktypeNullError);
        }
        alerte_type = value;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: ktypeNullError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Type d'alerte",
        hintText: "Entrez le type d'alerte",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
      ),
    );
  }

  TextFormField buildtelephoneFormField() {
    return TextFormField(
      obscureText: false,
      onSaved: (newValue) => alerte_telephone = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kvtelephoneNullError);
        }
        alerte_telephone = value;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: kvtelephoneNullError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Téléphone",
        hintText: "Entrez votre téléphone",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/city.svg"),
      ),
    );
  }

 TextFormField builddateFormField() {
    return TextFormField(
      obscureText: false,
      onSaved: (newValue) => alerte_date = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kdateNullError);
        }
        alerte_date = value;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: kdateNullError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Date",
        hintText: "Entrez la date",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/city.svg"),
      ),
    );
  }

}
