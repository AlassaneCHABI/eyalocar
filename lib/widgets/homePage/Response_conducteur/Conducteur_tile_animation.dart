
import 'dart:convert';
import 'dart:io';

import 'package:animations/animations.dart';
import 'package:eyav2/app_theme.dart';
import 'package:eyav2/components/default_button.dart';
import 'package:eyav2/constants.dart';
import 'package:eyav2/global_config.dart';
import 'package:eyav2/modeles/Categorie.dart';
import 'package:eyav2/modeles/Conducteur_reponse.dart';
import 'package:eyav2/modeles/Voiture.dart';
import 'package:eyav2/reservation/reserver.dart';
import 'package:eyav2/widgets/homePage/Conducteur_request/All_request_conducteur.dart';
import 'package:eyav2/widgets/homePage/Response_conducteur/detail_conduteur.dart';
import 'package:eyav2/widgets/homePage/Voitures/All_cars.dart';
import 'package:eyav2/widgets/homePage/Voitures/Vehicule_by_categorie.dart';
import 'package:eyav2/widgets/homePage/Voitures/detail.dart';
import 'package:eyav2/widgets/homePage/Voitures/details_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart ' as http;

class ConducteurTileResponseAnimation extends StatelessWidget {
  final int itemNo;
  final Conducteur_reponse conducteur;

  const ConducteurTileResponseAnimation({this.itemNo = 0, required this.conducteur});

  @override
  Widget build(BuildContext context) {
    ContainerTransitionType _transitionType = ContainerTransitionType.fade;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: OpenContainer<bool>(
        transitionType: _transitionType,
        openBuilder: (BuildContext _, VoidCallback openContainer) {
          return detail_conducteur(conducteur: conducteur) ;
        },
        closedElevation: 0.0,
        closedBuilder: (BuildContext _, VoidCallback openContainer) {
          return Card(
            elevation: 4,

            child:Column(
              //mainAxisSize: MainAxisSize.max,
              children: [
            ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child:
                Container(
                  height: 200,
                  width: 350,
                  child: Image.network(
                    "${Configuration.base_url_mage}/Driver_${conducteur.id}/${conducteur.driver_photo}.jpg",
                    fit: BoxFit.cover,
                  ),
                ),),
                 SizedBox(height: 8,),
                Container(
                  child:Align(
                    alignment: Alignment.centerLeft,
                    child:Text(
                        "  Nom : "+ conducteur.driver_lastname,
                        style: TextStyle(fontSize: 15)//AppTheme.of(context).bodyText1,

                    ),
                  )

                ),
                SizedBox(height: 8,),
                Container(
                  child:Align(
                    alignment: Alignment.centerLeft,
                    child:Text(
                        "  Prénom : "+ conducteur.driver_firstname,
                        style: TextStyle(fontSize: 15)//AppTheme.of(context).bodyText1,

                    )
                  )

                ),
                SizedBox(height: 8,),
                Container(
                  child:Align(
                    alignment: Alignment.centerLeft,
                    child:Text(
                        "  Type de permis : "+ conducteur.driver_type,
                        style: TextStyle(fontSize: 15)//AppTheme.of(context).bodyText1,

                    ),
                  )

                ),
                SizedBox(height: 8,),
                Container(
                  child:Align(
                    alignment: Alignment.centerLeft,
                    child:Text(
                        "  Ville : "+ conducteur.driver_city,
                        style: TextStyle(fontSize: 15)//AppTheme.of(context).bodyText1,

                    ),
                  )
                ),

                SizedBox(height: 10,),
                conducteur.status=="not reserved"? Container(
                  width: 320,
                  child:Row(children:[ Align(
                      alignment: Alignment.centerLeft,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.resolveWith<Color>(
                                (Set<MaterialState> states) {
                              if (states.contains(MaterialState.pressed)) {
                                return Colors.red; // Color when button is pressed
                              }
                              return kPrimaryColor; // Default color
                            },
                          ),
                          foregroundColor: MaterialStateProperty.all<Color>(Colors.white), // Text color
                        ),
                       child: Text("RESERVER"),
                      onPressed: () async {

                          SharedPreferences prefs = await SharedPreferences.getInstance();
                          String? token= prefs.getString("token");
                          var url = Uri.http('${Configuration.base_url}', 'apiv2/update-rrdrivers');
                          // List<Voitures> voitures = [];
                          final response = await http.post(
                              url,
                              headers: {
                                HttpHeaders.contentTypeHeader: 'application/json',
                                HttpHeaders.acceptHeader: 'application/json',
                                HttpHeaders.authorizationHeader:'Bearer $token'
                              },
                              body: json.encode({
                                "rrdriver_id": conducteur.rrdriver_id,
                              })
                          );
                          print(response.body);
                          print(response.statusCode);

                          if(response.statusCode == 200){
                            showDialog(
                              context: context,
                              builder: (BuildContext ctx) {
                                return AlertDialog(
                                  title: Text("Demande"),
                                  content: Text("Votre demande a été envoyée avec succès.", textAlign: TextAlign.center,),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(ctx);
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => R_conducteurListingWidget(token:token!)));
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
                                  "rrdriver_id": conducteur.rrdriver_id
                                  })
                              );

                              print(newResponse.body);
                              print(newResponse.statusCode);
                              // List<dynamic> body = json.decode(newResponse.body);
                            }

                            showDialog(
                              context: context,
                              builder: (BuildContext ctx) {
                                return AlertDialog(
                                  title: Text("Demande"),
                                  content: Text("Votre demande a été envoyée avec succès.", textAlign: TextAlign.center,),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(ctx);
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => R_conducteurListingWidget(token:token!)));
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
                          else{
                            showDialog(
                              context: context,
                              builder: (BuildContext ctx) {
                                return AlertDialog(
                                  title: Text("Echec"),
                                  content: Text("Votre reservation n'a pas été envoyée.Veuillez vérifier votre connexion internet avant de relancer la reservation", textAlign: TextAlign.center,),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(ctx);
                                        //Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
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
                                    'assets/images/warning_img.png',
                                    width: 80,
                                    height: 80,
                                  ),
                                );
                              },
                            );
                          }
                          //return voitures;

                        /*Navigator.push(context,
                            new MaterialPageRoute(builder: (ctxt) => new Reserver(voiture: voiture))
                        );*/
                      },
                      //AppTheme.of(context).bodyText1,
                  )
                  ),SizedBox(width: 10,),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.resolveWith<Color>(
                                (Set<MaterialState> states) {
                              if (states.contains(MaterialState.pressed)) {
                                return Colors.red; // Color when button is pressed
                              }
                              return Color(0xff43B6A3);// Default color
                            },
                          ),
                          foregroundColor: MaterialStateProperty.all<Color>(Colors.white), // Text color
                        ),
                       child: Text("..."),
                      onPressed: (){
                        Navigator.push(context,
                            new MaterialPageRoute(builder: (ctxt) => new detail_conducteur(conducteur: conducteur))
                        );
                      },
                      //AppTheme.of(context).bodyText1,
                  )
                  )])
                ):Text(""),
                SizedBox(height: 10,),
              ],
            )
          ) ;
        },
      ),
    );
  }
}
