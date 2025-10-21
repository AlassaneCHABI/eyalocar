
import 'package:animations/animations.dart';
import 'package:eyav2/app_theme.dart';
import 'package:eyav2/components/default_button.dart';
import 'package:eyav2/constants.dart';
import 'package:eyav2/global_config.dart';
import 'package:eyav2/modeles/Categorie.dart';
import 'package:eyav2/modeles/Voiture.dart';
import 'package:eyav2/pages/home_page.dart';
import 'package:eyav2/reservation/reserver.dart';
import 'package:eyav2/widgets/homePage/Voitures/Vehicule_by_categorie.dart';
import 'package:eyav2/widgets/homePage/Voitures/detail.dart';
import 'package:eyav2/widgets/homePage/Voitures/details_page.dart';
import 'package:flutter/material.dart';

class TarifTileAnimation extends StatelessWidget {
  final int itemNo;
  final Category categorie;

  const TarifTileAnimation({this.itemNo = 0, required this.categorie});

  @override
  Widget build(BuildContext context) {

    ContainerTransitionType _transitionType = ContainerTransitionType.fade;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: OpenContainer<bool>(
        transitionType: _transitionType,
        openBuilder: (BuildContext _, VoidCallback openContainer) {
          return Vehicule_by_categorie(category_id: categorie.id,category_name: categorie.category_name,);//detail(voitures: voiture) ;
        },
        closedElevation: 0.0,
        closedBuilder: (BuildContext _, VoidCallback openContainer) {
          return Card(
            elevation: 4,

            child:Column(
              //mainAxisSize: MainAxisSize.max,
              children: [
                ListTile(
                  title: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child:
            Container(
              child: Image.network(
                "${Configuration.base_url_mage}/Categorie_${categorie.id}/${categorie.category_photo}.png",
                fit: BoxFit.cover,
              ),
            ),),
                  trailing: Container(
                    width: 60.0,
                    height: 60.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xff43B6A3),
                    ),
                    child: Center(
                      child: Text(
                        "  APD\n"+categorie.category_tarif_apd+"\n  FCFA",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ), /*ClipRRect(
                    borderRadius:BorderRadius.circular(20),
                    child: Text(categorie.category_tarif_apd),
                  ),*/
                  subtitle:Container(
                      child:Column(
                         children: [
                           SizedBox(height: 10,),
                          Align(
                          child:Row(
                          children:[ Text(
                          categorie.category_name,
                          style: TextStyle(fontSize: 25,color: kPrimaryColor)//AppTheme.of(context).bodyText1,
                          )
                          ]
                          ),
                          ),
                           SizedBox(height: 10,),
                           Align(
                          alignment: Alignment.centerLeft,
                          child:Container(
                            child: Text(categorie.category_description,textAlign: TextAlign.justify,),
                          ),
                          ),

                         ],
                        )

                  ) ,
                ),

                SizedBox(height: 10,),
              ],
            )
          ) ;
        },
      ),
    );
  }
}
