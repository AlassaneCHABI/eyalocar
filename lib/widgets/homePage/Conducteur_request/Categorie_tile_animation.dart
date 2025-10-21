
import 'package:animations/animations.dart';
import 'package:eyav2/app_theme.dart';
import 'package:eyav2/components/default_button.dart';
import 'package:eyav2/constants.dart';
import 'package:eyav2/global_config.dart';
import 'package:eyav2/modeles/Categorie.dart';
import 'package:eyav2/modeles/Request_conducteur.dart';
import 'package:eyav2/modeles/Voiture.dart';
import 'package:eyav2/modeles/request_cars.dart';
import 'package:eyav2/new/found_conductors_list.dart';
import 'package:eyav2/pages/home_page.dart';
import 'package:eyav2/reservation/reserver.dart';
import 'package:eyav2/widgets/homePage/Response_conducteur/All_response.dart';
import 'package:eyav2/widgets/homePage/Response_requeste/All_response.dart';
import 'package:eyav2/widgets/homePage/Voitures/Vehicule_by_categorie.dart';
import 'package:eyav2/widgets/homePage/Voitures/detail.dart';
import 'package:eyav2/widgets/homePage/Voitures/details_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ConducteurTileAnimation extends StatelessWidget {
  final int itemNo;
  final Request_conducteur conducteur;

  const ConducteurTileAnimation({this.itemNo = 0, required this.conducteur});

  String formatDateTime(String dateTimeString) {
    // Parse la date en tant qu'objet DateTime
    DateTime dateTime = DateTime.parse(dateTimeString);

    // Crée un format pour "jour/mois/année heure"
    DateFormat formatter = DateFormat('dd/MM/yyyy HH:mm');

    // Formate la date selon le format spécifié
    String formattedDate = formatter.format(dateTime);

    return formattedDate;
  }

  @override
  Widget build(BuildContext context) {
    ContainerTransitionType _transitionType = ContainerTransitionType.fade;
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Card(
          elevation: 2,
          color: Colors.white,
          child:Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              //mainAxisSize: MainAxisSize.max,
              children: [

                SizedBox(height: 15,),
                Container(
                    child:Align(
                        alignment: Alignment.centerLeft,
                        child:conducteur.status=="Pending"? Text(
                            "Demande en cours de traitement",
                            style: TextStyle(fontSize: 18,color: Colors.orange, fontFamily: "Ubuntu", fontWeight: FontWeight.bold)//AppTheme.of(context).bodyText1,
                        ):Text(
                            "Demande déjà traitée",
                            style: TextStyle(fontSize: 18, color: greenThemeColor, fontFamily: "Ubuntu", fontWeight: FontWeight.bold)//AppTheme.of(context).bodyText1,
                        )
                    )
                ),
                SizedBox(height: 15,),
                Container(
                    child:Align(
                        alignment: Alignment.centerLeft,
                        child:
                        Text(
                            "  Tranche d'âge : "+ conducteur.tranche_age,
                            style: TextStyle(fontSize: 15)//AppTheme.of(context).bodyText1,
                        )
                    )),
                SizedBox(height: 8,),
                Container(
                    child:Align(
                      alignment: Alignment.centerLeft,
                      child:Row(
                          children:[
                            Text(
                                "  Permis : "+ conducteur.permis,
                                style: TextStyle(fontSize: 15)//AppTheme.of(context).bodyText1,
                            ), SizedBox(width: 20,),
                            SizedBox(width: 20,),
                          ]
                      ),
                    )

                ),

                SizedBox(height: 8,),
                Container(
                    child:Align(
                      alignment: Alignment.centerLeft,
                      child:Text(
                          "  Date: "+ formatDateTime(conducteur.created_at),
                          style: TextStyle(fontSize: 15)//AppTheme.of(context).bodyText1,
                      ),
                    )

                ),
                SizedBox(height: 10,),
                SizedBox(height: 8,),
                Container(
                    child:Padding(
                      padding: EdgeInsets.all(10),
                      child:Container(
                        alignment: Alignment.topLeft,
                        child: ElevatedButton.icon(
                          onPressed: () async{
                            conducteur.status=="Pending"?
                            showDialog(
                              context: context,
                              builder: (BuildContext ctx) {
                                return AlertDialog(
                                  title: Text("Alerte"),
                                  content: Text("Votre demande n'a pas encore été traité", textAlign: TextAlign.center,),
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
                                          backgroundColor: MaterialStateProperty.all(greenThemeColor),
                                          shadowColor: MaterialStateProperty.all(greenThemeColor),
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
                            ): conducteur.status=="Not available"?
                            showDialog(
                              context: context,
                              builder: (BuildContext ctx) {
                                return AlertDialog(
                                  title: Text("Alerte"),
                                  content: Text("Pas de conducteur disponible pour cette demande", textAlign: TextAlign.center,),
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
                                          backgroundColor: MaterialStateProperty.all(greenThemeColor),
                                          shadowColor: MaterialStateProperty.all(greenThemeColor),
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
                            ):
                            Navigator.push(context, MaterialPageRoute(builder: (context) => FoundConductorsListScreen(request_id: conducteur.id)));
                          },
                          icon: const Icon(Icons.remove_red_eye_outlined, color: Colors.white,),
                          label: const Text('Voir plus', style: TextStyle(color: Colors.white, fontSize: 16,)),
                          style: ElevatedButton.styleFrom(backgroundColor: greenThemeColor),
                        ),
                      ),
                    )

                ),
                SizedBox(height: 10,),
              ],
            ),
          )
      )
    );
  }
}
