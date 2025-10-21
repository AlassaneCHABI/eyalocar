import 'dart:convert';
import 'dart:io';

import 'package:eyav2/components/form_error.dart';
import 'package:eyav2/constants.dart';
import 'package:eyav2/function/function.dart';
import 'package:eyav2/global_config.dart';
import 'package:eyav2/modeles/Categorie.dart';
import 'package:eyav2/new/add_car.dart';
import 'package:eyav2/new/entry_screen.dart';
import 'package:eyav2/new/found_cars_list.dart';
import 'package:eyav2/widgets/homePage/Voitures/All_cars.dart';
import 'package:http/http.dart' as http;
import 'package:eyav2/new/drawer.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchCarScreen extends StatefulWidget {
  @override
  State<SearchCarScreen> createState() => _SearchCarScreenState();
}

class _SearchCarScreenState extends State<SearchCarScreen> {
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
      }
    }
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
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Louer", style: TextStyle(fontFamily: "Ubuntu", fontSize: 24, fontWeight: FontWeight.bold),),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => AddCarScreen()));
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                      backgroundColor: greenThemeColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(80),
                      ),
                    ),
                    child: Text("+ Ajouter un véhicule", style: TextStyle(color: Colors.white, fontSize: 16)),
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
                          _buildCarCategoryDropdown(),
                          SizedBox(height: 24),
                          _buildCarMinYearTextField(),
                          SizedBox(height: 5),
                          v_min?Text("Cette valeur doit être supérieur ou égale à ${now.year-8} et inférieur ou égale à ${now.year}",style: TextStyle(color: Colors.red),):Text(""),
                          v_min? SizedBox(height: 10) :SizedBox(),
                          _buildCarMaxYearTextField(),
                          SizedBox(height: 5),
                          v_max?Text("Cette valeur doit être supérieur ou égale à ${now.year-8} et inférieur ou égale à ${now.year}",style: TextStyle(color: Colors.red),):Text(""),
                          v_max? SizedBox(height: 10) :SizedBox(),
                          _buildBudgetTextField(),
                          SizedBox(height: 5),
                          min_bud?Text("Cette valeur doit être supérieur ou égale à 25000",style: TextStyle(color: Colors.red),):Text(""),
                          min_bud? SizedBox(height: 10) :SizedBox(),
                          FormError(errors: errors),

                          SizedBox(height: 20),

                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () async {
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

  Widget _buildCarCategoryDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Text(
        //   "Catégorie de véhicule",
        //   style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        // ),
        // SizedBox(height: 8),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.all(Radius.circular(80)),
          ),
          child: DropdownButton<int?>(
            isExpanded: true,
            hint: const Text(
              'Sélectionner la catégorie',
            ),
            onChanged: (value) {
              setState(() {
                car_category = value;
              });
            },
            items: liste_Category.map((item) {
              return DropdownMenuItem<int?>(
                value: item.id,
                child: Text(item.category_name),
              );
            }).toList(),
            value: car_category,
            underline: SizedBox(),
          ),
        ),
      ],
    );
  }


  Widget _buildBudgetTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Text(
        //   "Prix du véhicule",
        //   style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        // ),
        // SizedBox(height: 8,),
        TextFormField(
          keyboardType: TextInputType.number,
          onSaved: (newValue) => budget = newValue,
          onChanged: (value) {
            if (value.isNotEmpty) {
              removeError(error: kcar_priceNullError);
            }
            budget = value;
          },
          validator: (value) {
            if (value!.isEmpty) {
              addError(error: kcar_priceNullError);
              return "";
            }
            return null;
          },
          decoration: InputDecoration(
            hintText: "Entrez votre budget",
            hintStyle: TextStyle(color: Colors.grey),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
              borderRadius: BorderRadius.all(Radius.circular(80)),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black),
              borderRadius: BorderRadius.all(Radius.circular(80)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCarMinYearTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Text(
        //   "Année du véhicule",
        //   style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        // ),
        // SizedBox(height: 8,),
        TextFormField(
          keyboardType: TextInputType.number,
          onSaved: (newValue) => year_minimum = newValue,
          onChanged: (value) {
            if (value.isNotEmpty) {
              removeError(error: kcar_yearNullError);
            }
            year_minimum = value;
          },
          validator: (value) {
            if (value!.isEmpty) {
              addError(error: kcar_yearNullError);
              return "";
            }
            return null;
          },
          decoration: InputDecoration(
            hintText: "Entrez l'année minimum",
            hintStyle: TextStyle(color: Colors.grey),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
              borderRadius: BorderRadius.all(Radius.circular(80)),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black),
              borderRadius: BorderRadius.all(Radius.circular(80)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCarMaxYearTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Text(
        //   "Année du véhicule",
        //   style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        // ),
        // SizedBox(height: 8,),
        TextFormField(
          keyboardType: TextInputType.number,
          onSaved: (newValue) => year_maximum = newValue,
          onChanged: (value) {
            if (value.isNotEmpty) {
              removeError(error: kcar_yearNullError);
            }
            year_maximum = value;
          },
          validator: (value) {
            if (value!.isEmpty) {
              addError(error: kcar_yearNullError);
              return "";
            }
            return null;
          },
          decoration: InputDecoration(
            hintText: "Entrez l'année maximum",
            hintStyle: TextStyle(color: Colors.grey),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
              borderRadius: BorderRadius.all(Radius.circular(80)),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black),
              borderRadius: BorderRadius.all(Radius.circular(80)),
            ),
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

class CarCard extends StatelessWidget {
  final String name;
  final String imageUrl;

  CarCard({
    required this.name,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Color(0xFFD9FFD9),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(),
                Icon(
                  Icons.favorite_border,
                  color: Colors.black,
                ),
              ],
            ),
          ),
          Image.network(imageUrl, height: 80), // Remplace par l'image de ta voiture
          SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                // padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                backgroundColor: Color(0xFFE5A000),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: Wrap(
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    softWrap: true,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
*/