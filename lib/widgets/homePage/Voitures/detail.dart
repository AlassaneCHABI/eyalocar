import 'dart:convert';
import 'dart:io';

// import 'package:carousel_pro_nullsafety/carousel_pro_nullsafety.dart';
import 'package:eyav2/constants.dart';
import 'package:eyav2/global_config.dart';
import 'package:eyav2/modeles/Voiture.dart';
import 'package:eyav2/reservation/reserver.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../DrawerMenuWidget.dart';
import '../../bottomnav.dart';
import 'All_cars.dart';
import 'package:http/http.dart ' as http;

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
                          "Nom  "+ widget.voitures.car_name,
                          style: TextStyle(fontSize: 15,color: Colors.green)//AppTheme.of(context).bodyText1,

                      )
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
                        "  Prix : "+ widget.voitures.car_price.toString()+" FCFA",
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
                        "  Année : "+ widget.voitures.car_year,
                        style: TextStyle(fontSize: 15,color: kPrimaryColor)//AppTheme.of(context).bodyText1,

                    ),

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
         widget.voitures.status=="not reserved"? Center(
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
                child: Text("Reserver ce véhicule"),
                onPressed: () async {
                  Navigator.push(context,
                      new MaterialPageRoute(builder: (ctxt) => new Reserver(voiture: widget.voitures))
                  );
                 /*
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  String? token= prefs.getString("token");
                  var url = Uri.http('${Configuration.base_url}', 'apiv2/update-rrcars');
                  // List<Voitures> voitures = [];
                  final response = await http.post(
                      url,
                      headers: {
                        HttpHeaders.contentTypeHeader: 'application/json',
                        HttpHeaders.acceptHeader: 'application/json',
                        HttpHeaders.authorizationHeader:'Bearer $token'
                      },
                      body: json.encode({
                        "rrcar_id": widget.voitures.rrcar_id,
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
                                Navigator.push(context, MaterialPageRoute(builder: (context) => CarsListingWidget(token:token!)));
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
                            "rrcar_id": widget.voitures.rrcar_id,
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
                                Navigator.push(context, MaterialPageRoute(builder: (context) => CarsListingWidget(token:token!)));
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
                 */

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
