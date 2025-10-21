import 'dart:async';
import 'dart:convert';
import 'dart:io';
// import 'package:carousel_pro_nullsafety/carousel_pro_nullsafety.dart';
import 'package:eyav2/global_config.dart';
import 'package:eyav2/modeles/Categorie.dart';
import 'package:eyav2/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:eyav2/components/default_button.dart';
import 'package:eyav2/components/form_error.dart';
import '../../../constants.dart';
import '../../../size_config.dart';
import 'package:http/http.dart ' as http;

class AjoutForm extends StatefulWidget {
  @override
  _AjoutFormFormState createState() => _AjoutFormFormState();
}

class _AjoutFormFormState extends State<AjoutForm> {
  final _formKey = GlobalKey<FormState>();

  String? alerte_name;
  String? alerte_car_informations;
  String? alerte_email;
  String? alerte_type;
  String? alerte_telephone;
  bool remember = false;
  TextEditingController alerte_date = TextEditingController();
  late TextEditingController _documentController = TextEditingController();
  final List<String?> errors = [];
  final List<Category> liste_Category = [];

  void addError({String? error}) {
    if (!errors.contains(error))
      setState(() {
        errors.add(error);
      });
  }

 /* Future<void> requestPermissions() async {
    final PermissionStatus status = await Permission.storage.request();
    if (status.isGranted) {
      // Permission is granted, you can use path_provider now
    } else {
      // Permission denied, handle accordingly
    }
  }
*/

  Future <void> AddAlerte(String alerte_name,String alerte_car_informations, String alerte_email,String alerte_type,String alerte_telephone,String alerte_date) async {
    var url = Uri.http('${Configuration.base_url}', 'apiv2/add-alertes');
    final response = await http.post(
        url,
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.acceptHeader: 'application/json',
        },
        body: json.encode({
          "alerte_name": alerte_name,
          "alerte_car_informations": alerte_car_informations,
          "alerte_email": alerte_email,
          "alerte_type": alerte_type,
          "alerte_telephone": alerte_telephone,
          "alerte_date": alerte_date,
        })
    );
    if(response.statusCode==200){
      showDialog(
        context: this.context,
        builder: (BuildContext ctx) {
          return AlertDialog(
            title: Text("Reservation"),
            content: Text("L'alerte a été ajoutée avec succès.", textAlign: TextAlign.center,),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
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
    else if (response.statusCode == 301) {
      final newUrl = response.headers['location'];
      if (newUrl != null) {
        // Make a new request to the new URL
        final newResponse = await http.post(Uri.parse(newUrl),
            headers: {
              HttpHeaders.contentTypeHeader: 'application/json',
              HttpHeaders.acceptHeader: 'application/json',
            },
            body: json.encode({
              "alerte_name": alerte_name,
              "alerte_car_informations": alerte_car_informations,
              "alerte_email": alerte_email,
              "alerte_type": alerte_type,
              "alerte_telephone": alerte_telephone,
              "alerte_date": alerte_date,
            })
        );

        if(newResponse.statusCode==200){
          showDialog(
            context: this.context,
            builder: (BuildContext ctx) {
              return AlertDialog(
                title: Text("Enregistrement"),
                content: Text("L'alerte a été ajoutée avec succès.", textAlign: TextAlign.center,),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(ctx);
                      Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
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
        // Process the new response
        print(newResponse.statusCode);
        print(newResponse.body);
      }
    }
  }

  void removeError({String? error}) {
    if (errors.contains(error))
      setState(() {
        errors.remove(error);
      });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != DateTime.now()) {
      setState(() {
        alerte_date.text = picked.toString().substring(0, 10);
      });
    }
  }

  List<String> type_Liste = ['Assurance','Visite technique'];
  String? selectedOption_type = 'Assurance';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
//           Container(
//             child:Padding(
//               padding: EdgeInsets.only(left: 10, right: 10,top: 0,bottom: 0),
//               child: Container(
//                   height: 200.0,
//                   width: double.infinity,
//                   child: Carousel(
//                     images: [
//                       Image.asset("assets/assurance.jpg",
//                         width: double.infinity,
//                         fit: BoxFit.cover,
//                       ),
//                       Image.asset("assets/visite.jpg",
//                         width: double.infinity,
//                         fit: BoxFit.cover,
//                       )
//                       ,
//
//                       Image.asset("assets/alerte4.jpg",
//                         width: double.infinity,
//                         fit: BoxFit.cover,
//                       )
//                       ,
//
// //              Image.asset("assets/images/promotion_two.png",height: double.infinity,width: double.infinity,),
// //              Image.asset("assets/images/promotion_three.png",height: double.infinity,width: double.infinity,),
//                     ],
//                     dotSize: 4.0,
//                     dotSpacing: 15.0,
//                     dotColor: Colors.purple,
//                     indicatorBgPadding: 5.0,
//                     dotBgColor: Colors.black54.withOpacity(0.2),
//                     borderRadius: true,
//                     radius: Radius.circular(20),
//                     moveIndicatorFromBottom: 180.0,
//                     noRadiusForIndicator: true,
//                   )),
//             ) ,
//           ),
          SizedBox(height: 20),
          Center(child: Text("Souscriptions alerte assurance ou visite technique",style: TextStyle(color: Color(0xff43B6A3),fontSize: 18),),),
          SizedBox(height: 20),
          Center(child: Text("Recevez 30 jours à l'arriver à terme de votre assurance ou visite technique des rappels journaliers en vous inscrivant gratuitement à nos programmes d'alerte",),),
          SizedBox(height: 20),
          buildalerte_nameFormField(),
          SizedBox(height: 20),
          buildalerte_emailFormField(),
          SizedBox(height: 20),
          DropdownButton<String>(
            isExpanded: true,
            value: selectedOption_type,
            onChanged: (String? newValue) {
              setState(() {
                selectedOption_type = newValue;
              });
            },
            items: type_Liste.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
          SizedBox(height: 20),
          buildalerte_telephoneFormField(),
          SizedBox(height: 20),
          TextFormField(
            controller: alerte_date,
            decoration: InputDecoration(
              labelText: 'Date d\'expiration',
              suffixIcon: IconButton(
                icon: Icon(Icons.calendar_today),
                onPressed: () => _selectDate(context),
              ),
            ),
            keyboardType: TextInputType.datetime,
            onTap: () => _selectDate(context),
          ),
          SizedBox(height: 20),
          buildalerte_car_informationsFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          FormError(errors: errors),
          DefaultButton(
            text: "Enregistrer",
            press: () async {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                showAlertDialog(context);
                AddAlerte(alerte_name!,alerte_car_informations!,alerte_email!,selectedOption_type!,alerte_telephone!,alerte_date.text);

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
          Container(margin: EdgeInsets.only(left: 5),child:Text("Ajout d'alerte ....." )),
        ],),
    );
    showDialog(barrierDismissible: false,
      context:context,
      builder:(BuildContext context){
        return alert;
      },
    );
  }
  TextFormField buildalerte_nameFormField() {
    return TextFormField(
      obscureText: false,
      onSaved: (newValue) => alerte_name = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kcar_nameNullError);
        }
        alerte_name = value;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: kcar_nameNullError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        //labelText: "Nom ",
        hintText: "Entrez le nom de l'alerte",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        //suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
      ),
    );
  }


  TextFormField buildalerte_car_informationsFormField() {
    return TextFormField(
      obscureText: false,
      keyboardType: TextInputType.multiline,
      onSaved: (newValue) => alerte_car_informations = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kcar_priceNullError);
        }
        alerte_car_informations = value;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: kcar_priceNullError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        //labelText: "Details",
        hintText: "Entrez quelques informations sur la voiture",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        //suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/adresse.svg"),
      ),
    );
  }

  TextFormField buildalerte_emailFormField() {
    return TextFormField(
      obscureText: false,
      onSaved: (newValue) => alerte_email = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kEmailNullError);
        }
        alerte_email = value;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: kEmailNullError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        //labelText: "Email) ",
        hintText: "Entrez votre email",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        //suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/about.svg"),
      ),
    );
  }

  TextFormField buildalerte_telephoneFormField() {
    return TextFormField(
      obscureText: false,
      keyboardType: TextInputType.number,
      onSaved: (newValue) => alerte_telephone = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: ktelephoneNullError);
        }
        alerte_telephone = value;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: ktelephoneNullError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        //labelText: "Téléphone)",
        hintText: "Entrez le numéro",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        //suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
      ),
    );
  }

  /*TextFormField buildVilleFormField() {
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
        labelText: "Ville",
        hintText: "Entrez votre ville",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/city.svg"),
      ),
    );
  }*/

}
