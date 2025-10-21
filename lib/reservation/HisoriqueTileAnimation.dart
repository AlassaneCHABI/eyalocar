
import 'dart:convert';
import 'dart:io';

import 'package:animations/animations.dart';
import 'package:eyav2/constants.dart';
import 'package:eyav2/modeles/Reservation.dart';
import 'package:eyav2/modeles/Setting.dart';
import 'package:eyav2/new/entry_screen.dart';
import 'package:eyav2/pages/home_page.dart';
import 'package:eyav2/reservation/historique.dart';
import 'package:flutter/material.dart';
import 'package:eyav2/global_config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:eyav2/function/function.dart'as function;
import 'package:http/http.dart ' as http;
import 'package:kkiapay_flutter_sdk/kkiapay_flutter_sdk.dart';


import '../Historique/H_paiement.dart';

class HostoriqueTileAnimation extends StatefulWidget {

  final int itemNo;
  final Reservation reservation;
  const HostoriqueTileAnimation({this.itemNo = 0, required this.reservation});

  @override
  State<HostoriqueTileAnimation> createState() => _HostoriqueTileAnimationState();
}

class _HostoriqueTileAnimationState extends State<HostoriqueTileAnimation> {

  late String username;
  late String lastname;
  late String firstname;
  late String email;
  late String token;
  late int montant;
  late int reservation_id;
  late int bonus;
  late String bonus_expiration;
  late int minimum_paiement=0;
  late int allow_bonus=0;
  bool bonus_visible=false;


  _getLocalUser() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      username=prefs.getString("username")!;
      lastname=prefs.getString("lastname")!;
      firstname=prefs.getString("firstname")!;
      email=prefs.getString("email")!;
      token=prefs.getString("token")!;
      bonus=prefs.getInt("bonus")!;

      if(bonus>=int.parse(widget.reservation.remaining_amount)){
        bonus_visible =true;
      }

    } catch (e) {
      print(e.toString());
    }
  }

  Future<void>  getSetting() async {
    var url = Uri.http('${Configuration.base_url}', 'apiv2/setting');
    final response = await http.get(
      url,
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.acceptHeader: 'application/json',
      },
    );
    if (response.statusCode == 301) {
      final newUrl = response.headers['location'];
      if (newUrl != null) {
        // Make a new request to the new URL
        final newResponse = await http.get(Uri.parse(newUrl),
          headers: {
            HttpHeaders.contentTypeHeader: 'application/json',
            HttpHeaders.acceptHeader: 'application/json',
          },
        );
        print(newResponse.statusCode);
        print(newResponse.body);
        Setting setting = Setting.fromJson(json.decode(newResponse.body));
        setState(() {
          minimum_paiement = setting.minimum_paiement;
          allow_bonus = setting.allow_bonus;
        });
        print("Voici le minimum à payer $minimum_paiement");
        print("Voici la permission $allow_bonus");

      }
    }else if(response.statusCode == 200){
      print(response.statusCode);
      print(response.body);
      Setting setting = Setting.fromJson(json.decode(response.body));
      setState(() {
        minimum_paiement = setting.minimum_paiement;
        allow_bonus = setting.allow_bonus;
      });
      print("Voici le minimum à payer $minimum_paiement");
      print("Voici la permission $allow_bonus");

    }

  }


  void successCallback(response, context) {
    Navigator.pop(context);
    switch ( response['status'] ) {

      case PAYMENT_CANCELLED: print(PAYMENT_CANCELLED);
      break;

      case PAYMENT_SUCCESS:
        //reserver(widget.reservation.id,widget.reservation.booking_society!,widget.reservation.booking_phone_number!,widget.reservation.booking_ifu!,widget.reservation.booking_circuit!,widget.reservation.booking_le!,widget.reservation.booking_ld!,widget.reservation.booking_he,widget.reservation.booking_dd,widget.reservation.booking_de,token.toString());
        paiement_reservation(widget.reservation.id,int.parse(widget.reservation.remaining_amount),token);
        //update_car();

        break;
      case PAYMENT_FAILED: print(PAYMENT_FAILED);
      break;

      default:
        break;
    }
  }

  Future <void> reserver(int car_id,String booking_society,String booking_phone_number, String booking_ifu,String booking_circuit,String booking_le,String booking_ld,String booking_he,String booking_dd,String booking_de,String token) async {
    showAlertDialog(context);
    var url = Uri.http('${Configuration.base_url}', 'apiv2/add-bookings');

    final response = await http.post(
        url,
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.acceptHeader: 'application/json',
          HttpHeaders.authorizationHeader:'Bearer $token'
        },
        body: json.encode({
          "car_id": car_id,
          "booking_society": booking_society,
          "booking_phone_number": booking_phone_number,
          "booking_ifu": booking_ifu,
          "booking_circuit": booking_circuit,
          "booking_le": booking_le,
          "booking_ld": booking_ld,
          "booking_he": booking_he,
          "booking_de": booking_de,
          "booking_dd": booking_dd,
        })
    );
    if(response.statusCode==200){

    }
    else if (response.statusCode == 301) {
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
              "car_id": car_id,
              "booking_society": booking_society,
              "booking_phone_number": booking_phone_number,
              "booking_ifu": booking_ifu,
              "booking_circuit": booking_circuit,
              "booking_le": booking_le,
              "booking_ld": booking_ld,
              "booking_he": booking_he,
              "booking_de": booking_de,
              "booking_dd": booking_dd,
            })
        );
        if(newResponse.statusCode==200){

        }
        // Process the new response
        print(newResponse.statusCode);
        print(newResponse.body);
      }
    }
  }

  showAlertDialog(BuildContext context){
    AlertDialog alert=AlertDialog(
      content: new Row(
        children: [
          CircularProgressIndicator(),
          Container(margin: EdgeInsets.only(left: 5),child:Text("Reservation ....." )),
        ],),
    );
    showDialog(barrierDismissible: false,
      context:context,
      builder:(BuildContext context){
        return alert;
      },
    );
  }

  void  paiement_reservation(int booking_id,int payment_amount,String token) async {
    var url = Uri.http('${Configuration.base_url}', 'apiv2/add-payments');

    final response = await http.post(
        url,
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.acceptHeader: 'application/json',
          HttpHeaders.authorizationHeader:'Bearer $token'
        },
        body: json.encode({
          "booking_id": booking_id,
          "payment_amount": payment_amount,
        })
    );

    if(response.statusCode==200){
      showDialog(
        context: this.context,
        builder: (BuildContext ctx) {
          return AlertDialog(
            title: Text("Paiement"),
            content: Text("Paiement effectué avec succès.", textAlign: TextAlign.center,),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => HistoriqueListingWidget(token:token!)));
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
              'assets/images/checked_img.png',
              width: 80,
              height: 80,
            ),
          );
        },
      );
    }else if (response.statusCode == 301) {
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
              "booking_id": booking_id,
              "payment_amount": payment_amount,
            })
        );
        if(newResponse.statusCode==200){
          showDialog(
            context: this.context,
            builder: (BuildContext ctx) {
              return AlertDialog(
                title: Text("Paiement"),
                content: Text("Paiement effectué avec succès.", textAlign: TextAlign.center,),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(ctx);
                      Navigator.push(context, MaterialPageRoute(builder: (context) => HistoriqueListingWidget(token:token!)));
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
                  'assets/images/checked_img.png',
                  width: 80,
                  height: 80,
                ),
              );
            },
          );
        }else{
          showDialog(
            context: this.context,
            builder: (BuildContext ctx) {
              return AlertDialog(
                title: Text("Paiement"),
                content: Text("Paiement non effectué.", textAlign: TextAlign.center,),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(ctx);
                     // Navigator.push(context, MaterialPageRoute(builder: (context) => HistoriqueListingWidget(token:token!)));
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
          );
        }

        print(newResponse.body);
        print(newResponse.statusCode);
        print("My token :"+token);
      }
    }

  }


  Future<void> update_car() async {
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
          "rrcar_id": widget.reservation..booking_car,
        })
    );
    print(response.body);
    print(response.statusCode);

    if(response.statusCode == 200){
      showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return AlertDialog(
            title: Text("Paiement"),
            content: Text("Paiement effectué avec succès.", textAlign: TextAlign.center,),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => Liste_paiement(token: token!,)));
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
              "rrcar_id": widget.reservation..booking_car,
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
            title: Text("Paiement"),
            content: Text("Paiement effectué avec succès.", textAlign: TextAlign.center,),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => Liste_paiement(token: token!,)));
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
            content: Text("Le paiement n'a pas été envoyé.Veuillez vérifier votre connexion internet avant de relancer le paiemen", textAlign: TextAlign.center,),
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
      );
    }
  }



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getLocalUser();
    getSetting();
  }

 /* void successCallback(response, context) {
    Navigator.pop(context);
    switch ( response['status'] ) {

      case PAYMENT_CANCELLED: print(PAYMENT_CANCELLED);
      break;

      case PAYMENT_SUCCESS:
      function.paiement_reservation(montant,reservation_id,token);

      showDialog(
        context: this.context,
        builder: (BuildContext ctx) {
          return AlertDialog(
            title: Text("Paiement"),
            content: Text("Paiement effectué avec succès.", textAlign: TextAlign.center,),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
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
              'assets/images/checked_img.png',
              width: 80,
              height: 80,
            ),
          );
        },
      );

        break;
      case PAYMENT_FAILED: print(PAYMENT_FAILED);
      break;

      default:
        break;
    }
  }
  */


  @override
  Widget build(BuildContext context) {
    ContainerTransitionType _transitionType = ContainerTransitionType.fade;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Card(
              color: Colors.white,
              elevation: 4,

              child:Column(
                //mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    height: 300,
                    width: double.infinity,
                    child: Image.network(
                      "${Configuration.base_url_mage}/Car_${widget.reservation.booking_car}/${widget.reservation.car_exterior_img}.jpg",
                      fit: BoxFit.cover,
                    ),

                  ),
                  SizedBox(height: 20,),
                  Container(
                      child:Align(
                        alignment: Alignment.centerLeft,
                        child:Row(
                            children:[
                              SizedBox(width: 11,),
                              Text(
                                  "Nom du véhicule : ",
                                  style: new TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold)//AppTheme.of(context).bodyText1,
                              ) ,
                              Text(
                                  "${widget.reservation.car_name}",
                                  style: TextStyle(fontSize: 15)//AppTheme.of(context).bodyText1,
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
                            children:[
                              SizedBox(width: 11,),
                              Text(
                                "Type : ",
                                  style: new TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold)//AppTheme.of(context).bodyText1,

                              ),

                              Text(widget.reservation.category_name,
                                style: TextStyle(fontSize: 15)//AppTheme.of(context).bodyText1,

                              ),

                              /*SizedBox(width: 20,),
                              Text(
                                  "Statut  :",
                                  style: TextStyle(fontSize: 15,color: Colors.green)//AppTheme.of(context).bodyText1,

                              ),*/
                              //Text(widget.reservation.booking_status=="Approved"?"Approuvé":widget.reservation.booking_status=="Confirmed"?"Confirmé":widget.reservation.booking_status=="Disapproved"?"Rejeté":widget.reservation.booking_status=="Paid"?"Payée":"En attente",style: TextStyle(fontSize: 15,color: Colors.green)),

                            ]
                        ),
                      )

                  ),

                  SizedBox(height: 8,),
                  Container(
                      child:Align(
                        alignment: Alignment.centerLeft,
                        child:Row(
                            children:[
                              SizedBox(width: 11,),
                              Text(
                                  "Trajet : ",
                                  style: new TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold)//AppTheme.of(context).bodyText1,
                              ) ,
                              Text(
                                  "De  "+ widget.reservation.booking_le+" à  "+widget.reservation.booking_ld,
                                  style: TextStyle(fontSize: 15)//AppTheme.of(context).bodyText1,
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
                            children:[
                              SizedBox(width: 11,),
                              Text(
                                  "Date de départ : ",
                                  style: new TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold)//AppTheme.of(context).bodyText1,
                              ),
                              Text(widget.reservation.booking_de,
                                  style: TextStyle(fontSize: 15)//AppTheme.of(context).bodyText1,
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
                            children:[
                              SizedBox(width: 11,),
                              Text(
                                  "Date d'arrivée : ",
                                  style: new TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold)//AppTheme.of(context).bodyText1,
                              ),
                              Text(widget.reservation.booking_dd,
                                  style: TextStyle(fontSize: 15)//AppTheme.of(context).bodyText1,
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
                            children:[
                              SizedBox(width: 11,),
                              Text(
                                  "Prix journalier : ",
                                  style: new TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold)//AppTheme.of(context).bodyText1,
                              ),
                              Text(widget.reservation.booking_price.toString()+" FCFA")
                            ]
                        ),
                      )

                  ),
                  SizedBox(height: 8,),
                  Container(
                      child:Align(
                        alignment: Alignment.centerLeft,
                        child:Row(
                            children:[
                              SizedBox(width: 11,),
                              Text(
                                  "Montant payé : ",
                                  style: new TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold)//AppTheme.of(context).bodyText1,
                              ),
                              Text(widget.reservation.total_payments.toString()+" FCFA")
                            ]
                        ),
                      )

                  ),
                  SizedBox(height: 8,),
                  Container(
                      child:Align(
                        alignment: Alignment.centerLeft,
                        child:Row(
                            children:[
                              SizedBox(width: 11,),
                              Text(
                                  "Montant restant : ",
                                  style: new TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold)//AppTheme.of(context).bodyText1,
                              ),
                              Text(widget.reservation.remaining_amount.toString()+" FCFA")
                            ]
                        ),
                      )

                  ),

                  SizedBox(height: 8,),
                 bonus_visible? Container(
                      child:Align(
                        alignment: Alignment.centerLeft,
                        child:Row(
                            children:[
                              SizedBox(width: 11,),
                              Text(
                                  "Bonus disponible $bonus points ",
                                  style: new TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold)//AppTheme.of(context).bodyText1,
                              ),
                              Text(widget.reservation.remaining_amount.toString()+" FCFA")
                            ]
                        ),
                      )

                  ):Text(""),
                  SizedBox(height: 10,),

                  widget.reservation.remaining_amount!="0"? Container(
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
                            child: Text("Payer le montant restant"),
                            onPressed: () async {
                              if(allow_bonus==1 && bonus>=int.parse(widget.reservation.remaining_amount)){
                                paiement_reservation(widget.reservation.id,int.parse(widget.reservation.remaining_amount),token);
                                /*showDialog(
                                  context: this.context,
                                  builder: (BuildContext ctx) {
                                    return AlertDialog(
                                      title: Text("Paiement"),
                                      content: Text("Paiement effectué avec succès.", textAlign: TextAlign.center,),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(ctx);
                                            Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
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
                                        'assets/images/checked_img.png',
                                        width: 80,
                                        height: 80,
                                      ),
                                    );
                                  },
                                );*/
                              }else{

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) =>  KKiaPay(
                                    amount: int.parse(widget.reservation.remaining_amount),
                                    countries: ["BJ"],
                                    name: firstname+" "+lastname,
                                    email: email,
                                    reason: 'Frais de reservation',
                                    data: 'Fake data',
                                    sandbox: false,
                                    apikey: 'ea9e13226779a14133230f82896ed2ad0fd4658b',
                                    callback: successCallback,
                                    theme: defaultTheme, // Ex : "#222F5A",
                                    partnerId: 'AxXxXXxId',
                                    //    paymentMethods: ["momo","card"]
                                  )),
                                );

                              }
      /*
                              setState(() {
                                montant=widget.reservation.booking_amount;
                                reservation_id=widget.reservation.id;
                              });

                              SharedPreferences prefs = await SharedPreferences.getInstance();
                              print(bonus);
                              print("minimum paiement $minimum_paiement");
                              print("allow_bonus $allow_bonus");
                              if(allow_bonus==1){
                                if(bonus!=0 && bonus>= (((widget.reservation.booking_amount)*minimum_paiement)/100).toInt()){
                                  // Convertir la date de l'API en objet DateTime
                                  DateTime apiDateTime = DateTime.parse(bonus_expiration);
                                  DateTime currentDate = DateTime.now();
                                  if(apiDateTime.isAfter(currentDate) || apiDateTime.isAtSameMomentAs(currentDate)){
                                    await reserver(widget.reservation.booking_car,widget.reservation.booking_society!,widget.reservation.booking_phone_number!,widget.reservation.booking_ifu!,widget.reservation.booking_circuit!,widget.reservation.booking_le!,widget.reservation.booking_ld!,
                                        widget.reservation.booking_he,widget.reservation.booking_dd,widget.reservation.booking_de,token.toString());

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
                              "rrcar_id": widget.reservation.booking_car,
                              })
                              );
                              print(response.body);
                              print(response.statusCode);

                              if(response.statusCode == 200){
                              showDialog(
                              context: context,
                              builder: (BuildContext ctx) {
                              return AlertDialog(
                                title: Text("Paiement"),
                                content: Text("Paiement effectué avec succès.", textAlign: TextAlign.center,),
                              actions: [
                              TextButton(
                              onPressed: () {
                              Navigator.pop(ctx);
                              Navigator.push(context, MaterialPageRoute(builder: (context) => Liste_paiement(token: token!,)));
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
                              "rrcar_id": widget.reservation.booking_car,
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
                                title: Text("Paiement"),
                                content: Text("Paiement effectué avec succès.", textAlign: TextAlign.center,),
                              actions: [
                              TextButton(
                              onPressed: () {
                              Navigator.pop(ctx);
                              Navigator.push(context, MaterialPageRoute(builder: (context) => Liste_paiement(token: token!,)));
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
                              content: Text("Votre paiement a échoué.Veuillez vérifier votre connexion internet avant de relancer le paiement", textAlign: TextAlign.center,),
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
                              );
                              }
                              }
                              else{

                              Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) =>  KKiaPay(
                              amount: (((widget.reservation.booking_price)*minimum_paiement)/100).toInt(),
                              countries: ["BJ"],
                              name: firstname+" "+lastname,
                              email: email,
                              reason: 'Frais de reservation',
                              data: 'Fake data',
                              sandbox: false,
                              apikey: 'ea9e13226779a14133230f82896ed2ad0fd4658b',
                              callback: successCallback,
                              theme: defaultTheme, // Ex : "#222F5A",
                              partnerId: 'AxXxXXxId',
                              //    paymentMethods: ["momo","card"]
                              )),
                              );
                              }

                              }else{

                              Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) =>  KKiaPay(
                              amount: (((widget.reservation.booking_price)*minimum_paiement)/100).toInt(),
                              countries: ["BJ"],
                              name: firstname+" "+lastname,
                              email: email,
                              reason: 'Frais de reservation',
                              data: 'Fake data',
                              sandbox: false,
                              apikey: 'ea9e13226779a14133230f82896ed2ad0fd4658b',
                              callback: successCallback,
                              theme: defaultTheme, // Ex : "#222F5A",
                              partnerId: 'AxXxXXxId',
      //    paymentMethods: ["momo","card"]
                              )),
                              );
                              }
                              }
                              else{
                              Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) =>  KKiaPay(
                              amount: (((widget.reservation.booking_price)*minimum_paiement)/100).toInt(),
                              countries: ["BJ"],
                              name: firstname+" "+lastname,
                              email: email,
                              reason: 'Frais de reservation',
                              data: 'Fake data',
                              sandbox: false,
                              apikey: 'ea9e13226779a14133230f82896ed2ad0fd4658b',
                              callback: successCallback,
                              theme: defaultTheme, // Ex : "#222F5A",
                              partnerId: 'AxXxXXxId',
      //    paymentMethods: ["momo","card"]
                              )),
                              );
                              }
                              */
                            },
                            //AppTheme.of(context).bodyText1,
                          )
                      ),SizedBox(width: 10,),
                      ])
                  )/*:widget.reservation.booking_status=="Confirmed"? Container(
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
                            child: Text("Payer la réservation"),
                            onPressed: () async{

                              setState(() {
                                montant=widget.reservation.booking_amount;
                                reservation_id=widget.reservation.id;
                              });

                              SharedPreferences prefs = await SharedPreferences.getInstance();
                              print(bonus);
                              print("minimum paiement $minimum_paiement");
                              print("allow_bonus $allow_bonus");
                              if(allow_bonus==1){
                                if(bonus!=0 && bonus_expiration!="Vide" && bonus>= (((widget.reservation.booking_amount)*minimum_paiement)/100).toInt()){
                                  // Convertir la date de l'API en objet DateTime
                                  DateTime apiDateTime = DateTime.parse(bonus_expiration);
                                  DateTime currentDate = DateTime.now();
                                  if(apiDateTime.isAfter(currentDate) || apiDateTime.isAtSameMomentAs(currentDate)){
                                    await reserver(widget.reservation.booking_car,widget.reservation.booking_society!,widget.reservation.booking_phone_number!,widget.reservation.booking_ifu!,widget.reservation.booking_circuit!,widget.reservation.booking_le!,widget.reservation.booking_ld!,
                                        widget.reservation.booking_he,widget.reservation.booking_dd,widget.reservation.booking_de,token.toString());

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
                                          "rrcar_id": widget.reservation.booking_car,
                                        })
                                    );
                                    print(response.body);
                                    print(response.statusCode);

                                    if(response.statusCode == 200){
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext ctx) {
                                          return AlertDialog(
                                            title: Text("Reservation"),
                                            content: Text("La réservation a été envoyée avec succès.", textAlign: TextAlign.center,),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.pop(ctx);
                                                  Navigator.push(context, MaterialPageRoute(builder: (context) => Liste_paiement(token: token!,)));
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
                                              "rrcar_id": widget.reservation.booking_car,
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
                                            title: Text("Reservation"),
                                            content: Text("La réservation a été envoyée avec succès.", textAlign: TextAlign.center,),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.pop(ctx);
                                                  Navigator.push(context, MaterialPageRoute(builder: (context) => Liste_paiement(token: token!,)));
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
                                      );
                                    }
                                  }
                                  else{

                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) =>  KKiaPay(
                                        amount: (((widget.reservation.booking_price)*minimum_paiement)/100).toInt(),
                                        countries: ["BJ"],
                                        name: firstname+" "+lastname,
                                        email: email,
                                        reason: 'Frais de reservation',
                                        data: 'Fake data',
                                        sandbox: false,
                                        apikey: 'ea9e13226779a14133230f82896ed2ad0fd4658b',
                                        callback: successCallback,
                                        theme: defaultTheme, // Ex : "#222F5A",
                                        partnerId: 'AxXxXXxId',
                                        //    paymentMethods: ["momo","card"]
                                      )),
                                    );
                                  }

                                }else{

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) =>  KKiaPay(
                                      amount: (((widget.reservation.booking_price)*minimum_paiement)/100).toInt(),
                                      countries: ["BJ"],
                                      name: firstname+" "+lastname,
                                      email: email,
                                      reason: 'Frais de reservation',
                                      data: 'Fake data',
                                      sandbox: false,
                                      apikey: 'ea9e13226779a14133230f82896ed2ad0fd4658b',
                                      callback: successCallback,
                                      theme: defaultTheme, // Ex : "#222F5A",
                                      partnerId: 'AxXxXXxId',
      //    paymentMethods: ["momo","card"]
                                    )),
                                  );
                                }
                              }
                              else{
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) =>  KKiaPay(
                                    amount: (((widget.reservation.booking_price)*minimum_paiement)/100).toInt(),
                                    countries: ["BJ"],
                                    name: firstname+" "+lastname,
                                    email: email,
                                    reason: 'Frais de reservation',
                                    data: 'Fake data',
                                    sandbox: false,
                                    apikey: 'ea9e13226779a14133230f82896ed2ad0fd4658b',
                                    callback: successCallback,
                                    theme: defaultTheme, // Ex : "#222F5A",
                                    partnerId: 'AxXxXXxId',
      //    paymentMethods: ["momo","card"]
                                  )),
                                );
                              }

                            },
                            //AppTheme.of(context).bodyText1,
                          )
                      ),SizedBox(width: 10,),
                      ])
                  )*/:Text(""),
                  SizedBox(height: 10,),
                ],
              )
          ),
          SizedBox(height: 20,),
        ],
      )

    );
  }
}

