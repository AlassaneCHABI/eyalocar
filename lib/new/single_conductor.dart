import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:eyav2/new/found_conductors_list.dart';
import 'package:http/http.dart' as http;
import 'package:eyav2/constants.dart';
import 'package:eyav2/global_config.dart';
import 'package:eyav2/modeles/Conducteur_reponse.dart';
import 'package:eyav2/new/drawer.dart';
import 'package:eyav2/new/update_profile.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class SingleConductorScreen extends StatefulWidget {
  final Conducteur_reponse conductor;
  SingleConductorScreen({
    super.key,
    required this.conductor
  });

  @override
  State<SingleConductorScreen> createState() => _SingleConductorScreenState();
}

class _SingleConductorScreenState extends State<SingleConductorScreen> {
  var _isLoading = false;

  @override
  void initState() {
    super.initState();

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Détails du conducteur", style: TextStyle(fontFamily: "Ubuntu", fontSize: 20, fontWeight: FontWeight.bold),),
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black),
        ),
        drawer: CustomDrawer(),
        // bottomNavigationBar: BottomNavBar(),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  // margin: EdgeInsets.symmetric(vertical: 5,),
                  // padding: EdgeInsets.all(8),
                  // decoration: BoxDecoration(
                  //   color: Colors.grey[200],
                  //   borderRadius: BorderRadius.circular(10),
                  // ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 60,
                        child: CachedNetworkImage(
                          imageUrl: "${Configuration.base_url_mage}/Driver_${widget.conductor.id}/${widget.conductor.driver_photo}.jpg",
                          placeholder: (context, url) =>
                              CircularProgressIndicator(),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                          imageBuilder: (context, imageProvider) =>
                              CircleAvatar(
                                radius: 60,
                                backgroundImage: imageProvider,
                              ),
                        ),
                        // backgroundImage: NetworkImage("${Configuration.base_url_mage}/Driver_${widget.conductor.id}/${widget.conductor.driver_photo}.jpg"),
                      ),
                      SizedBox(width: 20),
                      Expanded(
                        child: Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("${widget.conductor.driver_firstname} ${widget.conductor.driver_lastname}", style: TextStyle(fontFamily: "Ubuntu", fontWeight: FontWeight.bold, fontSize: 18),),
                              SizedBox(height: 2),
                              Text("${widget.conductor.driver_address}, ${widget.conductor.driver_city}", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                              // Icon(Icons.star, color: Colors.orange, size: 20,),
                              SizedBox(height: 2),
                              Text("${widget.conductor.driver_year}", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: greenThemeColor)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                ),
                SizedBox(height: 20,),
                Text(
                  "Email ",
                  style: TextStyle(fontFamily: "Ubuntu", fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text(
                  "${widget.conductor.driver_email}",
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 20,),
                Text(
                  "Téléphone ",
                  style: TextStyle(fontFamily: "Ubuntu", fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text(
                  "${widget.conductor.driver_phone_number}",
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 20,),
                Text(
                  "Permis ",
                  style: TextStyle(fontFamily: "Ubuntu", fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text(
                  "${widget.conductor.driver_type}",
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 20,),
                // Text(
                //   "Expérience ",
                //   style: TextStyle(fontFamily: "Ubuntu", fontSize: 24, fontWeight: FontWeight.bold),
                // ),
                // SizedBox(height: 10),
                // Column(
                //   children: [
                //     experienceRadio("Adobe Photoshop"),
                //     experienceRadio("Adobe Illustrator"),
                //     experienceRadio("Adobe Indesign"),
                //     experienceRadio("Adobe XD"),
                //     experienceRadio("Adobe Lightroom"),
                //     experienceRadio("Adobe Premiere Pro"),
                //     experienceRadio("Adobe After Effect"),
                //     experienceRadio("Cinema 4D"),
                //     experienceRadio("Sketch"),
                //   ],
                // ),
                SizedBox(height: 10),
                widget.conductor.status=="not reserved"? SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
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
                              "rrdriver_id": widget.conductor.rrdriver_id,
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
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => FoundConductorsListScreen(request_id: widget.conductor.request_id,)));
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
                                  "rrdriver_id": widget.conductor.rrdriver_id
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
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => FoundConductorsListScreen(request_id: widget.conductor.request_id,)));
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
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: greenThemeColor,
                      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      'Réserver',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ) : Text(""),
            ]),
          ),
        )
    );

  }

  String selectedExperience = "";
  Widget experienceRadio(String experience) {
    return Row(
      children: [
        Radio<String>(
          value: experience,
          groupValue: selectedExperience,
          onChanged: (value) {
            setState(() {
              selectedExperience = value!;
            });
          },
        ),
        Text(experience, style: TextStyle(fontSize: 18)),
      ],
    );
  }


}
