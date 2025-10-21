import 'dart:convert';
import 'dart:io';
import 'package:eyav2/Historique/H_paiement.dart';
import 'package:eyav2/Politique/confidentialite.dart';
import 'package:eyav2/Recherches/recherche.dart';

import 'package:eyav2/global_config.dart';
import 'package:eyav2/new/add_conductor.dart';
import 'package:eyav2/new/cooki.dart';
import 'package:eyav2/new/entry_screen.dart';
import 'package:eyav2/new/mention.dart';
import 'package:eyav2/new/privacy_policy.dart';
import 'package:eyav2/new/search_conductor.dart';
import 'package:eyav2/new/search_selector.dart';
import 'package:eyav2/new/sign-in.dart';
import 'package:eyav2/new/usage_policy.dart';
import 'package:eyav2/new/user_profile.dart';
import 'package:eyav2/parametre.dart';
import 'package:eyav2/profil/profil_ui.dart';
import 'package:eyav2/reservation/historique.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart ' as http;

class CustomDrawer extends StatefulWidget {
  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
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
    return Drawer(
      backgroundColor: Colors.white,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // En-tête du Drawer
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: Image.asset("assets/LOUEZ1.png",)
          ),

          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            child: Column(
              children: [
                buildDrawerItem(
                  svgPath: 'assets/icons/icon_coins.svg',
                  text: '$bonus points',
                  onTap: () {},
                ),
                buildDrawerItem(
                  svgPath: 'assets/icons/icon_home.svg',
                  text: 'Accueil',
                  onTap: () {
                    Navigator.pushAndRemoveUntil(context,
                        new MaterialPageRoute(builder: (ctxt) => EntryScreen()),
                            (route) => false
                    );
                  },
                ),
                buildDrawerItem(
                  svgPath: 'assets/icons/icon_search.svg',
                  text: 'Recherches',
                  onTap: () async{
                    // SharedPreferences prefs = await SharedPreferences.getInstance();
                    //prefs.remove("email");
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    String? token= prefs.getString("token");
                    Navigator.push(context,
                         MaterialPageRoute(builder: (ctxt) =>  SearchSelector(token:token!)),
                    );
                  },
                ),
                buildDrawerItem(
                  svgPath: 'assets/icons/icon_car.svg',
                  text: 'Se faire conduire',
                  onTap: () {
                    Navigator.push(context,
                      MaterialPageRoute(builder: (ctxt) =>  SearchConductorScreen(
                      )),
                    );
                  },
                ),
                buildDrawerItem(
                  svgPath: 'assets/icons/icon_drive.svg',
                  text: 'Conduire',
                  onTap: () {
                    Navigator.push(context,
                         MaterialPageRoute(builder: (ctxt) =>  AddConductorScreen(
                        )),
                    );
                  },
                ),
                // buildDrawerItem(
                //   svgPath: 'assets/icons/icon_socials.svg',
                //   text: 'Intégrer',
                //   onTap: () {},
                // ),
                buildDrawerItem(
                  svgPath: 'assets/icons/icon_finance.svg',
                  text: 'Réservations',
                  onTap: () async{
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    String? token= prefs.getString("token");
                    Navigator.push(context,
                         MaterialPageRoute(builder: (ctxt) =>  HistoriqueListingWidget(token:token!
                        )),
                    );
                  },
                ),
                buildDrawerItem(
                  svgPath: 'assets/icons/icon_dollar_sign.svg',
                  text: 'Paiements',
                  onTap: () async {
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    String? token= prefs.getString("token");
                    Navigator.push(context,
                         MaterialPageRoute(builder: (ctxt) =>  Liste_paiement(token:token!
                        )),
                    );
                  },
                ),
                buildDrawerItem(
                  svgPath: 'assets/icons/settings.svg',
                  text: 'Paramètres du compte',
                  onTap: () {
                    /*Navigator.push(context,
                         MaterialPageRoute(builder: (ctxt) => AuthUserProfile(
                        )),
                    );*/
                    Navigator.push(context,
                         MaterialPageRoute(builder: (ctxt) => setting(
                        )),
                    );
                  },
                ),

                buildDrawerItem(
                  svgPath: 'assets/icons/icon_info.svg',
                  text: "Politique d'utilisation",
                  onTap: () {
                    Navigator.push(context,
                      MaterialPageRoute(builder: (ctxt) => UsagePolicy(
                      )),
                    );
                  },
                ),
                buildDrawerItem(
                  svgPath: 'assets/icons/icon_info.svg',
                  text: "Confidentialité",
                  onTap: () {
                    Navigator.push(context,
                      MaterialPageRoute(builder: (ctxt) => PrivacyPolicy(
                      )),
                    );
                  },
                ),
                buildDrawerItem(
                  svgPath: 'assets/icons/icon_info.svg',
                  text: "Politique de cookies",
                  onTap: () {
                    Navigator.push(context,
                      MaterialPageRoute(builder: (ctxt) => Cooki(
                      )),
                    );
                  },
                ),
                buildDrawerItem(
                  svgPath: 'assets/icons/icon_info.svg',
                  text: "Mentions légales et CGU",
                  onTap: () {
                    Navigator.push(context,
                      MaterialPageRoute(builder: (ctxt) => Mention(
                      )),
                    );
                  },
                ),
                buildDrawerItem(
                  svgPath: 'assets/icons/icon_contact.svg',
                  text: 'Contactez-nous',
                  onTap: () {
                    openWhatsAppWithMessage('Bonjour Eyalocar!', '22952479595');
                  },
                ),
                buildDrawerItem(
                  svgPath: 'assets/icons/icon_logout.svg',
                  text: 'Déconnexion',
                  onTap: () async {
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    prefs.remove("email");
                    Navigator.pushAndRemoveUntil(context,
                         MaterialPageRoute(builder: (ctxt) => LoginScreen()),(route) => false
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem({required String svgPath, required String text, required GestureTapCallback onTap}) {
    return ListTile(
      leading: SvgPicture.asset(
        svgPath,
        width: 20,
        height: 20,
        color: Color(0xFF0EA000),
      ),
      title: Text(
        text,
        style: TextStyle(fontFamily: "Ubuntu", fontSize: 18),
      ),
      onTap: onTap,
    );
  }

  Widget buildDrawerItem({required String svgPath, required String text, required GestureTapCallback onTap}) {
    return InkWell(
      splashColor: Color(0xFFD9FFD9),
      child: Container(
        height: 50,
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Row(
            children: <Widget>[
              SvgPicture.asset(
                svgPath,
                width: 20,
                height: 20,
                color: Color(0xFF0EA000),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
              ),
              Text(
                text,
                style: TextStyle(fontFamily: "Ubuntu", fontSize: 18),
              ),
            ],

        ),
      ),
      onTap: onTap,
    );
  }
}
