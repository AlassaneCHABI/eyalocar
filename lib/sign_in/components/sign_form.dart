
import 'package:eyav2/function/function.dart';
import 'package:eyav2/modeles/Categorie.dart';
import 'package:eyav2/modeles/Voiture.dart';
import 'package:eyav2/pages/home_page.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:eyav2/components/custom_surfix_icon.dart';
import 'package:eyav2/components/form_error.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../components/default_button.dart';
import '../../../constants.dart';
import '../../../size_config.dart';
import '../../forgot_password/forgot_password_screen.dart';


class SignForm extends StatefulWidget {
  @override
  _SignFormState createState() => _SignFormState();
}

class _SignFormState extends State<SignForm> {
  final _formKey = GlobalKey<FormState>();
  late String email;
  late String password;
  late bool remember = false;
  String message="Email ou mot de passe invalide";
  bool status=false;
  int status_value=0;
  final List<String> errors = [];
  bool passwordVisible = true;
  //List<Users> user = [] ;

  void addError({required String error}) {
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
  final List<Category> liste_categorie = [];

  late String user_token;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    requestPermission();
    getToken();

   /* FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance; // Change here
    _firebaseMessaging.getToken().then((token){
      print("token is $token");
      print("fin");
    });
    */

    print("Les categories");
    getCategorie().then((value){
      if(value!=null){
        setState(() {
          liste_categorie.addAll(value);
        });
      }
      print(liste_categorie.length);
    });
  }


  void requestPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings =await messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        sound: true
    );
    if(settings.authorizationStatus ==AuthorizationStatus.authorized){
      print("user granted permission");
    }
    else if(settings.authorizationStatus==AuthorizationStatus.provisional){
      print("User granted provisional permission");
    }
    else{
      print("user declined  or has  not accepted permission");
    }
  }

  void getToken() async {
    await FirebaseMessaging.instance.getToken().then(
            (token){
          setState(() {
            user_token= token!;
            print("My token is $user_token");
          });
          // saveToken(user_token);
        }
    );
  }


  showAlertDialog(BuildContext context){
    AlertDialog alert=AlertDialog(
      content: new Row(
        children: [
          CircularProgressIndicator(),
          Container(margin: EdgeInsets.only(left: 5),child:Text("Veuillez patienter...." )),
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
    return Form(
      key: _formKey,
      child: Column(
        children: [
          status?Text(message,style: TextStyle(color: Colors.red),):Text(""),
          buildEmailFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildPasswordFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          Row(
            children: [
             // Checkbox(
                //value: remember,
                //activeColor: kPrimaryColor,
                //onChanged: (value) {
                  //setState(() {
                    //remember = value;
                  //});
                //},
              //),
             // Text("Remember me"),
              Spacer(),
              GestureDetector(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ForgotPasswordScreen()));
                },
                child: Text(
                  "Mot de passe oublié",
                  style: TextStyle(decoration: TextDecoration.underline),
                ),
              )
            ],
          ),
          FormError(errors: errors),
          SizedBox(height: getProportionateScreenHeight(20)),
          DefaultButton(
            text: "Continuer",
            press: () {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                 print("start");
                showAlertDialog(context);
                 login(email, password,user_token).then((value) async {
                   try{
                     print(value[0].email);
                     SharedPreferences prefs = await SharedPreferences.getInstance();
                     prefs.setInt('id',value[0].id );
                     prefs.setString('username',value[0].username );
                     prefs.setString('lastname',value[0].lastname );
                     prefs.setString('firstname',value[0].firstname );
                     prefs.setString('city',value[0].city );
                     prefs.setString('address',value[0].address );
                     prefs.setString('type_identifier',value[0].type_identifier );
                     prefs.setString('identifier',value[0].identifier );
                     prefs.setString('email',value[0].email );
                     prefs.setString('token',value[0].token );
                     prefs.setInt('bonus',value[0].bonus );
                     prefs.setString('bonus_expiration',value[0].bonus_expiration );
                     print("end");
                     Navigator.push(context,
                         new MaterialPageRoute(builder: (ctxt) => new HomePage())
                     );
                    // Navigator.pushNamed(context, HomeScreen.routeName);
                   }catch(e){
                     print(e);
                     setState(() {
                       status=true;
                     });
                     Navigator.pop(context);

                   }
                 });
              }
            },
          ),
        ],
      ),
    );
  }

  TextFormField buildPasswordFormField() {
    return TextFormField(
      obscureText: passwordVisible,
      onSaved: (newValue) => password = newValue!,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kPassNullError);
        } else if (value.length >= 8) {
          removeError(error: kShortPassError);
        }
        return null;
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
        //labelText: "Mot de passe",
        hintText: "Entrez votre mot de passe",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
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
        ),      ),
    );
  }

  TextFormField buildEmailFormField() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      onSaved: (newValue) => email = newValue!,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kEmailNullError);
        } else if (emailValidatorRegExp.hasMatch(value)) {
          removeError(error: kInvalidEmailError);
        }
        return null;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: kEmailNullError);
          return "";
        } /*else if (!emailValidatorRegExp.hasMatch(value)) {
          addError(error: kInvalidEmailError);
          return "";
        }*/
        return null;
      },
      decoration: InputDecoration(
        //labelText: "Email",
        hintText: "Entrez votre Email",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Mail.svg"),
      ),
    );
  }
}
