import 'package:eyav2/constants.dart';
import 'package:eyav2/delete_compte/delete_compte.dart';
import 'package:eyav2/new/drawer.dart';
import 'package:eyav2/new/search_car.dart';
import 'package:eyav2/new/search_conductor.dart';
import 'package:eyav2/new/user_profile.dart';
import 'package:eyav2/profil/profil_ui.dart';
import 'package:eyav2/widgets/homePage/Conducteur_request/All_request_conducteur.dart';
import 'package:eyav2/widgets/homePage/Voitures/All_cars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class setting extends StatefulWidget {

  const setting({super.key});

  @override
  State<setting> createState() => _settingState();
}

class _settingState extends State<setting> {
  var _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Paramètre", style: TextStyle(fontFamily: "Ubuntu", fontSize: 22, fontWeight: FontWeight.bold),),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      drawer: CustomDrawer(),

      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Material(
              elevation: 5,
              child: Container(
                // height: 200,
                // width: 200,
                padding: EdgeInsets.symmetric(vertical: 30, horizontal: 30),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.fromBorderSide(BorderSide(style: BorderStyle.solid))
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        SvgPicture.asset(
                          "assets/icons/icon_person.svg",
                          width: 50,
                          height: 50,
                          color: Color(0xFF0EA000),
                        ),
                        SizedBox(height: 20,),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => AuthUserProfile()));
                          },
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                            backgroundColor: greenThemeColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(80),
                            ),
                          ),
                          child: Text("Profil utilisateur", style: TextStyle(color: Colors.white, fontSize: 14)),
                        ),
                      ],
                    ),
                    SizedBox(height: 50,),
                    Column(
                      children: [
                        SvgPicture.asset(
                          "assets/icons/trash.svg",
                          width: 50,
                          height: 50,
                          color: Color(0xFF0EA000),
                        ),
                        SizedBox(height: 20,),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(context,
                              MaterialPageRoute(builder: (ctxt) => DeleteCompteScreen()),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                            backgroundColor: greenThemeColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(80),
                            ),
                          ),
                          child: Text("Suppression du compte", style: TextStyle(color: Colors.white, fontSize: 14)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
