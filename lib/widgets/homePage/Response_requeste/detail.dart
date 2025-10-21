// import 'package:carousel_pro_nullsafety/carousel_pro_nullsafety.dart';
import 'package:eyav2/constants.dart';
import 'package:eyav2/global_config.dart';
import 'package:eyav2/modeles/Voiture.dart';
import 'package:eyav2/reservation/reserver.dart';
import 'package:flutter/material.dart';

import '../../../AjoutAlerte/Ajout_Alerte.dart';
import '../../../AjoutVoiture/Ajout_voiture.dart';
import '../../../Recherche_voiture/Recherche.dart';
import '../../../Recherche_voiture/components/Recherche_form.dart';
import '../../../pages/home_page.dart';
import '../../DrawerMenuWidget.dart';
import '../../bottomnav.dart';
import 'All_response.dart';

class detail extends StatefulWidget {
  Voitures voitures;
   detail({Key? key, required this.voitures}) : super(key: key);

  @override
  State<detail> createState() => _detailState();
}

class _detailState extends State<detail> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.voitures.category_name),
        backgroundColor: kPrimaryColor,
      ),

        drawer: DrawerMenuWidget(),
        bottomNavigationBar: bottomNvigator(),


        body: SingleChildScrollView(

        child: Card(
          elevation: 4,
          child: Column(
        children: [
          SizedBox(height: 10,),
          Text("DETAIL DE VEHICULE",style: TextStyle(color: Color(0xff43B6A3),fontSize: 20),),
//           Container(
//             child:Padding(
//               padding: EdgeInsets.only(left: 10, right: 10,top: 10,bottom: 10),
//               child:Card(elevation: 4,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(10), // Bordure arrondie
//                     side: BorderSide(
//                       color: Colors.white, // Couleur de la bordure
//                       width: 2, // Largeur de la bordure
//                     ),
//                   ),
//                   child:ClipRRect(
//                       borderRadius: BorderRadius.circular(15),
//                       child:
//                   Container(
//                   height: 200.0,
//                   width: double.infinity,
//                   child: Carousel(
//                     images: [
//                       Image.network("${Configuration.base_url_mage}/Car_${widget.voitures.id}/${widget.voitures.car_exterior_img}.jpg",
//                         width: double.infinity,
//                         fit: BoxFit.cover,
//                       ),
//                       Image.network("${Configuration.base_url_mage}/Car_${widget.voitures.id}/${widget.voitures.car_interior_img}.jpg",
//                         width: double.infinity,
//                         fit: BoxFit.cover,
//                       )
//                       ,
//                       Image.network("${Configuration.base_url_mage}/Car_${widget.voitures.id}/${widget.voitures.car_front_img}.jpg",
//                         width: double.infinity,
//                         fit: BoxFit.cover,
//                       ),
//                       Image.network("${Configuration.base_url_mage}/Car_${widget.voitures.id}/${widget.voitures.car_rear_img}.jpg",
//                         width: double.infinity,
//                         fit: BoxFit.cover,
//                       ),
// //              Image.asset("assets/images/promotion_two.png",height: double.infinity,width: double.infinity,),
// //              Image.asset("assets/images/promotion_three.png",height: double.infinity,width: double.infinity,),
//                     ],
//                     dotSize: 4.0,
//                     dotSpacing: 15.0,
//                     dotColor: Colors.purple,
//                     indicatorBgPadding: 5.0,
//                     dotBgColor: Colors.black54.withOpacity(0.2),
//                     borderRadius: true,
//                     radius: Radius.circular(20),
//                     moveIndicatorFromBottom: 180.0,
//                     noRadiusForIndicator: true,
//                   )))),
//             ) ,
//           ),
          SizedBox(height: 8,),
          Container(
              child:Align(
                alignment: Alignment.centerLeft,
                child:Row(
                    children:[ Text(
                        "  Type : "+ widget.voitures.category_name,
                        style: TextStyle(fontSize: 15,color: kPrimaryColor)//AppTheme.of(context).bodyText1,

                    ), SizedBox(width: 20,),
                      Text(
                          "Status  "+ widget.voitures.car_status,
                          style: TextStyle(fontSize: 15,color: Colors.green)//AppTheme.of(context).bodyText1,

                      )
                    ]
                ),
              )

          ),
          SizedBox(height: 8,),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child:Align(
                alignment: Alignment.centerLeft,
                child:Text(
                    widget.voitures.car_features,
                    style: TextStyle(fontSize: 15,color: kPrimaryColor)//AppTheme.of(context).bodyText1,
                )),),
          SizedBox(height: 8,),
          Center(
            child: Container(

              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                      if (states.contains(MaterialState.pressed)) {
                        return kPrimaryColor; // Color when button is pressed
                      }
                      return kPrimaryColor; // Default color
                    },
                  ),
                  foregroundColor: MaterialStateProperty.all<Color>(Colors.white), // Text color
                ),
                child: Text("FORMULAIRE DE RESERVATION"),
                onPressed: (){
                  Navigator.push(context,
                      new MaterialPageRoute(builder: (ctxt) => new Reserver(voiture: widget.voitures))
                  );
                },
                //AppTheme.of(context).bodyText1,
              ),
            ),
          ),
          SizedBox(height: 10,),
        ]))
      ));
  }
}
