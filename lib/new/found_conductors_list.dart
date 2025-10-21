import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:eyav2/components/form_error.dart';
import 'package:eyav2/modeles/Conducteur_reponse.dart';
import 'package:eyav2/new/single_conductor.dart';
import 'package:eyav2/widgets/homePage/Conducteur_request/All_request_conducteur.dart';
import 'package:http/http.dart' as http;
import 'package:eyav2/constants.dart';
import 'package:eyav2/global_config.dart';
import 'package:eyav2/function/function.dart' as function;
import 'package:eyav2/new/add_conductor.dart';
import 'package:eyav2/new/drawer.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FoundConductorsListScreen extends StatefulWidget {
  int request_id;
  FoundConductorsListScreen({super.key, required this.request_id});
  @override
  State<FoundConductorsListScreen> createState() => _FoundConductorsListScreenState();
}

class _FoundConductorsListScreenState extends State<FoundConductorsListScreen> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController? textController;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool isSearchStarted = false;

  List<Conducteur_reponse> searchedConductors = [];
  List<Conducteur_reponse> conductorsList = [];
  bool filterAscending = false;
  bool filterDescending = false;

  @override
  void initState() {
    super.initState();
    function.getConducteurbyRequest_id(widget.request_id).then((value) {
      if (value != null) {
        setState(() {
          conductorsList.addAll(value);
        });
      }
    });
    textController = TextEditingController();
  }

  void applyFilters() {
    if (filterAscending) {
      conductorsList.sort((a, b) => a.driver_year.compareTo(b.driver_year));
    } else if (filterDescending) {
      conductorsList.sort((a, b) => b.driver_year.compareTo(a.driver_year));
    } else {
      // Réinitialise la liste si aucun filtre n'est actif
      function.getConducteurbyRequest_id(widget.request_id).then((value) {
        if (value != null) {
          setState(() {
            conductorsList = value;
          });
        }
      });
    }
  }

  void searchConductors() {
    isSearchStarted = textController!.text.isNotEmpty;
    if (isSearchStarted) {
      searchedConductors = conductorsList.where((item) =>
      item.driver_firstname.toLowerCase().contains(textController!.text.trim().toLowerCase()) ||
          item.driver_lastname.toLowerCase().contains(textController!.text.trim().toLowerCase()) ||
          item.driver_city.toLowerCase().contains(textController!.text.trim().toLowerCase())).toList();
    } else {
      searchedConductors = conductorsList;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Mes demandes", style: TextStyle(fontFamily: "Ubuntu", fontSize: 22, fontWeight: FontWeight.bold),),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      drawer: CustomDrawer(),
      body: conductorsList.isEmpty
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Conducteurs", style: TextStyle(fontFamily: "Ubuntu", fontSize: 24, fontWeight: FontWeight.bold)),
              ],
            ),
            SizedBox(height: 20),
            TextFormField(
              keyboardType: TextInputType.text,
              controller: textController,
              onChanged: (_) => EasyDebounce.debounce(
                'tFMemberController',
                Duration(milliseconds: 500),
                searchConductors,
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
                suffixIcon: GestureDetector(onTap: searchConductors, child: Icon(Icons.search)),
              ),
            ),
            SizedBox(height: 20),
            Wrap(
              alignment: WrapAlignment.center,
              children: [
                FilterButton(
                  label: "Année croissante",
                  onPress: () {
                    setState(() {
                      filterAscending = true;
                      filterDescending = false;
                      applyFilters();
                    });
                  },
                  selected: filterAscending,
                ),
                FilterButton(
                  label: "Année décroissante",
                  onPress: () {
                    setState(() {
                      filterDescending = true;
                      filterAscending = false;
                      applyFilters();
                    });
                  },
                  selected: filterDescending,
                ),
              ],
            ),
            SizedBox(height: 30),
            Expanded(
              child: ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                itemCount: (isSearchStarted ? searchedConductors : conductorsList).length,
                itemBuilder: (context, index) {
                  final conductor = isSearchStarted ? searchedConductors[index] : conductorsList[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => SingleConductorScreen(conductor: conductor)));
                    },
                    child: DriverTile(
                      itemNo: index,
                      conductor: conductor,
                    ),
                  );
                },
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
  final VoidCallback onPress;
  final bool selected;

  FilterButton({required this.label, required this.onPress, this.selected = false});

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
            if (selected) ...[
              Icon(Icons.check, color: Colors.white, size: 16),
              SizedBox(width: 8),
            ],
            Text(label, style: TextStyle(color: selected ? Colors.white : Colors.black)),
          ],
        ),
      ),
    );
  }
}


// Widget pour afficher chaque conducteur
class DriverTile extends StatefulWidget {
  final int itemNo;
  final Conducteur_reponse conductor;

  DriverTile({
    super.key,
    this.itemNo = 0,
    required this.conductor,
  });

  @override
  State<DriverTile> createState() => _DriverTileState();
}

class _DriverTileState extends State<DriverTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5,),
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 60,
            // backgroundImage: NetworkImage("${Configuration.base_url_mage}/Driver_${widget.conductor.id}/${widget.conductor.driver_photo}.jpg"),
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
          ),
          SizedBox(width: 20),
          Expanded(
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("${widget.conductor.driver_firstname} ${widget.conductor.driver_lastname}", style: TextStyle(fontFamily: "Ubuntu", fontWeight: FontWeight.bold, fontSize: 18),),
                  SizedBox(height: 2),
                  Text(widget.conductor.driver_year, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                  // Icon(Icons.star, color: Colors.orange, size: 20,),
                  SizedBox(height: 2),
                  Text("${widget.conductor.driver_city}", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: greenThemeColor)),
                ],
              ),
            ),
          ),
        ],
    ));
  }
}
