import 'package:eyav2/constants.dart';
import 'package:eyav2/new/drawer.dart';
import 'package:eyav2/new/search_car.dart';
import 'package:eyav2/new/search_conductor.dart';
import 'package:eyav2/widgets/homePage/Conducteur_request/All_request_conducteur.dart';
import 'package:eyav2/widgets/homePage/Voitures/All_cars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SearchSelector extends StatefulWidget {
  final String token;
  const SearchSelector({super.key,required this.token});

  @override
  State<SearchSelector> createState() => _SearchSelectorState();
}

class _SearchSelectorState extends State<SearchSelector> {
  var _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Recherches", style: TextStyle(fontFamily: "Ubuntu", fontSize: 22, fontWeight: FontWeight.bold),),
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
                          "assets/icons/icon_car.svg",
                          width: 50,
                          height: 50,
                          color: Color(0xFF0EA000),
                        ),
                        SizedBox(height: 20,),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => CarsListingWidget(token: widget.token)));
                          },
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                            backgroundColor: greenThemeColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(80),
                            ),
                          ),
                          child: Text("Recherches de véhicules", style: TextStyle(color: Colors.white, fontSize: 14)),
                        ),
                      ],
                    ),
                    SizedBox(height: 50,),
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
                            Navigator.push(context,
                              MaterialPageRoute(builder: (ctxt) => R_conducteurListingWidget(token:widget.token!)),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                            backgroundColor: greenThemeColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(80),
                            ),
                          ),
                          child: Text("Recherches de conducteurs", style: TextStyle(color: Colors.white, fontSize: 14)),
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
