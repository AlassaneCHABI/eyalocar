import 'dart:convert';
import 'dart:io';

// import 'package:carousel_pro_nullsafety/carousel_pro_nullsafety.dart';
import 'package:eyav2/constants.dart';
import 'package:eyav2/global_config.dart';
import 'package:eyav2/modeles/Conducteur_reponse.dart';
import 'package:eyav2/widgets/homePage/Conducteur_request/All_request_conducteur.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../DrawerMenuWidget.dart';
import '../../bottomnav.dart';
import 'package:http/http.dart ' as http;


class detail_conducteur extends StatefulWidget {
  Conducteur_reponse conducteur;
  detail_conducteur({Key? key, required this.conducteur}) : super(key: key);

  @override
  State<detail_conducteur> createState() => _detailState();
}

class _detailState extends State<detail_conducteur> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.conducteur.driver_firstname),
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
          Text("DETAIL DU CONDUCTEUR",style: TextStyle(color: Color(0xff43B6A3),fontSize: 20),),
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
//                       Image.network("https://otrade-company.com/storage/app/public/Driver_${widget.conducteur.id}/${widget.conducteur.driver_photo}.jpg",
//                         width: double.infinity,
//                         fit: BoxFit.cover,
//                       ),
//                      /* Image.network("${Configuration.base_url_mage}/Car_${widget.voitures.id}/${widget.voitures.car_interior_img}.jpg",
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
//                       ),*/
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
                        "  Nom : "+ widget.conducteur.driver_lastname,
                        style: TextStyle(fontSize: 15,color: kPrimaryColor)//AppTheme.of(context).bodyText1,

                    ),

                    ]
                ),
              )

          ),
          SizedBox(height: 8,),
          Container(
              child:Align(
                alignment: Alignment.centerLeft,
                child:Row(
                    children:[ Text(
                        "  Prénom : "+ widget.conducteur.driver_firstname,
                        style: TextStyle(fontSize: 15,color: kPrimaryColor)//AppTheme.of(context).bodyText1,

                    ),
                    ]
                ),
              )

          ),
          SizedBox(height: 8,),
          Container(
              child:Align(
                alignment: Alignment.centerLeft,
                child:Row(
                    children:[ Text(
                        "  Ville : "+ widget.conducteur.driver_city,
                        style: TextStyle(fontSize: 15,color: kPrimaryColor)//AppTheme.of(context).bodyText1,

                    ),
                    ]
                ),
              )

          ),
          SizedBox(height: 8,),
          /*Padding(
            padding: const EdgeInsets.all(8.0),
            child:Align(
                alignment: Alignment.centerLeft,
                child:Text(
                    widget.voitures.car_features,
                    style: TextStyle(fontSize: 15,color: kPrimaryColor)//AppTheme.of(context).bodyText1,
                )),),
          */
          SizedBox(height: 8,),
         widget.conducteur.status=="not reserved"? Center(
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
                child: Text("Réserver"),
                onPressed: () async {
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  String? token= prefs.getString("token");
                  var url = Uri.http('${Configuration.base_url}', 'apiv2/update_rrdrivers');
                  // List<Voitures> voitures = [];
                  final response = await http.post(
                      url,
                      headers: {
                        HttpHeaders.contentTypeHeader: 'application/json',
                        HttpHeaders.acceptHeader: 'application/json',
                        HttpHeaders.authorizationHeader:'Bearer $token'
                      },
                      body: json.encode({
                        "rrdriver_id": widget.conducteur.rrdriver_id,
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
                            "rrdriver_id": widget.conducteur.rrdriver_id
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
              ),
            ),
          ):Text(""),
          SizedBox(height: 10,),
        ]))
      ));
  }
}
