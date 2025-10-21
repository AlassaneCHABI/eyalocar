import 'dart:convert';
import 'dart:io';

// import 'package:carousel_pro_nullsafety/carousel_pro_nullsafety.dart';
import 'package:eyav2/components/default_button.dart';
import 'package:eyav2/components/form_error.dart';
import 'package:eyav2/constants.dart';
import 'package:eyav2/global_config.dart';
import 'package:eyav2/modeles/Setting.dart';
import 'package:eyav2/modeles/Voiture.dart';
import 'package:eyav2/new/drawer.dart';
import 'package:eyav2/pages/home_page.dart';
import 'package:eyav2/pages/home_page.dart';
import 'package:eyav2/reservation/historique.dart';
import 'package:flutter/material.dart';
import 'package:kkiapay_flutter_sdk/kkiapay_flutter_sdk.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart ' as http;
import '../widgets/DrawerMenuWidget.dart';
import '../widgets/bottomnav.dart';
import 'package:eyav2/function/function.dart'as function;


class Reserver extends StatefulWidget {

  Voitures voiture;
  Reserver({Key? key,required this.voiture}) : super(key: key);

  @override
  _Reserver createState() => _Reserver();
}
class _Reserver extends State<Reserver> {
  final _formKey = GlobalKey<FormState>();
  final List<String?> errors = [];
  String? booking_society;
  String? booking_phone_number;
  String? budget;
  String? booking_ifu;
  String? booking_circuit;
  String? booking_le;
  String? booking_ld;
  //String? booking_he;

  late String username;
  late String lastname;
  late String firstname;
  late String email;
  late String token;
  late int bonus=0;
  late String bonus_expiration;
  late int minimum_paiement=0;
  late int allow_bonus=0;
  late int reservation_id=0;
  late int montant_=0;
  late int budget_minimum=0;
  late int nbr_jour=0;
  DateTime date1 = DateTime(2023, 1, 1);
  DateTime date2 = DateTime(2023, 12, 31);
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

    } catch (e) {
      print(e.toString());
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getLocalUser();
    getSetting();
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
          "rrcar_id": widget.voiture.rrcar_id,
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
                  Navigator.push(context, MaterialPageRoute(builder: (context) => HistoriqueListingWidget(token:token!)));
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
              "rrcar_id": widget.voiture.rrcar_id,
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
                  Navigator.push(context, MaterialPageRoute(builder: (context) => HistoriqueListingWidget(token:token!)));
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
  }

  void successCallback(response, context) {
    Navigator.pop(context);
    switch ( response['status'] ) {

      case PAYMENT_CANCELLED: print(PAYMENT_CANCELLED);
      break;

      case PAYMENT_SUCCESS:
        reserver(widget.voiture.id,booking_society!,booking_phone_number!,booking_ifu!,booking_circuit!,booking_le!,booking_ld!,
            booking_he.text,booking_dd.text,booking_de.text,token.toString(),int.parse(budget!));
        break;
      case PAYMENT_FAILED: print(PAYMENT_FAILED);
      break;

      default:
        break;
    }
  }


  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
    );

    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
        booking_he.text = _selectedTime!.format(context);
      });
    }
  }


  Future <void> reserver(int car_id,String booking_society,String booking_phone_number, String booking_ifu,String booking_circuit,String booking_le,String booking_ld,String booking_he,String booking_dd,String booking_de,String token,int budget) async {

    print("Voici le prix $budget");
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
          "payment_amount": budget,
        })
    );

    if(response.statusCode == 200){
      update_car();
      //Navigator.pop(context);

      /*Map<String, dynamic> responseBodyMap = json.decode(response.body);
      //Reservation reservation = Reservation.fromJson(json.decode(newResponse.body));
      setState(() {
        print("voici l'id $responseBodyMap['id']");
        reservation_id = responseBodyMap['id'];
      });

        */
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
              "payment_amount": budget,
            })
        );

        print(newResponse.body);
        print(newResponse.statusCode);
        if(newResponse.statusCode==200){
          update_car();

         /* Map<String, dynamic> responseBodyMap = json.decode(newResponse.body);
          setState(() {
            print("voici l'id $responseBodyMap['id']");
            reservation_id = responseBodyMap['id'];

          });
           */

        }else{
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
        // List<dynamic> body = json.decode(newResponse.body);
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

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != DateTime.now()) {
      setState(() {
        booking_de.text = picked.toString().substring(0, 10);
        date1 = picked;
      });
    }
  }

 Future<void> _selectDate_destionation(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != DateTime.now()) {
      setState(() {
        booking_dd.text = picked.toString().substring(0, 10);
        date2=picked;
        if(booking_de!=null){
          nbr_jour =date2.difference(date1).inDays +1;
          budget_minimum = ((widget.voiture.car_price*nbr_jour*minimum_paiement)/100).toInt();
          if(bonus>=budget_minimum){
            bonus_visible=true;
          }
        }
      });
    }
  }

  final TextEditingController booking_he = TextEditingController();
  TextEditingController booking_de = TextEditingController();
  TextEditingController booking_dd = TextEditingController();
  TimeOfDay? _selectedTime;

  void addError({String? error}) {
    if (!errors.contains(error))
      setState(() {
        errors.add(error);
      });
  }

  void removeError({String? error}) {
    if (errors.contains(error))
      setState(() {
        errors.remove(error);
      });
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Réservation de véhicule', style: TextStyle(fontFamily: "Ubuntu", fontSize: 22, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      drawer: CustomDrawer(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 8),
              Text(
                "Infos de la voiture",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: "Nom : ",
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: "${widget.voiture.car_name}",
                      style: TextStyle(fontSize: 15),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: "Type : ",
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text: "${widget.voiture.category_name}",
                          style: TextStyle(fontSize: 15),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 20),
                  // Statut optionnel à ajouter si nécessaire
                ],
              ),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: "Caractéristiques : ",
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: "${widget.voiture.car_features}",
                      style: TextStyle(fontSize: 15),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              Center(
                child: Text(
                  "FORMULAIRE DE RÉSERVATION",
                  style: TextStyle(fontFamily: "Ubuntu", fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),

              SizedBox(height: 16),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    buildAsocietyFormField(),
                    SizedBox(height: 16),
                    buildphone_numberFormField(),
                    SizedBox(height: 16),
                    buildifuFormField(),
                    SizedBox(height: 16),
                    buildcircuitFormField(),
                    SizedBox(height: 16),
                    buildembarquementFormField(),
                    SizedBox(height: 16),
                    builddestinationFormField(),
                    SizedBox(height: 16),
                    buildDateEmbarquementFormField(),
                    SizedBox(height: 16),
                    buildDateDeBarquementFormField(),
                    SizedBox(height: 16),
                    buildHeureEmbarquementFormField(),
                    SizedBox(height: 16),
                    _buildPriceDetails(),
                    SizedBox(height: 16),
                    bonus_visible
                        ? _buildBonusDetails()
                        : SizedBox.shrink(),
                    SizedBox(height: 16),
                    buildamountFormField(),
                    SizedBox(height: 16),
                    FormError(errors: errors),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            _handleReservation();
                          }
                        },
                        child: Text("Réserver", style: TextStyle(fontSize: 18),),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: greenThemeColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 16),
                        ),
                      ),
                    ),

                    SizedBox(height: 16),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

// Fonction pour afficher les détails du prix
  Widget _buildPriceDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Prix journalier : ${widget.voiture.car_price} fcfa",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
        SizedBox(height: 8),
        Text(
          "Nombre de jours : $nbr_jour jours",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
        SizedBox(height: 8),
        Text(
          "Montant total : ${widget.voiture.car_price * nbr_jour} fcfa",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
        SizedBox(height: 8),
        Text(
          "Montant minimum à payer : $budget_minimum fcfa",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
      ],
    );
  }

// Fonction pour afficher les détails des bonus
  Widget _buildBonusDetails() {
    return Padding(
      padding: EdgeInsets.only(right: 130),
      child: Text(
        "Bonus disponible : $bonus points",
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
      ),
    );
  }

// Fonction de gestion de la réservation
  void _handleReservation() {
    showAlertDialog(context);
    if (budget_minimum <= int.parse(budget!) &&
        int.parse(budget!) <= widget.voiture.car_price * nbr_jour) {
      if (allow_bonus == 1 && bonus >= int.parse(budget!)) {
        reserver(
          widget.voiture.id,
          booking_society!,
          booking_phone_number!,
          booking_ifu!,
          booking_circuit!,
          booking_le!,
          booking_ld!,
          booking_he.text,
          booking_dd.text,
          booking_de.text,
          token.toString(),
          int.parse(budget!),
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => KKiaPay(
              amount: 1,
              countries: ["BJ"],
              name: "$firstname $lastname",
              email: email,
              reason: 'Frais de reservation',
              data: 'Fake data',
              sandbox: false,
              apikey: 'ea9e13226779a14133230f82896ed2ad0fd4658b',
              callback: successCallback,
              theme: defaultTheme,
              partnerId: 'AxXxXXxId',
            ),
          ),
        );
      }
    } else {
      Navigator.pop(context);
      showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return AlertDialog(
            title: Text("Réservation"),
            content: Text(
              "Le montant à payer doit être supérieur ou égal à $budget_minimum fcfa "
                  "et inférieur ou égal à ${widget.voiture.car_price * nbr_jour} fcfa",
              textAlign: TextAlign.center,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: Text('OK'),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: vertFonceColor,
                ),
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



//   TextFormField buildembarquementFormField() {
//     return TextFormField(
//       keyboardType: TextInputType.text,
//       obscureText: false,
//       onSaved: (newValue) => booking_le = newValue,
//       onChanged: (value) {
//         if (value.isNotEmpty) {
//           removeError(error: kbooking_leNullError);
//         }
//         booking_le = value;
//       },
//       validator: (value) {
//         if (value!.isEmpty) {
//           addError(error: kbooking_leNullError);
//           return "";
//         }
//         return null;
//       },
//       decoration: InputDecoration(
//        // labelText: "Lieu d'embarquement'",
//         hintText: "Entrez le lieu de depart",
//         // If  you are using latest version of flutter then lable text and hint text shown like this
//         // if you r using flutter less then 1.20.* then maybe this is not working properly
//         floatingLabelBehavior: FloatingLabelBehavior.always,
//         //suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
//       ),
//     );
//   }
//
//   TextFormField builddestinationFormField() {
//     return TextFormField(
//       keyboardType: TextInputType.text,
//       obscureText: false,
//       onSaved: (newValue) => booking_ld = newValue,
//       onChanged: (value) {
//         if (value.isNotEmpty) {
//           removeError(error: kdestinationNullError);
//         }
//         booking_ld = value;
//       },
//       validator: (value) {
//         if (value!.isEmpty) {
//           addError(error: kdestinationNullError);
//           return "";
//         }
//         return null;
//       },
//       decoration: InputDecoration(
//         //labelText: "lieu d'arrivé",
//         hintText: "Entrez le lieu de destination",
//         // If  you are using latest version of flutter then lable text and hint text shown like this
//         // if you r using flutter less then 1.20.* then maybe this is not working properly
//         floatingLabelBehavior: FloatingLabelBehavior.always,
//         //suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
//       ),
//     );
//   }
//
//   /*TextFormField buildheureFormField() {
//     return TextFormField(
//       obscureText: false,
//       onSaved: (newValue) => booking_he = newValue,
//       onChanged: (value) {
//         if (value.isNotEmpty) {
//           removeError(error: kbooking_heNullError);
//         }
//         booking_he = value;
//       },
//       validator: (value) {
//         if (value!.isEmpty) {
//           addError(error: kbooking_heNullError);
//           return "";
//         }
//         return null;
//       },
//       decoration: InputDecoration(
//         labelText: "Heure d'embarquement",
//         hintText: "Entrez l'heure d'embarquement",
//         // If  you are using latest version of flutter then lable text and hint text shown like this
//         // if you r using flutter less then 1.20.* then maybe this is not working properly
//         floatingLabelBehavior: FloatingLabelBehavior.always,
//         //suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
//       ),
//     );
//   }
// */
//   TextFormField buildcircuitFormField() {
//     return TextFormField(
//       obscureText: false,
//       onSaved: (newValue) => booking_circuit = newValue,
//       onChanged: (value) {
//         if (value.isNotEmpty) {
//           removeError(error: kbooking_circuitNullError);
//         }
//         booking_circuit = value;
//       },
//       validator: (value) {
//         if (value!.isEmpty) {
//           addError(error: kbooking_circuitNullError);
//           return "";
//         }
//         return null;
//       },
//       decoration: InputDecoration(
//         //labelText: "Trajet",
//         hintText: "Entrez le trajet",
//         // If  you are using latest version of flutter then lable text and hint text shown like this
//         // if you r using flutter less then 1.20.* then maybe this is not working properly
//         floatingLabelBehavior: FloatingLabelBehavior.always,
//         //suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/adresse.svg"),
//       ),
//     );
//   }
//
//   TextFormField buildAsocietyFormField() {
//     return TextFormField(
//       obscureText: false,
//       onSaved: (newValue) => booking_society = newValue,
//       onChanged: (value) {
//         if (value.isNotEmpty) {
//           removeError(error: kAbooking_societyNullError);
//         }
//         booking_society = value;
//       },
//       validator: (value) {
//         if (value!.isEmpty) {
//           addError(error: kAbooking_societyNullError);
//           return "";
//         }
//         return null;
//       },
//       decoration: InputDecoration(
//        // labelText: "Ville ",
//         hintText: "Entrez votre Ville",
//         // If  you are using latest version of flutter then lable text and hint text shown like this
//         // if you r using flutter less then 1.20.* then maybe this is not working properly
//         floatingLabelBehavior: FloatingLabelBehavior.always,
//       //  suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/about.svg"),
//       ),
//     );
//   }
//
//   TextFormField buildphone_numberFormField() {
//     return TextFormField(
//       obscureText: false,
//       keyboardType: TextInputType.number,
//       onSaved: (newValue) => booking_phone_number = newValue,
//       onChanged: (value) {
//         if (value.isNotEmpty) {
//           removeError(error: kPhoneNumberNullError);
//         }
//         booking_phone_number = value;
//       },
//       validator: (value) {
//         if (value!.isEmpty) {
//           addError(error: kPhoneNumberNullError);
//           return "";
//         }
//         return null;
//       },
//       decoration: InputDecoration(
//        // labelText: "Numéro",
//         hintText: "Entrez votre Télephone",
//         // If  you are using latest version of flutter then lable text and hint text shown like this
//         // if you r using flutter less then 1.20.* then maybe this is not working properly
//         floatingLabelBehavior: FloatingLabelBehavior.always,
//         //suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
//       ),
//     );
//   }
//
//   TextFormField buildamountFormField() {
//     return TextFormField(
//       obscureText: false,
//       keyboardType: TextInputType.number,
//       onSaved: (newValue) => budget = newValue,
//       onChanged: (value) {
//         if (value.isNotEmpty) {
//           removeError(error: kbudgetNullError);
//         }
//         budget = value;
//       },
//       validator: (value) {
//         if (value!.isEmpty) {
//           addError(error: kbudgetNullError);
//           return "";
//         }
//         return null;
//       },
//       decoration: InputDecoration(
//        // labelText: "Numéro",
//         hintText: "Entrez le montant à payer",
//         // If  you are using latest version of flutter then lable text and hint text shown like this
//         // if you r using flutter less then 1.20.* then maybe this is not working properly
//         floatingLabelBehavior: FloatingLabelBehavior.always,
//         //suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
//       ),
//     );
//   }
//
//   TextFormField buildifuFormField() {
//     return TextFormField(
//       keyboardType: TextInputType.number,
//       obscureText: false,
//       onSaved: (newValue) => booking_ifu = newValue,
//       onChanged: (value) {
//         if (value.isNotEmpty) {
//           removeError(error: kbooking_ifuNullError);
//         }
//         booking_ifu = value;
//       },
//       validator: (value) {
//         if (value!.isEmpty) {
//           addError(error: kbooking_ifuNullError);
//           return "";
//         }
//         return null;
//       },
//       decoration: InputDecoration(
//        // labelText: "IFU",
//         hintText: "Entrez votre IFU, Passeport ou Carte CEDEAO",
//         // If  you are using latest version of flutter then lable text and hint text shown like this
//         // if you r using flutter less then 1.20.* then maybe this is not working properly
//         floatingLabelBehavior: FloatingLabelBehavior.always,
//       //  suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/city.svg"),
//       ),
//     );
//   }


  Widget buildembarquementFormField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          keyboardType: TextInputType.text,
          obscureText: false,
          onSaved: (newValue) => booking_le = newValue,
          onChanged: (value) {
            if (value.isNotEmpty) {
              removeError(error: kbooking_leNullError);
            }
            booking_le = value;
          },
          validator: (value) {
            if (value!.isEmpty) {
              addError(error: kbooking_leNullError);
              return "";
            }
            return null;
          },
          decoration: InputDecoration(
            hintText: "Entrez le lieu de départ",
            hintStyle: TextStyle(color: Colors.grey),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
              borderRadius: BorderRadius.all(Radius.circular(80)),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black),
              borderRadius: BorderRadius.all(Radius.circular(80)),
            ),
            floatingLabelBehavior: FloatingLabelBehavior.always,
          ),
        ),
      ],
    );
  }

  Widget builddestinationFormField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          keyboardType: TextInputType.text,
          obscureText: false,
          onSaved: (newValue) => booking_ld = newValue,
          onChanged: (value) {
            if (value.isNotEmpty) {
              removeError(error: kdestinationNullError);
            }
            booking_ld = value;
          },
          validator: (value) {
            if (value!.isEmpty) {
              addError(error: kdestinationNullError);
              return "";
            }
            return null;
          },
          decoration: InputDecoration(
            hintText: "Entrez le lieu de destination",
            hintStyle: TextStyle(color: Colors.grey),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
              borderRadius: BorderRadius.all(Radius.circular(80)),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black),
              borderRadius: BorderRadius.all(Radius.circular(80)),
            ),
            floatingLabelBehavior: FloatingLabelBehavior.always,
          ),
        ),
      ],
    );
  }

  Widget buildcircuitFormField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          obscureText: false,
          onSaved: (newValue) => booking_circuit = newValue,
          onChanged: (value) {
            if (value.isNotEmpty) {
              removeError(error: kbooking_circuitNullError);
            }
            booking_circuit = value;
          },
          validator: (value) {
            if (value!.isEmpty) {
              addError(error: kbooking_circuitNullError);
              return "";
            }
            return null;
          },
          decoration: InputDecoration(
            hintText: "Entrez le trajet",
            hintStyle: TextStyle(color: Colors.grey),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
              borderRadius: BorderRadius.all(Radius.circular(80)),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black),
              borderRadius: BorderRadius.all(Radius.circular(80)),
            ),
            floatingLabelBehavior: FloatingLabelBehavior.always,
          ),
        ),
      ],
    );
  }

  Widget buildAsocietyFormField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          obscureText: false,
          onSaved: (newValue) => booking_society = newValue,
          onChanged: (value) {
            if (value.isNotEmpty) {
              removeError(error: kAbooking_societyNullError);
            }
            booking_society = value;
          },
          validator: (value) {
            if (value!.isEmpty) {
              addError(error: kAbooking_societyNullError);
              return "";
            }
            return null;
          },
          decoration: InputDecoration(
            hintText: "Entrez votre Ville",
            hintStyle: TextStyle(color: Colors.grey),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
              borderRadius: BorderRadius.all(Radius.circular(80)),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black),
              borderRadius: BorderRadius.all(Radius.circular(80)),
            ),
            floatingLabelBehavior: FloatingLabelBehavior.always,
          ),
        ),
      ],
    );
  }

  Widget buildphone_numberFormField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          obscureText: false,
          keyboardType: TextInputType.number,
          onSaved: (newValue) => booking_phone_number = newValue,
          onChanged: (value) {
            if (value.isNotEmpty) {
              removeError(error: kPhoneNumberNullError);
            }
            booking_phone_number = value;
          },
          validator: (value) {
            if (value!.isEmpty) {
              addError(error: kPhoneNumberNullError);
              return "";
            }
            return null;
          },
          decoration: InputDecoration(
            hintText: "Entrez votre Téléphone",
            hintStyle: TextStyle(color: Colors.grey),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
              borderRadius: BorderRadius.all(Radius.circular(80)),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black),
              borderRadius: BorderRadius.all(Radius.circular(80)),
            ),
            floatingLabelBehavior: FloatingLabelBehavior.always,
          ),
        ),
      ],
    );
  }

  Widget buildamountFormField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          obscureText: false,
          keyboardType: TextInputType.number,
          onSaved: (newValue) => budget = newValue,
          onChanged: (value) {
            if (value.isNotEmpty) {
              removeError(error: kbudgetNullError);
            }
            budget = value;
          },
          validator: (value) {
            if (value!.isEmpty) {
              addError(error: kbudgetNullError);
              return "";
            }
            return null;
          },
          decoration: InputDecoration(
            hintText: "Entrez le montant à payer",
            hintStyle: TextStyle(color: Colors.grey),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
              borderRadius: BorderRadius.all(Radius.circular(80)),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black),
              borderRadius: BorderRadius.all(Radius.circular(80)),
            ),
            floatingLabelBehavior: FloatingLabelBehavior.always,
          ),
        ),
      ],
    );
  }

  Widget buildifuFormField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          keyboardType: TextInputType.number,
          obscureText: false,
          onSaved: (newValue) => booking_ifu = newValue,
          onChanged: (value) {
            if (value.isNotEmpty) {
              removeError(error: kbooking_ifuNullError);
            }
            booking_ifu = value;
          },
          validator: (value) {
            if (value!.isEmpty) {
              addError(error: kbooking_ifuNullError);
              return "";
            }
            return null;
          },
          decoration: InputDecoration(
            hintText: "Entrez votre IFU, Passeport ou Carte CEDEAO",
            hintStyle: TextStyle(color: Colors.grey),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
              borderRadius: BorderRadius.all(Radius.circular(80)),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black),
              borderRadius: BorderRadius.all(Radius.circular(80)),
            ),
            floatingLabelBehavior: FloatingLabelBehavior.always,
          ),
        ),
      ],
    );
  }

  Widget buildDateEmbarquementFormField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: booking_de,
          decoration: InputDecoration(
            hintText: 'Date d\'embarquement',
            hintStyle: TextStyle(color: Colors.grey),
            suffixIcon: IconButton(
              icon: Icon(Icons.calendar_today),
              onPressed: () => _selectDate(context),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
              borderRadius: BorderRadius.all(Radius.circular(80)),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black),
              borderRadius: BorderRadius.all(Radius.circular(80)),
            ),
            floatingLabelBehavior: FloatingLabelBehavior.always,
          ),
          keyboardType: TextInputType.datetime,
          onTap: () => _selectDate(context),
        ),
        SizedBox(height: 16),
      ],
    );
  }

  Widget buildDateDeBarquementFormField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: booking_dd,
          decoration: InputDecoration(
            hintText: 'Date de débarquement',
            hintStyle: TextStyle(color: Colors.grey),
            suffixIcon: IconButton(
              icon: Icon(Icons.calendar_today),
              onPressed: () => _selectDate_destionation(context),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
              borderRadius: BorderRadius.all(Radius.circular(80)),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black),
              borderRadius: BorderRadius.all(Radius.circular(80)),
            ),
            floatingLabelBehavior: FloatingLabelBehavior.always,
          ),
          keyboardType: TextInputType.datetime,
          onTap: () => _selectDate_destionation(context),
        ),
        SizedBox(height: 16),
      ],
    );
  }

  Widget buildHeureEmbarquementFormField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: booking_he,
          readOnly: true,
          onTap: _selectTime,
          decoration: InputDecoration(
            hintText: 'Heure d\'embarquement',
            hintStyle: TextStyle(color: Colors.grey),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
              borderRadius: BorderRadius.all(Radius.circular(80)),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black),
              borderRadius: BorderRadius.all(Radius.circular(80)),
            ),
            floatingLabelBehavior: FloatingLabelBehavior.always,
          ),
        ),
        SizedBox(height: 16),
      ],
    );
  }

}