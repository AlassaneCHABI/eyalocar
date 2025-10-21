import 'package:animations/animations.dart';
import 'package:eyav2/constants.dart';
import 'package:eyav2/global_config.dart';
import 'package:eyav2/modeles/Voiture.dart';
import 'package:eyav2/widgets/homePage/Voitures/detail.dart';
import 'package:flutter/material.dart';

class VoitureTileResponseAnimation extends StatelessWidget {
  final int itemNo;
  final Voitures voiture;

  const VoitureTileResponseAnimation({this.itemNo = 0, required this.voiture});

  @override
  Widget build(BuildContext context) {
    ContainerTransitionType _transitionType = ContainerTransitionType.fade;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: OpenContainer<bool>(
        transitionType: _transitionType,
        openBuilder: (BuildContext _, VoidCallback openContainer) {
          return detail(voitures: voiture) ;
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
                  width: 320,
                  child: Image.network(
                    "${Configuration.base_url_mage}/Car_${voiture.id}/${voiture.car_exterior_img}.jpg",
                    fit: BoxFit.cover,
                  ),
                ),),
                 SizedBox(height: 8,),
                Container(
                  child:Align(
                    alignment: Alignment.centerLeft,
                    child:Text(
                        "  Type : "+ voiture.category_name,
                        style: TextStyle(fontSize: 15)//AppTheme.of(context).bodyText1,

                    ),
                  )

                ),
                SizedBox(height: 8,),
                Container(
                  child:Align(
                    alignment: Alignment.centerLeft,
                    child:Text(
                        "  Nom  "+ voiture.car_name,
                        style: TextStyle(fontSize: 15,color: Colors.green)//AppTheme.of(context).bodyText1,

                    )
                  )

                ),
                SizedBox(height: 8,),
                Container(
                  child:Align(
                    alignment: Alignment.centerLeft,
                    child:Text(
                        "  Prix : "+ voiture.car_price.toString()+" FCFA",
                        style: TextStyle(fontSize: 15)//AppTheme.of(context).bodyText1,

                    ),
                  )

                ),
                SizedBox(height: 8,),
                Container(
                  child:Align(
                    alignment: Alignment.centerLeft,
                    child:Text(
                        "  Année : "+ voiture.car_year,
                        style: TextStyle(fontSize: 15)//AppTheme.of(context).bodyText1,

                    ),
                  )
                ),
                SizedBox(height: 10,),
                voiture.status=="not reserved"? Container(
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
                        Navigator.push(context,
                            //new MaterialPageRoute(builder: (ctxt) => new Reserver(voiture: voiture)));
                            new MaterialPageRoute(builder: (ctxt) => new detail(voitures: voiture)));
                          /*
                          print(voiture.rrcar_id);
                          print("L'id du vehicule");
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
                                "rrcar_id": voiture.rrcar_id,
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
                                  "rrcar_id": voiture.rrcar_id,
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
                          }*/
                          //return voitures;

                        /*Navigator.push(context,
                            new MaterialPageRoute(builder: (ctxt) => new Reserver(voiture: voiture))
                        );*/
                      },
                      //AppTheme.of(context).bodyText1,
                  )
                  ),SizedBox(width: 10,),
                    /*Align(
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
                            new MaterialPageRoute(builder: (ctxt) => new detail(voitures: voiture))
                        );
                      },
                      //AppTheme.of(context).bodyText1,
                  )
                  )*/
                  ])
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
