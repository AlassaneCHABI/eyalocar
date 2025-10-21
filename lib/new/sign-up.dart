import 'package:eyav2/components/form_error.dart';
import 'package:eyav2/constants.dart';
import 'package:eyav2/new/complete-profile.dart';
import 'package:eyav2/new/sign-in.dart';
import 'package:flutter/material.dart';


class RegisterScreen extends StatefulWidget {
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool _isChecked = false;
  final _formKey = GlobalKey<FormState>();

  String? nom;
  String? prenom;
  String? ville;
  String? adresse;
  String? pseudo;
  bool remember = false;

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
              padding: EdgeInsets.symmetric(
                vertical: MediaQuery.of(context).size.height * 0.1,
                horizontal: MediaQuery.of(context).size.width * 0.08,
              ),  /*EdgeInsets.symmetric(horizontal: 50, vertical: 50),*/
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 50),
                    Image.asset('assets/logo-4x.png', height: 100),
                    const SizedBox(height: 50),
                    Text(
                      'Enregistrez-vous',
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
                          _buildPseudoTextField(),
                          SizedBox(height: 20),
                          _buildNomTextField(),
                          SizedBox(height: 20),
                          _buildPrenomTextField(),
                          SizedBox(height: 20),
                          _buildVilleTextField(),
                          SizedBox(height: 20),
                          _buildAdresseTextField(),
                          SizedBox(height: 20),
                          FormError(errors: errors),
                          // Column(
                          //   children: [
                          //     Row(
                          //       children: [
                          //         Checkbox(
                          //           value: _isChecked,
                          //           onChanged: (value) {
                          //             setState(() {
                          //               _isChecked = value ?? false;
                          //             });
                          //           },
                          //           activeColor: Color(0xFFE5A000),
                          //         ),
                          //         const Expanded(
                          //           child: Text(
                          //             'Je ne suis pas un robot',
                          //             style: TextStyle(fontWeight: FontWeight.bold),
                          //           ),
                          //         ),
                          //       ],
                          //     ),
                          //     Row(
                          //       children: [
                          //         SizedBox(width: 45,),
                          //         Expanded(child: Text("Confirmez que vous n'êtes pas un programme.", softWrap: true, style: TextStyle(color: Colors.grey),))
                          //       ],
                          //     ),
                          //   ],
                          // ),
                          SizedBox(height: 20),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  _formKey.currentState!.save();
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (ctxt) =>  CompleteProfilScreen(nom: nom!,prenom: prenom!,ville: ville!,adresse: adresse!,pseudo: pseudo!,))
                                  );
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
                    TextButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Déjà inscrit ?',
                            style: TextStyle(color: Colors.grey),
                          ),
                          SizedBox(width: 5,),
                          const Text(
                            'Connectez-vous',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, bool obscure, String hintText) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        SizedBox(height: 8,),
        TextField(
          obscureText: obscure,
          decoration: InputDecoration(
            hintText: hintText,
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

  Widget _buildNomTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Nom",
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        SizedBox(height: 8,),
        TextFormField(
          obscureText: false,
          onSaved: (newValue) => nom = newValue,
          onChanged: (value) {
            if (value.isNotEmpty) {
              removeError(error: kNomNullError);
            }
            nom = value;
          },
          validator: (value) {
            if (value!.isEmpty) {
              addError(error: kNomNullError);
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

  Widget _buildPrenomTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Prénom",
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        SizedBox(height: 8,),
        TextFormField(
          obscureText: false,
          onSaved: (newValue) => prenom = newValue,
          onChanged: (value) {
            if (value.isNotEmpty) {
              removeError(error: kprenomNullError);
            }
            prenom = value;
          },
          validator: (value) {
            if (value!.isEmpty) {
              addError(error: kprenomNullError);
              return "";
            }
            return null;
          },
          decoration: InputDecoration(
            hintText: "Entrez votre prénom",
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

  Widget _buildAdresseTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Adresse",
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        SizedBox(height: 8,),
        TextFormField(
          obscureText: false,
          onSaved: (newValue) => adresse = newValue,
          onChanged: (value) {
            if (value.isNotEmpty) {
              removeError(error: kAddressNullError);
            }
            adresse = value;
          },
          validator: (value) {
            if (value!.isEmpty) {
              addError(error: kAddressNullError);
              return "";
            }
            return null;
          },
          decoration: InputDecoration(
            hintText: "Entrez votre adresse",
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

  Widget _buildPseudoTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Nom d'utilisateur",
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        SizedBox(height: 8,),
        TextFormField(
          obscureText: false,
          onSaved: (newValue) => pseudo = newValue,
          onChanged: (value) {
            if (value.isNotEmpty) {
              removeError(error: kAPseudoNullError);
            }
            pseudo = value;
          },
          validator: (value) {
            if (value!.isEmpty) {
              addError(error: kAPseudoNullError);
              return "";
            }
            return null;
          },
          decoration: InputDecoration(
            hintText: "Entrez votre nom d'utilisateur",
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

  Widget _buildVilleTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Ville",
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        SizedBox(height: 8,),
        TextFormField(
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
            hintText: "Entrez votre ville ",
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

}
