import 'package:eyav2/AjoutAlerte/Ajout_Alerte.dart';
import 'package:eyav2/AjoutVoiture/Ajout_voiture.dart';
import 'package:eyav2/Recherche_voiture/Recherche.dart';
import 'package:eyav2/new/add_alert.dart';
import 'package:eyav2/new/add_car.dart';
import 'package:eyav2/new/add_conductor.dart';
import 'package:eyav2/new/custom_bottom_bar.dart';
import 'package:eyav2/new/drawer.dart';
import 'package:eyav2/new/home.dart';
import 'package:eyav2/new/search_car.dart';
import 'package:eyav2/new/single_car.dart';
import 'package:eyav2/new/user_profile.dart';
import 'package:eyav2/profil/profil_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class EntryScreen extends StatefulWidget {
  @override
  State<EntryScreen> createState() => _EntryScreenState();
}

class _EntryScreenState extends State<EntryScreen> {
  final List _pages =  [
    HomeScreen(),
    AddCarScreen(),
    SearchCarScreen(),
    AddAlert(),
    AuthUserProfile(),
  ];
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    SvgPicture svgIcon(String src, {Color? color}) {
      return SvgPicture.asset(
        src,
        height: 22,
        colorFilter: ColorFilter.mode(
            color ?? Color(0xFF0EA000),
            BlendMode.srcIn),
      );
    }

    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Accueil'),
      //   backgroundColor: Colors.white,
      //   elevation: 0,
      //   iconTheme: IconThemeData(color: Colors.black),
      // ),
      // drawer: CustomDrawer(),
      body: _pages[_currentIndex],
      bottomNavigationBar:BottomAppBar(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              _buildNavItem(
                svgIcon("assets/icons/icon_home.svg"),
                svgIcon("assets/icons/icon_home_bold.svg"),
                "Accueil",
                0,
              ),
              _buildNavItem(
                svgIcon("assets/icons/icon_bag.svg"),
                svgIcon("assets/icons/icon_bag_bold.svg"),
                "Voiture",
                1,
              ),
              _buildNavItem(
                svgIcon("assets/icons/icon_search.svg"),
                svgIcon("assets/icons/icon_search_bold.svg"),
                "Rechercher",
                2,
              ),
              _buildNavItem(
                svgIcon("assets/icons/icon_ronds.svg"),
                svgIcon("assets/icons/icon_ronds_bold.svg"),
                "Alerte",
                3,
              ),
              _buildNavItem(
                svgIcon("assets/icons/icon_person.svg"),
                svgIcon("assets/icons/icon_person_bold.svg"),
                "Profil",
                4,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(Widget icon, Widget selectedIcon, String label, int index) {
    bool isSelected = _currentIndex == index;
    Color color = isSelected ? Color(0xFF0EA000) : Colors.grey;

    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      child: Row(
        children: [
          isSelected ? selectedIcon : icon,
          if (isSelected) ...[
            SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ],
      ),
    );
  }

}
