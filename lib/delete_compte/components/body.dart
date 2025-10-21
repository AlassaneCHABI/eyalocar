
import 'dart:convert';
import 'dart:io';

import 'package:eyav2/forgot_password/Pin_code.dart';
import 'package:eyav2/global_config.dart';
import 'package:eyav2/new/home.dart';
import 'package:flutter/material.dart';
import 'package:eyav2/components/custom_surfix_icon.dart';
import 'package:eyav2/components/default_button.dart';
import 'package:eyav2/components/form_error.dart';
import 'package:eyav2/components/no_account_text.dart';
import 'package:eyav2/size_config.dart';
import '../../../constants.dart';
import 'package:eyav2/function/function.dart' as function;
import 'package:http/http.dart ' as http;

import '../../new/found_cars_list.dart';
class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: SingleChildScrollView(
        child: Padding(
          padding:
          EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              SizedBox(height: 30),
              //SizedBox(height: SizeConfig.screenHeight * 0.04),
              /* Text(
                "Forgot Password",
                style: TextStyle(
                  fontSize: getProportionateScreenWidth(28),
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),*/
              Text(
                "Veuillez entrer votre e-mail",
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 30),
              //  SizedBox(height: SizeConfig.screenHeight * 0.1),
              DeleteForm(),
            ],
          ),
        ),
      ),
    );
  }
}

class DeleteForm extends StatefulWidget {
  @override
  _DeleteFormState createState() => _DeleteFormState();
}

class _DeleteFormState extends State<DeleteForm> {
  final _formKey = GlobalKey<FormState>();
  List<String> errors = [];
  String? email;
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [

          TextFormField(
            keyboardType: TextInputType.emailAddress,
            onSaved: (newValue) => email = newValue,
            onChanged: (value) {
              if (value.isNotEmpty && errors.contains(kEmailNullError)) {
                setState(() {
                  errors.remove(kEmailNullError);
                });
              } else if (emailValidatorRegExp.hasMatch(value) &&
                  errors.contains(kInvalidEmailError)) {
                setState(() {
                  errors.remove(kInvalidEmailError);
                });
              }
              email=value;
            },
            validator: (value) {
              if (value!.isEmpty && !errors.contains(kEmailNullError)) {
                setState(() {
                  errors.add(kEmailNullError);
                });
              } else if (!emailValidatorRegExp.hasMatch(value) &&
                  !errors.contains(kInvalidEmailError)) {
                setState(() {
                  errors.add(kInvalidEmailError);
                });
              }
              return null;
            },
            decoration: InputDecoration(
              labelText: "Email",
              hintText: "Entrer votre Email",
              // If  you are using latest version of flutter then lable text and hint text shown like this
              // if you r using flutter less then 1.20.* then maybe this is not working properly
              floatingLabelBehavior: FloatingLabelBehavior.always,
              suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Mail.svg"),
            ),
          ),
          SizedBox(height: 30),
          FormError(errors: errors),
          // SizedBox(height: SizeConfig.screenHeight * 0.1),
          DefaultButton(
            text: "Demander",
            press: () {
              if (_formKey.currentState!.validate()) {
                print(email);
                showAlertDialog(context);
                Delete_(email!);
                //function.ResetPin(email!);
                //Navigator.push( context, MaterialPageRoute(builder: (context) => PinPasswordScreen(email:email!)));
              }
            },
          ),
          SizedBox(height: 30),
          //SizedBox(height: SizeConfig.screenHeight * 0.1),
         // NoAccountText(),
        ],
      ),
    );
  }


  showAlertDialog(BuildContext context){
    AlertDialog alert=AlertDialog(
      content: new Row(
        children: [
          CircularProgressIndicator(),
          Container(margin: EdgeInsets.only(left: 5),child:Text("Demande en cours ....." )),
        ],),
    );
    showDialog(barrierDismissible: false,
      context:context,
      builder:(BuildContext context){
        return alert;
      },
    );
  }

  void  Delete_(String email) async {
    try{
      var url = Uri.http('${Configuration.base_url}', 'apiv2/request-deletion');
      int status = 0;
      final response = await http.post(
          url,
          headers: {
            HttpHeaders.contentTypeHeader: 'application/json',
            HttpHeaders.acceptHeader: 'application/json',
          },
          body: json.encode({
            "email": email,
          })
      );
      print(response.statusCode);
      print(response.body);
      if (response.statusCode == 301) {
        final newUrl = response.headers['location'];
        if (newUrl != null) {
          // Make a new request to the new URL
          final newResponse = await http.post(Uri.parse(newUrl),
              headers: {
                HttpHeaders.contentTypeHeader: 'application/json',
                HttpHeaders.acceptHeader: 'application/json',
              },
              body: json.encode({
                "email": email,
              })
          );
          print(newResponse.body);
          print(newResponse.statusCode);
          if(newResponse.statusCode==200){
            Navigator.pop(context);
            showDialog(
              context: this.context,
              builder: (BuildContext ctx) {
                return AlertDialog(
                  title: Text("Demande de suppression"),
                  content: Text("Patientez pendant que nous traitons votre requête!", textAlign: TextAlign.center,),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(ctx);
                        Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()));
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
        }
      }
    }catch(e){
      print("erreur  :$e");
    }


  }

}
