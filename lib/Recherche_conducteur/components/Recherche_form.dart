import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:eyav2/global_config.dart';
import 'package:eyav2/modeles/Categorie.dart';
import 'package:eyav2/pages/home_page.dart';
import 'package:eyav2/widgets/homePage/Conducteur_request/All_request_conducteur.dart';
import 'package:flutter/material.dart';
import 'package:eyav2/components/default_button.dart';
import 'package:eyav2/components/form_error.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../constants.dart';
import '../../../size_config.dart';
import 'package:eyav2/function/function.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart ' as http;

import '../../widgets/homePage/Voitures/All_cars.dart';

class RechercheForm extends StatefulWidget {
  @override
  _RechercheFormFormState createState() => _RechercheFormFormState();
}

class _RechercheFormFormState extends State<RechercheForm> {
  final _formKey = GlobalKey<FormState>();

  List<String> tranch_age = ['Tranche d\'âge','25 ans  - 35 ans', '35 ans à 45 ans'];
  String? selectedOption_tranch_age = 'Tranche d\'âge';
  List<String> type_permi = ['Type de permis','Permis A', 'Permis B', 'Permis C'];
  String? selectedOption_type_permi = 'Type de permis';

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
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Future<void>  Recherche_Conductieur(String tranche_age ,String permis) async {
    print(tranche_age);
    print(permis);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token= prefs.getString("token");
    var url = Uri.http('${Configuration.base_url}', 'apiv2/add-requestdrivers');
   // List<Voitures> voitures = [];
    final response = await http.post(
        url,
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.acceptHeader: 'application/json',
          HttpHeaders.authorizationHeader:'Bearer $token'
        },
        body: json.encode({
          "tranche_age": tranche_age,
          "permis": permis,
        })
    );
    print(response.body);
    print(response.statusCode);

    if(response.statusCode == 200){
      showDialog(
        context: this.context,
        builder: (BuildContext ctx) {
          return AlertDialog(
            title: Text("Demande"),
            content: Text("Votre demande a été envoyée avec succès.", textAlign: TextAlign.center,),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => R_conducteurListingWidget(token:token!)));
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
              'assets/images/checked_img.png',
              width: 80,
              height: 80,
            ),
          );
        },
      );

    }
    if (response.statusCode == 301) {
      final newUrl = response.headers['location'];
      if (newUrl != null) {
        // Make a new request to the new URL
        final newResponse = await http.post(Uri.parse(newUrl),
            headers: {
              HttpHeaders.contentTypeHeader: 'application/json',
              HttpHeaders.acceptHeader: 'application/json',
              HttpHeaders.authorizationHeader:'Bearer $token'
            },
            body: json.encode({
              "tranche_age": tranche_age,
              "permis": permis,
            })
        );

        print(newResponse.body);
        print(newResponse.statusCode);
       // List<dynamic> body = json.decode(newResponse.body);
      }

      showDialog(
        context: this.context,
        builder: (BuildContext ctx) {
          return AlertDialog(
            title: Text("Demande"),
            content: Text("Votre demande a été envoyée avec succès.", textAlign: TextAlign.center,),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => R_conducteurListingWidget(token:token!)));
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
              'assets/images/checked_img.png',
              width: 80,
              height: 80,
            ),
          );
        },
      );

    }
    else{
      showDialog(
        context: this.context,
        builder: (BuildContext ctx) {
          return AlertDialog(
            title: Text("Echec"),
            content: Text("Votre demande n'a pas été envoyée.Veuillez vérifier votre connexion internet avant de relancer la recherche", textAlign: TextAlign.center,),
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
    //return voitures;
  }


  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Container(
                  child: Image.asset("assets/conducteur.png")
              ),
         // Container(child: Text(("RECHERCHER UN CONDUCTEUR"), style: TextStyle(color: kPrimaryColor,fontSize: 20),),),
          SizedBox(height: 40),
          DropdownButton<String>(
            isExpanded: true,
            value: selectedOption_tranch_age,
            onChanged: (String? newValue) {
              setState(() {
                selectedOption_tranch_age = newValue;
                print(selectedOption_tranch_age);
              });
            },
            items: tranch_age.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
          SizedBox(height: 20),
          DropdownButton<String>(
            isExpanded: true,
            value: selectedOption_type_permi,
            onChanged: (String? newValue) {
              setState(() {
                selectedOption_type_permi = newValue;
                print(selectedOption_type_permi);
              });
            },
            items: type_permi.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),

          SizedBox(height: getProportionateScreenHeight(30)),
          FormError(errors: errors),
          DefaultButton(
            text: "RECHERCHER ",
            press: () async {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                SharedPreferences prefs = await SharedPreferences.getInstance();
                var token =prefs.get("token");
                print(token);
                Recherche_Conductieur(selectedOption_tranch_age!,selectedOption_type_permi!);

              }
            },
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  showAlertDialog(BuildContext context){
    AlertDialog alert=AlertDialog(
      content: new Row(
        children: [
          CircularProgressIndicator(),
          Container(margin: EdgeInsets.only(left: 5),child:Text("Ajout du véhicule ....." )),
        ],),
    );
    showDialog(barrierDismissible: false,
      context:context,
      builder:(BuildContext context){
        return alert;
      },
    );
  }

}
