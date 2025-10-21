import 'dart:convert';
import 'dart:io';

import 'package:eyav2/constants.dart';
import 'package:eyav2/global_config.dart';
import 'package:eyav2/profil/profil_ui.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart ' as http;
import '../widgets/DrawerMenuWidget.dart';
import '../widgets/bottomnav.dart';

class Updateprofil extends StatefulWidget {
  const Updateprofil({Key? key}) : super(key: key);

  @override
  State<Updateprofil> createState() => _UpdateprofilState();
}

class _UpdateprofilState extends State<Updateprofil> {
  late String username;
  late String lastname;
  late String firstname;
  late String city;
  late String address;
  late String type_identifier;
  late String identifier;
  late String email;
  late String token;
  List<String> type_identite = ['Type d\'identité','NPI', 'IFU'];
  String? selectedOption_type_identite = 'Type d\'identité';

  _getLocalUser() async {
    setState(() {
      _isLoading = true;
    });
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      username=prefs.getString("username")!;
      lastname=prefs.getString("lastname")!;
      firstname=prefs.getString("firstname")!;
      city=prefs.getString("city")!;
      address=prefs.getString("address")!;
      type_identifier=prefs.getString("type_identifier")!;
      identifier=prefs.getString("identifier")!;
      email=prefs.getString("email")!;
      token=prefs.getString("token")!;

    } catch (e) {
      print(e.toString());
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  showAlertDialog(BuildContext context){
    AlertDialog alert=AlertDialog(
      content: new Row(
        children: [
          CircularProgressIndicator(),
          Container(margin: EdgeInsets.only(left: 5),child:Text("Mise à jour ....." )),
        ],),
    );
    showDialog(barrierDismissible: false,
      context:context,
      builder:(BuildContext context){
        return alert;
      },
    );
  }

  Future <void> UpdatedUser(String pseudo,String nom,String prenom, String ville,String adresse,String type_identifier,String identifier) async {

    showAlertDialog(context);
    var url = Uri.http('${Configuration.base_url}', 'apiv2/auth/edit-profile');

    final response = await http.post(
        url,
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.acceptHeader: 'application/json',
          HttpHeaders.authorizationHeader:'Bearer $token'
        },
        body: json.encode({
          "username": pseudo,
          "lastname": nom,
          "firstname": prenom,
          "city": ville,
          "address": adresse,
          "type_identifier": type_identifier,
          "identifier": identifier,
        })
    );
    if(response.statusCode==200){
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('username',pseudo);
      prefs.setString('lastname',nom );
      prefs.setString('firstname',prenom );
      prefs.setString('city',ville );
      prefs.setString('address',adresse );
      prefs.setString('type_identifier',type_identifier );
      prefs.setString('identifier',identifier );
      prefs.setString('email',email );
      Navigator.of(context).pop();
      showDialog(
        context: this.context,
        builder: (BuildContext ctx) {
          return AlertDialog(
            title: Text("Mise à jour du profil"),
            content: Text("Les informations ont été mises à jour avec succès", textAlign: TextAlign.center,),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilUI()));
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
              "username": pseudo,
              "lastname": nom,
              "firstname": prenom,
              "city": ville,
              "address": adresse,
              "type_identifier": type_identifier,
              "identifier": identifier,
            })
        );
        if(newResponse.statusCode==200){

          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('username',pseudo);
          prefs.setString('lastname',nom );
          prefs.setString('firstname',prenom );
          prefs.setString('city',ville );
          prefs.setString('address',adresse );
          prefs.setString('type_identifier',type_identifier );
          prefs.setString('identifier',identifier );
          prefs.setString('email',email );
          Navigator.of(context).pop();
          showDialog(
            context: this.context,
            builder: (BuildContext ctx) {
              return AlertDialog(
                title: Text("Mise à jour du profil"),
                content: Text("Les informations ont été mises à jour avec succès.", textAlign: TextAlign.center,),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(ctx);
                      Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilUI()));
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
    else{
      showDialog(
          context: context,
          builder:
              (BuildContext context) {
            return AlertDialog(
              title: const Text(
                  "Erreur de Mise à jour"),
              content: const Text(
                  "Veuillez reprendre la mise à jour"),
              actions: [
                TextButton(
                  onPressed: () =>
                      Navigator.pop(
                          context),
                  child: const Text(
                      "OK"),
                )
              ],
            );
          });
    }
  }



  late String userId ;
  bool _isLoading = false;

  final _formKey = GlobalKey<FormState>();
  bool passwordVisible = true;


  @override
  void initState() {
    super.initState();
    _getLocalUser();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: kPrimaryColor,
          title: const Text('MISE A JOUR DU PROFIL'),
          /*actions: [
            PopupMenuButton(
              itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                const PopupMenuItem(
                  value: 2,
                  child: Text('Parametre'),
                ),
              ],
              icon: const Icon(Icons.settings), // <-- Add an icon here
              onSelected: (value) {
                // Handle menu item selection
              },
            ),
          ],*/
        ),
        drawer: DrawerMenuWidget(),
        bottomNavigationBar: bottomNvigator(),


        body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
            Widget>[
          const SizedBox(height: 10),
          Expanded(
              child: Container(
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(60),
                          topRight: Radius.circular(60))),
                  child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Padding(
                        padding: const EdgeInsets.all(30),
                        child: Column(
                          children: <Widget>[
                            username == null || _isLoading
                                ? Center(
                                    child: SizedBox(
                                      height: 40.0,
                                      width: 40.0,
                                      child: CircularProgressIndicator(
                                        color: kPrimaryColor,
                                        strokeWidth: 5,
                                      ),
                                    ),
                                  )
                                : Form(
                                    key: _formKey,
                                    child: ListView(
                                      shrinkWrap: true,
                                      primary: false,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      padding: const EdgeInsets.all(1.0),
                                      children: <Widget>[
                                        //////////////////////// full name

                                        const Text('Nom d\'utilisateur'),
                                        const SizedBox(height: 5),
                                        Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors.grey,
                                              width: 1.0,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(5.0),
                                          ),
                                          child: TextFormField(
                                            initialValue:
                                            username,
                                            keyboardType: TextInputType.text,
                                            decoration: const InputDecoration(
                                              border: InputBorder.none,
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                      vertical: 10,
                                                      horizontal: 10),
                                            ),
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Veuillez entrer votre nom d\'utilisateur';
                                              }
                                              autovalidateMode:
                                              AutovalidateMode
                                                  .onUserInteraction; // afficher les messages d'erreur directement sous le champ
                                            },
                                            onChanged: (value) {
                                              setState(() {
                                                username =
                                                    value.toString();
                                              });
                                            },
                                          ),
                                        ),
                                        const SizedBox(height: 10),

                                        const Text('Nom'),
                                        const SizedBox(height: 5),
                                        Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors.grey,
                                              width: 1.0,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(5.0),
                                          ),
                                          child: TextFormField(
                                           initialValue: lastname,
                                            keyboardType: TextInputType.text,
                                            decoration: const InputDecoration(
                                              border: InputBorder.none,
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                      vertical: 10,
                                                      horizontal: 10),
                                            ),
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Veuillez entrer votre nom';
                                              }
                                              autovalidateMode:
                                              AutovalidateMode
                                                  .onUserInteraction; // afficher les messages d'erreur directement sous le champ
                                            },
                                            onChanged: (value) {
                                              setState(() {
                                                lastname = value;
                                              });
                                            },
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        const Text('Prénom'),
                                        const SizedBox(height: 5),
                                        Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors.grey,
                                              width: 1.0,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(5.0),
                                          ),
                                          child: TextFormField(
                                           initialValue: firstname,
                                            keyboardType: TextInputType.text,
                                            decoration: const InputDecoration(
                                              border: InputBorder.none,
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                      vertical: 10,
                                                      horizontal: 10),
                                            ),
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Veuillez entrer votre prénom';
                                              }
                                              autovalidateMode:
                                              AutovalidateMode
                                                  .onUserInteraction; // afficher les messages d'erreur directement sous le champ
                                            },
                                            onChanged: (value) {
                                              setState(() {
                                                firstname = value;
                                              });
                                            },
                                          ),
                                        ),
                                        const SizedBox(height: 20),
                                        const Text('Adresse'),
                                        const SizedBox(height: 5),
                                        Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors.grey,
                                              width: 1.0,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(5.0),
                                          ),
                                          child: TextFormField(
                                           initialValue: address,
                                            keyboardType: TextInputType.text,
                                            decoration: const InputDecoration(
                                              border: InputBorder.none,
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                      vertical: 10,
                                                      horizontal: 10),
                                            ),
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Veuillez entrer votre adresse';
                                              }
                                              autovalidateMode:
                                              AutovalidateMode
                                                  .onUserInteraction; // afficher les messages d'erreur directement sous le champ
                                            },
                                            onChanged: (value) {
                                              setState(() {
                                                address = value;
                                              });
                                            },
                                          ),
                                        ),
                                        const SizedBox(height: 20),

                                        const Text('Ville'),
                                        const SizedBox(height: 5),
                                        Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors.grey,
                                              width: 1.0,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(5.0),
                                          ),
                                          child: TextFormField(
                                           initialValue: city,
                                            keyboardType: TextInputType.text,
                                            decoration: const InputDecoration(
                                              border: InputBorder.none,
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                      vertical: 10,
                                                      horizontal: 10),
                                            ),
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Veuillez entrer votre ville';
                                              }
                                              autovalidateMode:
                                              AutovalidateMode
                                                  .onUserInteraction; // afficher les messages d'erreur directement sous le champ
                                            },
                                            onChanged: (value) {
                                              setState(() {
                                                city = value;
                                              });
                                            },
                                          ),
                                        ),

                                        const SizedBox(height: 20),
                                        //const Text('Tyde'),
                                        const SizedBox(height: 5),
                                        Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors.grey,
                                              width: 1.0,
                                            ),
                                            borderRadius:
                                            BorderRadius.circular(5.0),
                                          ),
                                          child:  DropdownButton<String>(
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
                                        ),),

                                        const SizedBox(height: 20),

                                        const Text('Identité'),
                                        const SizedBox(height: 5),
                                        Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors.grey,
                                              width: 1.0,
                                            ),
                                            borderRadius:
                                            BorderRadius.circular(5.0),
                                          ),
                                          child: TextFormField(
                                            initialValue: identifier,
                                            keyboardType: TextInputType.text,
                                            decoration: const InputDecoration(
                                              border: InputBorder.none,
                                              contentPadding:
                                              EdgeInsets.symmetric(
                                                  vertical: 10,
                                                  horizontal: 10),
                                            ),
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Veuillez entrer votre identité';
                                              }
                                              autovalidateMode:
                                              AutovalidateMode
                                                  .onUserInteraction; // afficher les messages d'erreur directement sous le champ
                                            },
                                            onChanged: (value) {
                                              setState(() {
                                                identifier = value;
                                              });
                                            },
                                          ),
                                        ),

                                        const SizedBox(height: 20),
                                        // champs Entre votre adresse email const SizedBox(height: 20),
                                        const Text('Email'),
                                        const SizedBox(height: 5),
                                        Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors.grey,
                                              width: 1.0,
                                            ),
                                            borderRadius:
                                            BorderRadius.circular(5.0),
                                          ),
                                          child: TextFormField(
                                            enabled: false,
                                            initialValue: email,
                                            keyboardType:
                                            TextInputType.emailAddress,
                                            decoration: const InputDecoration(
                                              border: InputBorder.none,
                                              contentPadding:
                                              EdgeInsets.symmetric(
                                                  vertical: 10,
                                                  horizontal: 10),
                                            ),
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Veuillez entrer votre adresse e-mail';
                                              } else if (!value.contains('@')) {
                                                return 'Veuillez entrer une adresse e-mail valide';
                                              }
                                              return null;
                                            },
                                            onChanged: (value) {
                                              setState(() {
                                                email = value;
                                              });
                                            },
                                            // controller: _fullnameController,
                                          ),
                                        ),

                                        const SizedBox(height: 40),
                                        Container(
                                          height: 40,
                                          width: 300,
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 50),
                                          child: ElevatedButton(
                                            onPressed: () {
                                              if (_formKey.currentState!
                                                  .validate()) {
                                               UpdatedUser(username,lastname,firstname,city,address,selectedOption_type_identite!,identifier!);
                                              } else {
                                                showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return AlertDialog(
                                                        title: const Text(
                                                            "Erreur de validation"),
                                                        content: const Text(
                                                            "Veuillez remplir tous les champs"),
                                                        actions: [
                                                          TextButton(
                                                            onPressed: () =>
                                                                Navigator.pop(
                                                                    context),
                                                            child: const Text(
                                                                "OK"),
                                                          )
                                                        ],
                                                      );
                                                    });
                                              }
                                            },
                                            style: ButtonStyle(
                                              backgroundColor:
                                              MaterialStateProperty.all<
                                                  Color>(
                                                  kPrimaryColor!),
                                              textStyle: MaterialStateProperty
                                                  .all<TextStyle>(
                                                  const TextStyle(
                                                      fontSize: 20)),
                                              shape: MaterialStateProperty.all<
                                                  RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                                    borderRadius:
                                                    BorderRadius.circular(
                                                        50)),
                                              ),
                                            ),
                                            child: const Text('Mettre à jour '),
                                          ),
                                        ),
                                       /* const SizedBox(height: 20),
                                        const Text('Pays'),
                                        DropdownWidget(
                                          controller: _paysController,
                                          key: const ValueKey("ActDropButt"),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: Colors.grey,
                                                width: 1.0,
                                              ),
                                              borderRadius: BorderRadius.circular(5.0),
                                            ),
                                            child: DropdownButtonFormField(
                                              value: liste_pays.isNotEmpty
                                                  ? (user.pays_name != null
                                                  ? liste_pays.firstWhere(
                                                    (item) => item.name == user.pays_name!,
                                                orElse: () => liste_pays.first,
                                              )
                                                  : liste_pays.first)
                                                  : null,
                                              style: const TextStyle(
                                                color: grisColor,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              hint: const Text(
                                                'Sélectionnez Votre Pays',
                                              ),
                                              isExpanded: true,
                                              onChanged: (value) {
                                                setState(() {
                                                    paysname = value?.name;
                                                    print("*** CHOIX PAYS");
                                                    print(paysname);
                                                    pay_is=value!.online_id;
                                                    print(""""""""""pay_id """"""""""""""");
                                                    print(pay_is);
                                                    //_paysController.text = value!.online_id.toString();

                                                    //print(_paysController.text);
                                                    /*String countryCode =
                                                        liste_pays.firstWhere((item) => item.id == value).indicatif;
                                                    _phone1Controller.text = countryCode;
                                                    _phone2Controller.text = countryCode;*/

                                                });
                                              },
                                              items: liste_pays
                                                  .map((item) => DropdownMenuItem(
                                                value: item,
                                                child: Text(
                                                  '${item.name}',
                                                ),
                                              ))
                                                  .toList(),
                                              validator: (value) {
                                                if (value == null) {
                                                  return 'Veuillez sélectionner votre pays';
                                                }
                                                return null;
                                              },
                                              decoration: const InputDecoration(
                                                border: InputBorder.none,
                                                contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                              ),
                                            ),
                                          ),
                                        ),

                                        const SizedBox(height: 20.0),*/
                                        //const Text('Commune'),

                                        // _isLoading
                                        //     ? SizedBox(
                                        //         height: 20.0,
                                        //         width: 20.0,
                                        //         child:
                                        //             CircularProgressIndicator(
                                        //           color: violetFonceColor,
                                        //           strokeWidth: 1,
                                        //         ),
                                        //       )
                                        //     :
                                      /*  DropdownWidget(
                                            controller: _communeController,
                                            key: const ValueKey(
                                                "ActDropcommune"),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: Colors.grey,
                                                  width: 1.0,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(5.0),
                                              ),
                                              child: DropdownButtonFormField(
                                                style: const TextStyle(
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.bold),
                                                hint: const Text(
                                                  'Séléctionnez Votre commune',
                                                ),
                                                isExpanded: true,
                                                onChanged: (value) {
                                                  print(value);
                                                  setState(() {
                                                    communename=value?.name;
                                                    _communeController.text =
                                                        value.toString();
                                                  });
                                                },
                                                items: liste_communes
                                                    .map((item) =>
                                                        DropdownMenuItem(
                                                            value: item,
                                                            child: Text(
                                                              '${item.name}',
                                                            )))
                                                    .toList(),
                                                validator: (value) {
                                                  if (value == null) {
                                                    return 'Veuillez selectioner votre Commune';
                                                  }
                                                  return null;
                                                },
                                              ),
                                            )),
                                        const SizedBox(
                                          height: 20,
                                        ),*/
                                        //const Text('Partenaire'),

                                        // _isLoading
                                        //     ? SizedBox(
                                        //         height: 20.0,
                                        //         width: 20.0,
                                        //         child:
                                        //             CircularProgressIndicator(
                                        //           color: violetFonceColor,
                                        //           strokeWidth: 1,
                                        //         ),
                                        //       )
                                        //     :
                                        /*DropdownWidget(
                                          controller: _partenaireController,
                                          key: const ValueKey("PartenaireDropdown"),
                                          child: DropdownButtonFormField(
                                            value: liste_partenaires.isNotEmpty
                                                ? (user.partenaire_name != null
                                                ? liste_partenaires.firstWhere(
                                                  (item) => item.name == user.partenaire_name!,
                                              orElse: () => liste_partenaires.first,
                                            )
                                                : liste_partenaires.first)
                                                : null,
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w500),
                                            hint: const Text(
                                              'Sélectionnez un partenaire',
                                            ),
                                            isExpanded: true,
                                            onChanged: (value) {
                                              partenairename = value?.name;
                                              print(value?.name);
                                              setState(() {
                                                _partenaireController.text = value!.online_id.toString();
                                                print(_partenaireController.text);
                                              });
                                            },
                                            items: liste_partenaires.map((item) =>
                                                DropdownMenuItem(
                                                    value: item,
                                                    child: Text('${item.name}',
                                                    ))).toList(),
                                            validator: (value) => (value==null)?"Sélectionnez un partenaire":null,
                                            decoration: InputDecoration(
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(5),
                                                borderSide: const BorderSide(width: 1, color: Colors.grey),
                                              ),
                                              contentPadding: EdgeInsets.symmetric(
                                                  vertical: 1,
                                                  horizontal: 10),
                                            ),
                                          ),
                                        ),
                                         */

                                        /* const SizedBox(height: 20),
                                        const Text('Mot de passe'),
                                        const SizedBox(height: 5),

                                        Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors.grey,
                                              width: 1.0,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(5.0),
                                          ),
                                          child: TextFormField(
                                            controller: _passwordController,
                                            keyboardType: TextInputType.text,
                                            decoration: InputDecoration(
                                                border: InputBorder.none,
                                              contentPadding: EdgeInsets.symmetric(
                                                  vertical: 10,
                                                  horizontal: 10),
                                              suffixIcon: IconButton(
                                                icon: Icon(
                                                  passwordVisible ? Icons.visibility_off : Icons.visibility,
                                                  color: violetFonceColor,
                                                ),
                                                onPressed: () {
                                                  setState(() {
                                                    passwordVisible = !passwordVisible;
                                                  });
                                                },
                                              ),
                                            ),
                                            obscureText: passwordVisible,
                                            validator: (value) {
                                              if (value == null || value.isEmpty || value.length<8) {
                                                return 'Mot de passe incomplet (min. 8 caractères requis)';
                                              }
                                              return null;
                                            },
                                          ),

                                        ),*/
                                      ],
                                    ),
                                  ),
                          ],
                        ),
                      )))),
        ]));
  }


  _getProfilUser() async {
    setState(() {
      _isLoading = true;
    });
    try {
      /*await ApiService().getApi('/get-user/${userId}').then((value) {
        print(value);
        setState(() {
          user = User.fromJson(value['user']);
        });
      });*/
    } catch (e) {
      print(e.toString());
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }





  //fonction registrer
 /* _register() async {
    final data = {
      //Ajouter l'id du pays et l'id du partenaire
      'user_id': userId,
      'full_name': user.full_name,
      'email': user.email,
      'password': user.password,
      'phone1': user.phone1,
      'phone2': user.phone2,
      'pseudo': user.pseudo,
    };

    setState(() {
      _isLoading = true;
    });
    print(data);
    var response = await ApiService().putApi('/update-user/${userId}', data);
    await DbManager().updateDbUser(user);
    print('sucess: ${response}');

      if (response['success'] == true) {
        showDialog(
          context: this.context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Succès'),
              content: const Text(
                  'Les informations ont été mises à jour avec succès.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    if (_emailController.text.isNotEmpty ||
                        _passwordController.text.isNotEmpty) {
                      pref_manager.removeAllPrefItem();
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => const LoginUI()),
                        (route) => false,
                      );
                    }
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${response['message']}'),
        ),
      );
    }
  }
*/


}
