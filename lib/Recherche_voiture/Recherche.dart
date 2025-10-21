import 'package:eyav2/constants.dart';
import 'package:eyav2/size_config.dart';
import 'package:flutter/material.dart';
import '../AjoutAlerte/Ajout_Alerte.dart';
import '../AjoutVoiture/Ajout_voiture.dart';
import '../pages/home_page.dart';
import '../widgets/DrawerMenuWidget.dart';
import '../widgets/bottomnav.dart';
import 'components/body.dart';

class RechercheScreen extends StatelessWidget {
  static String routeName = "/sign_up";
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Recherche de voiture"),
        backgroundColor: kPrimaryColor,
        centerTitle: true,
      ),
      drawer: DrawerMenuWidget(),
      bottomNavigationBar: BottomNavigationBar(
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
           /* Navigator.pushAndRemoveUntil(context,
                new MaterialPageRoute(builder: (ctxt) => new RechercheScreen()),
                    (route) => false
            );
*/
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

      body: Body(),
    );
  }
}
