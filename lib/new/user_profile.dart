import 'package:eyav2/constants.dart';
import 'package:eyav2/new/drawer.dart';
import 'package:eyav2/new/update_profile.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthUserProfile extends StatefulWidget {
  // final String nom;
  // final String prenom;
  // final String ville;
  // final String adresse;
  // final String pseudo;
  // final String type_identifier;
  // final String identifier;
  // final String email;
  // AuthUserProfile({super.key,
  //   required this.nom,
  //   required this.prenom,
  //   required this.ville,
  //   required this.adresse,
  //   required this.pseudo,
  //   required this.type_identifier,
  //   required this.identifier,
  //   required this.email,
  //
  // });

  @override
  State<AuthUserProfile> createState() => _AuthUserProfileState();
}

class _AuthUserProfileState extends State<AuthUserProfile> {
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
  late int bonus;
  late String bonus_expiration;

  @override
  void initState() {
    super.initState();
    _getLocalUser();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Profil", style: TextStyle(fontFamily: "Ubuntu", fontSize: 22, fontWeight: FontWeight.bold),),
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black),
        ),
        drawer: CustomDrawer(),
        // bottomNavigationBar: BottomNavBar(),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  // margin: EdgeInsets.symmetric(vertical: 5,),
                  // padding: EdgeInsets.all(8),
                  // decoration: BoxDecoration(
                  //   color: Colors.grey[200],
                  //   borderRadius: BorderRadius.circular(10),
                  // ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundImage: AssetImage("assets/images/user_avatar.jpg"),
                      ),
                      SizedBox(width: 20),
                      Expanded(
                        child: Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("$firstname $lastname", style: TextStyle(fontFamily: "Ubuntu", fontWeight: FontWeight.bold, fontSize: 18),),
                              SizedBox(height: 2),
                              Text("$address, $city", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                              // Icon(Icons.star, color: Colors.orange, size: 20,),
                              SizedBox(height: 2),
                              Text("$username", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: greenThemeColor)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                ),
                SizedBox(height: 20,),
                Text(
                  "Email ",
                  style: TextStyle(fontFamily: "Ubuntu", fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text(
                  "${email}",
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 20,),
                Text(
                  "ID ",
                  style: TextStyle(fontFamily: "Ubuntu", fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text(
                  "${type_identifier} : ${identifier}",
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 20,),
                // Text(
                //   "Permis ",
                //   style: TextStyle(fontFamily: "Ubuntu", fontSize: 24, fontWeight: FontWeight.bold),
                // ),
                // SizedBox(height: 10),
                // Text(
                //   "${widget.}",
                //   style: TextStyle(fontSize: 16),
                // ),
                // SizedBox(height: 20,),

                // Text(
                //   "Expérience ",
                //   style: TextStyle(fontFamily: "Ubuntu", fontSize: 24, fontWeight: FontWeight.bold),
                // ),
                // SizedBox(height: 10),
                // Column(
                //   children: [
                //     experienceRadio("Adobe Photoshop"),
                //     experienceRadio("Adobe Illustrator"),
                //     experienceRadio("Adobe Indesign"),
                //     experienceRadio("Adobe XD"),
                //     experienceRadio("Adobe Lightroom"),
                //     experienceRadio("Adobe Premiere Pro"),
                //     experienceRadio("Adobe After Effect"),
                //     experienceRadio("Cinema 4D"),
                //     experienceRadio("Sketch"),
                //   ],
                // ),
                // SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(context,
                        MaterialPageRoute(builder: (ctxt) =>  UpdateProfile()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: greenThemeColor,
                      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      'Modifier le profil',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
            ]),
          ),
        )
    );

  }

  String selectedExperience = "";
  Widget experienceRadio(String experience) {
    return Row(
      children: [
        Radio<String>(
          value: experience,
          groupValue: selectedExperience,
          onChanged: (value) {
            setState(() {
              selectedExperience = value!;
            });
          },
        ),
        Text(experience, style: TextStyle(fontSize: 18)),
      ],
    );
  }

  _getLocalUser() async {
    setState(() {
      _isLoading = true;
    });
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      username=prefs.getString("username")!;
      lastname=prefs.getString("lastname")!;
      firstname=prefs.getString("firstname")!;
      city=prefs.getString("city")!;
      address=prefs.getString("address")!;
      type_identifier=prefs.getString("type_identifier")!;
      identifier=prefs.getString("identifier")!;
      email=prefs.getString("email")!;
      token=prefs.getString("token")!;
      bonus_expiration=prefs.getString("bonus_expiration")!;
      bonus=prefs.getInt("bonus")!;

    } catch (e) {
      print(e.toString());
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

}
