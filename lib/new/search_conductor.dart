import 'dart:convert';
import 'dart:io';
import 'package:eyav2/components/form_error.dart';
import 'package:eyav2/widgets/homePage/Conducteur_request/All_request_conducteur.dart';
import 'package:http/http.dart' as http;
import 'package:eyav2/constants.dart';
import 'package:eyav2/global_config.dart';
import 'package:eyav2/new/add_conductor.dart';
import 'package:eyav2/new/drawer.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchConductorScreen extends StatefulWidget {
  @override
  State<SearchConductorScreen> createState() => _SearchConductorScreenState();
}

class _SearchConductorScreenState extends State<SearchConductorScreen> {
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
                    backgroundColor: MaterialStateProperty.all(greenThemeColor),
                    shadowColor: MaterialStateProperty.all(greenThemeColor),
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
    return Scaffold(
      appBar: AppBar(
        title: Text("", style: TextStyle(fontFamily: "Ubuntu", fontSize: 22, fontWeight: FontWeight.bold),),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      drawer: CustomDrawer(),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Conducteurs", style: TextStyle(fontFamily: "Ubuntu", fontSize: 24, fontWeight: FontWeight.bold),),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => AddConductorScreen()));

                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                      backgroundColor: greenThemeColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(80),
                      ),
                    ),
                    child: Text("+ Conduire", style: TextStyle(color: Colors.white, fontSize: 16)),
                  ),
                ],
              ),
              SizedBox(height: 20,),
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    Container(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildAgeGroupDropdown(),
                          SizedBox(height: 20),
                          _buildPermisTypeDropdown(),
                          SizedBox(height: 20),
                          FormError(errors: errors),
                          SizedBox(height: 30),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                  _formKey.currentState!.save();
                                  SharedPreferences prefs = await SharedPreferences.getInstance();
                                  var token =prefs.get("token");
                                  print(token);
                                  Recherche_Conductieur(selectedOption_tranch_age!,selectedOption_type_permi!);
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: greenThemeColor,
                                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text("Rechercher", style: TextStyle(color: Colors.white, fontSize: 16),),
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAgeGroupDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Tranche d'âge",
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        SizedBox(height: 8),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 5),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.all(Radius.circular(80)),
          ),
          child: DropdownButton<String>(
            isExpanded: true,
            value: selectedOption_tranch_age,
            onChanged: (String? newValue) {
              setState(() {
                selectedOption_tranch_age = newValue;
                print(selectedOption_tranch_age);
              });
            },
            underline: SizedBox(),
            items: tranch_age.map<DropdownMenuItem<String>>((String value) {
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

  Widget _buildPermisTypeDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Type de permis de conduire",
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        SizedBox(height: 8),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 5),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.all(Radius.circular(80)),
          ),
          child: DropdownButton<String>(
            isExpanded: true,
            value: selectedOption_type_permi,
            onChanged: (String? newValue) {
              setState(() {
                selectedOption_type_permi = newValue;
                print(selectedOption_type_permi);
              });
            },
            underline: SizedBox(),
            items: type_permi.map<DropdownMenuItem<String>>((String value) {
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
}



/*
class FilterButton extends StatefulWidget {
  final String label;
  bool selected;

  FilterButton({required this.label, this.selected = false});

  @override
  State<FilterButton> createState() => _FilterButtonState();
}

class _FilterButtonState extends State<FilterButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            widget.selected = !widget.selected;
          });
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: widget.selected ? Colors.green : Colors.grey[300],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.selected) ...[
              Icon(Icons.check, color: Colors.white, size: 16),
              SizedBox(width: 8),
            ],
            Text(widget.label, style: TextStyle(color: widget.selected ? Colors.white : Colors.black)),
          ],
        ),
      ),
    );
  }
}

// Widget pour afficher chaque conducteur
class DriverTile extends StatelessWidget {
  final String name;
  final String date;
  final String country;
  final String imageUrl;

  DriverTile({
    required this.name,
    required this.date,
    required this.country,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5,),
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 60, // Augmenter encore la taille ici
            backgroundImage: NetworkImage(imageUrl),
          ),
          SizedBox(width: 20),
          Expanded(
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: TextStyle(fontFamily: "Ubuntu", fontWeight: FontWeight.bold, fontSize: 18),),
                  SizedBox(height: 2),
                  Text(date, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                  Icon(Icons.star, color: Colors.orange, size: 20,),
                  SizedBox(height: 2),
                  Text(country, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: greenThemeColor)),
                ],
              ),
            ),
          ),
        ],
    ));
  }
}
*/