import 'dart:convert';
import 'dart:io';

import 'package:eyav2/Politique/confidentialite.dart';
import 'package:eyav2/Politique/politique.dart';
import 'package:eyav2/Recherche_conducteur/Recherche.dart';
import 'package:eyav2/Recherches/recherche.dart';
import 'package:eyav2/pages/home_page.dart';
import 'package:eyav2/parametre.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../AjoutConducteur/Ajout_conducteur.dart';
import '../Historique/H_paiement.dart';
import '../global_config.dart';
import '../profil/profil_ui.dart';
import '../reservation/historique.dart';
import '../sign_in/sign_in_screen.dart';
import 'package:http/http.dart ' as http;

class DrawerMenuWidget extends StatefulWidget {
  const DrawerMenuWidget({Key? key}) : super(key: key);

  @override
  State<DrawerMenuWidget> createState() => _DrawerMenuWidgetState();
}

class _DrawerMenuWidgetState extends State<DrawerMenuWidget> {

  late int bonus =0;
  _launchURL(String link) async {
    var url = link;
    await launchUrl(Uri.parse(url));
  }

  void openWhatsAppWithMessage(String message, String phoneNumber) async {
    String url = 'https://wa.me/$phoneNumber?text=${Uri.encodeFull(message)}';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }

  }

  Future<void>  getBonus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token= prefs.getString("token");
    var url = Uri.http('${Configuration.base_url}', 'apiv2/auth/profile');
    final response = await http.post(
      url,
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.acceptHeader: 'application/json',
        HttpHeaders.authorizationHeader:'Bearer $token'
      },
    );
    print("le token $token");
    print(response.statusCode);
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
        );
        print(newResponse.statusCode);
        print(newResponse.body);
        // Utiliser json.decode pour obtenir une carte (Map<String, dynamic>)
        Map<String, dynamic> responseBodyMap = json.decode(newResponse.body);

        setState(() {
          bonus = responseBodyMap['bonus'];
          prefs.setInt("bonus",bonus);
        });
        prefs.setInt("bonus",bonus);
        print("Voici le bonus $bonus");


      }
    }else if(response.statusCode == 200){
      print(response.statusCode);
      print(response.body);
      Map<String, dynamic> responseBodyMap = json.decode(response.body);

      setState(() {
        bonus = responseBodyMap['bonus'];
        prefs.setInt("bonus",bonus);
      });
      prefs.setInt("bonus",bonus);
      print("Voici le bonus $bonus");


    }

  }

  @override
  void initState() {
    super.initState();
    getBonus();
    print("test");
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Drawer(
        child: ListView(
          children: <Widget>[
            DrawerHeader(
                decoration: BoxDecoration(
                    gradient: LinearGradient(colors: <Color>[
                      Colors.white,
                      Colors.white,
                    ])
                ),
                child:
                        Container(
                            child: Image.asset("assets/LOUEZ1.png",)
                        )
                      //Text('EYALOCAR', style: TextStyle(color: Colors.white, fontSize: 25.0),)
                ),
            Container(
              padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
              /*decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.grey.shade400))
              ),*/
              child: InkWell(
                  splashColor: Colors.orangeAccent,
                  child: Container(
                      height: 40,
                      child: Row(
                        mainAxisAlignment : MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(children: <Widget>[
                            Icon(Icons.shopping_cart),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                            ),
                            Text("$bonus points", style: TextStyle(
                                fontSize: 16
                            ),),
                          ],),

                        ],)
                  )
              ),
            ),

            Container(
              padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
              /*decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.grey.shade400))
              ),*/
              child: InkWell(
                  splashColor: Colors.orangeAccent,
                  onTap: (){
                    Navigator.pushAndRemoveUntil(context,
                        new MaterialPageRoute(builder: (ctxt) => new HomePage()),
                            (route) => false
                    );
                  },
                  child: Container(
                      height: 40,
                      child: Row(
                        mainAxisAlignment : MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(children: <Widget>[
                            Icon(Icons.home),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                            ),
                            Text("Accueil", style: TextStyle(
                                fontSize: 16
                            ),),
                          ],),

                        ],)
                  )
              ),
            ),
            SizedBox(height: 10,),
            Container(
              padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
              /*decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey.shade400))
              ),*/
              child: InkWell(
                  splashColor: Colors.orangeAccent,
                  onTap: () async {
                    // SharedPreferences prefs = await SharedPreferences.getInstance();
                    //prefs.remove("email");
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    String? token= prefs.getString("token");
                    Navigator.pushAndRemoveUntil(context,
                        new MaterialPageRoute(builder: (ctxt) => new Recherche(token:token!)),
                            (route) => false
                    );
                  },
                  child: Container(
                      height: 40,
                      child: Row(
                        mainAxisAlignment : MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(children: <Widget>[
                            Icon(Icons.search),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                            ),
                            Text("Recherches ", style: TextStyle(
                                fontSize: 16
                            ),),
                          ],),
                          // Icon(Icons.arrow_right)
                        ],)
                  )
              ),
            ),
              /*SizedBox(height: 10,),
                     Container(
                        padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
                        /*decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey.shade400))
              ),*/
              child: InkWell(
                  splashColor: Colors.orangeAccent,
                  onTap: () async {
                    // SharedPreferences prefs = await SharedPreferences.getInstance();
                    //prefs.remove("email");
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    String? token= prefs.getString("token");
                    Navigator.pushAndRemoveUntil(context,
                        new MaterialPageRoute(builder: (ctxt) => new CarsListingWidget(token:token!)),
                            (route) => false
                    );
                  },
                  child: Container(
                      height: 40,
                      child: Row(
                        mainAxisAlignment : MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(children: <Widget>[
                            Icon(Icons.search),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                            ),
                            Text("Mes recherches de voiture", style: TextStyle(
                                fontSize: 16
                            ),),
                          ],),
                          // Icon(Icons.arrow_right)
                        ],)
                  )
              ),
            ),
            SizedBox(height: 10,),
            Container(
              padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
              /*decoration: BoxDecoration(
    border: Border(bottom: BorderSide(color: Colors.grey.shade400))
    ),*/
              child: InkWell(
                  splashColor: Colors.orangeAccent,
                  onTap: () async {
                    // SharedPreferences prefs = await SharedPreferences.getInstance();
                    //prefs.remove("email");
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    String? token= prefs.getString("token");
                    Navigator.pushAndRemoveUntil(context,
                        new MaterialPageRoute(builder: (ctxt) => new R_conducteurListingWidget(token:token!)),
                            (route) => false
                    );
                  },
                  child: Container(
                      height: 40,
                      child: Row(
                        mainAxisAlignment : MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(children: <Widget>[
                            Icon(Icons.search),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                            ),
                            Text("Mes recherches de conducteur", style: TextStyle(
                                fontSize: 16
                            ),),
                          ],),
                          // Icon(Icons.arrow_right)
                        ],)
                  )
              ),
            ),
            */
            SizedBox(height: 10,),
          /*  Container(
              padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
              /*decoration: BoxDecoration(
    border: Border(bottom: BorderSide(color: Colors.grey.shade400))
    ),*/
              child: InkWell(
                  splashColor: Colors.orangeAccent,
                  onTap: () async {
                    // SharedPreferences prefs = await SharedPreferences.getInstance();
                    //prefs.remove("email");
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    String? token= prefs.getString("token");
                    print(token);
                    Navigator.pushAndRemoveUntil(context,
                        new MaterialPageRoute(builder: (ctxt) => new HistoriqueListingWidget(token:token!)),
                            (route) => false
                    );
                  },
                  child: Container(
                      height: 40,
                      child: Row(
                        mainAxisAlignment : MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(children: <Widget>[
                            Icon(Icons.history_edu),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                            ),
                            Text("Mes réservations", style: TextStyle(
                                fontSize: 16
                            ),),
                          ],),
                          // Icon(Icons.arrow_right)
                        ],)
                  )
              ),
            ),
            */
           // SizedBox(height: 10,),

           /* Container(
              padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
              /*decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.grey.shade400))
              ),*/
              child: InkWell(
                  splashColor: Colors.orangeAccent,
                  onTap: () async {
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    String? token= prefs.getString("token");
                    Navigator.pushAndRemoveUntil(context,
                        new MaterialPageRoute(builder: (ctxt) => new Liste_paiement(
                          token: token!,
                        )),(route) => false
                    );
                  },

                  child: Container(
                      height: 40,
                      child: Row(
                        mainAxisAlignment : MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(children: <Widget>[
                            Icon(Icons.monetization_on_outlined),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                            ),
                            Text("Mes paiements", style: TextStyle(
                                fontSize: 16
                            ),),
                          ],),
                          // Icon(Icons.arrow_right)
                        ],)
                  )
              ),
            ),*/
           // SizedBox(height: 10,),
            Container(
              padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
              /*decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.grey.shade400))
              ),*/
              child: InkWell(
                  splashColor: Colors.orangeAccent,
                  onTap: (){
                    /*Navigator.pushAndRemoveUntil(context,
                        new MaterialPageRoute(builder: (ctxt) => new ListeConducteur(
                        )),(route) => false
                    );
                    */
                    Navigator.pushAndRemoveUntil(context,
                        new MaterialPageRoute(builder: (ctxt) => new RechercheConducteurScreen(
                        )),(route) => false
                    );
                  },

                  child: Container(
                      height: 40,
                      child: Row(
                        mainAxisAlignment : MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(children: <Widget>[
                            Icon(Icons.drive_eta),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                            ),
                            Text("Se faire conduire", style: TextStyle(
                                fontSize: 16
                            ),),
                          ],),
                          // Icon(Icons.arrow_right)
                        ],)
                  )
              ),
            ),
            SizedBox(height: 10,),
            Container(
              padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
              /*decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.grey.shade400))
              ),*/
              child: InkWell(
                  splashColor: Colors.orangeAccent,
                  onTap: (){
                    Navigator.pushAndRemoveUntil(context,
                        new MaterialPageRoute(builder: (ctxt) => new AjoutConducteurScreen(
                        )),(route) => false
                    );
                  },

                  child: Container(
                      height: 40,
                      child: Row(
                        mainAxisAlignment : MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(children: <Widget>[
                            Icon(Icons.add_to_drive),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                            ),
                            Text("Conduire", style: TextStyle(
                                fontSize: 16
                            ),),
                          ],),
                          // Icon(Icons.arrow_right)
                        ],)
                  )
              ),
            ),
            SizedBox(height: 10,),
            Container(
              padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
              /*decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.grey.shade400))
              ),*/
              child: InkWell(
                  splashColor: Colors.orangeAccent,
                  onTap: () async {
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    String? token= prefs.getString("token");
                    Navigator.pushAndRemoveUntil(context,
                        new MaterialPageRoute(builder: (ctxt) => new HistoriqueListingWidget(token:token!
                        )),(route) => false
                    );
                  },

                  child: Container(
                      height: 40,
                      child: Row(
                        mainAxisAlignment : MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(children: <Widget>[
                            Icon(Icons.library_books),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                            ),
                            Text("Réservations et paiements", style: TextStyle(
                                fontSize: 16
                            ),),
                          ],),
                          // Icon(Icons.arrow_right)
                        ],)
                  )
              ),
            ),
            SizedBox(height: 10,),
            Container(
              padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
              /*decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.grey.shade400))
              ),*/
              child: InkWell(
                  splashColor: Colors.orangeAccent,
                  onTap: () async {
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    String? token= prefs.getString("token");
                    Navigator.pushAndRemoveUntil(context,
                        new MaterialPageRoute(builder: (ctxt) => new Liste_paiement(token:token!
                        )),(route) => false
                    );
                  },

                  child: Container(
                      height: 40,
                      child: Row(
                        mainAxisAlignment : MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(children: <Widget>[
                            Icon(Icons.monetization_on_outlined),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                            ),
                            Text("Paiements", style: TextStyle(
                                fontSize: 16
                            ),),
                          ],),
                          // Icon(Icons.arrow_right)
                        ],)
                  )
              ),
            ),

            SizedBox(height: 10,),
            Container(
              padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
              /*decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.grey.shade400))
              ),*/
              child: InkWell(
                  splashColor: Colors.orangeAccent,
                  onTap: (){
                    /*Navigator.pushAndRemoveUntil(context,
                        new MaterialPageRoute(builder: (ctxt) => new ProfilUI(
                        )),(route) => false
                    );*/

                    Navigator.pushAndRemoveUntil(context,
                        new MaterialPageRoute(builder: (ctxt) => new setting(
                        )),(route) => false
                    );
                  },

                  child: Container(
                      height: 40,
                      child: Row(
                        mainAxisAlignment : MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(children: <Widget>[
                            Icon(Icons.person),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                            ),
                            Text("Paramètres du compte", style: TextStyle(
                                fontSize: 16
                            ),),
                          ],),
                          // Icon(Icons.arrow_right)
                        ],)
                  )
              ),
            ),
           // SizedBox(height: 10,),
            /*Container(
              padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
              /*decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.grey.shade400))
              ),*/
              child: InkWell(
                  splashColor: Colors.orangeAccent,
                  onTap: (){
                    _launchURL("${Configuration.base_url_}/about");
                  },

                  child: Container(
                      height: 40,
                      child: Row(
                        mainAxisAlignment : MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(children: <Widget>[
                            Icon(Icons.info_rounded),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                            ),
                            Text("A propos", style: TextStyle(
                                fontSize: 16
                            ),),
                          ],),
                          // Icon(Icons.arrow_right)
                        ],)
                  )
              ),
            ),*/

            SizedBox(height: 10,),
            Container(
              padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
              /*decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.grey.shade400))
              ),*/
              child: InkWell(
                  splashColor: Colors.orangeAccent,
                  onTap: (){
                    Navigator.pushAndRemoveUntil(context,
                        new MaterialPageRoute(builder: (ctxt) => new Politique(
                        )),(route) => false
                    );
                   // _launchURL("${Configuration.base_url_}/politique-de-confidentialite");
                  },

                  child: Container(
                      height: 40,
                      child: Row(
                        mainAxisAlignment : MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(children: <Widget>[
                            Icon(Icons.info_outline),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                            ),
                            Text("Politique d'utilisation", style: TextStyle(
                                fontSize: 16
                            ),),
                          ],),
                          // Icon(Icons.arrow_right)
                        ],)
                  )
              ),
            ),
            SizedBox(height: 10,),
            Container(
              padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
              /*decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.grey.shade400))
              ),*/
              child: InkWell(
                  splashColor: Colors.orangeAccent,
                  onTap: (){
                    Navigator.pushAndRemoveUntil(context,
                        new MaterialPageRoute(builder: (ctxt) => new Confidentialite(
                        )),(route) => false
                    );
                   // _launchURL("${Configuration.base_url_}/politique-de-confidentialite");
                  },

                  child: Container(
                      height: 40,
                      child: Row(
                        mainAxisAlignment : MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(children: <Widget>[
                            Icon(Icons.info_outline),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                            ),
                            Text("Politique de confidentialité", style: TextStyle(
                                fontSize: 16
                            ),),
                          ],),
                          // Icon(Icons.arrow_right)
                        ],)
                  )
              ),
            ),
            SizedBox(height: 10,),
            Container(
              padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
              /*decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.grey.shade400))
              ),*/
              child: InkWell(
                  splashColor: Colors.orangeAccent,
                  onTap: (){
                    openWhatsAppWithMessage('Bonjour Eyalocar!', '22952479595');
                  },

                  child: Container(
                      height: 40,
                      child: Row(
                        mainAxisAlignment : MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(children: <Widget>[
                            Icon(Icons.phone),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                            ),
                            Text("Contactez le support", style: TextStyle(
                                fontSize: 16
                            ),),
                          ],),
                          // Icon(Icons.arrow_right)
                        ],)
                  )
              ),
            ),
            SizedBox(height: 10,),
            Container(
              padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
              /*decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.grey.shade400))
              ),*/
              child: InkWell(
                  splashColor: Colors.orangeAccent,
                  onTap: () async {
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    prefs.remove("email");
                    Navigator.pushAndRemoveUntil(context,
                        new MaterialPageRoute(builder: (ctxt) => new SignInScreen()),(route) => false
                    );
                  },
                  child: Container(
                      height: 40,
                      child: Row(
                        mainAxisAlignment : MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(children: <Widget>[
                            Icon(Icons.logout),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                            ),
                            Text("Déconnexion", style: TextStyle(
                                fontSize: 16
                            ),),
                          ],),
                          // Icon(Icons.arrow_right)
                        ],)
                  )
              ),
            ),
          ],
        ),
      ),
    );
  }
}
