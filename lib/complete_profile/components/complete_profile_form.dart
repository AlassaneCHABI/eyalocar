
import 'package:eyav2/function/function.dart';
import 'package:eyav2/politique_out.dart';
import 'package:eyav2/sign_in/sign_in_screen.dart';
import 'package:flutter/material.dart';
import 'package:eyav2/components/custom_surfix_icon.dart';
import 'package:eyav2/components/default_button.dart';
import 'package:eyav2/components/form_error.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../constants.dart';
import '../../../size_config.dart';


class CompleteProfileForm extends StatefulWidget {
  static String routeName = "/CheckoutPage";
  String nom;
  String prenom;
  String ville;
  String adresse;
  String pseudo;

  CompleteProfileForm({ Key? key, required this.nom,required this.prenom,required this.ville,required this.adresse,required this.pseudo}) : super(key: key);

  @override
  State<CompleteProfileForm> createState() => _CompleteProfileState();
}

class _CompleteProfileState extends State<CompleteProfileForm> {

  final _formKey = GlobalKey<FormState>();
  final List<String?> errors = [];
  List<String> type_identite = ['Tye d\'identité','NPI', 'IFU'];
  String? selectedOption_type_identite = 'Tye d\'identité';
  String? type_identifier;
  String? identifier;
  String? email;
  String? password;
  bool passwordVisible = true;
  bool _acceptPolicy = false;
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

  showAlertDialog(BuildContext context){
    AlertDialog alert=AlertDialog(
      content: new Row(
        children: [
          CircularProgressIndicator(),
          Container(margin: EdgeInsets.only(left: 5),child:Text("Loading" )),
        ],),
    );
    showDialog(barrierDismissible: false,
      context:context,
      builder:(BuildContext context){
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Material(
            // borderRadius: BorderRadius.all(Radius.circular(50.0)),
            //elevation: 10,
            child: Padding(padding: EdgeInsets.all(8.0),
              child:  Container(
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
          //buildType_endentiteFormField(),
          DropdownButton<String>(
            isExpanded: true,
            value: selectedOption_type_identite,
            onChanged: (String? newValue) {
              setState(() {
                selectedOption_type_identite = newValue;
              });
            },
            items: type_identite.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),

          SizedBox(height: 20),
          buildNum_endentiteFormField(),
          SizedBox(height: 20),
          buildEmailFormField(),
          SizedBox(height: 20),
          buildPasswordFormField(),
          FormError(errors: errors),
          SizedBox(height: 20),
          Row(
            children: [
              Checkbox(
                value: _acceptPolicy,
                onChanged: (value) {
                  setState(() {
                    _acceptPolicy = value!;
                  });
                },
              ),
              Text("J'adhère à la Politique d'utilisation"),
            ],
          ),
          InkWell(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => Politique_out()));

            },
            child:Text("Cliquer ici pour plus de details",style: TextStyle(fontSize: 15,color: kPrimaryColor),),
          ),

          SizedBox(height: 20),
          DefaultButton(
            text: "Continuer",
            press: () async {
              if (_formKey.currentState!.validate()) {
                showAlertDialog(context);
                if(_acceptPolicy){
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  prefs.setString('pseudo',widget.pseudo);
                  prefs.setString('nom',widget.nom);
                  prefs.setString('prenom',widget.prenom);
                  prefs.setString('ville',widget.ville);
                  prefs.setString('adresse',widget.adresse );
                  prefs.setString('type_identifier',selectedOption_type_identite! );
                  prefs.setString('identifier',identifier!);
                  prefs.setString('email',email! );
                  prefs.setString('password',password! );
                  register(widget.pseudo,widget.nom,widget.prenom,widget.ville,widget.adresse,selectedOption_type_identite!,identifier!,email!,password!);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => SignInScreen()));
                }
                else{
                  Navigator.pop(context);
                  showDialog(
                    context: context,
                    builder: (BuildContext ctx) {
                      return AlertDialog(
                        title: Text("Alerte"),
                        content: Text("Vous devez accepter nos politiques d'utilisation avant de contnuer", textAlign: TextAlign.center,),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(ctx);
                              //Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
                            },
                            child: const Text('OK'),
                            style: ButtonStyle(
                                elevation: MaterialStateProperty.all(15),
                                foregroundColor: MaterialStateProperty.all(Colors.white),
                                backgroundColor: MaterialStateProperty.all(vertFonceColor),
                                shadowColor: MaterialStateProperty.all(vertFonceColor),
                                padding: MaterialStateProperty.all(const EdgeInsets.all(5)),
                                fixedSize: MaterialStateProperty.all(const Size(100, 40))),
                          ),
                        ],
                        actionsAlignment: MainAxisAlignment.center,
                        icon: Image.asset(
                          'assets/images/warning_img.png',
                          width: 80,
                          height: 80,
                        ),
                      );
                    },
                  );
                }

              }
            },
          ),
        ],
      ),
    );
  }

  TextFormField buildPasswordFormField() {
    return TextFormField(
      obscureText: passwordVisible,
      onSaved: (newValue) => password = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kPassNullError);
        } else if (value.length >= 8) {
          removeError(error: kShortPassError);
        }
        password = value;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: kPassNullError);
          return "";
        } else if (value.length < 8) {
          addError(error: kShortPassError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        //labelText: "Mot de passe",
        hintText: "Entrez votre mot de passe",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: IconButton(
          icon: Icon(
            passwordVisible ? Icons.visibility_off : Icons.visibility,
            //color: violetFonceColor,
          ),
          onPressed: () {
            setState(() {
              passwordVisible = !passwordVisible;
            });
          },
        ),      ),
    );
  }

  TextFormField buildEmailFormField() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      onSaved: (newValue) => email = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kEmailNullError);
        } else if (emailValidatorRegExp.hasMatch(value)) {
          removeError(error: kInvalidEmailError);
        }
        email=value;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: kEmailNullError);
          return "";
        } /*else if (!emailValidatorRegExp.hasMatch(value)) {
          addError(error: kInvalidEmailError);
          return "";
        }*/
        return null;
      },
      decoration: InputDecoration(
       // labelText: "Email",
        hintText: "Entrez votre Email",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Mail.svg"),
      ),
    );
  }

  TextFormField buildType_endentiteFormField() {
    return TextFormField(
      keyboardType: TextInputType.phone,
      onSaved: (newValue) => type_identifier = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: ktelephoneNullError);
        }
        type_identifier=value;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: ktelephoneNullError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
       // labelText: "Type d'identité",
        hintText: "Entrez votre identite",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Phone.svg"),
      ),
    );
  }

  TextFormField buildNum_endentiteFormField() {
    return TextFormField(
      keyboardType: TextInputType.phone,
      onSaved: (newValue) => identifier = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: ktelephoneNullError);
        }
        identifier=value;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: ktelephoneNullError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
      //  labelText: "Numéro d'identité",
        hintText: "Entrez votre numéro d'identite",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Phone.svg"),
      ),
    );
  }


}

