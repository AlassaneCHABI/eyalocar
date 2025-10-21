import 'package:eyav2/AjoutAlerte/Ajout_Alerte.dart';
import 'package:eyav2/AjoutVoiture/Ajout_voiture.dart';
import 'package:eyav2/constants.dart';
import 'package:eyav2/pages/home_page.dart';
import 'package:eyav2/widgets/bottom_nav_item.dart';
import 'package:flutter/material.dart';

import '../Recherche_voiture/components/Recherche_form.dart';

Widget buildBottomNavBar(int currIndex, Size size, bool isDarkMode,BuildContext context) {
  return BottomNavigationBar(
    iconSize: size.width * 0.07,
    elevation: 0,
    selectedLabelStyle: const TextStyle(fontSize: 0),
    unselectedLabelStyle: const TextStyle(fontSize: 0),
    currentIndex: currIndex,
    backgroundColor: kPrimaryColor,
    type: BottomNavigationBarType.fixed,
    selectedItemColor: isDarkMode ? Colors.indigoAccent : Colors.black,
    unselectedItemColor: const Color(0xff3b22a1),
    onTap: (value) {

      /*Navigator.push(context,
          new MaterialPageRoute(builder: (ctxt) => new CarsListingWidget())
      )*/;
        if (value == 0) {
          Navigator.push(context,
              new MaterialPageRoute(builder: (ctxt) => new HomePage())
          );
        }
        if (value == 1) {
          Navigator.push(context,
              new MaterialPageRoute(builder: (ctxt) => new AjoutScreen())
          );
        }if (value == 2) {
        Navigator.push(context,
            new MaterialPageRoute(builder: (ctxt) => new AjoutAlerteScreen())
        );
        }if (value == 3) {
        Navigator.push(context,
            new MaterialPageRoute(builder: (ctxt) => new RechercheForm())
        );


        }

    },
    items: [
      buildBottomNavItem(
        "assets/icons/accueil.png",
        isDarkMode,
        size,
        'Accueil'
      ),
      buildBottomNavItem(
        "assets/icons/ajouter.png",
        isDarkMode,
        size,
          'Ajouter'
      ),
      buildBottomNavItem(
        "assets/icons/alerte.png",
        isDarkMode,
        size,
          'Alerte'
      ),
      buildBottomNavItem(
        "assets/icons/chercher.png",
        isDarkMode,
        size,
          'Véhicule'
      ),
    ],
  );
}
