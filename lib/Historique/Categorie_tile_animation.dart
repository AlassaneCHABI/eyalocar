
import 'package:animations/animations.dart';
import 'package:eyav2/app_theme.dart';
import 'package:eyav2/components/default_button.dart';
import 'package:eyav2/constants.dart';
import 'package:eyav2/global_config.dart';
import 'package:eyav2/modeles/Categorie.dart';
import 'package:eyav2/modeles/Voiture.dart';
import 'package:eyav2/reservation/reserver.dart';
import 'package:eyav2/widgets/homePage/Voitures/Vehicule_by_categorie.dart';
import 'package:eyav2/widgets/homePage/Voitures/details_page.dart';
import 'package:flutter/material.dart';

class VoitureTileAnimation extends StatelessWidget {
  final int itemNo;
  final Voitures voiture;

  const VoitureTileAnimation({this.itemNo = 0, required this.voiture});

  @override
  Widget build(BuildContext context) {
    ContainerTransitionType _transitionType = ContainerTransitionType.fade;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: OpenContainer<bool>(
        transitionType: _transitionType,
        openBuilder: (BuildContext _, VoidCallback openContainer) {
          return DetailsPage(
            car_name: voiture.car_name,
            car_features: voiture.car_features,
            car_status: voiture.car_status,
            car_price:voiture.car_price,
            category_name: voiture.category_name,
            car_exterior_img: voiture.car_exterior_img,
            car_interior_img: voiture.car_interior_img,
            car_rear_img: voiture.car_rear_img,
            car_front_img: voiture.car_front_img,
            car_reg_no: voiture.car_reg_no,
          ) ;
        },
        closedElevation: 0.0,
        closedBuilder: (BuildContext _, VoidCallback openContainer) {
          return Card(
            elevation: 4,

            child:Column(
              //mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  child: Image.network(
                    "${Configuration.base_url_mage}/Car_${voiture.id}/${voiture.car_exterior_img}.jpg",
                    fit: BoxFit.cover,
                  ),

                ),
                 SizedBox(height: 8,),
                Container(
                  child:Align(
                    alignment: Alignment.centerLeft,
                    child:Row(
                       children:[ Text(
                     "  Type : "+ voiture.category_name,
                      style: TextStyle(fontSize: 15)//AppTheme.of(context).bodyText1,

                     ), SizedBox(width: 20,),
                         Text(
                          "Status  "+ voiture.car_status,
                      style: TextStyle(fontSize: 15,color: Colors.green)//AppTheme.of(context).bodyText1,

                  )
                 ]
                    ),
                  )

                ),
                SizedBox(height: 10,),
                Container(
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
                      onPressed: (){
                        Navigator.push(context,
                            new MaterialPageRoute(builder: (ctxt) => new Reserver(voiture: voiture))
                        );
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

                      },
                      //AppTheme.of(context).bodyText1,
                  )
                  )])
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
