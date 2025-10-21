import 'dart:convert';
import 'dart:io';

import 'package:easy_debounce/easy_debounce.dart';
import 'package:eyav2/Historique/H_paiement.dart';
import 'package:eyav2/function/function.dart' as function;
import 'package:eyav2/components/form_error.dart';
import 'package:eyav2/constants.dart';
import 'package:eyav2/global_config.dart';
import 'package:eyav2/modeles/Categorie.dart';
import 'package:eyav2/modeles/Reservation.dart';
import 'package:eyav2/modeles/Setting.dart';
import 'package:eyav2/modeles/Voiture.dart';
import 'package:eyav2/new/add_car.dart';
import 'package:eyav2/new/single_car.dart';
import 'package:eyav2/reservation/HisrotiqueList.dart';
import 'package:eyav2/reservation/historique.dart';
import 'package:eyav2/widgets/homePage/Voitures/All_cars.dart';
import 'package:http/http.dart' as http;
import 'package:eyav2/new/drawer.dart';
import 'package:flutter/material.dart';
import 'package:kkiapay_flutter_sdk/kkiapay_flutter_sdk.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FoundCarsListScreen extends StatefulWidget {
  final int request_id;
  FoundCarsListScreen({super.key, required this.request_id});

  @override
  State<FoundCarsListScreen> createState() => _FoundCarsListScreenState();
}

class _FoundCarsListScreenState extends State<FoundCarsListScreen> {
  late TextEditingController textController;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool isSearchStarted = false;
  List<Voitures> searchedCars = [];
  final List<Voitures> carsList = [];
  List<Voitures> displayedCars = [];
  List<bool> filterSelected = [false, false, false, false];

  @override
  void initState() {
    super.initState();
    function.getVoiturebyRequest_id(widget.request_id).then((value) {
      if (value != null) {
        setState(() {
          carsList.addAll(value);
          displayedCars = List.from(carsList);
        });
      }
    });
    textController = TextEditingController();
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  void toggleFilter(int index) {
    setState(() {

      filterSelected = [false, false, false, false];
      filterSelected[index] = !filterSelected[index];


      if (!filterSelected.contains(true)) {
        displayedCars = List.from(carsList);
      } else {

        displayedCars = List.from(isSearchStarted ? searchedCars : carsList);
        switch (index) {
          case 0:
            displayedCars.sort((a, b) => int.parse(b.car_year).compareTo(int.parse(a.car_year))); // Plus récent
            break;
          case 1:
            displayedCars.sort((a, b) => int.parse(a.car_year).compareTo(int.parse(b.car_year))); // Plus ancien
            break;
          case 2:
            displayedCars.sort((a, b) => a.car_price.compareTo(b.car_price)); // Prix croissant
            break;
          case 3:
            displayedCars.sort((a, b) => b.car_price.compareTo(a.car_price)); // Prix décroissant
            break;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Mes demandes", style: TextStyle(fontFamily: "Ubuntu", fontSize: 22, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      drawer: CustomDrawer(),
      body: carsList.isEmpty
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Voitures", style: TextStyle(fontFamily: "Ubuntu", fontSize: 24, fontWeight: FontWeight.bold)),
              ],
            ),
            SizedBox(height: 20),
            TextFormField(
              keyboardType: TextInputType.text,
              controller: textController,
              obscureText: false,
              textInputAction: TextInputAction.search,
              onChanged: (_) => EasyDebounce.debounce(
                'tFMemberController',
                Duration(milliseconds: 300),
                    () {
                  setState(() {
                    isSearchStarted = textController.text.isNotEmpty && textController.text.trim().length > 0;
                    if (isSearchStarted) {
                      searchedCars = carsList
                          .where((item) =>
                      item.car_name.toLowerCase().contains(textController.text.trim().toLowerCase()) ||
                          item.car_year.toLowerCase().contains(textController.text.trim().toLowerCase()))
                          .toList();
                    }
                    displayedCars = List.from(isSearchStarted ? searchedCars : carsList);
                  });
                },
              ),
              decoration: InputDecoration(
                hintText: "Rechercher",
                hintStyle: TextStyle(color: Colors.grey),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.all(Radius.circular(80)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                  borderRadius: BorderRadius.all(Radius.circular(80)),
                ),
                suffixIcon: Icon(Icons.search),
              ),
            ),
            SizedBox(height: 20),
            Wrap(
              alignment: WrapAlignment.center,
              children: [
                FilterButton(
                  label: "Plus récent",
                  selected: filterSelected[0],
                  onPress: () => toggleFilter(0),
                ),
                FilterButton(
                  label: "Plus ancien",
                  selected: filterSelected[1],
                  onPress: () => toggleFilter(1),
                ),
                FilterButton(
                  label: "Prix croissant",
                  selected: filterSelected[2],
                  onPress: () => toggleFilter(2),
                ),
                FilterButton(
                  label: "Prix décroissant",
                  selected: filterSelected[3],
                  onPress: () => toggleFilter(3),
                ),
              ],
            ),
            SizedBox(height: 30),
            Expanded(
              child: GridView.builder(
                physics: NeverScrollableScrollPhysics(),
                itemCount: displayedCars.length,
                itemBuilder: (context, index) {
                  return CarCard(
                    itemNo: index,
                    car: displayedCars[index],
                  );
                },
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: MediaQuery.of(context).size.width / MediaQuery.of(context).size.width,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FilterButton extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onPress;

  FilterButton({required this.label, required this.selected, required this.onPress});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: ElevatedButton(
        onPressed: onPress,
        style: ElevatedButton.styleFrom(
          backgroundColor: selected ? Colors.green : Colors.grey[300],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (selected) Icon(Icons.check, color: Colors.white, size: 16),
            SizedBox(width: 8),
            Text(label, style: TextStyle(color: selected ? Colors.white : Colors.black)),
          ],
        ),
      ),
    );
  }
}

// class CarCard extends StatelessWidget {
//   final int itemNo;
//   final Voitures car;
//
//   CarCard({super.key, this.itemNo = 0, required this.car});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.all(10),
//       decoration: BoxDecoration(
//         color: Color(0xFFD9FFD9),
//         borderRadius: BorderRadius.circular(20),
//       ),
//       child: Column(
//         // mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           // Padding(
//           //   padding: const EdgeInsets.all(8.0),
//           //   child: Row(
//           //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           //     children: [
//           //       Container(),
//           //       Icon(
//           //         Icons.favorite_border,
//           //         color: Colors.black,
//           //       ),
//           //     ],
//           //   ),
//           // ),
//           // SizedBox(height: 10,),
//           Image.network(
//             "${Configuration.base_url_mage}/Car_${car.id}/${car.car_exterior_img}.jpg",
//             fit: BoxFit.cover,
//             height: 80,
//           ),
//           // SizedBox(height: 10),
//           // Text("${car.car_name}"),
//           SizedBox(height: 10),
//           SizedBox(
//             width: double.infinity,
//             child: ElevatedButton(
//               onPressed: () {
//                 Navigator.push(context, MaterialPageRoute(builder: (context) => SingleCarScreen(car: car)));
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.green,
//                 foregroundColor: Colors.white,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//               ),
//               child: Text("${car.car_name}", style: TextStyle(fontSize: 16)),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

class CarCard extends StatelessWidget {
  final int itemNo;
  final Voitures car;

  const CarCard({
    Key? key,
    required this.itemNo,
    required this.car,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Récupère la largeur de l'écran
    double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      width: screenWidth / 2.5,
      margin: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: Color(0xFFD9FFD9),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Flexible(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(8.0)),
              child: Image.network(
                "${Configuration.base_url_mage}/Car_${car.id}/${car.car_exterior_img}.jpg",
                height: screenWidth / 4,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => SingleCarScreen(car: car)));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Text(
                car.car_name,
                style: TextStyle(
                  fontSize: screenWidth * 0.04,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),

    );
  }
}
