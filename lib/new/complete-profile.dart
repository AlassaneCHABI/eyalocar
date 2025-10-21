import 'package:eyav2/components/form_error.dart';
import 'package:eyav2/constants.dart';
import 'package:eyav2/function/function.dart';
import 'package:eyav2/new/sign-in.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class CompleteProfilScreen extends StatefulWidget {
  static String routeName = "/CheckoutPage";
  String nom;
  String prenom;
  String ville;
  String adresse;
  String pseudo;

  CompleteProfilScreen({ Key? key, required this.nom,required this.prenom,required this.ville,required this.adresse,required this.pseudo}) : super(key: key);

  @override
  State<CompleteProfilScreen> createState() => _CompleteProfilScreenState();
}

class _CompleteProfilScreenState extends State<CompleteProfilScreen> {
  final _formKey = GlobalKey<FormState>();
  final List<String?> errors = [];
  List<String> type_identite = ['Type de pièce d\'identité','NPI', 'IFU'];
  String? selectedOption_type_identite = 'NPI';
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
          Container(margin: EdgeInsets.only(left: 5),child:Text("Chargement" )),
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
    return Scaffold(
      body: Stack(
        children: [
          Opacity(
            opacity: 0.85,
            child: Image.asset(
              'assets/back-car.png',
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
          Container(
            color: Color(0xFF104912).withOpacity(0.80),
          ),
          SingleChildScrollView(
            child: Padding(
              padding:  EdgeInsets.symmetric(
                vertical: MediaQuery.of(context).size.height * 0.1,
                horizontal: MediaQuery.of(context).size.width * 0.08,
              ),
              /*EdgeInsets.symmetric(horizontal: 50, vertical: 50),*/
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 50),
                    Image.asset('assets/logo-4x.png', height: 100),
                    const SizedBox(height: 50),
                    Text(
                      'Compléter le profil',
                      style: TextStyle(fontFamily: "Ubuntu", fontSize: 32, color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 20),
                    Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: [
                          _buildTypeIdentiteDropdown(),
                          SizedBox(height: 20),
                          _buildNumIdentiteTextField(),
                          SizedBox(height: 20),
                          _buildEmailTextField(),
                          SizedBox(height: 20),
                          _buildPasswordTextField(),
                          SizedBox(height: 20),
                          FormError(errors: errors),
                          Column(
                            children: [
                              Row(
                                children: [
                                  Checkbox(
                                    value: _acceptPolicy,
                                    onChanged: (value) {
                                      setState(() {
                                        _acceptPolicy = value ?? false;
                                      });
                                    },
                                    activeColor: Color(0xFFE5A000),
                                  ),
                                  const Expanded(
                                    child: Text(
                                      "J'adhère à la politique d'utilisation",
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  SizedBox(width: 45,),
                                  Expanded(child: Text("Cliquez ici pour plus de détails.", softWrap: true, style: TextStyle(color: Colors.grey),))
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () async {
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
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
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
                                                  elevation: WidgetStateProperty.all(15),
                                                  foregroundColor: WidgetStateProperty.all(Colors.white),
                                                  backgroundColor: WidgetStateProperty.all(vertFonceColor),
                                                  shadowColor: WidgetStateProperty.all(vertFonceColor),
                                                  padding: WidgetStateProperty.all(const EdgeInsets.all(5)),
                                                  fixedSize: WidgetStateProperty.all(const Size(100, 40))),
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
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFFE5A000),
                                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text("Continuer", style: TextStyle(color: Colors.black),),
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
        ],
      ),
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
            borderRadius: BorderRadius.all(Radius.circular(10)),
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
                  padding: const EdgeInsets.all(8.0), // Ajoute un padding pour le style
                  child: Text(value),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildTypeIdentiteTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Type de pièce d'identité",
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        SizedBox(height: 8,),
        TextFormField(
          // keyboardType: TextInputType.phone,
          onSaved: (newValue) => type_identifier = newValue,
          onChanged: (value) {
            if (value.isNotEmpty) {
              removeError(error: kTypeIdentiteNullError);
            }
            type_identifier=value;
          },
          validator: (value) {
            if (value!.isEmpty) {
              addError(error: kTypeIdentiteNullError);
              return "";
            }
            return null;
          },
          decoration: InputDecoration(
            hintText: "Entrez votre nom",
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

  Widget _buildNumIdentiteTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Numéro de la pièce",
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        SizedBox(height: 8,),
        TextFormField(
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
            hintText: "Entrez le n° de la pièce",
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
            }
            /*else if (!emailValidatorRegExp.hasMatch(value)) {
              addError(error: kInvalidEmailError);
              return "";
            }*/
            return null;
          },
          decoration: InputDecoration(
            hintText: "nom@domaine.com",
            hintStyle: TextStyle(color: Colors.grey),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black),
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Mot de passe",
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        SizedBox(height: 8,),
        TextFormField(
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
            hintText: "**************",
            hintStyle: TextStyle(color: Colors.grey),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black),
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
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
            ),
          ),
        ),
      ],
    );
  }


}
