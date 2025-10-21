import 'package:eyav2/AjoutAlerte/Ajout_Alerte.dart';
import 'package:eyav2/AjoutVoiture/Ajout_voiture.dart';
import 'package:eyav2/Recherche_voiture/Recherche.dart';
import 'package:eyav2/new/drawer.dart';
import 'package:eyav2/new/search_car.dart';
import 'package:eyav2/profil/profil_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size; //check the size of device
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;

    SvgPicture svgIcon(String src, {Color? color}) {
      return SvgPicture.asset(
        src,
        height: 22,
        colorFilter: ColorFilter.mode(
            color ?? Color(0xFF0EA000),
            BlendMode.srcIn),
      );
    }
    return PopScope(
        canPop: false,
        child: Scaffold(
      appBar: AppBar(
        // title: Text('Accueil'),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        title: Image.asset(
          isDarkMode
              ? 'assets/logo_horizontal.jpg'
              : 'assets/logo_horizontal.jpg',
          height: size.height * 0.06,
          width: size.width * 0.35,
        ),
      ),
      drawer: CustomDrawer(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Accueil", style: TextStyle(fontFamily: "Ubuntu", fontSize: 28, fontWeight: FontWeight.bold),),
              SizedBox(height: 10,),
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Color(0xFFD9FFD9), // Couleur de fond verte légère
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Découvrez plus',
                          style: TextStyle(
                            fontFamily: "Ubuntu",
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text('De voiture avec EYALOCAR'),
                        SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context)=> SearchCarScreen()));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFFE5A000),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: Text('Explorer', style: TextStyle(fontFamily: "Ubuntu", fontWeight: FontWeight.bold, color: Colors.black),),
                        ),
                      ],
                    ),
                    Image.asset('assets/images/car-home.png', height: 80),
                  ],
                ),
              ),
              SizedBox(height: 20),

              // Section "Flotte"
              Text(
                'Flotte',
                style: TextStyle(
                  fontFamily: "Ubuntu",
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),

              GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  buildCarCategory('', 'assets/images/golf.png'),
                  buildCarCategory('', 'assets/images/i30n.png'),
                  buildCarCategory('', 'assets/images/yaris.png'),
                  buildCarCategory1('', 'assets/images/car-home.png'),
                ],
              ),
              SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(context,
                      MaterialPageRoute(builder: (ctxt) =>  SearchCarScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF0EA000), // Couleur verte
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    'Rechercher une voiture',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),onPopInvoked : (didPop){
      // logic
      //print("Ajouter une photo");
    },
    );
  }

  Widget buildCarCategory(String name, String imagePath) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Color(0xFFFFF0E6), // Couleur beige
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(),
              Icon(
                Icons.favorite_border,
                color: Colors.black,
              ),
            ],
          ),
          Image.asset(imagePath, height: 60),
          SizedBox(height: 10),
          Text(
            name,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 5),

        ],
      ),
    );
  }

  Widget buildCarCategory1(String name, String imagePath) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Color(0xFFFFF0E6), // Couleur beige
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(),
              Icon(
                Icons.favorite_border,
                color: Colors.black,
              ),
            ],
          ),
          Image.asset(imagePath, height: 77),
          SizedBox(height: 10),
          Text(
            name,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 5),

        ],
      ),
    );
  }

}
