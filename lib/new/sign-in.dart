import 'package:eyav2/components/form_error.dart';
import 'package:eyav2/constants.dart';
import 'package:eyav2/forgot_password/forgot_password_screen.dart';
import 'package:eyav2/function/function.dart';
import 'package:eyav2/modeles/Categorie.dart';
import 'package:eyav2/new/entry_screen.dart';
import 'package:eyav2/new/sign-up.dart';
import 'package:eyav2/pages/home_page.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  bool _isChecked = false;

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
    getCategorie().then((value) {
      if (value != null) {
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
    await FirebaseMessaging.instance.getToken().then((token) {
      setState(() {
        user_token = token!;
      });
      print("My token is $user_token");
    });
    // saveToken(user_token);
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
    var size = MediaQuery.of(context).size;
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
              ),  /* EdgeInsets.symmetric(horizontal: 50, vertical: 50),*/
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 50),
                    Image.asset('assets/logo-4x.png', height: 100),
                    const SizedBox(height: 50),
                    const Text(
                      'Connexion',
                      style: TextStyle(
                        fontFamily: 'Ubuntu',
                        fontSize: 28,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: [
                          _buildEmailTextField(),
                          const SizedBox(height: 20),
                          _buildPasswordTextField(),
                          const SizedBox(height: 20),
                          Column(
                            children: [
                              Row(
                                children: [
                                  Checkbox(
                                    value: _isChecked,
                                    onChanged: (value) {
                                      setState(() {
                                        _isChecked = value ?? false;
                                      });
                                    },
                                    activeColor: Color(0xFFE5A000),
                                  ),
                                  const Expanded(
                                    child: Text(
                                      'Je ne suis pas un robot',
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  SizedBox(width: 45,),
                                  Expanded(child: Text("Confirmez que vous n'êtes pas un programme.", softWrap: true, style: TextStyle(color: Colors.grey),))
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed:
                              // isTokenAvailable ?
                              () {
                                  if (_formKey.currentState!.validate()) {
                                    if (!_isChecked) {
                                      // Si la case n'est pas cochée, afficher un message
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text("Veuillez confirmer que vous n'êtes pas un robot."),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                    } else {
                                        _formKey.currentState!.save();
                                        print("start");
                                        showAlertDialog(context);
                                        login(email, password, user_token).then((
                                        value) async {
                                          try {
                                            print(value[0].email);
                                            SharedPreferences prefs = await SharedPreferences
                                                .getInstance();
                                            prefs.setInt('id', value[0].id);
                                            prefs.setString(
                                              'username', value[0].username);
                                            prefs.setString(
                                              'lastname', value[0].lastname);
                                            prefs.setString(
                                              'firstname', value[0].firstname);
                                            prefs.setString(
                                              'city', value[0].city);
                                            prefs.setString(
                                              'address', value[0].address);
                                            prefs.setString('type_identifier',
                                              value[0].type_identifier);
                                            prefs.setString('identifier',
                                              value[0].identifier);
                                            prefs.setString(
                                              'email', value[0].email);
                                            prefs.setString(
                                              'token', value[0].token);
                                            prefs.setInt('bonus', value[0].bonus);
                                            prefs.setString('bonus_expiration',
                                              value[0].bonus_expiration);
                                            print("end");
                                            Navigator.push(context,
                                              new MaterialPageRoute(builder: (
                                              ctxt) => EntryScreen())
                                            );
                                            // Navigator.pushNamed(context, HomeScreen.routeName);
                                          } catch (e) {
                                              print(e);
                                              setState(() {
                                                status = true;
                                              });
                                              Navigator.pop(context);
                                            }
                                          });
                                        }
                                    }

                                }
                              // : null
                              ,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFFE5A000),
                                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text('Se connecter', style: TextStyle(color: Colors.black),),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterScreen()));
                      },
                      child: const Text(
                        'Créer mon compte',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    SizedBox(height: 10,),
                    GestureDetector(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => ForgotPasswordScreen()));
                      },
                      child: Text(
                        "Mot de passe oublié ?",
                        style: TextStyle(decoration: TextDecoration.underline,color: Colors.white),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
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
