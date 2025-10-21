import 'package:eyav2/constants.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:eyav2/app_theme.dart';
import 'package:eyav2/modeles/Voiture.dart';
import 'package:eyav2/modeles/request_cars.dart';
import 'package:eyav2/new/drawer.dart';
import 'package:eyav2/widgets/homePage/Voitures/Voiture_liste.dart';
import 'package:flutter/material.dart';
import 'package:eyav2/function/function.dart' as function;
import '../../DrawerMenuWidget.dart';
import '../../bottomnav.dart';

class CarsListingWidget extends StatefulWidget {

  String token;
  CarsListingWidget({Key? key,required this.token}) : super(key: key);

  @override
  _CarsListingWidgetState createState() => _CarsListingWidgetState();
}

class _CarsListingWidgetState extends State<CarsListingWidget> {
  TextEditingController? textController;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool isSearchStarted = false;

  List<Request_cars> searchedVoitures = [];
  final List<Request_cars> voiture = [];


  void initState() {
    super.initState();
    function.getsearch(widget.token).then((value){
      if(value!=null){
        setState(() {
          voiture.addAll(value);
        });
      }
    });
    textController = TextEditingController();
  }


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      // key: scaffoldKey,
      // backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Vos demandes", style: TextStyle(fontFamily: "Ubuntu", fontSize: 22, fontWeight: FontWeight.bold),),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      drawer: CustomDrawer(),
      // bottomNavigationBar: bottomNvigator(),


      body:voiture.length==0?Center(child: CircularProgressIndicator(),):  Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: VoitureList(
              voiture: isSearchStarted ? searchedVoitures: voiture,
            ),
          ),
        ],
      ),
     // bottomNavigationBar: CustomBottomNavBar(selectedMenu: MenuState.home),
    );
  }
}
