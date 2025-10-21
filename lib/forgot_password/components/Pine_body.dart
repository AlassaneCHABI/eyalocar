
import 'package:eyav2/new/sign-in.dart';
import 'package:eyav2/sign_in/sign_in_screen.dart';
import 'package:flutter/material.dart';
import 'package:eyav2/components/custom_surfix_icon.dart';
import 'package:eyav2/components/default_button.dart';
import 'package:eyav2/components/form_error.dart';
import 'package:eyav2/components/no_account_text.dart';
import 'package:eyav2/size_config.dart';

import '../../../constants.dart';
import 'package:eyav2/function/function.dart' as function;


class PinBody extends StatefulWidget {
   final String email;
  const PinBody({super.key, required this.email,});
  @override
  State<StatefulWidget> createState() {
    return _PinBodyFormState();
  }
}

class _PinBodyFormState extends State<PinBody> {
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
             // SizedBox(height: SizeConfig.screenHeight * 0.04),
              /* Text(
                "Forgot Password",
                style: TextStyle(
                  fontSize: getProportionateScreenWidth(28),
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),*/
              Text(
                "Veuillez entrer le code que vous avez reçu\n dans le mail ci-dessous\n("+widget.email+")",
                textAlign: TextAlign.center,
              ),
             // SizedBox(height: SizeConfig.screenHeight * 0.1),
              ResetPassForm(email:widget.email),
            ],
          ),
        ),
      ),
    );
  }
}


class ResetPassForm extends StatefulWidget {
  final String email;
  const ResetPassForm({super.key, required this.email,});
  @override
  State<StatefulWidget> createState() {
    return _ResetPassFormFormState();
  }
}

class _ResetPassFormFormState extends State<ResetPassForm> {
  final _formKey = GlobalKey<FormState>();
  List<String> errors = [];
  String? password;
  String? confirmpassword;
  String? codepin;
  void addError({required String error}) {
    if (!errors.contains(error))
      setState(() {
        errors.add(error);
      });
  }

  void removeError({required String error}) {
    if (errors.contains(error))
      setState(() {
        errors.remove(error);
      });
  }
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          SizedBox(height: 30),
          TextFormField(
            obscureText: false,
            onSaved: (newValue) => codepin = newValue,
            onChanged: (value) {
              if (value.isNotEmpty) {
                removeError(error: kVilleNullError);
              }
              codepin = value;
            },
            validator: (value) {
              if (value!.isEmpty) {
                addError(error: kVilleNullError);
                return "";
              }
              return null;
            },
            decoration: InputDecoration(
              labelText: "Code ",
              hintText: "Entrer le code ",
              // If  you are using latest version of flutter then lable text and hint text shown like this
              // if you r using flutter less then 1.20.* then maybe this is not working properly
              floatingLabelBehavior: FloatingLabelBehavior.always,
              // suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
            ),
          ),
          SizedBox(height: 10,),

          TextFormField(
          obscureText: true,
          onSaved: (newValue) => password = newValue!,
          onChanged: (value) {
            if (value.isNotEmpty) {
              removeError(error: kPassNullError);
            } else if (value.length >= 8) {
              removeError(error: kShortPassError);
            }
            password=value;
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
            labelText: "Nouveau mot de passe",
            hintText: "Tapez votre mot de passe",
            // If  you are using latest version of flutter then lable text and hint text shown like this
            // if you r using flutter less then 1.20.* then maybe this is not working properly
            floatingLabelBehavior: FloatingLabelBehavior.always,
            suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Lock.svg"),
          ),
        ),

          SizedBox(height: 10,),

        TextFormField(
          obscureText: true,
          onSaved: (newValue) => confirmpassword = newValue!,
          onChanged: (value) {
            if (value.isNotEmpty) {
              removeError(error: kPassNullError);
            } else if (value.length >= 8) {
              removeError(error: kShortPassError);
            }
            confirmpassword=value;
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
            labelText: "Confirmer le mot de passe",
            hintText: "Tapez à nouveaau le mot de passe",
            // If  you are using latest version of flutter then lable text and hint text shown like this
            // if you r using flutter less then 1.20.* then maybe this is not working properly
            floatingLabelBehavior: FloatingLabelBehavior.always,
            suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Lock.svg"),
          ),
        ),

          SizedBox(height: 30),
          FormError(errors: errors),
          //SizedBox(height: SizeConfig.screenHeight * 0.1),
          DefaultButton(
            text: "Continuer",
            press: () {
              if (_formKey.currentState!.validate()) {
                print(widget.email);
                print(codepin);
                print(password);
                print(confirmpassword);
                if(password!=confirmpassword){
                  showDialog(
                    context: context,
                    builder: (BuildContext ctx) {
                      return AlertDialog(
                        title: Text("Erreur de mise à jour"),
                        content: Text("Les deux mots de passe doivent être identiques."),
                        actions: [
                          /*TextButton(
              onPressed: () => Navigator.pop(ctx, 'Fermer'),
              child: const Text('Fermer'),
            ),*/
                          TextButton(
                            onPressed: () => Navigator.pop(ctx, 'OK'),
                            child: const Text('OK'),
                            style: ButtonStyle(
                                elevation: MaterialStateProperty.all(15),
                                foregroundColor: MaterialStateProperty.all(Colors.white),
                                backgroundColor: MaterialStateProperty.all(kPrimaryColor),
                                shadowColor: MaterialStateProperty.all(kPrimaryColor),
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
                }else{
                  function.Update_Password(widget.email,codepin!,password!,confirmpassword!);
                  Navigator.push(context,
                      new MaterialPageRoute(builder: (ctxt) => new LoginScreen())
                  );
                }

              }
            },
          ),
          SizedBox(height: 30),
          //SizedBox(height: SizeConfig.screenHeight * 0.1),
          NoAccountText(),
        ],
      ),
    );
  }
}
