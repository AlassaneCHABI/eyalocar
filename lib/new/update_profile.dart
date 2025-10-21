import 'dart:convert';
import 'dart:io';
import 'package:eyav2/components/form_error.dart';
import 'package:eyav2/new/drawer.dart';
import 'package:http/http.dart' as http;
import 'package:eyav2/constants.dart';
import 'package:eyav2/global_config.dart';
import 'package:eyav2/new/user_profile.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UpdateProfile extends StatefulWidget {
  const UpdateProfile({super.key});

  @override
  State<UpdateProfile> createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
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
                  Navigator.push(context, MaterialPageRoute(builder: (context) => AuthUserProfile()));
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
                      Navigator.push(context, MaterialPageRoute(builder: (context) => AuthUserProfile()));
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
    return Scaffold(
      appBar: AppBar(
        title: Text("Modifier le profil", style: TextStyle(fontFamily: "Ubuntu", fontSize: 22, fontWeight: FontWeight.bold),),
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
                // Text(
                //   'Modifier le profil',
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
                      _buildLastnameTextField(),
                      SizedBox(height: 20),
                      _buildFirstnameTextField(),
                      SizedBox(height: 20),
                      _buildEmailTextField(),
                      SizedBox(height: 20),
                      // _buildUsernameTextField(),
                      // SizedBox(height: 20),
                      _buildAddressTextField(),
                      SizedBox(height: 20),
                      _buildCityTextField(),
                      SizedBox(height: 20),
                      _buildTypeIdentiteDropdown(),
                      SizedBox(height: 20),
                      _buildNumIdentifierTextField(),
                      SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
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
                          style: ElevatedButton.styleFrom(
                            backgroundColor: greenThemeColor,
                            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text("Mettre à jour", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),),
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

  Widget _buildLastnameTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Nom",
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        SizedBox(height: 8,),
        TextFormField(
          initialValue: lastname,
          keyboardType: TextInputType.text,
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
          decoration: InputDecoration(
            hintText: "Entrez votre nom",
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

  Widget _buildFirstnameTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Prénom",
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        SizedBox(height: 8,),
        TextFormField(
          initialValue: firstname,
          keyboardType: TextInputType.text,
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
          decoration: InputDecoration(
            hintText: "Entrez votre prénom",
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

  Widget _buildUsernameTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Nom d'utilisateur",
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        SizedBox(height: 8,),
        TextFormField(
          initialValue: username,
          keyboardType: TextInputType.text,
          validator: (value) {
            if (value == null ||
                value.isEmpty) {
              return 'Veuillez entrer votre pseudo';
            }
            autovalidateMode:
            AutovalidateMode
                .onUserInteraction; // afficher les messages d'erreur directement sous le champ
          },
          onChanged: (value) {
            setState(() {
              username = value;
            });
          },
          decoration: InputDecoration(
            hintText: "Entrez votre pseudo",
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

  Widget _buildAddressTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Adresse",
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        SizedBox(height: 8,),
        TextFormField(
          initialValue: address,
          keyboardType: TextInputType.text,
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
          decoration: InputDecoration(
            hintText: "Entrez votre adresse",
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

  Widget _buildCityTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Ville",
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        SizedBox(height: 8,),
        TextFormField(
          initialValue: city,
          keyboardType: TextInputType.text,
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
          decoration: InputDecoration(
            hintText: "Entrez votre ville",
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

  Widget _buildTypeIdentiteDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Type de pièce d'identité",
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
            value: selectedOption_type_identite,
            onChanged: (String? newValue) {
              setState(() {
                selectedOption_type_identite = newValue;
              });
            },
            underline: SizedBox(), // Suppression de la ligne par défaut
            items: type_identite.map<DropdownMenuItem<String>>((String value) {
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

  Widget _buildNumIdentifierTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "N° de la pièce d'dentité",
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        SizedBox(height: 8,),
        TextFormField(
          initialValue: identifier,
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value == null ||
                value.isEmpty) {
              return 'Veuillez entrer le n°';
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
          decoration: InputDecoration(
            hintText: "Entrez le n° de la pièce",
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

  Widget _buildEmailTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Email",
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        SizedBox(height: 8,),
        TextFormField(
          initialValue: email,
          keyboardType: TextInputType.emailAddress,
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

}
