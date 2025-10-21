import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:eyav2/global_config.dart';
import 'package:eyav2/modeles/Categorie.dart';
import 'package:flutter/material.dart';
import 'package:eyav2/components/default_button.dart';
import 'package:eyav2/components/form_error.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../constants.dart';
import '../../../size_config.dart';
import 'package:eyav2/function/function.dart';
import 'package:http/http.dart ' as http;
import '../../widgets/homePage/Voitures/All_cars.dart';

class RechercheForm extends StatefulWidget {
  @override
  _RechercheFormFormState createState() => _RechercheFormFormState();
}

class _RechercheFormFormState extends State<RechercheForm> {
  final _formKey = GlobalKey<FormState>();
  int? car_category;
  String? year_maximum;
  String? year_minimum;
  String? budget;
  bool v_max=false;
  bool v_min=false;
  bool min_bud=false;

  DateTime now = DateTime.now();
  int current_year=0;

  final List<String?> errors = [];
  final List<Category> liste_Category = [];

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
    getCategorie().then((value){
      if(value!=null){
        setState(() {
          liste_Category.addAll(value);
        });
      }
    });
  }

  Future<void>  getVoiture(int category_id,String year_minimum ,String year_maximum, int budget) async {
    print(category_id);
    print(year_minimum);
    print(year_maximum);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token= prefs.getString("token");
    var url = Uri.http('${Configuration.base_url}', 'apiv2/add-requestcars');
   // List<Voitures> voitures = [];
    final response = await http.post(
        url,
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.acceptHeader: 'application/json',
          HttpHeaders.authorizationHeader:'Bearer $token'
        },
        body: json.encode({
          "category_id": category_id,
          "year_minimum": year_minimum,
          "year_maximum": year_maximum,
          "budget": budget,
        })
    );
    print(response.body);
    print(response.statusCode);

    if(response.statusCode == 200){
      Navigator.pop(context);
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
                  Navigator.push(context, MaterialPageRoute(builder: (context) => CarsListingWidget(token:token!)));
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
              "category_id": category_id,
              "year_minimum": year_minimum,
              "year_maximum": year_maximum,
              "budget": budget,
            })
        );

        print(newResponse.body);
        print(newResponse.statusCode);
       // List<dynamic> body = json.decode(newResponse.body);
      }
      Navigator.pop(context);

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
                  Navigator.push(context, MaterialPageRoute(builder: (context) => CarsListingWidget(token:token!)));
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
      Navigator.pop(context);
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


  Future<void>  demande_vehicule(int category_id,String year_minimum ,String year_maximum, int budget) async {
    print(category_id);
    print(year_minimum);
    print(year_maximum);
    print(budget);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token= prefs.getString("token");

    var url = Uri.http('${Configuration.base_url}', 'apiv2/add-requestcars');
    final response = await http.post(
        url,
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.acceptHeader: 'application/json',
          HttpHeaders.authorizationHeader:'Bearer $token'
        },
        body: json.encode({
          "category_id": category_id,
          "year_minimum": year_minimum,
          "year_maximum": year_maximum,
          "budget": budget,
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
                  Navigator.push(context, MaterialPageRoute(builder: (context) => CarsListingWidget(token:token!)));
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
              "category_id": category_id,
              "year_minimum": year_minimum,
              "year_maximum": year_maximum,
              "budget": budget,
            })
        );

        if(newResponse.statusCode==200){

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
                      Navigator.push(context, MaterialPageRoute(builder: (context) => CarsListingWidget(token:token!)));
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
        }else{
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
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
            Container(

                  child: Image.asset("assets/choix1.jpg")
              ),

          //Container(child: Text(("RECHERCHER UN VEHICULE"), style: TextStyle(color: kPrimaryColor,fontSize: 20),),),
          SizedBox(height: 30),
          DropdownButtonFormField(
            style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w500),
            hint: const Text(
              'Selectionner la categorie',
            ),
            isExpanded: true,
            onChanged: (value) {
              setState(() {
                car_category = value!.id;
              });
            },
            items: liste_Category.map((item) =>
                DropdownMenuItem(
                    value: item,
                    child: Text('${item.category_name}',
                    ))).toList(),
            validator: (value) => (value==null)?"Selectionner la categorie":null,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(
                  vertical: 1,
                  horizontal: 10),
            ),
          ),

          SizedBox(height: 20),
          buildanneFormField(),
          SizedBox(height: 10),
          v_min?Text("Cette valeur doit être supérieur ou égale à ${now.year-8} et inférieur ou égale à ${now.year}",style: TextStyle(color: Colors.red),):Text(""),
          SizedBox(height: 20),
          buildanne1FormField(),
          SizedBox(height: 10),
          v_max?Text("Cette valeur doit être supérieur ou égale à ${now.year-8} et inférieur ou égale à ${now.year}",style: TextStyle(color: Colors.red),):Text(""),
          SizedBox(height: 20),
          buildbudgetFormField(),
          SizedBox(height: 10),
          min_bud?Text("Cette valeur doit être supérieur ou égale à 25000",style: TextStyle(color: Colors.red),):Text(""),

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
                v_max=false;
                v_min=false;
                min_bud=false;
                if(int.parse(year_minimum!) < (now.year-8) || int.parse(year_minimum!) > now.year ){
                  setState(() {
                    v_min=true;
                  });
                }else if(int.parse(year_maximum!)>now.year || int.parse(year_maximum!) < (now.year-8)){
                  setState(() {
                    v_max=true;
                  });
                }else if(int.parse(budget!)<25000){
                  setState(() {
                    min_bud=true;
                  });
                }
                else{
                  showAlertDialog(context);
                 //demande_vehicule(car_category!,year_minimum!,year_maximum!,int.parse(budget!));
                  getVoiture(car_category!,year_minimum!,year_maximum!,int.parse(budget!));
                }
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
          Container(margin: EdgeInsets.only(left: 5),child:Text("Envoi en cours ....." )),
        ],),
    );
    showDialog(barrierDismissible: false,
      context:context,
      builder:(BuildContext context){
        return alert;
      },
    );
  }



  TextFormField buildanneFormField() {
    return TextFormField(
      keyboardType: TextInputType.number,
      obscureText: false,
      onSaved: (newValue) =>  year_minimum= newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kAnneNullError);
        }
        year_minimum = value;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: kAnneNullError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
       // labelText: "Ville",
        hintText: "Entrez l'année minimum",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        //suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/city.svg"),
      ),
    );
  }

  TextFormField buildanne1FormField() {
    return TextFormField(
      keyboardType: TextInputType.number,
      obscureText: false,
      onSaved: (newValue) =>  year_maximum= newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kAnneNullError);
        }
        year_maximum = value;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: kAnneNullError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
       // labelText: "Ville",
        hintText: "Entrez l'année maximum",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        //suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/city.svg"),
      ),
    );
  }

  TextFormField buildbudgetFormField() {
    return TextFormField(
      keyboardType: TextInputType.number,
      obscureText: false,
      onSaved: (newValue) =>  budget= newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kAnneNullError);
        }
        budget = value;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: kAnneNullError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
       // labelText: "Ville",
        hintText: "Entrez votre budget",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        //suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/city.svg"),
      ),
    );
  }

}
