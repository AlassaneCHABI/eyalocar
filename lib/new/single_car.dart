import 'dart:io';

import 'package:eyav2/components/form_error.dart';
import 'package:eyav2/constants.dart';
import 'package:eyav2/function/function.dart';
import 'package:eyav2/global_config.dart';
import 'package:eyav2/modeles/Categorie.dart';
import 'package:eyav2/modeles/Reservation.dart';
import 'package:eyav2/modeles/Voiture.dart';
import 'package:eyav2/new/drawer.dart';
import 'package:eyav2/new/entry_screen.dart';
import 'package:eyav2/new/sign-in.dart';
import 'package:eyav2/reservation/reserver.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class SingleCarScreen extends StatefulWidget {
  final Voitures car;
  SingleCarScreen({Key? key, required this.car,});
  @override
  State<SingleCarScreen> createState() => _SingleCarScreenState();
}

class _SingleCarScreenState extends State<SingleCarScreen> {
  String? selectedImageUrl;
  DateTime now = DateTime.now();

  List<String> carImagesUrl = [];

  // Fonction pour sélectionner une image à afficher en grand
  void _selectImage(String imageUrl) {
    setState(() {
      selectedImageUrl = imageUrl;
    });
  }
  String imgBaseUrl(imgString) {
    return "${Configuration.base_url_mage}/Car_${widget.car.id}/${imgString}.jpg";
  }

  @override
  void initState() {
    super.initState();
    carImagesUrl = [
      imgBaseUrl(widget.car.car_exterior_img),
      imgBaseUrl(widget.car.car_interior_img),
      imgBaseUrl(widget.car.car_front_img),
      imgBaseUrl(widget.car.car_rear_img),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Détails de la voiture',
          style: TextStyle(fontFamily: "Ubuntu", fontSize: 22, color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      drawer: CustomDrawer(),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          decoration: BoxDecoration(
            color: Color(0xFFD9FFD9),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              Container(
                // padding: EdgeInsets.all(20),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20,),

                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      // height: double.infinity,
                      width: double.infinity,
                      // decoration: BoxDecoration(
                      //   color: Colors.white,
                      //   borderRadius: BorderRadius.circular(15),
                      // ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text("${widget.car.car_name}", style: TextStyle(fontFamily: "Ubuntu", fontSize: 22, fontWeight: FontWeight.bold),),
                                  Text("${widget.car.car_year}", style: TextStyle(fontFamily: "Ubuntu", fontSize: 20),),
                                ],
                              ),
                              Icon(Icons.favorite_border),
                            ],
                          ),
                          SizedBox(height: 20,),
                          selectedImageUrl != null
                            ? Image.network(selectedImageUrl!, fit: BoxFit.cover)
                            : Image.network(carImagesUrl[0], fit: BoxFit.cover),
                        ],
                      ),
                    ),
                    SizedBox(height: 20,),
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Color(0xFFD9FFD9),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        children: [
                          Container(
                            height: 100,
                            child: Row(
                              children: List.generate(4, (index) {
                                return Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      if (index < carImagesUrl.length && carImagesUrl[index] != null) {
                                        _selectImage(carImagesUrl[index]!); // Sélectionner l'image à afficher en grand
                                      }
                                    },
                                    child: Container(
                                      height: 80,
                                      width: MediaQuery.of(context).size.width / 5,
                                      padding: EdgeInsets.all(5),
                                      margin: EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                        // border: Border.all(color: Colors.grey),
                                      ),
                                      child: carImagesUrl.length > index
                                          ? Image.network(carImagesUrl[index], fit: BoxFit.cover)
                                          : Icon(Icons.image, size: 60, color: Colors.grey), // Si aucune image
                                    ),
                                  ),
                                );},),
                            ),
                          ),

                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      height: 250,
                      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: [
                          Text(" ${widget.car.car_features}"),
                          SizedBox(height: 30,),
                          Row(
                            children: [
                              Icon(Icons.access_time),
                              SizedBox(width: 10,),
                              Text("${widget.car.car_year}")
                            ],
                          ),
                          SizedBox(height: 20,),
                          Row(
                            children: [
                              Icon(Icons.category_outlined),
                              SizedBox(width: 10,),
                              Text("${widget.car.category_name}")
                            ],
                          ),
                          SizedBox(height: 20,),
                          Row(
                            children: [
                              Icon(Icons.monetization_on_outlined),
                              SizedBox(width: 10,),
                              Text("${widget.car.car_price}")
                            ],
                          ),
                          // SizedBox(height: 20,),
                          // Row(
                          //   children: [
                          //     Icon(Icons.ac_unit),
                          //     SizedBox(width: 10,),
                          //     Text("${widget.car.}")
                          //   ],
                          // ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    widget.car.status=="not reserved" ?SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (ctxt) => new Reserver(voiture: widget.car))
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: greenThemeColor,
                          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text("Réserver cette voiture", style: TextStyle(color: Colors.white, fontSize: 16),),
                      ),
                    ) : Text(""),
                    SizedBox(height: 20),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

}
