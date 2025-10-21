import 'package:flutter/material.dart';

import '../AjoutAlerte/Ajout_Alerte.dart';
import '../AjoutVoiture/Ajout_voiture.dart';
import '../Recherche_voiture/Recherche.dart';
import '../constants.dart';
import '../pages/home_page.dart';

class bottomNvigator extends StatefulWidget {
  const bottomNvigator({Key? key}) : super(key: key);

  @override
  State<bottomNvigator> createState() => _bottomNvigatorState();
}

class _bottomNvigatorState extends State<bottomNvigator> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size; //check the size of device
    return Container(
      child: BottomNavigationBar(
        selectedItemColor:  Colors.white,
        unselectedItemColor: Color(0xffffffff),
        backgroundColor: kPrimaryColor,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
        unselectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
        onTap: (value) {

          /*Navigator.push(context,
          new MaterialPageRoute(builder: (ctxt) => new CarsListingWidget())
      )*/;
          if (value == 0) {
            Navigator.pushAndRemoveUntil(context,
                new MaterialPageRoute(builder: (ctxt) => new HomePage()),
                    (route) => false
            );
          }
          if (value == 1) {
            Navigator.pushAndRemoveUntil(context,
                new MaterialPageRoute(builder: (ctxt) => new AjoutScreen()),
                    (route) => false
            );
          }if (value == 2) {
            Navigator.pushAndRemoveUntil(context,
                new MaterialPageRoute(builder: (ctxt) => new AjoutAlerteScreen()),
                    (route) => false
            );
          }if (value == 3) {
            /*Navigator.push(context,
                new MaterialPageRoute(builder: (ctxt) => new CarsListingWidget())
            );
            */
            Navigator.pushAndRemoveUntil(context,
                new MaterialPageRoute(builder: (ctxt) => new RechercheScreen()),
                    (route) => false
            );

          }

        },
        items:  <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: SizedBox(
              height: size.width * 0.06,
              width: size.width * 0.06,
              child: Container(
                decoration: BoxDecoration(
                  //color: Colors.white,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(
                      10,
                    ),
                  ),
                ),
                child: Image.asset(
                  "assets/icons/accueil.png",
                ),
              ),
            ),
            label: 'Accueil ',

          ),
          BottomNavigationBarItem(
            icon: SizedBox(
              height: size.width * 0.06,
              width: size.width * 0.06,
              child: Container(
                decoration: BoxDecoration(
                  //color: Colors.white,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(
                      10,
                    ),
                  ),
                ),
                child: Image.asset(
                  "assets/icons/ajouter.png",
                ),
              ),
            ),
            label: 'Ajouter ',
          ),
          BottomNavigationBarItem(
            icon: SizedBox(
              height: size.width * 0.06,
              width: size.width * 0.06,
              child: Container(
                decoration: BoxDecoration(
                  //color: Colors.white,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(
                      10,
                    ),
                  ),
                ),
                child: Image.asset(
                  "assets/icons/alerte.png",
                ),
              ),
            ),
            label: 'Alertes ',
          ),
          BottomNavigationBarItem(
            icon: SizedBox(
              height: size.width * 0.06,
              width: size.width * 0.06,
              child: Container(
                decoration: BoxDecoration(
                  //color: Colors.white,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(
                      10,
                    ),
                  ),
                ),
                child: Image.asset(
                  "assets/icons/chercher.png",
                ),
              ),
            ),
            label: 'Voitures ',
          ),
        ],
      ),
    );
  }
}
