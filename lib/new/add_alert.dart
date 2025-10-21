import 'dart:convert';
import 'dart:io';
import 'package:eyav2/components/form_error.dart';
import 'package:eyav2/constants.dart';
import 'package:eyav2/global_config.dart';
import 'package:eyav2/modeles/Categorie.dart';
import 'package:eyav2/new/entry_screen.dart';
import 'package:http/http.dart' as http;
import 'package:eyav2/new/drawer.dart';
import 'package:flutter/material.dart';

class AddAlert extends StatefulWidget {
  const AddAlert({super.key});

  @override
  State<AddAlert> createState() => _AddAlertState();
}

class _AddAlertState extends State<AddAlert> {
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
                  Navigator.push(context, MaterialPageRoute(builder: (context) => EntryScreen()));
                },
                child: const Text('OK'),
                style: ButtonStyle(
                    elevation: MaterialStateProperty.all(15),
                    foregroundColor: MaterialStateProperty.all(Colors.white),
                    backgroundColor: MaterialStateProperty.all(greenThemeColor),
                    shadowColor: MaterialStateProperty.all(greenThemeColor),
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
                      Navigator.push(context, MaterialPageRoute(builder: (context) => EntryScreen()));
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
    return Scaffold(
      appBar: AppBar(
        title: Text("Souscription Alerte", style: TextStyle(fontFamily: "Ubuntu", fontSize: 22, fontWeight: FontWeight.bold),),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      drawer: CustomDrawer(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20,),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 20),
                Center(child: Text("Souscriptions alerte assurance ou visite technique",style: TextStyle(fontFamily: "Ubuntu", color: greenThemeColor,fontSize: 18),),),
                SizedBox(height: 20),
                Center(child: Text("Recevez 30 jours à l'arriver à terme de votre assurance ou visite technique des rappels journaliers en vous inscrivant gratuitement à nos programmes d'alerte",),),
                SizedBox(height: 20),
                // Text(
                //   'Souscrire à une alerte',
                //   style: TextStyle(fontFamily: "Ubuntu", fontSize: 32, color: Colors.white, fontWeight: FontWeight.bold),
                // ),
                // SizedBox(height: 20),
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      _buildAlertNameTextField(),
                      SizedBox(height: 20),
                      _buildAlertEmailTextField(),
                      SizedBox(height: 20),
                      _buildAlertTypeDropdown(),
                      SizedBox(height: 20),
                      _buildAlertTelephoneTextField(),
                      SizedBox(height: 20),
                      _buildAlertDateTextField(),
                      SizedBox(height: 20),
                      _buildAlertCarInfosTextField(),
                      SizedBox(height: 40),
                      FormError(errors: errors),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                              showAlertDialog(context);
                              AddAlerte(alerte_name!,alerte_car_informations!,alerte_email!,selectedOption_type!,alerte_telephone!,alerte_date.text);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: greenThemeColor,
                            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text("Enregistrer", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),),
                        ),
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
                // HaveAccountText(),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAlertNameTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Nom de l'alerte",
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        SizedBox(height: 8,),
        TextFormField(
          keyboardType: TextInputType.text,
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
            hintText: "Entrez le nom de l'alerte",
            hintStyle: TextStyle(color: Colors.grey),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
              borderRadius: BorderRadius.all(Radius.circular(80)),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black),
              borderRadius: BorderRadius.all(Radius.circular(80)),
            ),
            floatingLabelBehavior: FloatingLabelBehavior.always,
          ),
        ),
      ],
    );
  }

  Widget _buildAlertCarInfosTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Infos de la voiture",
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        SizedBox(height: 8,),
        TextFormField(
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
            hintText: "Entrez quelques informations sur la voiture",
            hintStyle: TextStyle(color: Colors.grey),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black),
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            floatingLabelBehavior: FloatingLabelBehavior.always,
          ),
        ),
      ],
    );
  }

  Widget _buildAlertDateTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Date d'expiration",
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        SizedBox(height: 8,),
        TextFormField(
          controller: alerte_date,
          keyboardType: TextInputType.datetime,
          onTap: () => _selectDate(context),
          decoration: InputDecoration(
            hintText: "Entrez la date",
            hintStyle: TextStyle(color: Colors.grey),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
              borderRadius: BorderRadius.all(Radius.circular(80)),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black),
              borderRadius: BorderRadius.all(Radius.circular(80)),
            ),
            suffixIcon: IconButton(
              icon: Icon(Icons.calendar_today, color: greenThemeColor,),
              onPressed: () => _selectDate(context),
            ),
            floatingLabelBehavior: FloatingLabelBehavior.always,
          ),
        ),
      ],
    );
  }

  Widget _buildAlertTypeDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Type d'alerte",
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.all(Radius.circular(80)),
          ),
          child: DropdownButton<String>(
            isExpanded: true,
            value: selectedOption_type,
            onChanged: (String? newValue) {
              setState(() {
                selectedOption_type = newValue;
              });
            },
            underline: SizedBox(), // Suppression de la ligne par défaut
            items: type_Liste.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(value),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildAlertTelephoneTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "N° de téléphone",
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        SizedBox(height: 8,),
        TextFormField(
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
            hintText: "Entrez le n° de téléphone",
            hintStyle: TextStyle(color: Colors.grey),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
              borderRadius: BorderRadius.all(Radius.circular(80)),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black),
              borderRadius: BorderRadius.all(Radius.circular(80)),
            ),
            floatingLabelBehavior: FloatingLabelBehavior.always,
          ),
        ),
      ],
    );
  }

  Widget _buildAlertEmailTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Email",
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        SizedBox(height: 8,),
        TextFormField(
          keyboardType: TextInputType.emailAddress,
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
            hintText: "Entrez votre email",
            hintStyle: TextStyle(color: Colors.grey),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
              borderRadius: BorderRadius.all(Radius.circular(80)),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black),
              borderRadius: BorderRadius.all(Radius.circular(80)),
            ),
            floatingLabelBehavior: FloatingLabelBehavior.always,
          ),
        ),
      ],
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
}
