import 'dart:convert';
import 'dart:io';
import 'package:eyav2/AjoutAlerte/Ajout_Alerte.dart';
import 'package:eyav2/AjoutConducteur/Ajout_conducteur.dart';
import 'package:eyav2/AjoutVoiture/Ajout_voiture.dart';
import 'package:eyav2/TopPromoSlider.dart';
import 'package:eyav2/global_config.dart';
import 'package:eyav2/widgets/homePage/Conducteur/Liste_conducteur.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Recherche_voiture/components/Recherche_form.dart';
import '../constants.dart';
import '../widgets/DrawerMenuWidget.dart';
import 'package:http/http.dart ' as http;

import '../widgets/bottomnav_accueil.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var _isLoading = false;
  late String username;
  late String lastname;
  late String firstname;
  late String city;
  late String address;
  late String type_identifier;
  late String identifier;
  late String email;
  late String token;
  late int bonus =0;
  late String bonus_expiration;



  Future<void>  getBonus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token= prefs.getString("token");
    var url = Uri.http('${Configuration.base_url}', 'apiv2/auth/profile');
    final response = await http.post(
      url,
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.acceptHeader: 'application/json',
        HttpHeaders.authorizationHeader:'Bearer $token'
      },
    );
    print("le token $token");
    print(response.statusCode);
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
        );
        print(newResponse.statusCode);
        print(newResponse.body);
        // Utiliser json.decode pour obtenir une carte (Map<String, dynamic>)
        Map<String, dynamic> responseBodyMap = json.decode(newResponse.body);

        setState(() {
          bonus = responseBodyMap['bonus'];
          prefs.setInt("bonus",bonus);
        });
        prefs.setInt("bonus",bonus);
        print("Voici le bonus $bonus");


      }
    }else if(response.statusCode == 200){
      print(response.statusCode);
      print(response.body);
      Map<String, dynamic> responseBodyMap = json.decode(response.body);

      setState(() {
        bonus = responseBodyMap['bonus'];
        prefs.setInt("bonus",bonus);
      });
      prefs.setInt("bonus",bonus);
      print("Voici le bonus $bonus");


    }

  }

  _launchURL(String link) async {
    var url = link;
    await launchUrl(Uri.parse(url));
  }

  void openWhatsAppWithMessage(String message, String phoneNumber) async {
    String url = 'https://wa.me/$phoneNumber?text=${Uri.encodeFull(message)}';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }

  }

  @override
  void initState() {
    super.initState();
    getBonus();
   print("test");
  }

  final scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size; //check the size of device
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isDarkMode = brightness ==
        Brightness.dark; //check if device is in dark or light mode

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(40.0), //appbar size
        child: AppBar(
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(
                  Icons.menu,
                  color: Colors.white,
                ),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
                tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
              );
            },
          ),
          bottomOpacity: 0.0,
          elevation: 0.0,
          shadowColor: Colors.transparent,
          backgroundColor: kPrimaryColor, //appbar bg color
          /*leading: Padding(
            padding: EdgeInsets.only(
              left: size.width * 0.05,
            ),
            child: SizedBox(
              height: size.width * 0.1,
              width: size.width * 0.1,
              child: Container(
                decoration: BoxDecoration(
                  color: isDarkMode
                      ? const Color(0xff070606)
                      : Colors.white, //icon bg color
                  borderRadius: const BorderRadius.all(
                    Radius.circular(
                      10,
                    ),
                  ),
                ),
                child: IconButton(
                  //UniconsLine.bars,
                  icon: Icon(Icons.menu),
                  color: isDarkMode
                      ? Colors.white
                      : const Color(0xff3b22a1), //icon bg color
                  //size: size.height * 0.025,
                  onPressed: (){
                    if(scaffoldKey.currentState!.isDrawerOpen){
                      scaffoldKey.currentState!.closeDrawer();
                      //close drawer, if drawer is open
                    }else{
                      scaffoldKey.currentState!.openDrawer();
                      //open drawer, if drawer is closed
                    }
                  },
                ),
              ),
            ),
          ),*/
          automaticallyImplyLeading: false,
          titleSpacing: 0,
          leadingWidth: size.width * 0.15,
          title: Image.asset(
            isDarkMode
                ? 'assets/logo_white.jpg'
                : 'assets/logo_white.jpg',
            height: size.height * 0.06,
            width: size.width * 0.35,
          ),
          centerTitle: true,
        ),
      ),
      drawer: DrawerMenuWidget(),
      extendBody: true,
      extendBodyBehindAppBar: true,
      bottomNavigationBar: bottomNvigator(),
      body:SingleChildScrollView(
          child:
      Center(
        child: Container(
          height: size.height,
          width: size.height,
          /*decoration: BoxDecoration(
            color: const Color(0xfff8f8f8), //background color
          ),*/
          child: SafeArea(
            child: ListView(
              children: [
                // Container(
                //
                //     margin: EdgeInsets.only(left: 10,right: 10),
                //     child:TopPromoSlider()
                // ),
                Padding(padding: EdgeInsets.only(top: size.height*0.0),
                child:Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0), // Border radius
                      side: BorderSide(
                        color: kPrimaryColor, // Border color
                        width: 0.0, // Border width
                      ),
                    ),
                    child:Image.asset("assets/AFFICHE4.png")
                ),),
                SizedBox(height: 10,),
               Padding(
                padding: EdgeInsets.all(15),
                    child: TextButton(
                      style: TextButton.styleFrom(
                        //shape:
                        //RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                       // primary: Colors.white,
                        backgroundColor: kPrimaryColor,
                      ),
                      onPressed: () async {
                        Navigator.pushAndRemoveUntil(context,
                            new MaterialPageRoute(builder: (ctxt) => new AjoutConducteurScreen(
                            )),(route) => false
                        );
                      },
                      child: Text(
                        "Conduire",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                SizedBox(height: 10,),
              ],
            ),
          ),
        ),
      )),
    );
  }

/*  Card makeDashboardItem(String title, String path,int element) {
    return Card(
        color:kPrimaryColor,
        clipBehavior: Clip.antiAlias,
        child:InkWell(
          onTap: () {
            /*if(first_use){
              showDialogPrivacy(context,element);
            }else{
              //Navigate(element);
              getUserLocation(element);
            }*/
          },
          child:Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 10,),
              AspectRatio(
                aspectRatio: 18.0 / 11.0,
                child: Image.asset(path),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Center(
                      child: Text(title,style: TextStyle(fontSize: 12,color: Colors.white),),
                    )

                  ],
                ),
              ),
            ],
          ),
        )
    );/*Card(

        elevation: 1.0,
        margin: EdgeInsets.all(10),
        child: Container(

          decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(10.0),),
          child:  InkWell(
            onTap: () {
              if(first_use){
                showDialogPrivacy(context,element);
              }else{
                getUserLocation(element);
              }
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              verticalDirection: VerticalDirection.down,
              children: <Widget>[
               Image.asset(path,fit: BoxFit.cover),
                Text(title,
                      style:
                      TextStyle(fontSize: 13.0, color: Colors.black)),
              ],
            ),
          ),
        ));*/
  }
*/
  Card makeDashboardItem2(String title, String path,int element) {
    return Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20), // Bordure arrondie
          side: BorderSide(
            color: Colors.white30, // Couleur de la bordure
            width: 2, // Largeur de la bordure
          ),
        ),
        color:Colors.white,
        clipBehavior: Clip.antiAlias,
        child:InkWell(
          onTap: () {
            if(element==1){
              Navigator.pushAndRemoveUntil(context,
                  new MaterialPageRoute(builder: (ctxt) => new AjoutScreen()),
                      (route) => false
              );
            }
            else if(element==2){
              Navigator.pushAndRemoveUntil(context,
                  new MaterialPageRoute(builder: (ctxt) => new RechercheForm()),
                      (route) => false
              );
            }else if(element==3){
              Navigator.pushAndRemoveUntil(context,
                  new MaterialPageRoute(builder: (ctxt) => new AjoutConducteurScreen()),
                      (route) => false
              );
            }else if(element==4){
              Navigator.pushAndRemoveUntil(context,
                  new MaterialPageRoute(builder: (ctxt) => new ListeConducteur()),
                      (route) => false
              );
            }else if(element==5){
              Navigator.pushAndRemoveUntil(context,
                  new MaterialPageRoute(builder: (ctxt) => new AjoutAlerteScreen()),
                      (route) => false
              );
            }/*else if(element==6){
              Navigator.push(context,
                  new MaterialPageRoute(builder: (ctxt) => new CategorieListingWidget())
              );
            }*/
          },
          child:Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 10,),
              AspectRatio(
                aspectRatio: 18.0 / 11.0,
                child: Image.asset(path),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Center(
                      child: Text(title,style: TextStyle(fontSize: 12,color: Colors.black),),
                    )
                  ],
                ),
              ),
            ],
          ),
        )
    );/*Card(

        elevation: 1.0,
        margin: EdgeInsets.all(20),
        child: Container(

          decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(10.0),),
          child:  InkWell(
            onTap: () {
              if(element==5){
              Navigator.push(context,
              new MaterialPageRoute(builder: (ctxt) => new Liste_Consultation(token:token))
              );
              }
             else if(element==6){
              Navigator.push(context,
              new MaterialPageRoute(builder: (ctxt) => new Liste_Ordonnance(token:token))
              );
              }
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              verticalDirection: VerticalDirection.down,
              children: <Widget>[

                Center(
                    child: Image.asset(path,fit: BoxFit.cover,height: 80,),

                ),
             SizedBox(height: 20,),
                Center(
                  child:  Text(title,
                      style:
                      TextStyle(fontSize: 13.0, color: Colors.black)),
                )
              ],
            ),
          ),
        ))*/;
  }


  OutlineInputBorder textFieldBorder() {
    return OutlineInputBorder(
      borderRadius: const BorderRadius.all(Radius.circular(15.0)),
      borderSide: BorderSide(
        color: Colors.grey.withOpacity(0.5),
        width: 1.0,
      ),
    );
  }
}
